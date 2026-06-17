[CmdletBinding()]
param(
    [string]$FixturePath = "",
    [string]$SnapshotPath = "",
    [string]$ReportPath = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\qa_skill_lib.ps1"

if (-not $FixturePath) {
    $FixturePath = Get-QaTestPath -ChildPath "fixtures.json"
}
if (-not $SnapshotPath) {
    $SnapshotPath = Get-QaTestPath -ChildPath "snapshots.json"
}
if (-not $ReportPath) {
    $ReportPath = Get-QaOutputPath -ChildPath "qa_skill_test_report.json"
}

if (-not (Test-Path -LiteralPath $FixturePath)) {
    Write-QaLog -Level "ERROR" -Message "Fixture file not found: $FixturePath"
    exit 2
}
if (-not (Test-Path -LiteralPath $SnapshotPath)) {
    Write-QaLog -Level "ERROR" -Message "Snapshot file not found: $SnapshotPath"
    exit 2
}

$fixtures = Read-QaJsonFile -Path $FixturePath
$snapshots = @{}
foreach ($row in @(Read-QaJsonFile -Path $SnapshotPath)) {
    $snapshots[$row.id] = $row.qa
}

$results = New-Object System.Collections.Generic.List[object]

foreach ($fixture in @($fixtures)) {
    $record = New-QaFixtureRecord -Fixture $fixture
    $record.qa = Build-QAText -Record $record
    $validation = Get-QAValidationResult -Record $record
    $checks = Get-QaExpectedChecks -Fixture $fixture

    $issues = New-Object System.Collections.Generic.List[string]
    foreach ($expected in @($checks.must_contain)) {
        if ($expected -and $record.qa -notmatch [regex]::Escape($expected)) {
            $issues.Add("Thiếu chuỗi bắt buộc: $expected")
        }
    }
    foreach ($unexpected in @($checks.must_not_contain)) {
        if ($unexpected -and $record.qa -match [regex]::Escape($unexpected)) {
            $issues.Add("Chứa chuỗi không mong muốn: $unexpected")
        }
    }

    if ($snapshots.ContainsKey($fixture.id) -and $snapshots[$fixture.id] -ne $record.qa) {
        $issues.Add("Snapshot mismatch. Run ./skills/qa/scripts/update_qa_snapshots.ps1 -ConfirmUpdate after reviewing the diff.")
    }

    foreach ($issue in @($validation.issues)) {
        $issues.Add($issue)
    }

    $passed = ($validation.score -ge 8 -and $issues.Count -eq 0)
    $results.Add([pscustomobject]@{
        id = $fixture.id
        passed = $passed
        score = $validation.score
        issues = @($issues)
        qa = $record.qa
    })
}

$passedResults = @($results | Where-Object { $_.passed -eq $true })
$failedResults = @($results | Where-Object { $_.passed -ne $true })

$summaryData = [ordered]@{}
$summaryData["total"] = $results.Count
$summaryData["passed"] = $passedResults.Count
$summaryData["failed"] = $failedResults.Count
$summaryData["details"] = @($results.ToArray())
$summary = [pscustomobject]$summaryData

Write-QaJsonFile -Path $ReportPath -Data $summary -Depth 10

Write-QaLog -Level "INFO" -Message ("Executed {0} tests" -f $summary.total)
Write-QaLog -Level "INFO" -Message ("Passed: {0}" -f $summary.passed)
Write-QaLog -Level "INFO" -Message ("Failed: {0}" -f $summary.failed)

if ($summary.failed -gt 0) {
    foreach ($failed in @($failedResults)) {
        Write-QaLog -Level "ERROR" -Message ("{0}: {1}" -f $failed.id, ($failed.issues -join "; "))
    }
    exit 1
}

Write-QaLog -Level "PASS" -Message "QA skill tests passed."
