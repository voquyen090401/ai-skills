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
