[CmdletBinding()]
param(
    [string]$DatasetPath = "",
    [string]$ValidationPath = "",
    [string]$TestReportPath = "",
    [string]$ReportPath = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\qa_skill_lib.ps1"

if (-not $DatasetPath) {
    $DatasetPath = Get-QaDatasetPath
}
if (-not $ValidationPath) {
    $ValidationPath = Get-QaOutputPath -ChildPath "qa_skill_validation.json"
}
if (-not $TestReportPath) {
    $TestReportPath = Get-QaOutputPath -ChildPath "qa_skill_test_report.json"
}
if (-not $ReportPath) {
    $ReportPath = Get-QaOutputPath -ChildPath "qa_skill_report.md"
}

$records = Read-JsonlFile -Path $DatasetPath
$stats = Get-QaDatasetStatistics -Records $records
$validation = if (Test-Path -LiteralPath $ValidationPath) { Read-QaJsonFile -Path $ValidationPath } else { $null }
$tests = if (Test-Path -LiteralPath $TestReportPath) { Read-QaJsonFile -Path $TestReportPath } else { $null }

$report = New-Object System.Collections.Generic.List[string]
$report.Add("# QA Skill Report")
$report.Add("")
$report.Add("## Runtime Files")
$report.Add('- SKILL: `skills/qa/SKILL.md`')
$report.Add('- Agent config: `skills/qa/agents/openai.yaml`')
$report.Add('- Output rules: `skills/qa/references/output-template.md`')
$report.Add('- QA groups: `skills/qa/references/qa-groups.md`')
$report.Add('- Gold dataset: `skills/qa/references/gold_dataset.jsonl`')
$report.Add("")
$report.Add("## Script Roles")
$report.Add('- Build prompt: `skills/qa/scripts/build_prompt_bundle.ps1`')
$report.Add('- Validate skill: `skills/qa/scripts/validate_qa_skill.ps1`')
$report.Add('- Run tests: `skills/qa/scripts/run_qa_skill_tests.ps1`')
$report.Add('- Update snapshots: `skills/qa/scripts/update_qa_snapshots.ps1`')
$report.Add('- Import gold QA: `skills/qa/scripts/import_gold_qa.ps1`')
$report.Add('- Regenerate candidate dataset: `skills/qa/scripts/regenerate_brse_investigation_dataset.ps1`')
$report.Add("")
$report.Add("## Dataset Summary")
$report.Add(("- Total records: {0}" -f $stats.total))
$report.Add(("- Needs review: {0}" -f $stats.needs_review))
$report.Add(("- Duplicate IDs: {0}" -f @($stats.duplicate_ids).Count))
$report.Add(("- Duplicate QA bodies: {0}" -f @($stats.duplicate_qa).Count))
$report.Add("")
$report.Add("### Category Distribution")
foreach ($row in @($stats.by_category)) {
    $report.Add(("- {0}: {1}" -f $row.name, $row.count))
}
$report.Add("")
$report.Add("### Difficulty Distribution")
foreach ($row in @($stats.by_difficulty)) {
    $report.Add(("- {0}: {1}" -f $row.name, $row.count))
}
$report.Add("")
$report.Add("### Module Distribution")
foreach ($row in @($stats.by_module)) {
    $report.Add(("- {0}: {1}" -f $row.name, $row.count))
}
$report.Add("")
$report.Add("### Screen Distribution")
foreach ($row in @($stats.by_screen)) {
    $report.Add(("- {0}: {1}" -f $row.name, $row.count))
}

if ($validation) {
    $report.Add("")
    $report.Add("## Validation")
    $report.Add(("- Passed: {0}" -f $validation.passed))
    $report.Add(("- Issue count: {0}" -f @($validation.issues).Count))
}

if ($tests) {
    $report.Add("")
    $report.Add("## Tests")
    $report.Add(("- Total: {0}" -f $tests.total))
    $report.Add(("- Passed: {0}" -f $tests.passed))
    $report.Add(("- Failed: {0}" -f $tests.failed))
}

[System.IO.File]::WriteAllText($ReportPath, ($report -join "`n"), (New-Object System.Text.UTF8Encoding($true)))
Write-QaLog -Level "PASS" -Message "QA skill report generated."
