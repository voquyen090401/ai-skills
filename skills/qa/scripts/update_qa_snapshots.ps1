[CmdletBinding()]
param(
    [string]$FixturePath = "",
    [string]$SnapshotPath = "",
    [switch]$ConfirmUpdate
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

if (-not $ConfirmUpdate) {
    Write-QaLog -Level "ERROR" -Message "Snapshot update requires -ConfirmUpdate."
    exit 2
}

$fixtures = Read-QaJsonFile -Path $FixturePath
$existing = @{}
if (Test-Path -LiteralPath $SnapshotPath) {
    foreach ($row in @(Read-QaJsonFile -Path $SnapshotPath)) {
        $existing[$row.id] = $row.qa
    }
}

$snapshots = New-Object System.Collections.Generic.List[object]
$changed = New-Object System.Collections.Generic.List[string]

foreach ($fixture in @($fixtures)) {
    $record = New-QaFixtureRecord -Fixture $fixture
    $record.qa = Build-QAText -Record $record
    $snapshots.Add([pscustomobject]@{
        id = $fixture.id
        qa = $record.qa
    })

    if (-not $existing.ContainsKey($fixture.id) -or $existing[$fixture.id] -ne $record.qa) {
        $changed.Add($fixture.id)
    }
}

Write-QaLog -Level "INFO" -Message ("Snapshots changed: {0}" -f $changed.Count)
if ($changed.Count -gt 0) {
    Write-QaLog -Level "INFO" -Message ("Changed fixture IDs: {0}" -f ($changed -join ", "))
}

Write-QaJsonFile -Path $SnapshotPath -Data $snapshots -Depth 10
Write-QaLog -Level "PASS" -Message "Snapshots updated."
