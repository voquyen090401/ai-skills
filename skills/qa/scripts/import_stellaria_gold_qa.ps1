param(
    [string]$SourcePath = "C:\Users\User\.codex\attachments\b330f87b-7dbe-4be6-a619-6cac12cd728e\pasted-text.txt",
    [string]$DatasetPath = "D:\Workscpace\AISkill\skills\qa\references\gold_dataset.jsonl",
    [string]$ReportPath = "D:\Workscpace\AISkill\STELLARIA_GOLD_QA_IMPORT_REPORT.md"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\qa_skill_lib.ps1"

function Get-SplitSegments {
    param([string]$Text)

    $pattern = '""(?=(Liên quan đến|Dựa vào|Dựa trên|Theo như|Theo mô tả|Chúng tôi muốn xác nhận|Về vấn đề))'
    return @(
        [regex]::Split($Text, $pattern) |
        Where-Object {
            $_.Trim() -and
            $_ -notmatch '^(Liên quan đến|Dựa vào|Dựa trên|Theo như|Theo mô tả|Chúng tôi muốn xác nhận|Về vấn đề)$'
        } |
        ForEach-Object { $_.Trim(' ', '"', "`r", "`n") }
    )
}

function Get-SubText {
    param(
        [string]$Text,
        [string]$Start,
        [string]$End
    )

    $startIndex = if ($Start) { $Text.IndexOf($Start) } else { 0 }
    if ($startIndex -lt 0) {
        throw "Start anchor not found: $Start"
    }

    if ($End) {
        $endIndex = $Text.IndexOf($End, $startIndex + $Start.Length)
        if ($endIndex -lt 0) {
            throw "End anchor not found: $End"
        }
        return $Text.Substring($startIndex, $endIndex - $startIndex).Trim()
    }

    return $Text.Substring($startIndex).Trim()
}

function Get-CleanTextResult {
    param([string]$Text)

    $result = [ordered]@{
        text = $Text.Trim()
        corrections = New-Object System.Collections.Generic.List[string]
    }

    $result.text = $result.text -replace '""', "`n`n"
    $result.text = $result.text -replace 'Nhờ confirm No\.11', ''
    $result.text = $result.text -replace 'headerSau', 'header. Sau'
    $result.text = $result.text -replace 'Issuee', 'Issue'
    $result.text = $result.text -replace 'confrim', 'confirm'
    $result.text = $result.text -replace 'passoword', 'password'
    $result.text = $result.text -replace 'hiển thi', 'hiển thị'
    $result.text = $result.text -replace 'xử lú', 'xử lý'
    $result.text = $result.text -replace 'ghom', 'gom'
    $result.text = $result.text -replace 'subjetc', 'subject'
    $result.text = $result.text -replace 'categoy', 'category'
    $result.text = $result.text -replace 'uniquesness', 'uniqueness'
    $result.text = $result.text -replace 'thiết lặp', 'thiết lập'
    $result.text = $result.text -replace 'xử dịnh', 'xử định'
    $result.text = $result.text -replace 'đẩy đủ', 'đầy đủ'
    $result.text = $result.text -replace 'hiển thị confirm thành tích default', 'hiển thị confirm thành tích mặc định'
    $result.text = $result.text -replace 'Nhờ Bác confrim', 'Nhờ Bác confirm'
    $result.text = $result.text -replace 'Nhờ bác confrim', 'Nhờ bác confirm'
    $result.text = $result.text -replace 'status sẽ disable', 'status sẽ bị disable'
    $result.text = $result.text -replace 'thống hiện tại', 'hệ thống hiện tại'
    $result.text = $result.text -replace 'đang ghi nhận sai\.Còn', 'đang ghi nhận sai. Còn'
    $result.text = $result.text -replace 'Lớp A1 → domain: A1.htp.comLớp A2 → domain: A2.htp.com', "Lớp A1 → domain: A1.htp.com`nLớp A2 → domain: A2.htp.com"
    $result.text = $result.text -replace 'Ví dụ:Tổ chức', 'Ví dụ: Tổ chức'
    $result.text = $result.text -replace 'Ví dụ cụ thể:Trước', 'Ví dụ cụ thể: Trước'
    $result.text = $result.text -replace 'Hệ quả:Nếu', 'Hệ quả: Nếu'
    $result.text = $result.text -replace 'Do đó, để hạn chế', 'Do đó, để hạn chế'
    $result.text = $result.text -replace 'Trong quá trình điều tra hệ thống', 'Trong quá trình điều tra hệ thống'
    $result.text = $result.text -replace 'Như vậy có được không ạ \?', 'Như vậy có được không ạ?'
    $result.text = $result.text -replace '\s+([:;,.?!])', '$1'
    $result.text = $result.text -replace '([:;,.?!])([^\s\r\n])', '$1 $2'
    $result.text = $result.text -replace '\s+', ' '
    $result.text = $result.text -replace '(?<=\.)\s+(?=[A-ZÀ-Ỵ“"「\[])', "`n`n"
    $result.text = $result.text -replace '(?<=\?)\s+(?=[A-ZÀ-Ỵ“"「\[])', "`n`n"
    $result.text = $result.text -replace '(?<!\d)(\d+\.)', "`n`$1"
    $result.text = $result.text -replace '(?<=:)\s*(?=[A-ZÀ-Ỵ0-9「\[])', ' '
    $result.text = $result.text -replace "`n\s+","`n"
    $result.text = $result.text.Trim()

    foreach ($pair in @(
        "Issuee -> Issue",
        "confrim -> confirm",
        "passoword -> password",
        "hiển thi -> hiển thị",
        "xử lú -> xử lý",
        "ghom -> gom"
    )) {
        if ($Text -match [regex]::Escape(($pair -split ' -> ')[0])) {
            $result.corrections.Add($pair)
        }
    }

    return [pscustomobject]$result
}

function Get-SourceSheet {
    param([string]$QaText)

    $match = [regex]::Match($QaText, '(sheet\s+No\.?\s*\d+|No\.\d+)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if ($match.Success) {
        return $match.Value.Trim()
    }
    return $null
}

function Get-InputContext {
    param([string]$QaText)

    $text = ($QaText -replace '\s+', ' ').Trim()
    $text = $text -replace 'Nhờ\s*(Bác|bác).*(xác nhận|confirm).*$',''
    return $text.Trim()
}

function Get-MetadataLines {
    param([string]$QaText)

    return @(
        $QaText -split "`r?`n" |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ }
    )
}

function Extract-Evidence {
    param([string]$QaText)

    $lines = Get-MetadataLines -QaText $QaText
    $evidence = New-Object System.Collections.Generic.List[string]
    foreach ($line in $lines) {
        if ($line -match '^(Liên quan đến|Dựa vào|Dựa trên|Theo như|Theo mô tả|Chúng tôi muốn xác nhận|Về vấn đề)') { continue }
        if ($line -match 'Nhờ\s*(Bác|bác)|có đúng không|có được không|phù hợp|confirm|xác nhận') { continue }
        if ($line -match 'chúng tôi (đang hiểu|hiểu rằng|nhận thức|dự định|đề xuất)') { continue }
        $evidence.Add($line)
        if ($evidence.Count -ge 4) { break }
    }
    if ($evidence.Count -eq 0 -and @($lines).Count -gt 0) {
        $evidence.Add($lines[0])
    }
    return $evidence.ToArray()
}

function Extract-CurrentUnderstanding {
    param([string]$QaText)

    $lines = Get-MetadataLines -QaText $QaText
    $items = New-Object System.Collections.Generic.List[string]
    foreach ($line in $lines) {
        if ($line -match 'chúng tôi (đang hiểu|hiểu rằng|nhận thức|dự định|đề xuất|ghi nhận|quyết định)|Theo logic mới|Do đó,|Tuy nhiên|Nếu như nhận thức') {
            $items.Add($line)
        }
    }
    if ($items.Count -eq 0) {
        foreach ($line in ($lines | Where-Object { $_ -notmatch '^(Liên quan đến|Dựa vào|Dựa trên|Theo như|Theo mô tả|Chúng tôi muốn xác nhận|Về vấn đề|Nhờ\s*(Bác|bác))' } | Select-Object -First 3)) {
            $items.Add($line)
        }
    }
    return @($items.ToArray())
}

function Extract-UnclearPoints {
    param([string]$QaText)

    $lines = Get-MetadataLines -QaText $QaText
    $items = New-Object System.Collections.Generic.List[string]
    foreach ($line in $lines) {
        if ($line -match '^(Liên quan đến|Dựa vào|Dựa trên|Theo như|Theo mô tả|Chúng tôi muốn xác nhận|Về vấn đề)') { continue }
        if ($line -match 'chưa|không rõ|không biết|vấn đề|có đúng không|có được không|phù hợp|hay không|xác nhận|confirm') {
            if ($line -notmatch '^Nhờ\s*(Bác|bác)') {
                $items.Add($line)
            }
        }
    }
    return @($items | Select-Object -Unique)
}

function Extract-ConfirmationPoints {
    param([string]$QaText)

    $lines = Get-MetadataLines -QaText $QaText
    $items = New-Object System.Collections.Generic.List[string]
    foreach ($line in $lines) {
        if ($line -match '^(Liên quan đến|Dựa vào|Dựa trên|Theo như|Theo mô tả|Chúng tôi muốn xác nhận|Về vấn đề|Trong tài liệu)') { continue }
        if ($line -match 'có đúng không|có được không|phù hợp|xác nhận|confirm|hay không') {
            if ($line -notmatch '^Nhờ\s*(Bác|bác)') {
                $items.Add($line.TrimEnd('.', ' '))
            }
        }
    }
    if ($items.Count -eq 0) {
        $fallback = @($lines | Where-Object { $_ -notmatch '^Nhờ\s*(Bác|bác)' } | Select-Object -Last 1)
        if ($fallback.Count -gt 0) {
            $items.Add($fallback[0])
        }
    }
    return @($items | Select-Object -Unique)
}

function New-StellariaRecord {
    param(
        [string]$QaText,
        [string]$Category,
        [string]$Screen,
        [string]$Topic,
        [string]$Difficulty,
        [string[]]$RelatedScreens = @(),
        [bool]$NeedsReview = $false,
        [string[]]$ReviewNotes = @()
    )

    $clean = Get-CleanTextResult -Text $QaText
    $qa = $clean.text

    $record = [ordered]@{
        id = $null
        category = $Category
        module = "STELLARIA"
        screen = $Screen
        topic = $Topic
        style = "business_understanding_confirm"
        difficulty = $Difficulty
        source_type = "human_gold_qa"
        source_file = "Văn bản đã dán (1)(5).txt"
        source_reference = [ordered]@{
            document = "Stellaria_Requirement list"
            sheet = Get-SourceSheet -QaText $qa
            screen = $Screen
            lines = @()
        }
        input_context = Get-InputContext -QaText $qa
        evidence = @(Extract-Evidence -QaText $qa)
        current_understanding = @(Extract-CurrentUnderstanding -QaText $qa)
        unclear_points = @(Extract-UnclearPoints -QaText $qa)
        confirmation_points = @(Extract-ConfirmationPoints -QaText $qa)
        qa = $qa
        needs_review = $NeedsReview
        review_notes = @($ReviewNotes)
    }

    if ($RelatedScreens.Count -gt 0) {
        $record["related_screens"] = $RelatedScreens
    }

    if ($clean.corrections.Count -gt 0 -and -not $record.review_notes) {
        $record.review_notes = @()
    }

    return [pscustomobject]$record
}

function Get-NormalizedQaKey {
    param([string]$Text)
    return (($Text -replace '\s+',' ').Trim().ToLowerInvariant())
}

$sourceText = [System.IO.File]::ReadAllText($SourcePath, [System.Text.Encoding]::UTF8)
$segments = Get-SplitSegments -Text $sourceText

$recordsToImport = New-Object System.Collections.Generic.List[object]

$seg1 = $segments[0]
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg1 'Liên quan đến màn hình 成績確認_confirm thành tích' 'Liên quan đến trạng thái khởi tạo') -Category 'search_item' -Screen '成績確認' -Topic 'achievement_search_conditions_and_default_values' -Difficulty 'high'))
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg1 'Liên quan đến trạng thái khởi tạo' '4.Liên quan đến thao tác') -Category 'display_label' -Screen '成績確認' -Topic 'achievement_default_display_state' -Difficulty 'medium'))
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg1 '4.Liên quan đến thao tác' '5. Khi người dùng') -Category 'search_item' -Screen '成績確認' -Topic 'achievement_display_option_auto_refresh' -Difficulty 'medium'))
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg1 '5. Khi người dùng' '6. Liên quan đến chức năng export CSV') -Category 'multi_rule' -Screen '成績確認' -Topic 'achievement_disable_year_month_for_short_period' -Difficulty 'high'))
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg1 '6. Liên quan đến chức năng export CSV' $null) -Category 'csv_output' -Screen '成績確認' -Topic 'achievement_csv_export_hierarchy' -Difficulty 'high'))

$recordsToImport.Add((New-StellariaRecord -QaText $segments[1] -Category 'file_export' -Screen 'Subject' -Topic 'subject_html_export_scope_structure_and_filename' -Difficulty 'high'))
$recordsToImport.Add((New-StellariaRecord -QaText $segments[2] -Category 'display_label' -Screen '成績確認' -Topic 'question_category_accordion_display' -Difficulty 'medium'))
$recordsToImport.Add((New-StellariaRecord -QaText $segments[3] -Category 'multi_rule' -Screen 'Course' -Topic 'course_display_order_field_and_sorting' -Difficulty 'high'))
$recordsToImport.Add((New-StellariaRecord -QaText $segments[4] -Category 'exception_case' -Screen 'Course' -Topic 'course_contract_visibility_with_firestore_limit' -Difficulty 'high'))

$seg6 = $segments[5]
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg6 'Liên quan đến màn hình Student' 'Liên quan item コース ở màn hình list subject') -Category 'multi_rule' -Screen 'Student' -Topic 'student_usage_date_validation_and_csv_scope' -Difficulty 'high'))
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg6 'Liên quan item コース ở màn hình list subject' $null) -Category 'version_conflict' -Screen 'Subject' -Topic 'subject_course_filter_scope_vs_contract_visibility' -Difficulty 'medium'))

$seg7a = $segments[6]
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg7a 'Liên quan đến các thay đổi tại màn hình Student' 'Liên quan đến format import CSV') -Category 'permission' -Screen 'Student' -Topic 'student_default_state_by_role' -Difficulty 'high'))
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg7a 'Liên quan đến format import CSV' $null) -Category 'import_csv' -Screen 'Student' -Topic 'student_csv_import_org_selection_and_rollback' -Difficulty 'high'))
$recordsToImport.Add((New-StellariaRecord -QaText $segments[7] -Category 'search_item' -Screen 'Subject' -Topic 'subject_search_execute_on_search_button' -Difficulty 'medium'))

$seg9 = $segments[8]
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg9 'Liên quan đến chức năng パスワードリセット' 'Liên quan đến [No.021]') -Category 'notification' -Screen 'Student' -Topic 'student_password_reset_flow_and_forced_logout' -Difficulty 'high' -RelatedScreens @('Admin')))
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg9 'Liên quan đến [No.021]' $null) -Category 'workflow_gap' -Screen 'レッスン' -Topic 'lesson_preview_without_student_login' -Difficulty 'high'))

$seg10 = $segments[9]
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg10 'Theo mô tả của bác đối với màn hình A Confirm 成績' 'Chúng tôi muốn xác nhận thêm về quy tắc liên kết giữa') -Category 'multi_rule' -Screen '成績確認' -Topic 'achievement_chart_pattern_flexibility' -Difficulty 'high'))
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg10 'Chúng tôi muốn xác nhận thêm về quy tắc liên kết giữa' $null) -Category 'multi_rule' -Screen '成績確認' -Topic 'achievement_left_right_filter_dependency' -Difficulty 'high'))

$recordsToImport.Add((New-StellariaRecord -QaText $segments[10] -Category 'file_export' -Screen 'Subject' -Topic 'subject_html_export_role_behavior_and_filename' -Difficulty 'high'))

$seg12 = $segments[11]
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg12 'Về vấn đề thay đổi Class của Student' 'Trong quá trình điều tra hệ thống') -Category 'workflow_gap' -Screen 'Student' -Topic 'student_class_change_new_account_strategy' -Difficulty 'high'))
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg12 'Trong quá trình điều tra hệ thống' 'Nhờ bác trả lời 2 ý sau') -Category 'search_item' -Screen '受講確認' -Topic 'sidebar_filter_extension_for_class_dependent_screens' -Difficulty 'high' -RelatedScreens @('レッスン設定','課題','問題')))
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg12 'Nhờ bác trả lời 2 ý sau' $null) -Category 'multi_rule' -Screen '成績確認' -Topic 'achievement_contract_basis_and_chart_value_counting' -Difficulty 'high'))

$recordsToImport.Add((New-StellariaRecord -QaText $segments[12] -Category 'workflow_gap' -Screen 'Admin' -Topic 'admin_delete_contract_admin_and_org_warning' -Difficulty 'medium' -RelatedScreens @('Organization')))

$seg14 = $segments[13]
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg14 'Liên quan đến màn hình Organization' 'Liên quan đến màn hình Student') -Category 'database' -Screen 'Organization' -Topic 'organization_display_flag_migration_and_default_search_state' -Difficulty 'high'))
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg14 'Liên quan đến màn hình Student' $null) -Category 'database' -Screen 'Student' -Topic 'student_usage_date_migration_for_old_data' -Difficulty 'high'))

$recordsToImport.Add((New-StellariaRecord -QaText $segments[14] -Category 'permission' -Screen '管理者' -Topic 'operator_role_column_for_system_admin_view' -Difficulty 'medium'))
$recordsToImport.Add((New-StellariaRecord -QaText $segments[15] -Category 'workflow_gap' -Screen 'Student' -Topic 'student_navigation_context_from_class_selection' -Difficulty 'medium' -RelatedScreens @('Organization','Class')))
$recordsToImport.Add((New-StellariaRecord -QaText $segments[16] -Category 'csv_output' -Screen 'Student' -Topic 'student_export_filename_and_special_character_handling' -Difficulty 'medium'))
$recordsToImport.Add((New-StellariaRecord -QaText $segments[17] -Category 'workflow_gap' -Screen 'Lesson' -Topic 'duplicate_lesson_with_questions' -Difficulty 'high' -RelatedScreens @('問題一覧')))
$recordsToImport.Add((New-StellariaRecord -QaText $segments[18] -Category 'multi_rule' -Screen 'My Page' -Topic 'subject_correct_rate_calculation_scope' -Difficulty 'high'))
$recordsToImport.Add((New-StellariaRecord -QaText $segments[19] -Category 'display_label' -Screen 'Student' -Topic 'student_status_classification_and_list_filter' -Difficulty 'medium'))
$recordsToImport.Add((New-StellariaRecord -QaText $segments[20] -Category 'exception_case' -Screen 'Student' -Topic 'student_login_common_error_message_for_invalid_state' -Difficulty 'medium'))
$recordsToImport.Add((New-StellariaRecord -QaText $segments[21] -Category 'workflow_gap' -Screen 'Student' -Topic 'student_class_change_cases_sheet_31' -Difficulty 'high' -NeedsReview $true -ReviewNotes @('QA chỉ tham chiếu sheet No.31, không có chi tiết case trong file nguồn hiện có.')))
$seg23 = $segments[22]
$recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $seg23 'Dựa vào QA 29' 'Liên quan đến màn hình [Students]') -Category 'search_item' -Screen '受講確認' -Topic 'lesson_confirmation_student_filter_include_active_and_inactive' -Difficulty 'medium' -NeedsReview $true -ReviewNotes @('QA tham chiếu QA 29 nhưng chưa xác định chắc chắn record nguồn tương ứng trong cùng file.')))

$externalStart = 'Liên quan đến màn hình [Students] thì chúng tôi có điểm cân xác nhận lại như sau:'
if ($sourceText.Contains($externalStart)) {
    $recordsToImport.Add((New-StellariaRecord -QaText (Get-SubText $sourceText $externalStart $null) -Category 'api' -Screen 'Students' -Topic 'external_students_courses_api_usage_date_params' -Difficulty 'high'))
}

$existing = Get-Content $DatasetPath | ForEach-Object { $_ | ConvertFrom-Json }
$backupPath = Join-Path (Split-Path $DatasetPath -Parent) 'gold_dataset.backup-before-stellaria.jsonl'
Copy-Item $DatasetPath $backupPath -Force

[int]$maxId = (($existing | ForEach-Object {
    if ($_.id -match '(\d+)$') { [int]$Matches[1] }
} | Measure-Object -Maximum).Maximum)
if (-not $maxId) { $maxId = 0 }

$allKeys = New-Object System.Collections.Generic.HashSet[string]
foreach ($row in $existing) {
    [void]$allKeys.Add((Get-NormalizedQaKey -Text $row.qa))
    [void]$allKeys.Add((("{0}::{1}" -f $row.screen, $row.topic).ToLowerInvariant()))
}

$added = New-Object System.Collections.Generic.List[object]
$duplicates = New-Object System.Collections.Generic.List[object]

foreach ($record in $recordsToImport) {
    $qaKey = Get-NormalizedQaKey -Text $record.qa
    $topicKey = ("{0}::{1}" -f $record.screen, $record.topic).ToLowerInvariant()
    if ($allKeys.Contains($qaKey) -or $allKeys.Contains($topicKey)) {
        $duplicates.Add([pscustomobject]@{
            screen = $record.screen
            topic = $record.topic
            reason = "same screen/topic or same QA content already exists"
        })
        continue
    }

    $maxId++
    $record.id = ("BI-QA-{0:D4}" -f $maxId)
    $added.Add($record)
    [void]$allKeys.Add($qaKey)
    [void]$allKeys.Add($topicKey)
}

$combined = @($existing) + $added.ToArray()
$utf8Bom = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllLines(
    $DatasetPath,
    @($combined | ForEach-Object { $_ | ConvertTo-Json -Compress -Depth 8 }),
    $utf8Bom
)

$detectedCount = $recordsToImport.Count
$categoryStats = @($added | Group-Object category | Sort-Object Name)
$screenStats = @($added | Group-Object screen | Sort-Object Name)
$difficultyStats = @($added | Group-Object difficulty | Sort-Object Name)
$reviewRows = @($added | Where-Object { $_.needs_review })
$spellingFixes = @(
    $added |
    ForEach-Object { $_.review_notes } |
    Where-Object { $_ }
)

$report = New-Object System.Collections.Generic.List[string]
$report.Add("# STELLARIA Gold QA Import Report")
$report.Add("")
$report.Add("1. File nguồn đã đọc")
$report.Add("- Văn bản đã dán (1)(5).txt")
$report.Add("")
$report.Add("2. Gold Dataset đã cập nhật")
$report.Add("- $DatasetPath")
$report.Add("- Backup: $backupPath")
$report.Add("")
$report.Add("3. Tổng QA phát hiện trong file nguồn")
$report.Add("- $detectedCount")
$report.Add("")
$report.Add("4. Tổng QA được thêm")
$report.Add("- $($added.Count)")
$report.Add("")
$report.Add("5. Tổng QA bị bỏ qua do duplicate")
$report.Add("- $($duplicates.Count)")
$report.Add("")
$report.Add("6. Tổng QA có needs_review = true")
$report.Add("- $($reviewRows.Count)")
$report.Add("")
$report.Add("7. Thống kê theo category")
foreach ($row in $categoryStats) { $report.Add("- $($row.Name): $($row.Count)") }
$report.Add("")
$report.Add("8. Thống kê theo screen")
foreach ($row in $screenStats) { $report.Add("- $($row.Name): $($row.Count)") }
$report.Add("")
$report.Add("9. Thống kê theo difficulty")
foreach ($row in $difficultyStats) { $report.Add("- $($row.Name): $($row.Count)") }
$report.Add("")
$report.Add("10. Danh sách record cần review")
if ($reviewRows.Count -eq 0) {
    $report.Add("- none")
}
else {
    foreach ($row in $reviewRows) {
        $report.Add("- $($row.id): $((@($row.review_notes)) -join '; ')")
    }
}
$report.Add("")
$report.Add("11. Danh sách duplicate")
if ($duplicates.Count -eq 0) {
    $report.Add("- none")
}
else {
    foreach ($row in $duplicates) {
        $report.Add("- $($row.screen) / $($row.topic): $($row.reason)")
    }
}
$report.Add("")
$report.Add("12. Danh sách lỗi chính tả đã chỉnh")
$report.Add("- Issuee -> Issue")
$report.Add("- confrim -> confirm")
$report.Add("- passoword -> password")
$report.Add("- hiển thi -> hiển thị")
$report.Add("- xử lú -> xử lý")
$report.Add("- ghom -> gom")
$report.Add("")
$report.Add("13. Kết quả validation")
$report.Add("- pending after import script")
$report.Add("")
$report.Add("14. Năm ví dụ record sau khi convert")
foreach ($row in ($added | Select-Object -First 5)) {
    $report.Add("")
    $report.Add('```json')
    $report.Add(($row | ConvertTo-Json -Depth 8))
    $report.Add('```')
}

[System.IO.File]::WriteAllLines($ReportPath, $report, $utf8Bom)

Write-Output ("Detected candidate QA: {0}" -f $detectedCount)
Write-Output ("Added QA: {0}" -f $added.Count)
Write-Output ("Skipped duplicate QA: {0}" -f $duplicates.Count)
Write-Output ("Needs review: {0}" -f $reviewRows.Count)
Write-Output ("Dataset total after update: {0}" -f $combined.Count)
Write-Output ("Backup created: {0}" -f $backupPath)
Write-Output ("Report created: {0}" -f $ReportPath)
