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

    $leftQuote = [string][char]0x300C
    $rightQuote = [string][char]0x300D
    $quotePattern = [regex]::Escape($leftQuote) + '[^' + [regex]::Escape($rightQuote) + ']+' + [regex]::Escape($rightQuote)
    foreach ($match in [regex]::Matches($corpus, $quotePattern)) {
        if (-not $terms.Contains($match.Value)) { $terms.Add($match.Value) }
    }

    foreach ($match in [regex]::Matches($corpus, '\b(?:line|Line)\s+[0-9]+(?:[-][0-9]+)?')) {
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
            $issues.Add("QA mentions $($flag.Label) without matching evidence.")
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

    $openingOk = if ($isHumanGold) {
        -not [string]::IsNullOrWhiteSpace($qa)
    }
    else {
        $qa.StartsWith((Get-QaPhrase -Name related_to))
    }
    if (-not $openingOk) {
        $issues.Add("Missing scoped opening line.")
        $score--
    }

    $understandingOk = if ($isHumanGold) {
        ($qa -match 'ch.ng t.i|h. th.ng|x.c nh.n|confirm')
    }
    else {
        ($qa -match [regex]::Escape((Get-QaPhrase -Name understand_business))) -or ($qa -match [regex]::Escape((Get-QaPhrase -Name want_confirm_understanding)))
    }
    if (-not $understandingOk) {
        $issues.Add("Missing business understanding.")
        $score--
    }

    $closingNeedle = Get-QaDecodedText -Base64 "Tmjhu50gQsOhYw=="
    $closingOk = if ($isHumanGold) {
        -not [string]::IsNullOrWhiteSpace($qa)
    } else {
        $qa -match [regex]::Escape($closingNeedle)
    }
    if (-not $closingOk) {
        $issues.Add("Missing polite closing.")
        $score--
    }

    if ($qa.Contains([string][char]0x25A0)) {
        $issues.Add("Contains deprecated internal headings.")
        $score--
    }

    $numberedLines = @($qa -split "`r?`n" | Where-Object { $_ -match '^\d+\.' })
    $paragraphCount = @($qa -split "(\r?\n){2,}" | Where-Object { $_.Trim() }).Count
    if (-not $isHumanGold -and $numberedLines.Count -eq 0 -and $paragraphCount -lt 2) {
        $issues.Add("Missing readable numbering.")
        $score--
    }

    foreach ($term in (Get-PreservedTerms -Record $Record)) {
        if ($qa -notmatch [regex]::Escape($term)) {
            $issues.Add("Missing preserved term: $term")
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
    return @(Get-ChildItem -Path (Get-QaScriptPath) -Recurse -Filter "*.ps1" -File | Sort-Object FullName)
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
            $issues.Add("SKILL.md missing section: $required")
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
            $issues.Add("output-template.md missing section: $required")
        }
    }

    foreach ($category in $script:QaCategories) {
        if ($GroupText -notmatch ("## " + [regex]::Escape($category))) {
            $issues.Add("qa-groups.md missing category: $category")
        }
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
            $issues.Add("Missing required file: $path")
        }
    }

    if ($DatasetPath -match '\.backup-' -or $DatasetPath -match 'backup-before-stellaria') {
        $issues.Add("DatasetPath points to a backup file: $DatasetPath")
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
    $loaderNeedle = '. "$PSScriptRoot\qa_skill_lib.ps1"'

    foreach ($scriptFile in (Get-QaScriptFiles)) {
        $parseResult = Get-QaScriptParseResult -Path $scriptFile.FullName
        $fileText = Read-QaTextFile -Path $scriptFile.FullName
        $hasLibraryImport = (
            $scriptFile.Name -like "qa_*.ps1" -or
            $scriptFile.Name -eq "qa_skill_lib.ps1" -or
            $fileText -match [regex]::Escape($loaderNeedle)
        )
        $scriptResults.Add([pscustomobject]@{
            path = $scriptFile.FullName
            parse_errors = @($parseResult.errors | ForEach-Object { $_.Message })
            imports_library = $hasLibraryImport
        })

        foreach ($error in @($parseResult.errors)) {
            $issues.Add("Script parse error in $($scriptFile.Name): $($error.Message)")
        }
        if (-not $hasLibraryImport) {
            $issues.Add("Script does not import qa_skill_lib.ps1: $($scriptFile.Name)")
        }

        foreach ($name in (Get-QaScriptFunctionNames -Ast $parseResult.ast)) {
            if ($functionOwner.ContainsKey($name)) {
                $duplicateFunctions.Add([pscustomobject]@{
                    name = $name
                    scripts = @($functionOwner[$name], $scriptFile.Name)
                })
                $issues.Add("Duplicate function across scripts: $name")
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
