[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,
    [string]$DatasetPath = "",
    [switch]$DryRun,
    [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\qa_skill_lib.ps1"

function Get-ImportNormalizedQaKey {
    param([string]$Text)
    return (($Text -replace '\s+', ' ').Trim().ToLowerInvariant())
}

function Get-NextQaId {
    param([object[]]$Records)

    [int]$maxId = (($Records | ForEach-Object {
                if ($_.id -match '(\d+)$') { [int]$Matches[1] }
            } | Measure-Object -Maximum).Maximum)
    if (-not $maxId) { $maxId = 0 }
    return $maxId + 1
}

function New-HumanGoldRecord {
    param(
        [string]$Id,
        [string]$QaText,
        [string]$SourceFile
    )

    $lines = @(
        $QaText -split "`r?`n" |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ }
    )
    $confirmation = @($lines | Where-Object { $_ -match '\?|xác nhận|confirm' })
    if ($confirmation.Count -eq 0 -and $lines.Count -gt 0) {
        $confirmation = @($lines[-1])
    }

    return [pscustomobject]@{
        id = $Id
        category = "workflow_gap"
        module = "IMPORTED"
        screen = "UNKNOWN"
        topic = ("imported_gold_qa_{0}" -f ($Id -replace '^BI-QA-', ''))
        style = "business_understanding_confirm"
        difficulty = "medium"
        source_type = "human_gold_qa"
        source_file = $SourceFile
        source_reference = [pscustomobject]@{
            document = $SourceFile
            screen = "UNKNOWN"
            lines = @()
        }
        input_context = (($lines -join " ") -replace '\s+', ' ').Trim()
        evidence = @($lines | Select-Object -First 3)
        current_understanding = @($lines | Select-Object -First 2)
        unclear_points = @()
        confirmation_points = @($confirmation)
        qa = $QaText.Trim()
        needs_review = $true
        review_notes = @("Imported from free-text input; metadata should be reviewed manually.")
    }
}

function Convert-InputToQaRecords {
    param(
        [string]$Text,
        [object[]]$ExistingRecords,
        [string]$SourceFile
    )

    $trimmed = $Text.Trim()
    if (-not $trimmed) {
        return @()
    }

    $records = New-Object System.Collections.Generic.List[object]
    $nextId = Get-NextQaId -Records $ExistingRecords

    $jsonlLike = @(
        $trimmed -split "`r?`n" |
        Where-Object { $_.Trim() }
    )

    $allJson = $true
    foreach ($line in $jsonlLike) {
        try {
            $null = $line | ConvertFrom-Json
        }
        catch {
            $allJson = $false
            break
        }
    }

    if ($allJson) {
        foreach ($line in $jsonlLike) {
            $item = $line | ConvertFrom-Json
            $id = if ($item.id) { [string]$item.id } else { "BI-QA-{0:D4}" -f $nextId; $nextId++ }
            if (-not $item.category) { $item | Add-Member -NotePropertyName category -NotePropertyValue "workflow_gap" }
            if (-not $item.module) { $item | Add-Member -NotePropertyName module -NotePropertyValue "IMPORTED" }
            if (-not $item.screen) { $item | Add-Member -NotePropertyName screen -NotePropertyValue "UNKNOWN" }
            if (-not $item.topic) { $item | Add-Member -NotePropertyName topic -NotePropertyValue ("imported_gold_qa_{0}" -f ($id -replace '^BI-QA-', '')) }
            if (-not $item.style) { $item | Add-Member -NotePropertyName style -NotePropertyValue "business_understanding_confirm" }
            if (-not $item.difficulty) { $item | Add-Member -NotePropertyName difficulty -NotePropertyValue "medium" }
            if (-not $item.source_type) { $item | Add-Member -NotePropertyName source_type -NotePropertyValue "human_gold_qa" }
            if (-not $item.source_file) { $item | Add-Member -NotePropertyName source_file -NotePropertyValue $SourceFile }
            if (-not $item.source_reference) {
                $item | Add-Member -NotePropertyName source_reference -NotePropertyValue ([pscustomobject]@{
                        document = $SourceFile
                        screen = $item.screen
                        lines = @()
                    })
            }
            if (-not $item.input_context) { $item | Add-Member -NotePropertyName input_context -NotePropertyValue $item.qa }
            if (-not $item.evidence) { $item | Add-Member -NotePropertyName evidence -NotePropertyValue @() }
            if (-not $item.current_understanding) { $item | Add-Member -NotePropertyName current_understanding -NotePropertyValue @() }
            if (-not $item.unclear_points) { $item | Add-Member -NotePropertyName unclear_points -NotePropertyValue @() }
            if (-not $item.confirmation_points) { $item | Add-Member -NotePropertyName confirmation_points -NotePropertyValue @() }
            if (-not ($item.PSObject.Properties.Name -contains "needs_review")) { $item | Add-Member -NotePropertyName needs_review -NotePropertyValue $false }
            if (-not ($item.PSObject.Properties.Name -contains "review_notes")) { $item | Add-Member -NotePropertyName review_notes -NotePropertyValue @() }
            $item.id = $id
            $records.Add($item)
        }

        return @($records.ToArray())
    }

    $blocks = @(
        [regex]::Split($trimmed, '(\r?\n){2,}') |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ }
    )
    foreach ($block in $blocks) {
        $id = "BI-QA-{0:D4}" -f $nextId
        $nextId++
        $records.Add((New-HumanGoldRecord -Id $id -QaText $block -SourceFile $SourceFile))
    }
    return @($records.ToArray())
}

if (($DryRun -and $Apply) -or (-not $DryRun -and -not $Apply)) {
    Write-QaLog -Level "ERROR" -Message "Specify exactly one mode: -DryRun or -Apply."
    exit 2
}

if (-not $DatasetPath) {
    $DatasetPath = Get-QaDatasetPath
}

if (-not (Test-Path -LiteralPath $InputPath)) {
    Write-QaLog -Level "ERROR" -Message "Input file not found: $InputPath"
    exit 2
}

$existing = Read-JsonlFile -Path $DatasetPath
$sourceFile = Split-Path -Path $InputPath -Leaf
$inputText = Read-QaTextFile -Path $InputPath
$candidateRecords = Convert-InputToQaRecords -Text $inputText -ExistingRecords $existing -SourceFile $sourceFile

    $existingKeys = New-Object System.Collections.Generic.HashSet[string]
foreach ($row in @($existing)) {
    [void]$existingKeys.Add((Get-ImportNormalizedQaKey -Text $row.qa))
}

$added = New-Object System.Collections.Generic.List[object]
$duplicates = New-Object System.Collections.Generic.List[string]
foreach ($record in @($candidateRecords)) {
    $qaKey = Get-ImportNormalizedQaKey -Text $record.qa
    if ($existingKeys.Contains($qaKey)) {
        $duplicates.Add($record.id)
        continue
    }
    $added.Add($record)
    [void]$existingKeys.Add($qaKey)
}

$combined = @($existing) + @($added.ToArray())
$validation = Get-DatasetValidationSummary -Records $combined

Write-QaLog -Level "INFO" -Message ("Candidate records: {0}" -f $candidateRecords.Count)
Write-QaLog -Level "INFO" -Message ("Added after duplicate check: {0}" -f $added.Count)
Write-QaLog -Level "INFO" -Message ("Skipped duplicates: {0}" -f $duplicates.Count)
Write-QaLog -Level "INFO" -Message ("Validation failed records after merge: {0}" -f $validation.failed)

if ($DryRun) {
    if ($validation.failed -gt 0) {
        Write-QaLog -Level "WARN" -Message "Dry run found validation issues in the merged dataset."
    }
    Write-QaLog -Level "PASS" -Message "Dry run complete."
    exit 0
}

if ($validation.failed -gt 0) {
    Write-QaLog -Level "ERROR" -Message "Merged dataset is invalid. Import aborted."
    exit 1
}

$backupPath = Join-Path (Split-Path -Path $DatasetPath -Parent) "gold_dataset.backup-before-import.jsonl"
$tempPath = Join-Path ([System.IO.Path]::GetDirectoryName($DatasetPath)) "gold_dataset.import-temp.jsonl"

Copy-Item -LiteralPath $DatasetPath -Destination $backupPath -Force
Write-JsonlFile -Path $tempPath -Records $combined -Depth 10

$tempValidation = Get-DatasetValidationSummary -Records (Read-JsonlFile -Path $tempPath)
if ($tempValidation.failed -gt 0) {
    Remove-Item -LiteralPath $tempPath -Force
    Write-QaLog -Level "ERROR" -Message "Temporary dataset validation failed. Import aborted."
    exit 1
}

Move-Item -LiteralPath $tempPath -Destination $DatasetPath -Force
Write-QaLog -Level "PASS" -Message ("Imported {0} QA record(s)." -f $added.Count)
Write-QaLog -Level "INFO" -Message ("Backup created at {0}" -f $backupPath)
