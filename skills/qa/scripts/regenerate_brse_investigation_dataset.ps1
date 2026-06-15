param(
    [string]$InputPath = "D:\Workscpace\AISkill\skills\qa\references\gold_dataset.jsonl",
    [string]$OutputPath = "D:\Workscpace\AISkill\output\brse_investigation_qa_dataset.jsonl"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-NewCategory {
    param([string]$Category)
    switch ($Category) {
        "impact_analysis" { return "impact_investigation" }
        "screen_scope" { return "scope_keep" }
        "search_condition" { return "search_item" }
        "workflow" { return "workflow_gap" }
        "status_transition" { return "workflow_gap" }
        "csv_import" { return "import_csv" }
        "csv_export" { return "csv_output" }
        "mail_notification" { return "notification" }
        "data_mapping" { return "mapping" }
        default { return $Category }
    }
}

function Get-Style {
    param([string]$Category)
    switch ($Category) {
        "impact_investigation" { return "investigation_confirm" }
        "scope_keep" { return "scope_keep_confirm" }
        "version_conflict" { return "version_compare_confirm" }
        "workflow_gap" { return "workflow_gap_confirm" }
        "import_csv" { return "csv_import_confirm" }
        "csv_output" { return "csv_output_confirm" }
        "validation" { return "validation_confirm" }
        "notification" { return "notification_confirm" }
        "mapping" { return "mapping_confirm" }
        default { return "investigation_confirm" }
    }
}

function Get-SourcePattern {
    param([string]$Topic)
    switch ($Topic) {
        "review_comment_scope" { return "impact_list_screens" }
        "standard_time_hide_scope" { return "impact_hide_items" }
        "shipment_fields_scope" { return "impact_add_items" }
        "bulk_update_scope" { return "impact_cross_module" }
        "keep_screen_scope" { return "scope_keep_unlisted_screens" }
        "subscreen_after_delete" { return "scope_keep_subscreen" }
        "batch_screen_scope" { return "scope_keep_batch" }
        "customer_tool_removed" { return "version_old_vs_new" }
        "delete_or_merge" { return "version_delete_or_merge" }
        "csv_hide_conflict" { return "version_csv_compatibility" }
        "review_flag_filters" { return "search_filter_logic" }
        "due_date_search" { return "search_add_date_item" }
        "hidden_field_search" { return "search_hidden_field_impact" }
        "import_history_search" { return "search_history_items" }
        "flag_display_format" { return "display_label_convert" }
        "overdue_color_rule" { return "display_color_rule" }
        "review_reason_visibility" { return "display_conditional_field" }
        "pending_reason_column" { return "display_reason_column" }
        "delete_flow" { return "workflow_delete_screen" }
        "branching_path" { return "workflow_branch_conditions" }
        "flow_after_recall_return" { return "workflow_return_flow" }
        "pending_release_flow" { return "workflow_pending_release" }
        "recall_authority" { return "status_recall_authority" }
        "return_logic" { return "status_return_logic" }
        "pending_status_codes" { return "status_pending_codes" }
        "no_rollback_to_ca30" { return "status_no_cross_module_rollback" }
        "review_reason_required" { return "validation_required_by_flag" }
        "weight_and_box_validation" { return "validation_master_and_format" }
        "jig_serial_validation" { return "validation_format_exists" }
        "csv_flag_value_validation" { return "validation_csv_flag_value" }
        "tool_number_uniqueness" { return "validation_uniqueness_rule" }
        "encoding_and_template" { return "csv_import_template_encoding" }
        "partial_or_all_or_nothing" { return "csv_import_transaction_policy" }
        "batch_import_behavior" { return "csv_import_batch_behavior" }
        "comment_required_with_flag" { return "csv_import_cross_field_rule" }
        "hidden_columns_output" { return "csv_output_hide_or_blank" }
        "flag_and_comment_export" { return "csv_output_flag_mapping" }
        "pending_records_export" { return "csv_output_pending_scope" }
        "review_flag_export" { return "csv_output_flag_addition" }
        "pending_mail_recipients" { return "notification_email_recipients" }
        "release_mail_behavior" { return "notification_release_event" }
        "mail_on_return" { return "notification_return_event" }
        "tool_drawing_part_mapping" { return "mapping_reference_sheet" }
        default { return "investigation_confirm" }
    }
}

function Parse-Sections {
    param([string]$QaText)

    $context = [regex]::Match($QaText, '■ Bối cảnh\s*(?<content>[\s\S]*?)(■ Nhận thức hiện tại|■ Câu hỏi xác nhận)')
    $understanding = [regex]::Match($QaText, '■ Nhận thức hiện tại\s*(?<content>[\s\S]*?)■ Câu hỏi xác nhận')
    $question = [regex]::Match($QaText, '■ Câu hỏi xác nhận\s*(?<content>[\s\S]*)$')

    $contextLines = @()
    $understandingLines = @()
    $questionLines = @()

    if ($context.Success) {
        $contextLines = $context.Groups["content"].Value -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    }
    if ($understanding.Success) {
        $understandingLines = $understanding.Groups["content"].Value -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    }
    if ($question.Success) {
        $questionLines = $question.Groups["content"].Value -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith("Nhờ bác") }
    }

    return @{
        context = $contextLines
        understanding = $understandingLines
        question = $questionLines
    }
}

function Ensure-Bullets {
    param([string[]]$Lines)
    $result = New-Object System.Collections.Generic.List[string]
    foreach ($line in $Lines) {
        $trimmed = $line.Trim()
        if (-not $trimmed) { continue }
        if ($trimmed.StartsWith("-")) {
            $trimmed = $trimmed.TrimStart("- ").Trim()
        }
        if ($trimmed.StartsWith("Do đó,")) { continue }
        if ($trimmed.StartsWith("Nhờ bác")) { continue }
        if ($trimmed.StartsWith("Nếu không đúng")) { continue }
        if ($trimmed.StartsWith("Cảm ơn bác")) { continue }
        if ($trimmed.StartsWith("Chúng tôi đang hiểu rằng:")) {
            $trimmed = $trimmed.Substring("Chúng tôi đang hiểu rằng:".Length).Trim()
        }
        elseif ($trimmed.StartsWith("Chúng tôi đang hiểu rằng")) {
            $trimmed = $trimmed.Substring("Chúng tôi đang hiểu rằng".Length).Trim(':',' ')
        }
        $result.Add("- $trimmed")
    }
    return $result
}

function Get-RelatedScreens {
    param([string[]]$Lines)
    $codes = New-Object System.Collections.Generic.List[string]
    foreach ($line in $Lines) {
        $matches = [regex]::Matches($line, '\b[A-Z]{2}(?:\d{4}|\d{2}xx)\b')
        foreach ($m in $matches) {
            if (-not $codes.Contains($m.Value)) {
                $codes.Add($m.Value)
            }
        }
    }
    return $codes
}

function Get-ProposedActions {
    param(
        [string]$NewCategory,
        [pscustomobject]$Item
    )

    switch ($NewCategory) {
        "impact_investigation" {
            return @(
                "cập nhật xử lý tại $($Item.screen) theo đúng thay đổi của yêu cầu",
                "rà soát đồng bộ các màn hình / CSV / batch đang tham chiếu cùng dữ liệu",
                "giữ nguyên database nếu chưa có chỉ thị thay đổi schema"
            )
        }
        "scope_keep" {
            return @(
                "giữ nguyên xử lý hiện tại cho các màn hình chưa được mô tả chi tiết",
                "chỉ mở rộng scope khi có mô tả bổ sung rõ ràng từ phía khách hàng"
            )
        }
        "version_conflict" {
            return @(
                "chốt version tài liệu chính thức trước khi tiến hành design và estimate",
                "tạm thời chưa mở rộng implement theo phần tài liệu chưa được xác nhận"
            )
        }
        "search_item" {
            return @(
                "chốt vị trí hiển thị, type và giá trị lựa chọn của item search",
                "xác định rõ logic AND / OR và giá trị default trước khi thiết kế UI"
            )
        }
        "workflow_gap" {
            return @(
                "chốt màn hình hoặc bước nghiệp vụ thay thế sau thay đổi flow",
                "chốt status, handoff và dữ liệu cần clear / giữ lại trong quá trình chuyển bước"
            )
        }
        "validation" {
            return @(
                "chốt rule validation giữa UI, CSV và batch để tránh lệch behavior",
                "xác định rõ message lỗi, timing check và cách block xử lý trước khi implement"
            )
        }
        "import_csv" {
            return @(
                "thống nhất template, encoding và quyền sử dụng button import",
                "chốt rõ rule rollback toàn bộ hay partial import khi có lỗi"
            )
        }
        "csv_output" {
            return @(
                "chốt header, nguồn dữ liệu và mapping output của từng column",
                "xác định rõ rule compatibility nếu có thay đổi layout file"
            )
        }
        "display_label" {
            return @(
                "chốt label / icon / color rule trước khi thực hiện thiết kế màn hình",
                "đảm bảo cách hiển thị đồng nhất giữa UI và output liên quan"
            )
        }
        "notification" {
            return @(
                "chốt đối tượng nhận, template và thời điểm gửi thông báo",
                "xác định rõ behavior khi gửi thất bại để tránh lệch nghiệp vụ"
            )
        }
        "mapping" {
            return @(
                "chốt item nguồn và item đích trước khi triển khai mapping",
                "xác định rõ trường hợp 1-1 hay 1-n nếu có phát sinh nhiều reference"
            )
        }
        "permission" {
            return @(
                "chốt authority matrix cho từng role hoặc bộ phận liên quan",
                "thống nhất rõ rule hiển thị / disable / readonly của từng thao tác"
            )
        }
        "master_data" {
            return @(
                "chốt master source và rule inactive data trước khi implement",
                "xác định rõ cách xử lý khi dữ liệu cũ đang tham chiếu master đã thay đổi"
            )
        }
        "multi_rule" {
            return @(
                "chốt precedence của từng rule khi nhiều điều kiện cùng thỏa",
                "tách rõ rule hiển thị ở mức record và mức field nếu cần"
            )
        }
        "batch" {
            return @(
                "chốt snapshot timing, job summary và khả năng rerun của batch",
                "xác định rõ ảnh hưởng giữa batch và thao tác tay trên màn hình"
            )
        }
        "api" {
            return @(
                "chốt timing call, retry, timeout và rule duplicate control",
                "xác định rõ behavior khi interface trả lỗi hoặc phản hồi trễ"
            )
        }
        "database" {
            return @(
                "chốt null handling, history handling và phạm vi thay đổi schema",
                "xác định rõ dữ liệu cũ sẽ được giữ nguyên hay cần chuẩn hóa lại"
            )
        }
        "exception_case" {
            return @(
                "chốt recovery path và warning cần hiển thị cho operator",
                "xác định rõ log hoặc checklist vận hành cho các trường hợp bất thường"
            )
        }
        default {
            return @("chốt lại nhận thức hiện tại trước khi triển khai tiếp")
        }
    }
}

function Get-Lead {
    param(
        [string]$NewCategory,
        [pscustomobject]$Item
    )

    switch ($NewCategory) {
        "impact_investigation" { return "Liên quan đến việc xử lý hạng mục liên quan tại $($Item.screen)." }
        "scope_keep" { return "Về các màn hình hoặc batch chưa được mô tả đầy đủ trong tài liệu." }
        "version_conflict" { return "Về việc cần chốt lại version tài liệu áp dụng." }
        "search_item" { return "Về việc bổ sung hoặc điều chỉnh item search." }
        "workflow_gap" { return "Liên quan đến thay đổi flow xử lý hiện tại." }
        "validation" { return "Liên quan đến rule validation của hạng mục đang thay đổi." }
        "import_csv" { return "Liên quan đến button import CSV." }
        "csv_output" { return "Liên quan đến output CSV." }
        "display_label" { return "Liên quan đến yêu cầu hiển thị giá trị trên màn hình." }
        "notification" { return "Liên quan đến xử lý thông báo / Email." }
        "mapping" { return "Liên quan đến mapping dữ liệu giữa các đối tượng." }
        "permission" { return "Liên quan đến quyền thao tác của user." }
        "master_data" { return "Liên quan đến dữ liệu tham chiếu master." }
        "multi_rule" { return "Liên quan đến trường hợp nhiều rule cùng tác động." }
        "batch" { return "Liên quan đến xử lý batch." }
        "api" { return "Liên quan đến xử lý interface / API." }
        "database" { return "Liên quan đến xử lý lưu trữ dữ liệu." }
        "exception_case" { return "Liên quan đến trường hợp exception / abnormal case." }
        default { return "Liên quan đến nội dung yêu cầu hiện tại." }
    }
}

function Get-ConfirmationIntro {
    param([string]$NewCategory)

    switch ($NewCategory) {
        "impact_investigation" { return "Nhờ bác xác nhận thêm giúp các điểm ảnh hưởng dưới đây:" }
        "scope_keep" { return "Nhờ bác xác nhận giúp cách hiểu của chúng tôi về phạm vi xử lý:" }
        "version_conflict" { return "Vì vậy, team xin xác nhận lại các điểm dưới đây:" }
        "search_item" { return "Để chốt cách bố trí item search, team xin xác nhận thêm:" }
        "workflow_gap" { return "Để tránh lệch flow ở bước tiếp theo, team xin xác nhận thêm:" }
        "validation" { return "Để chốt rule xử lý, team xin xác nhận thêm các điểm sau:" }
        "import_csv" { return "Ngoài ra, team xin xác nhận thêm rule import như sau:" }
        "csv_output" { return "Để chốt format output, team xin xác nhận thêm:" }
        "display_label" { return "Để thống nhất cách hiển thị, team xin xác nhận thêm:" }
        "notification" { return "Để chốt hướng gửi thông báo, team xin xác nhận thêm:" }
        "mapping" { return "Để tránh sai mapping khi implement, team xin xác nhận thêm:" }
        "permission" { return "Để chốt authority matrix, team xin xác nhận thêm:" }
        "master_data" { return "Để thống nhất nguồn master tham chiếu, team xin xác nhận thêm:" }
        "multi_rule" { return "Để tránh xung đột rule khi triển khai, team xin xác nhận thêm:" }
        "batch" { return "Để chốt behavior của batch, team xin xác nhận thêm:" }
        "api" { return "Để chốt interface behavior, team xin xác nhận thêm:" }
        "database" { return "Để chốt cách lưu dữ liệu, team xin xác nhận thêm:" }
        "exception_case" { return "Đối với các trường hợp bất thường, team xin xác nhận thêm:" }
        default { return "Ngoài ra, chúng tôi xin xác nhận thêm các điểm sau:" }
    }
}

function Build-BrSEText {
    param(
        [pscustomobject]$Item,
        [hashtable]$Parsed,
        [string]$NewCategory
    )

    $contextLines = $Parsed.context
    $understandingLines = Ensure-Bullets -Lines $Parsed.understanding
    $questionLines = Ensure-Bullets -Lines $Parsed.question
    $lead = Get-Lead -NewCategory $NewCategory -Item $Item

    $result = New-Object System.Collections.Generic.List[string]
    $result.Add($lead)
    $result.Add("")

    foreach ($line in $contextLines) {
        $result.Add($line)
    }

    $result.Add("")
    $result.Add("Để thống nhất hướng xử lý và tránh hiểu sai nghiệp vụ, chúng tôi muốn xác nhận thêm các nội dung sau.")

    $relatedScreens = Get-RelatedScreens -Lines $contextLines
    if (@($relatedScreens).Count -gt 1) {
        $result.Add("")
        $result.Add("Trong quá trình điều tra, chúng tôi nhận thấy có các đối tượng liên quan như sau:")
        foreach ($code in $relatedScreens) {
            if ($code -ne $Item.screen) {
                $result.Add("- $code")
            }
        }
    }

    $result.Add("")

    $investigationLine = $contextLines | Where-Object { $_.StartsWith("Sau khi điều tra hệ thống hiện tại") } | Select-Object -First 1
    if ($investigationLine) {
        $result.Add("Hiện tại bên chúng tôi đang hiểu rằng:")
    }
    else {
        $result.Add("Sau khi điều tra hệ thống hiện tại, chúng tôi đang hiểu như sau:")
    }

    foreach ($line in $understandingLines) {
        $result.Add($line)
    }

    if ($understandingLines.Count -gt 0) {
        $result.Add("")
        $result.Add("Phương án đối ứng của chúng tôi dự kiến là:")
        foreach ($line in (Get-ProposedActions -NewCategory $NewCategory -Item $Item)) {
            $result.Add("- $line")
        }
    }

    if ($questionLines.Count -gt 0) {
        $result.Add("")
        $result.Add("Các nội dung cần xác nhận:")
        $index = 1
        foreach ($line in $questionLines) {
            $clean = $line.TrimStart("- ").Trim()
            switch ($index) {
                1 { $marker = "①" }
                2 { $marker = "②" }
                3 { $marker = "③" }
                4 { $marker = "④" }
                5 { $marker = "⑤" }
                default { $marker = "$index." }
            }
            $result.Add("$marker $clean")
            $index++
        }
    }

    $result.Add("")
    $result.Add("Nhờ bác xác nhận lại nội dung trên.")
    $result.Add("Nếu không đúng, phiền bác mô tả rõ hơn.")
    $result.Add("Cảm ơn bác.")
    return ($result -join "`n")
}

$items = Get-Content $InputPath | ForEach-Object { $_ | ConvertFrom-Json }
$outDir = Split-Path -Parent $OutputPath
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

$rows = New-Object System.Collections.Generic.List[string]
$i = 1
foreach ($item in $items) {
    $newCategory = Get-NewCategory -Category $item.category
    $parsed = Parse-Sections -QaText $item.qa
    $newQa = Build-BrSEText -Item $item -Parsed $parsed -NewCategory $newCategory

    $obj = [ordered]@{
        id = ("BI-QA-{0:D4}" -f $i)
        category = $newCategory
        module = $item.module
        screen = $item.screen
        topic = $item.topic
        style = Get-Style -Category $newCategory
        source_pattern = Get-SourcePattern -Topic $item.topic
        difficulty = $item.difficulty
        qa = $newQa
    }
    $rows.Add(($obj | ConvertTo-Json -Compress -Depth 6))
    $i++
}

$utf8Bom = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllLines($OutputPath, $rows, $utf8Bom)

Write-Output "Generated $($rows.Count) records at $OutputPath"
