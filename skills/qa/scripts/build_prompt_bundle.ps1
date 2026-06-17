[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,
    [int]$FewShotCount = 3,
    [string]$DatasetPath = "",
    [string]$OutputPath = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\qa_skill_lib.ps1"

if (-not (Test-Path -LiteralPath $InputPath)) {
    Write-QaLog -Level "ERROR" -Message "Input file not found: $InputPath"
    exit 2
}

if ($FewShotCount -lt 1) {
    Write-QaLog -Level "ERROR" -Message "FewShotCount must be greater than 0."
    exit 2
}

if (-not $DatasetPath) {
    $DatasetPath = Get-QaDatasetPath
}

$inputText = Read-QaTextFile -Path $InputPath
$skillText = Read-QaTextFile -Path (Join-Path (Get-QaSkillRoot) "SKILL.md")
$templateText = Read-QaTextFile -Path (Get-QaReferencePath -ChildPath "output-template.md")
$groupText = Read-QaTextFile -Path (Get-QaReferencePath -ChildPath "qa-groups.md")
$dataset = Read-JsonlFile -Path $DatasetPath
$examples = Get-QaFewShotExamples -InputText $inputText -Dataset $dataset -FewShotCount $FewShotCount
$bundle = Build-QaPromptBundle -InputText $inputText -SkillText $skillText -TemplateText $templateText -GroupText $groupText -Examples $examples
$bundleIssues = @(Test-QaPromptBundleSections -PromptBundle $bundle)

if ($bundleIssues.Count -gt 0) {
    foreach ($issue in $bundleIssues) {
        Write-QaLog -Level "ERROR" -Message $issue
    }
    exit 1
}

if ($OutputPath) {
    Ensure-QaParentDirectory -Path $OutputPath
    $utf8Bom = New-Object System.Text.UTF8Encoding($true)
    [System.IO.File]::WriteAllText($OutputPath, $bundle, $utf8Bom)
    Write-QaLog -Level "PASS" -Message "Prompt bundle created at $OutputPath"
}
else {
    $bundle
}
