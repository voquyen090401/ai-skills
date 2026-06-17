[CmdletBinding()]
param(
    [string]$InputPath = "",
    [string]$OutputPath = "",
    [switch]$DryRun,
    [switch]$AppendToCandidate,
    [switch]$RewriteGoldDataset
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\qa_skill_lib.ps1"

if (-not $InputPath) {
    $InputPath = Get-QaDatasetPath
}
if (-not $OutputPath) {
    $OutputPath = Get-QaCandidateDatasetPath
}

if (-not (Test-Path -LiteralPath $InputPath)) {
    Write-QaLog -Level "ERROR" -Message "Input dataset not found: $InputPath"
    exit 2
}

$records = Read-JsonlFile -Path $InputPath
$converted = @(
    $records | ForEach-Object {
        if ($_.PSObject.Properties.Name -contains "source_type" -and $_.source_type -eq "human_gold_qa") {
            $_
        }
        elseif ($_.PSObject.Properties.Name -contains "current_understanding") {
            Normalize-ExistingRecord -Item $_
        }
        else {
            Convert-LegacyRecord -Item $_
        }
    }
)

$datasetValidation = Get-DatasetValidationSummary -Records $converted
if ($datasetValidation.failed -gt 0) {
    Write-QaLog -Level "ERROR" -Message ("Converted dataset contains {0} invalid records." -f $datasetValidation.failed)
    exit 1
}

if ($DryRun) {
    Write-QaLog -Level "PASS" -Message ("Dry run complete. Converted records: {0}" -f $converted.Count)
    Write-QaLog -Level "INFO" -Message ("Suggested output path: {0}" -f $(if ($RewriteGoldDataset) { $InputPath } else { $OutputPath }))
    exit 0
}

if ($RewriteGoldDataset) {
    $targetPath = $InputPath
}
elseif ($AppendToCandidate -and (Test-Path -LiteralPath $OutputPath)) {
    $existing = Read-JsonlFile -Path $OutputPath
    $targetPath = $OutputPath
    $converted = @($existing) + @($converted)
}
else {
    $targetPath = $OutputPath
}

Write-JsonlFile -Path $targetPath -Records $converted -Depth 10
Write-QaLog -Level "PASS" -Message ("Generated {0} records at {1}" -f $converted.Count, $targetPath)
