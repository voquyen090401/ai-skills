[CmdletBinding()]
param(
    [string]$DatasetPath = "",
    [string]$ReportPath = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\qa_skill_lib.ps1"

if (-not $DatasetPath) {
    $DatasetPath = Get-QaDatasetPath
}
if (-not $ReportPath) {
    $ReportPath = Get-QaOutputPath -ChildPath "qa_skill_validation.json"
}

if (-not (Test-Path -LiteralPath $DatasetPath)) {
    Write-QaLog -Level "ERROR" -Message "Dataset file not found: $DatasetPath"
    exit 2
}

$report = Get-QaSkillValidationReport -DatasetPath $DatasetPath
Write-QaJsonFile -Path $ReportPath -Data $report -Depth 10

$datasetValidation = $report.dataset_validation
Write-QaLog -Level "INFO" -Message ("Validated {0} records" -f $datasetValidation.total)
Write-QaLog -Level "INFO" -Message ("Passed: {0}" -f $datasetValidation.passed)
Write-QaLog -Level "INFO" -Message ("Failed: {0}" -f $datasetValidation.failed)
Write-QaLog -Level "INFO" -Message ("Average score: {0}" -f $datasetValidation.avg_score)

if (-not $report.passed) {
    foreach ($issue in @($report.issues)) {
        Write-QaLog -Level "ERROR" -Message $issue
    }
    exit 1
}

Write-QaLog -Level "PASS" -Message "QA skill validation passed."
