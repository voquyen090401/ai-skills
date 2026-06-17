Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$script:QaSkillRoot = Split-Path -Path $PSScriptRoot -Parent
$script:QaCategories = @(
    "impact_investigation",
    "scope_keep",
    "version_conflict",
    "search_item",
    "workflow_gap",
    "import_csv",
    "csv_output",
    "file_export",
    "display_label",
    "notification",
    "mapping",
    "permission",
    "master_data",
    "validation",
    "multi_rule",
    "batch",
    "api",
    "database",
    "exception_case"
)

function Write-QaLog {
    param(
        [ValidateSet("INFO", "WARN", "ERROR", "PASS")]
        [string]$Level,
        [string]$Message
    )

    Write-Output ("[QA-SKILL][{0}] {1}" -f $Level, $Message)
}

function Get-QaSkillRoot {
    return $script:QaSkillRoot
}

function Get-QaReferencePath {
    param([string]$ChildPath = "")
    $root = Join-Path (Get-QaSkillRoot) "references"
    if (-not $ChildPath) { return $root }
    return Join-Path $root $ChildPath
}

function Get-QaScriptPath {
    param([string]$ChildPath = "")
    $root = Join-Path (Get-QaSkillRoot) "scripts"
    if (-not $ChildPath) { return $root }
    return Join-Path $root $ChildPath
}

function Get-QaTestPath {
    param([string]$ChildPath = "")
    $root = Join-Path (Get-QaSkillRoot) "tests"
    if (-not $ChildPath) { return $root }
    return Join-Path $root $ChildPath
}

function Get-QaOutputPath {
    param([string]$ChildPath = "")
    $repoRoot = Split-Path (Split-Path (Get-QaSkillRoot) -Parent) -Parent
    $root = Join-Path $repoRoot "output"
    if (-not $ChildPath) { return $root }
    return Join-Path $root $ChildPath
}

function Get-QaDatasetPath {
    return Get-QaReferencePath -ChildPath "gold_dataset.jsonl"
}

function Get-QaCandidateDatasetPath {
    return Get-QaReferencePath -ChildPath "candidate_dataset.generated.jsonl"
}

function Get-QaBackupDatasetPath {
    return Get-QaReferencePath -ChildPath "gold_dataset.backup-before-stellaria.jsonl"
}

function Get-QaRequiredFiles {
    return @(
        (Join-Path (Get-QaSkillRoot) "SKILL.md"),
        (Get-QaReferencePath -ChildPath "gold_dataset.jsonl"),
        (Get-QaReferencePath -ChildPath "output-template.md"),
        (Get-QaReferencePath -ChildPath "qa-groups.md"),
        (Join-Path (Get-QaSkillRoot) "agents\openai.yaml"),
        (Get-QaScriptPath -ChildPath "build_prompt_bundle.ps1"),
        (Get-QaScriptPath -ChildPath "export_qa_skill_report.ps1"),
        (Get-QaScriptPath -ChildPath "import_gold_qa.ps1"),
        (Get-QaScriptPath -ChildPath "qa_skill_lib.ps1"),
        (Get-QaScriptPath -ChildPath "regenerate_brse_investigation_dataset.ps1"),
        (Get-QaScriptPath -ChildPath "run_qa_skill_tests.ps1"),
        (Get-QaScriptPath -ChildPath "update_qa_snapshots.ps1"),
        (Get-QaScriptPath -ChildPath "validate_qa_skill.ps1"),
        (Get-QaTestPath -ChildPath "fixtures.json"),
        (Get-QaTestPath -ChildPath "snapshots.json")
    )
}

function Ensure-QaParentDirectory {
    param([string]$Path)

    $parent = Split-Path -Path $Path -Parent
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

function Read-QaTextFile {
    param([string]$Path)
    return [System.IO.File]::ReadAllText((Resolve-Path $Path), [System.Text.Encoding]::UTF8)
}

function Read-QaJsonFile {
    param([string]$Path)
    return Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json
}

function Write-QaJsonFile {
    param(
        [string]$Path,
        [object]$Data,
        [int]$Depth = 10
    )

    Ensure-QaParentDirectory -Path $Path
    $utf8Bom = New-Object System.Text.UTF8Encoding($true)
    [System.IO.File]::WriteAllText($Path, ($Data | ConvertTo-Json -Depth $Depth), $utf8Bom)
}

function Read-JsonlFile {
    param([string]$Path)
    return @(Get-Content -LiteralPath $Path | ForEach-Object { $_ | ConvertFrom-Json })
}

function Write-JsonlFile {
    param(
        [string]$Path,
        [object[]]$Records,
        [int]$Depth = 10
    )

    Ensure-QaParentDirectory -Path $Path
    $utf8Bom = New-Object System.Text.UTF8Encoding($true)
    [System.IO.File]::WriteAllLines(
        $Path,
        @($Records | ForEach-Object { $_ | ConvertTo-Json -Compress -Depth $Depth }),
        $utf8Bom
    )
}

function Get-QaDatasetStatistics {
    param([object[]]$Records)

    $duplicateIds = @(
        $Records |
        Group-Object id |
        Where-Object { $_.Count -gt 1 } |
        ForEach-Object { $_.Name }
    )
    $duplicateQa = @(
        $Records |
        Group-Object { (("{0}" -f $_.qa) -replace '\s+', ' ').Trim().ToLowerInvariant() } |
        Where-Object { $_.Name -and $_.Count -gt 1 } |
        ForEach-Object { $_.Group[0].id }
    )

    return [pscustomobject]@{
        total = @($Records).Count
        needs_review = @($Records | Where-Object { $_.PSObject.Properties.Name -contains "needs_review" -and $_.needs_review }).Count
        duplicate_ids = @($duplicateIds)
        duplicate_qa = @($duplicateQa)
        by_category = @($Records | Group-Object category | Sort-Object Name | ForEach-Object {
                [pscustomobject]@{ name = $_.Name; count = $_.Count }
            })
        by_difficulty = @($Records | Group-Object difficulty | Sort-Object Name | ForEach-Object {
                [pscustomobject]@{ name = $_.Name; count = $_.Count }
            })
        by_module = @($Records | Group-Object module | Sort-Object Name | ForEach-Object {
                [pscustomobject]@{ name = $_.Name; count = $_.Count }
            })
        by_screen = @($Records | Group-Object screen | Sort-Object Name | ForEach-Object {
                [pscustomobject]@{ name = $_.Name; count = $_.Count }
            })
    }
}

function Test-QaCategoryValue {
    param([string]$Category)
    return $script:QaCategories -contains $Category
}

function Get-QaExpectedChecks {
    param([pscustomobject]$Fixture)

    if ($Fixture.PSObject.Properties.Name -contains "expected" -and $Fixture.expected) {
        return [pscustomobject]@{
            must_contain = @($Fixture.expected.mustContain)
            must_not_contain = @($Fixture.expected.mustNotContain)
        }
    }

    return [pscustomobject]@{
        must_contain = @($Fixture.must_contain)
        must_not_contain = @($Fixture.must_not_contain)
    }
}

function New-QaFixtureRecord {
    param([pscustomobject]$Fixture)

    return [pscustomobject]@{
        id = $Fixture.id
        category = $Fixture.category
        module = $Fixture.module
        screen = $Fixture.screen
        topic = $Fixture.topic
        style = "business_understanding_confirm"
        difficulty = $Fixture.difficulty
        source_reference = $Fixture.source_reference
        input_context = $Fixture.input_context
        evidence = @($Fixture.evidence)
        current_understanding = @($Fixture.current_understanding)
        unclear_points = @($Fixture.unclear_points)
        confirmation_points = @($Fixture.confirmation_points)
        focus_label = $Fixture.focus_label
        qa = $null
    }
}

function Get-QaFewShotExamples {
    param(
        [string]$InputText,
        [object[]]$Dataset,
        [int]$FewShotCount = 3
    )

    $inputTokens = @(
        [regex]::Matches(($InputText.ToLowerInvariant()), '\p{L}[\p{L}\p{N}_\-]{2,}') |
        ForEach-Object { $_.Value } |
        Select-Object -Unique
    )

    $scored = foreach ($row in @($Dataset)) {
        $corpus = @(
            $row.module
            $row.screen
            $row.topic
            $row.input_context
            @($row.evidence)
            @($row.confirmation_points)
        ) -join " "
        $text = $corpus.ToLowerInvariant()
        $score = 0
        foreach ($token in $inputTokens) {
            if ($text -match [regex]::Escape($token)) {
                $score++
            }
        }

        [pscustomobject]@{
            score = $score
            record = $row
        }
    }

    $selected = @(
        $scored |
        Sort-Object @{ Expression = "score"; Descending = $true }, @{ Expression = { $_.record.id } } |
        Select-Object -First $FewShotCount
    )

    if (@($selected | Where-Object { $_.score -gt 0 }).Count -eq 0) {
        return @($Dataset | Select-Object -First $FewShotCount)
    }

    return @($selected.record)
}

function Build-QaPromptBundle {
    param(
        [string]$InputText,
        [string]$SkillText,
        [string]$TemplateText,
        [string]$GroupText,
        [object[]]$Examples
    )

    $bundle = New-Object System.Collections.Generic.List[string]
    $bundle.Add("# QA Runtime Prompt Bundle")
    $bundle.Add("")
    $bundle.Add("## Skill Role")
    $bundle.Add($SkillText.Trim())
    $bundle.Add("")
    $bundle.Add("## Core Instructions")
    $bundle.Add("Follow the QA skill rules, stay evidence-bound, choose the smallest matching QA group, and return customer-ready Vietnamese QA only.")
    $bundle.Add("")
    $bundle.Add("## QA Category Rules")
    $bundle.Add($GroupText.Trim())
    $bundle.Add("")
    $bundle.Add("## Output Template")
    $bundle.Add($TemplateText.Trim())
    $bundle.Add("")
    $bundle.Add("## Relevant Gold Examples")

    $index = 1
    foreach ($item in @($Examples)) {
        $bundle.Add("")
        $bundle.Add(("### Example {0}" -f $index))
        $bundle.Add(("Category: {0}" -f $item.category))
        $bundle.Add(("Input: {0}" -f $item.input_context))
        $bundle.Add("Output:")
        $bundle.Add($item.qa)
        $index++
    }

    $bundle.Add("")
    $bundle.Add("## User Input")
    $bundle.Add($InputText.Trim())
    return ($bundle -join "`n")
}

function Test-QaPromptBundleSections {
    param([string]$PromptBundle)

    $requiredSections = @(
        "## Skill Role",
        "## Core Instructions",
        "## QA Category Rules",
        "## Output Template",
        "## Relevant Gold Examples",
        "## User Input"
    )

    $issues = New-Object System.Collections.Generic.List[string]
    foreach ($section in $requiredSections) {
        if ($PromptBundle -notmatch [regex]::Escape($section)) {
            $issues.Add("Thiếu section bắt buộc trong prompt bundle: $section")
        }
    }
    return @($issues)
}

function Convert-LegacyCategory {
    param([string]$Category)

    switch ($Category) {
        "impact_analysis" { return "impact_investigation" }
        "screen_scope" { return "scope_keep" }
        "search_condition" { return "search_item" }
        "workflow" { return "workflow_gap" }
        "status_transition" { return "multi_rule" }
        "csv_import" { return "import_csv" }
        "csv_export" { return "csv_output" }
        "mail_notification" { return "notification" }
        "data_mapping" { return "mapping" }
        default { return $Category }
    }
}

function Get-QAStyle {
    param([string]$Category)
    return "business_understanding_confirm"
}

function Get-FormatHint {
    param(
        [string]$Category,
        [string]$Topic,
        [string[]]$ConfirmationPoints,
        [string]$InputContext
    )

    $joined = (@($ConfirmationPoints) + @($InputContext)) -join " "
    if ($joined -match '(=|<>|!=|>=|<=)') { return "by_case" }
    if ($joined -match '\bcheck\b|\buncheck\b|checkbox|Khi |khi ') { return "state_transition" }
    if ($Category -in @("mapping", "csv_output") -and @($ConfirmationPoints).Count -ge 2) { return "grouped_topics" }
    if ($Category -in @("multi_rule", "workflow_gap")) { return "by_case" }
    if (@($ConfirmationPoints).Count -ge 3) { return "multi_understanding" }
    return "understanding_confirm"
}

function Parse-LegacyQASections {
    param([string]$QaText)

    $context = [regex]::Match($QaText, '■ Bối cảnh\s*(?<content>[\s\S]*?)(■ Nhận thức hiện tại|■ Câu hỏi xác nhận)')
    $understanding = [regex]::Match($QaText, '■ Nhận thức hiện tại\s*(?<content>[\s\S]*?)■ Câu hỏi xác nhận')
    $question = [regex]::Match($QaText, '■ Câu hỏi xác nhận\s*(?<content>[\s\S]*)$')

    return [ordered]@{
        Context = Get-CleanLines -Text ($context.Groups["content"].Value)
        Understanding = Get-CleanLines -Text ($understanding.Groups["content"].Value)
        Questions = Get-CleanLines -Text ($question.Groups["content"].Value)
    }
}

function Get-CleanLines {
    param([string]$Text)

    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($line in ($Text -split "`r?`n")) {
        $trimmed = $line.Trim()
        if (-not $trimmed) { continue }
        $trimmed = $trimmed -replace '^[\-•①②③④⑤⑥⑦⑧⑨0-9\.]+\s*', ''
        if ($trimmed -in @(
            "Nhờ bác xác nhận giúp.",
            "Nhờ bác xác nhận giúp",
            "Nhờ bác xác nhận giúp nội dung trên.",
            "Nhờ bác xác nhận lại nội dung trên.",
            "Nếu không đúng, phiền bác mô tả rõ hơn.",
            "Cảm ơn bác."
        )) {
            continue
        }
        if ($trimmed.StartsWith("Do đó,")) {
            $trimmed = $trimmed.Substring(5).Trim()
        }
        if ($trimmed.StartsWith("Chúng tôi đang hiểu rằng:")) {
            $trimmed = $trimmed.Substring("Chúng tôi đang hiểu rằng:".Length).Trim()
        }
        elseif ($trimmed.StartsWith("Chúng tôi đang hiểu rằng")) {
            $trimmed = $trimmed.Substring("Chúng tôi đang hiểu rằng".Length).Trim(':', ' ')
        }
        if ($trimmed) {
            $lines.Add($trimmed)
        }
    }
    return $lines.ToArray()
}

function Split-Sentences {
    param([string[]]$Lines)

    $sentences = New-Object System.Collections.Generic.List[string]
    foreach ($line in @($Lines)) {
        foreach ($fragment in ($line -split '(?<=[\.\?\!])\s+')) {
            $trimmed = $fragment.Trim()
            if ($trimmed) {
                $sentences.Add($trimmed)
            }
        }
    }
    return $sentences.ToArray()
}

function Get-SourceReference {
    param(
        [pscustomobject]$Item,
        [string[]]$ContextLines
    )

    $joined = ((@($Item.input_context) + @($ContextLines)) -join " ")
    $sheetMatch = [regex]::Match($joined, '(?i)(sheet)\s+([A-Z]{1,4}\d{0,4})')
    $lineMatches = [regex]::Matches($joined, '(?i)\bline[s]?\s+([0-9]+(?:\s*[-–]\s*[0-9]+)?)')
    $sheet = if ($sheetMatch.Success) { $sheetMatch.Groups[2].Value.Trim() } else { $null }

    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($match in $lineMatches) {
        $value = ($match.Groups[1].Value -replace '\s+', '')
        if (-not $lines.Contains($value)) {
            $lines.Add($value)
        }
    }

    $reference = [ordered]@{}
    if ($sheet) { $reference["sheet"] = $sheet }
    if ($Item.screen) { $reference["screen"] = $Item.screen }
    if ($lines.Count -gt 0) { $reference["lines"] = $lines.ToArray() }

    if ($reference.Count -eq 0) {
        return $null
    }

    return [pscustomobject]$reference
}

function Get-FocusLabel {
    param(
        [pscustomobject]$Item,
        [string[]]$ContextLines
    )

    $input = [string]$Item.input_context
    $firstSentence = if ($input) { ($input -split '\.')[0].Trim() } else { "" }
    $quotedItem = [regex]::Match((@($ContextLines) -join " "), '「[^」]+」')
    if ($firstSentence -match '(?i)Góc xác nhận') {
        $firstSentence = ($firstSentence -replace '(?i)Góc xác nhận.*$', '').Trim()
    }
    $firstSentence = $firstSentence -replace '^(Spec|Q&A mẫu|Impact|Sheet|Màn hình)\s*', ''
    $firstSentence = $firstSentence -replace '\s+trên\s+[A-Z]{2}\d{4}.*$', ''
    $firstSentence = $firstSentence -replace '^\s*[:\-]\s*', ''
    $firstSentence = $firstSentence -replace '^(bổ sung|thêm)\s+', ''
    $firstSentence = $firstSentence -replace '\s+cho\s+[A-Z]{2}\d{4}$', ''
    $firstSentence = $firstSentence -replace '\s+nhưng.*$', ''
    $firstSentence = $firstSentence.Trim()

    if ($quotedItem.Success -and $firstSentence -notmatch '「') {
        if ($firstSentence) {
            return "$firstSentence $($quotedItem.Value)".Trim()
        }
        return "nội dung $($quotedItem.Value)"
    }

    if ($firstSentence) {
        return $firstSentence
    }

    return "nội dung yêu cầu"
}

function Get-ReferenceText {
    param([pscustomobject]$SourceReference)

    if (-not $SourceReference) { return $null }

    $parts = New-Object System.Collections.Generic.List[string]
    if ($SourceReference.PSObject.Properties.Name -contains "lines" -and @($SourceReference.lines).Count -gt 0) {
        $parts.Add(("line {0}" -f ((@($SourceReference.lines)) -join ", ")))
    }
    if ($SourceReference.PSObject.Properties.Name -contains "screen" -and $SourceReference.screen) {
        $parts.Add(("màn hình {0}" -f $SourceReference.screen))
    }
    if ($SourceReference.PSObject.Properties.Name -contains "sheet" -and $SourceReference.sheet) {
        $parts.Add(("sheet {0}" -f $SourceReference.sheet))
    }

    if ($parts.Count -eq 0) { return $null }
    return ($parts -join " của ")
}

function Convert-ContextToEvidence {
    param([string[]]$ContextLines)
    return Split-Sentences -Lines $ContextLines
}

function Get-UnclearPoints {
    param(
        [string[]]$ContextLines,
        [string[]]$QuestionLines
    )

    $unclear = New-Object System.Collections.Generic.List[string]
    foreach ($line in @($ContextLines)) {
        if ($line -match 'chưa|không rõ|thiếu|chưa thấy|chưa xác định') {
            $unclear.Add($line)
        }
    }
    foreach ($line in @($QuestionLines)) {
        if ($line -notmatch '\?$') {
            $unclear.Add($line)
        }
    }
    return $unclear.ToArray()
}

function Normalize-ConfirmationPoints {
    param([string[]]$QuestionLines)

    $points = New-Object System.Collections.Generic.List[string]
    foreach ($line in @($QuestionLines)) {
        $trimmed = $line.Trim()
        if (-not $trimmed) { continue }
        $trimmed = $trimmed.TrimStart(',', ':', '-', ' ')
        if ($trimmed -match '^(?i)chúng tôi đang hiểu cần xác nhận|^(?i)do đó|^(?i)nhờ bác|^(?i)nếu cách hiểu') {
            continue
        }
        if ($trimmed -match '(?i)phase') {
            continue
        }
        if ($trimmed -notmatch '\?$') {
            $trimmed = $trimmed + "?"
        }
        $points.Add($trimmed)
    }
    return $points.ToArray()
}

function Join-Paragraph {
    param([string[]]$Lines)
    return ((@($Lines) | Where-Object { $_ }) -join " ")
}

function Get-CleanConfirmationText {
    param([string]$Text)

    $clean = $Text.Trim()
    $clean = $clean.TrimEnd('?', '.', ' ', ';', ':')
    return $clean
}

function Get-SectionLabels {
    param([string]$Category)

    switch ($Category) {
        "mapping" { return @("Về nguồn tham chiếu", "Về rule mapping") }
        "csv_output" { return @("Về item output", "Về nguồn dữ liệu và rule hiển thị") }
        default { return @("Về nội dung cần xác nhận") }
    }
}

function Group-ConfirmationPoints {
    param(
        [string[]]$ConfirmationPoints,
        [string]$Category
    )

    if ($Category -notin @("mapping", "csv_output")) {
        return @([pscustomobject]@{
            Title = $null
            Points = $ConfirmationPoints
        })
    }

    $labels = Get-SectionLabels -Category $Category
    $groups = New-Object System.Collections.Generic.List[object]
    $mid = [Math]::Ceiling(@($ConfirmationPoints).Count / 2.0)
    $groups.Add([pscustomobject]@{
        Title = $labels[0]
        Points = @($ConfirmationPoints)[0..([Math]::Max($mid - 1, 0))]
    })
    if (@($ConfirmationPoints).Count -gt $mid) {
        $groups.Add([pscustomobject]@{
            Title = $labels[1]
            Points = @($ConfirmationPoints)[$mid..(@($ConfirmationPoints).Count - 1)]
        })
    }
    return $groups.ToArray()
}

function Get-CaseTitles {
    param([string[]]$ConfirmationPoints)

    $titles = New-Object System.Collections.Generic.List[string]
    foreach ($point in @($ConfirmationPoints)) {
        $match = [regex]::Match($point, '「[^」]+」')
        if ($match.Success) {
            $titles.Add("Trường hợp $($match.Value)")
            continue
        }
        if ($point -match '(=|<>|!=|>=|<=)') {
            $titles.Add("Trường hợp $($point -replace '\?.*$','')")
            continue
        }
        if ($point -match '(?i)check') {
            $titles.Add("Khi người dùng check")
            continue
        }
        if ($point -match '(?i)uncheck') {
            $titles.Add("Khi người dùng không check")
            continue
        }
        $titles.Add("Trường hợp cần xác nhận")
    }
    return $titles.ToArray()
}

function Build-OpeningLine {
    param(
        [string]$FocusLabel,
        [pscustomobject]$SourceReference,
        [string]$FormatHint
    )

    $referenceText = Get-ReferenceText -SourceReference $SourceReference
    $scopeText = if ($referenceText) {
        "$FocusLabel được mô tả tại $referenceText"
    }
    else {
        $FocusLabel
    }

    switch ($FormatHint) {
        "grouped_topics" { return "Liên quan đến $scopeText, chúng tôi muốn xác nhận nhận thức như sau:" }
        default { return "Liên quan đến $scopeText, chúng tôi đang hiểu nghiệp vụ như sau:" }
    }
}

function Build-QAText {
    param([pscustomobject]$Record)

    $formatHint = Get-FormatHint -Category $Record.category -Topic $Record.topic -ConfirmationPoints $Record.confirmation_points -InputContext $Record.input_context
    $opening = Build-OpeningLine -FocusLabel $Record.focus_label -SourceReference $Record.source_reference -FormatHint $formatHint
    $understanding = @($Record.current_understanding)
    $unclearPoints = @($Record.unclear_points | Where-Object { $_ -and $_ -notmatch '^(,|:)?\s*chúng tôi' })
    $confirmation = @($Record.confirmation_points)

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add($opening)
    $lines.Add("")

    switch ($formatHint) {
        "grouped_topics" {
            $groups = Group-ConfirmationPoints -ConfirmationPoints $confirmation -Category $Record.category
            $index = 1
            foreach ($group in $groups) {
                if ($group.Title) {
                    $lines.Add("$index. $($group.Title):")
                    $lines.Add("")
                    foreach ($u in $understanding) {
                        $lines.Add($u)
                    }
                }
                else {
                    foreach ($u in $understanding) {
                        $lines.Add("$index. $u")
                        $index++
                    }
                }
                if ($group.Title) {
                    $lines.Add("")
                    $lines.Add("Nhờ Bác xác nhận thêm giúp các điểm sau:")
                    $questionIndex = 1
                    foreach ($point in $group.Points) {
                        $lines.Add("$questionIndex. $(Get-CleanConfirmationText -Text $point)?")
                        $questionIndex++
                    }
                    $lines.Add("")
                    $index++
                }
            }
        }
        "by_case" {
            $caseTitles = Get-CaseTitles -ConfirmationPoints $confirmation
            $commonIndex = 1
            foreach ($u in $understanding) {
                $lines.Add("$commonIndex. $u")
                $commonIndex++
            }
            foreach ($unclear in $unclearPoints) {
                $lines.Add("$commonIndex. $unclear")
                $commonIndex++
            }
            $caseIndex = $commonIndex
            for ($i = 0; $i -lt $confirmation.Count; $i++) {
                $lines.Add("")
                $lines.Add("$caseIndex. $($caseTitles[$i]):")
                $lines.Add("   - $(Get-CleanConfirmationText -Text $confirmation[$i])?")
                $caseIndex++
            }
        }
        "state_transition" {
            for ($i = 0; $i -lt $understanding.Count; $i++) {
                $lines.Add(("{0}. {1}" -f ($i + 1), $understanding[$i]))
            }
            $offset = $understanding.Count
            foreach ($unclear in $unclearPoints) {
                $offset++
                $lines.Add(("{0}. {1}" -f $offset, $unclear))
            }
            for ($i = 0; $i -lt $confirmation.Count; $i++) {
                $lines.Add("")
                $lines.Add(("{0}. {1}?" -f ($offset + $i + 1), (Get-CleanConfirmationText -Text $confirmation[$i])))
            }
        }
        default {
            for ($i = 0; $i -lt $understanding.Count; $i++) {
                $lines.Add(("{0}. {1}" -f ($i + 1), $understanding[$i]))
            }
            $nextIndex = $understanding.Count + 1
            foreach ($unclear in $unclearPoints) {
                $lines.Add(("{0}. {1}" -f $nextIndex, $unclear))
                $nextIndex++
            }
            if ($confirmation.Count -gt 0) {
                $lines.Add("")
                $lines.Add("Nhờ Bác xác nhận thêm giúp các điểm sau:")
                $questionIndex = 1
                foreach ($point in $confirmation) {
                    $lines.Add("$questionIndex. $(Get-CleanConfirmationText -Text $point)?")
                    $questionIndex++
                }
            }
        }
    }

    $lines.Add("")
    if ($formatHint -eq "grouped_topics") {
        $lines.Add("Nhờ Bác xác nhận giúp chúng tôi các nội dung trên.")
    }
    else {
        $lines.Add("Nhờ Bác xác nhận giúp cách hiểu trên có đúng không ạ?")
    }

    return ($lines -join "`n")
}

function Convert-LegacyRecord {
    param([pscustomobject]$Item)

    $parsed = Parse-LegacyQASections -QaText $Item.qa
    $sourceReference = Get-SourceReference -Item $Item -ContextLines $parsed.Context

    $record = [ordered]@{
        id = ($Item.id -replace '^QA', 'BI-QA')
        category = Convert-LegacyCategory -Category $Item.category
        module = $Item.module
        screen = $Item.screen
        topic = $Item.topic
        style = Get-QAStyle -Category (Convert-LegacyCategory -Category $Item.category)
        difficulty = $Item.difficulty
        source_type = if ($Item.PSObject.Properties.Name -contains "source_type") { $Item.source_type } else { $null }
        source_file = if ($Item.PSObject.Properties.Name -contains "source_file") { $Item.source_file } else { $null }
        source_reference = $sourceReference
        input_context = $Item.input_context
        evidence = Convert-ContextToEvidence -ContextLines $parsed.Context
        current_understanding = @($parsed.Understanding)
        unclear_points = Get-UnclearPoints -ContextLines $parsed.Context -QuestionLines $parsed.Questions
        confirmation_points = Normalize-ConfirmationPoints -QuestionLines $parsed.Questions
        focus_label = Get-FocusLabel -Item $Item -ContextLines $parsed.Context
        needs_review = if ($Item.PSObject.Properties.Name -contains "needs_review") { [bool]$Item.needs_review } else { $false }
        review_notes = if ($Item.PSObject.Properties.Name -contains "review_notes") { @($Item.review_notes) } else { @() }
        qa = $null
    }

    $record.qa = Build-QAText -Record ([pscustomobject]$record)
    return [pscustomobject]$record
}

function Normalize-ExistingRecord {
    param([pscustomobject]$Item)

    $record = [ordered]@{
        id = $Item.id
        category = $Item.category
        module = $Item.module
        screen = $Item.screen
        topic = $Item.topic
        style = if ($Item.PSObject.Properties.Name -contains "style" -and $Item.style) { $Item.style } else { "business_understanding_confirm" }
        difficulty = $Item.difficulty
        source_type = if ($Item.PSObject.Properties.Name -contains "source_type") { $Item.source_type } else { $null }
        source_file = if ($Item.PSObject.Properties.Name -contains "source_file") { $Item.source_file } else { $null }
        source_reference = if ($Item.PSObject.Properties.Name -contains "source_reference") { $Item.source_reference } else { $null }
        input_context = $Item.input_context
        evidence = if ($Item.PSObject.Properties.Name -contains "evidence") { @($Item.evidence) } else { @() }
        current_understanding = if ($Item.PSObject.Properties.Name -contains "current_understanding") { @($Item.current_understanding) } else { @() }
        unclear_points = if ($Item.PSObject.Properties.Name -contains "unclear_points") { @($Item.unclear_points) } else { @() }
        confirmation_points = Normalize-ConfirmationPoints -QuestionLines (@($Item.confirmation_points))
        focus_label = if ($Item.PSObject.Properties.Name -contains "focus_label" -and $Item.focus_label) {
            $Item.focus_label
        }
        else {
            Get-FocusLabel -Item $Item -ContextLines @($Item.evidence)
        }
        needs_review = if ($Item.PSObject.Properties.Name -contains "needs_review") { [bool]$Item.needs_review } else { $false }
        review_notes = if ($Item.PSObject.Properties.Name -contains "review_notes") { @($Item.review_notes) } else { @() }
        qa = $null
    }

    $record.qa = Build-QAText -Record ([pscustomobject]$record)
    return [pscustomobject]$record
}

function Get-ReferenceCorpus {
    param([pscustomobject]$Record)

    return (
        @(
            $Record.input_context
            $Record.module
            $Record.screen
            $Record.topic
            @($Record.evidence)
            @($Record.current_understanding)
            @($Record.confirmation_points)
        ) -join " "
    )
}

function Get-PreservedTerms {
    param([pscustomobject]$Record)

    $referenceBits = New-Object System.Collections.Generic.List[string]
    if ($Record.PSObject.Properties.Name -contains "source_reference" -and $Record.source_reference) {
        if ($Record.source_reference.PSObject.Properties.Name -contains "screen" -and $Record.source_reference.screen) {
            $referenceBits.Add([string]$Record.source_reference.screen)
        }
        if ($Record.source_reference.PSObject.Properties.Name -contains "sheet" -and $Record.source_reference.sheet) {
            $referenceBits.Add([string]$Record.source_reference.sheet)
        }
        if ($Record.source_reference.PSObject.Properties.Name -contains "lines") {
            foreach ($lineValue in @($Record.source_reference.lines)) {
                if ($lineValue) {
                    $referenceBits.Add([string]$lineValue)
                }
            }
        }
    }

    $focusLabel = if ($Record.PSObject.Properties.Name -contains "focus_label") { $Record.focus_label } else { "" }
    $corpus = ((@($Record.input_context, $focusLabel) + $referenceBits.ToArray()) -join " ")
    $terms = New-Object System.Collections.Generic.List[string]

    foreach ($match in [regex]::Matches($corpus, '\b[A-Z]{2}\d{4}\b')) {
        if (-not $terms.Contains($match.Value)) { $terms.Add($match.Value) }
    }
    foreach ($match in [regex]::Matches($corpus, '「[^」]+」')) {
        if (-not $terms.Contains($match.Value)) { $terms.Add($match.Value) }
    }
    foreach ($match in [regex]::Matches($corpus, '(販売部門\s*(?:=|<>|!=|>=|<=)\s*\d+)')) {
        if (-not $terms.Contains($match.Value)) { $terms.Add($match.Value) }
    }
    foreach ($match in [regex]::Matches($corpus, '\b(?:line|Line)\s+[0-9]+(?:[-–][0-9]+)?')) {
        if (-not $terms.Contains($match.Value)) { $terms.Add($match.Value) }
    }

    return $terms.ToArray()
}

function Test-ForInventedEntity {
    param([pscustomobject]$Record)

    $qa = $Record.qa
    $corpus = Get-ReferenceCorpus -Record $Record
    $flags = @(
        @{ Token = "CSV"; Label = "CSV" }
        @{ Token = "batch"; Label = "batch" }
        @{ Token = "API"; Label = "API" }
        @{ Token = "database"; Label = "database" }
        @{ Token = "master"; Label = "master" }
    )

    $issues = New-Object System.Collections.Generic.List[string]
    foreach ($flag in $flags) {
        if ($qa -match [regex]::Escape($flag.Token) -and $corpus -notmatch [regex]::Escape($flag.Token)) {
            $issues.Add("QA nhắc đến $($flag.Label) nhưng input/evidence không có dấu hiệu tương ứng.")
        }
    }
    return $issues.ToArray()
}

function Get-QAValidationResult {
    param([pscustomobject]$Record)

    $qa = [string]$Record.qa
    $issues = New-Object System.Collections.Generic.List[string]
    $score = 10
    $sourceType = if ($Record.PSObject.Properties.Name -contains "source_type") { [string]$Record.source_type } else { "" }
    $isHumanGold = ($sourceType -eq "human_gold_qa")

    $openingPattern = if ($isHumanGold) {
        '^\s*(?:\d+\.\s*)?(Liên quan(?: đến)?|Về việc|Về nội dung|Theo nội dung|Dựa vào|Dựa trên|Theo như|Theo mô tả|Chúng tôi muốn xác nhận|Về vấn đề|Trong quá trình điều tra|Nhờ\s*(Bác|bác)|Khi người dùng|Tại màn hình|Với role|Sau khi)'
    }
    else {
        '^(Liên quan đến|Về việc|Về nội dung|Theo nội dung|Dựa vào|Dựa trên|Theo như|Theo mô tả|Chúng tôi muốn xác nhận|Về vấn đề)'
    }
    if ($qa -notmatch $openingPattern) {
        $issues.Add("Thiếu câu mở đầu nêu phạm vi.")
        $score--
    }
    $understandingPattern = if ($isHumanGold) {
        'chúng tôi.*(hiểu|nhận thức|dự định|đề xuất|ghi nhận|confirm|xác nhận|quyết định)|Theo logic mới|Do đó|Tuy nhiên|hệ thống sẽ|sẽ hiển thị|sẽ tự động|sẽ lấy|tương ứng với'
    }
    else {
        'chúng tôi (đang hiểu|muốn xác nhận nhận thức|hiểu nghiệp vụ như sau|hiểu rằng|nhận thức|dự định|đề xuất|muốn confirm|muốn xác nhận|ghi nhận)|Theo logic mới|Do đó|Tuy nhiên'
    }
    if ($qa -notmatch $understandingPattern) {
        $issues.Add("Thiếu phần thể hiện nhận thức nghiệp vụ.")
        $score--
    }
    $closingPattern = if ($isHumanGold) {
        'Nhờ\s*(Bác|bác)|Xin bác xác nhận|có đúng không|có được không|phù hợp hay không|có vấn đề gì không|confirm|muốn xác nhận|xác nhận lại nhận thức'
    }
    else {
        'Nhờ\s*(Bác|bác).*(xác nhận|confirm)|Xin bác xác nhận|Như vậy có đúng không|có vấn đề gì không|phù hợp hay không'
    }
    if ($qa -notmatch $closingPattern) {
        $issues.Add("Thiếu câu kết thúc phù hợp.")
        $score--
    }
    if ($qa -match '■ Bối cảnh|■ Nhận thức hiện tại|■ Câu hỏi xác nhận') {
        $issues.Add("Còn heading nội bộ cũ.")
        $score--
    }
    if ($qa -match '^\s*(1\.|2\.|3\.)?\s*.+\?$' -and $qa -notmatch 'đang hiểu|hiểu nghiệp vụ') {
        $issues.Add("QA giống danh sách câu hỏi trực tiếp, thiếu nhận thức.")
        $score--
    }

    $numberedLines = @($qa -split "`r?`n" | Where-Object { $_ -match '^\d+\.' })
    $paragraphCount = @($qa -split "(\r?\n){2,}" | Where-Object { $_.Trim() }).Count
    if (-not $isHumanGold -and $numberedLines.Count -eq 0 -and $paragraphCount -lt 2) {
        $issues.Add("Thiếu numbering dễ đọc.")
        $score--
    }

    foreach ($term in (Get-PreservedTerms -Record $Record)) {
        if ($qa -notmatch [regex]::Escape($term)) {
            $issues.Add("QA chưa giữ lại term quan trọng: $term")
            $score--
            break
        }
    }

    foreach ($issue in (Test-ForInventedEntity -Record $Record)) {
        $issues.Add($issue)
        $score--
    }

    if ($score -lt 0) { $score = 0 }

    return [pscustomobject]@{
        id = $Record.id
        passed = ($score -ge 8 -and $issues.Count -eq 0)
        score = $score
        issues = $issues.ToArray()
    }
}

function Get-DatasetValidationSummary {
    param([object[]]$Records)

    $results = @($Records | ForEach-Object { Get-QAValidationResult -Record $_ })
    return [pscustomobject]@{
        total = $results.Count
        passed = @($results | Where-Object { $_.passed }).Count
        failed = @($results | Where-Object { -not $_.passed }).Count
        min_score = ($results | Measure-Object -Property score -Minimum).Minimum
        max_score = ($results | Measure-Object -Property score -Maximum).Maximum
        avg_score = [Math]::Round((($results | Measure-Object -Property score -Average).Average), 2)
        details = $results
    }
}

function Get-QaScriptFiles {
    return @(Get-ChildItem -Path (Get-QaScriptPath) -Filter "*.ps1" -File | Sort-Object Name)
}

function Get-QaScriptParseResult {
    param([string]$Path)

    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$tokens, [ref]$errors)
    return [pscustomobject]@{
        path = $Path
        ast = $ast
        errors = @($errors)
    }
}

function Get-QaScriptFunctionNames {
    param([System.Management.Automation.Language.Ast]$Ast)

    return @(
        $Ast.FindAll({
                param($node)
                $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
            }, $true) |
        ForEach-Object { $_.Name }
    )
}

function Get-QaMarkdownValidationIssues {
    param(
        [string]$SkillText,
        [string]$TemplateText,
        [string]$GroupText
    )

    $issues = New-Object System.Collections.Generic.List[string]

    foreach ($required in @(
            "## Governance Compliance",
            "## Skill Boundary",
            "## Required References",
            "## Output Modes",
            "## Workflow",
            "## Quality Gates"
        )) {
        if ($SkillText -notmatch [regex]::Escape($required)) {
            $issues.Add("SKILL.md thiếu section: $required")
        }
    }

    foreach ($required in @(
            "## Core Principle",
            "## Mandatory Outcome",
            "## Accepted Formats",
            "## Opening Rules",
            "## Writing Rules",
            "## Hard Avoids"
        )) {
        if ($TemplateText -notmatch [regex]::Escape($required)) {
            $issues.Add("output-template.md thiếu section: $required")
        }
    }

    foreach ($category in $script:QaCategories) {
        if ($GroupText -notmatch ("## " + [regex]::Escape($category))) {
            $issues.Add("qa-groups.md thiếu category: $category")
        }
    }

    return @($issues)
}

function Get-QaRecordSchemaIssues {
    param([pscustomobject]$Record)

    $issues = New-Object System.Collections.Generic.List[string]
    foreach ($field in @("id", "category", "module", "screen", "topic", "difficulty", "qa")) {
        if (-not ($Record.PSObject.Properties.Name -contains $field) -or [string]::IsNullOrWhiteSpace([string]$Record.$field)) {
            $issues.Add("Thiếu field bắt buộc: $field")
        }
    }

    if ($Record.PSObject.Properties.Name -contains "category" -and -not (Test-QaCategoryValue -Category $Record.category)) {
        $issues.Add("Category không hợp lệ: $($Record.category)")
    }

    if ($Record.PSObject.Properties.Name -contains "qa" -and [string]$Record.qa -match '^\s*$') {
        $issues.Add("QA rỗng.")
    }

    return @($issues)
}

function Get-QaSkillValidationReport {
    param([string]$DatasetPath)

    $issues = New-Object System.Collections.Generic.List[string]
    $requiredFileResults = New-Object System.Collections.Generic.List[object]

    foreach ($path in (Get-QaRequiredFiles)) {
        $exists = Test-Path -LiteralPath $path
        $requiredFileResults.Add([pscustomobject]@{
            path = $path
            exists = $exists
        })
        if (-not $exists) {
            $issues.Add("Thiếu file bắt buộc: $path")
        }
    }

    if ($DatasetPath -match '\.backup-' -or $DatasetPath -match 'backup-before-stellaria') {
        $issues.Add("DatasetPath đang trỏ vào file backup: $DatasetPath")
    }

    $skillText = Read-QaTextFile -Path (Join-Path (Get-QaSkillRoot) "SKILL.md")
    $templateText = Read-QaTextFile -Path (Get-QaReferencePath -ChildPath "output-template.md")
    $groupText = Read-QaTextFile -Path (Get-QaReferencePath -ChildPath "qa-groups.md")

    foreach ($issue in (Get-QaMarkdownValidationIssues -SkillText $skillText -TemplateText $templateText -GroupText $groupText)) {
        $issues.Add($issue)
    }

    $records = Read-JsonlFile -Path $DatasetPath
    $schemaIssues = New-Object System.Collections.Generic.List[object]
    foreach ($record in @($records)) {
        $recordIssues = @(Get-QaRecordSchemaIssues -Record $record)
        if ($recordIssues.Count -gt 0) {
            $schemaIssues.Add([pscustomobject]@{
                id = $record.id
                issues = $recordIssues
            })
            foreach ($issue in $recordIssues) {
                $issues.Add("Record $($record.id): $issue")
            }
        }
    }

    $contentSummary = Get-DatasetValidationSummary -Records $records
    foreach ($failure in @($contentSummary.details | Where-Object { -not $_.passed })) {
        foreach ($issue in @($failure.issues)) {
            $issues.Add("Record $($failure.id): $issue")
        }
    }

    $scriptResults = New-Object System.Collections.Generic.List[object]
    $functionOwner = @{}
    $duplicateFunctions = New-Object System.Collections.Generic.List[object]

    foreach ($scriptFile in (Get-QaScriptFiles)) {
        $parseResult = Get-QaScriptParseResult -Path $scriptFile.FullName
        $hasLibraryImport = ($scriptFile.Name -eq "qa_skill_lib.ps1") -or ((Read-QaTextFile -Path $scriptFile.FullName) -match [regex]::Escape('. "$PSScriptRoot\qa_skill_lib.ps1"'))
        $scriptResults.Add([pscustomobject]@{
            path = $scriptFile.FullName
            parse_errors = @($parseResult.errors | ForEach-Object { $_.Message })
            imports_library = $hasLibraryImport
        })

        foreach ($error in @($parseResult.errors)) {
            $issues.Add("Script parse error in $($scriptFile.Name): $($error.Message)")
        }
        if (-not $hasLibraryImport) {
            $issues.Add("Script chưa import qa_skill_lib.ps1: $($scriptFile.Name)")
        }

        foreach ($name in (Get-QaScriptFunctionNames -Ast $parseResult.ast)) {
            if ($functionOwner.ContainsKey($name)) {
                $duplicateFunctions.Add([pscustomobject]@{
                    name = $name
                    scripts = @($functionOwner[$name], $scriptFile.Name)
                })
                $issues.Add("Function trùng giữa scripts: $name")
            }
            else {
                $functionOwner[$name] = $scriptFile.Name
            }
        }
    }

    return [pscustomobject]@{
        passed = ($issues.Count -eq 0)
        issues = @($issues | Select-Object -Unique)
        required_files = $requiredFileResults
        dataset_statistics = Get-QaDatasetStatistics -Records $records
        dataset_validation = $contentSummary
        schema_issues = $schemaIssues
        script_results = $scriptResults
        duplicate_functions = $duplicateFunctions
    }
}
