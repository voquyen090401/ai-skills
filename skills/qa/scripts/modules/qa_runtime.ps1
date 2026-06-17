$script:QaSkillRoot = Split-Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
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

function Get-QaModulePath {
    param([string]$ChildPath = "")
    $root = Join-Path (Get-QaScriptPath) "modules"
    if (-not $ChildPath) { return $root }
    return Join-Path $root $ChildPath
}

function Get-QaAgentPath {
    param([string]$ChildPath = "")
    $root = Join-Path (Get-QaSkillRoot) "agents"
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
        (Join-Path (Get-QaSkillRoot) "README.md"),
        (Join-Path (Get-QaSkillRoot) "QA_SKILL_ANALYSIS.md"),
        (Get-QaReferencePath -ChildPath "gold_dataset.jsonl"),
        (Get-QaReferencePath -ChildPath "output-template.md"),
        (Get-QaReferencePath -ChildPath "qa-groups.md"),
        (Get-QaReferencePath -ChildPath "README.md"),
        (Get-QaAgentPath -ChildPath "openai.yaml"),
        (Get-QaScriptPath -ChildPath "build_prompt_bundle.ps1"),
        (Get-QaScriptPath -ChildPath "export_qa_skill_report.ps1"),
        (Get-QaScriptPath -ChildPath "import_gold_qa.ps1"),
        (Get-QaScriptPath -ChildPath "import_stellaria_gold_qa.ps1"),
        (Get-QaScriptPath -ChildPath "qa_skill_lib.ps1"),
        (Get-QaScriptPath -ChildPath "regenerate_brse_investigation_dataset.ps1"),
        (Get-QaScriptPath -ChildPath "run_qa_skill_tests.ps1"),
        (Get-QaScriptPath -ChildPath "update_qa_snapshots.ps1"),
        (Get-QaScriptPath -ChildPath "validate_qa_skill.ps1"),
        (Get-QaModulePath -ChildPath "qa_runtime.ps1"),
        (Get-QaModulePath -ChildPath "qa_prompt_bundle.ps1"),
        (Get-QaModulePath -ChildPath "qa_dataset.ps1"),
        (Get-QaModulePath -ChildPath "qa_generation.ps1"),
        (Get-QaModulePath -ChildPath "qa_validation.ps1"),
        (Get-QaTestPath -ChildPath "fixtures.json"),
        (Get-QaTestPath -ChildPath "snapshots.json"),
        (Get-QaTestPath -ChildPath "README.md")
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

function Test-QaCategoryValue {
    param([string]$Category)
    return $script:QaCategories -contains $Category
}
