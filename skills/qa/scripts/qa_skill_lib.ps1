Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$moduleFiles = @(
    "modules\qa_runtime.ps1",
    "modules\qa_prompt_bundle.ps1",
    "modules\qa_dataset.ps1",
    "modules\qa_generation.ps1",
    "modules\qa_validation.ps1"
)

foreach ($relativePath in $moduleFiles) {
    . (Join-Path $PSScriptRoot $relativePath)
}
