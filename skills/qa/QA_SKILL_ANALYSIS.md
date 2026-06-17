# QA Skill Analysis

## Scope

Files read in `skills/qa/`:

- `SKILL.md`
- `agents/openai.yaml`
- `references/gold_dataset.jsonl`
- `references/gold_dataset.backup-before-stellaria.jsonl`
- `references/output-template.md`
- `references/qa-groups.md`
- `scripts/build_prompt_bundle.ps1`
- `scripts/export_qa_skill_report.ps1`
- `scripts/import_stellaria_gold_qa.ps1`
- `scripts/qa_skill_lib.ps1`
- `scripts/regenerate_brse_investigation_dataset.ps1`
- `scripts/run_qa_skill_tests.ps1`
- `scripts/update_qa_snapshots.ps1`
- `scripts/validate_qa_skill.ps1`
- `tests/fixtures.json`
- `tests/snapshots.json`

## Current File Roles

- `SKILL.md`
  Documents the business intent and output expectations of the QA skill.
- `agents/openai.yaml`
  Stores a short default prompt for the agent, but duplicates several rules already written in `SKILL.md`.
- `references/output-template.md`
  Defines accepted QA shapes, openings, closings, and hard avoids.
- `references/qa-groups.md`
  Defines category selection rules.
- `references/gold_dataset.jsonl`
  Current runtime gold dataset with 104 JSONL records.
- `references/gold_dataset.backup-before-stellaria.jsonl`
  A point-in-time backup created by the Stellaria import flow. This is not runtime data and should not be treated as a normal reference file.
- `scripts/qa_skill_lib.ps1`
  Real logic center of the skill. It contains legacy conversion, QA formatting, and QA content validation rules.
- `scripts/build_prompt_bundle.ps1`
  Builds a prompt bundle from template, groups, input, and a few dataset examples.
- `scripts/validate_qa_skill.ps1`
  Validates dataset content only. It does not yet validate file structure, markdown structure, script conventions, or duplicate helper definitions.
- `scripts/run_qa_skill_tests.ps1`
  Rebuilds QA from fixtures and compares against validation rules plus snapshots.
- `scripts/update_qa_snapshots.ps1`
  Recomputes and overwrites snapshots immediately with no confirmation flag.
- `scripts/regenerate_brse_investigation_dataset.ps1`
  Converts or rewrites dataset records. Current interface is risky because it can rewrite the gold dataset directly with `-RewriteGoldDataset`.
- `scripts/export_qa_skill_report.ps1`
  Generates a historical-style report and examples, but the report content is partly hard-coded to a previous migration story.
- `scripts/import_stellaria_gold_qa.ps1`
  A specialized one-off importer for Stellaria content. It is useful evidence, but too specific to serve as the general gold QA import flow requested by the user.
- `tests/fixtures.json`
  Contains structured fixture input plus lightweight content assertions.
- `tests/snapshots.json`
  Contains exact QA snapshots for the fixtures.

## Current Runtime Flow

Observed runtime flow today:

1. `openai.yaml` provides a default prompt.
2. `SKILL.md` is available to the skill framework, but `build_prompt_bundle.ps1` does not read it.
3. `build_prompt_bundle.ps1` reads:
   - `references/output-template.md`
   - `references/qa-groups.md`
   - `references/gold_dataset.jsonl`
   - user input file
4. The bundle order today is:
   - Output Rules
   - QA Group Rules
   - Input
   - Few-shot Examples
5. The few-shot selection is naive:
   - exact regex match on `topic`
   - otherwise first `N` records from the dataset

Key finding:

- `build_prompt_bundle.ps1` does not load `SKILL.md`, so the current bundle misses the skill purpose, governance wording, stop conditions, and workflow guidance.
- `openai.yaml` does not call `build_prompt_bundle.ps1`; it only carries a short static prompt.

## Current Test Flow

Observed test flow today:

1. `run_qa_skill_tests.ps1` reads `fixtures.json`.
2. It builds synthetic records from fixture fields.
3. It generates `qa` using `Build-QAText` from `qa_skill_lib.ps1`.
4. It validates each generated QA with `Get-QAValidationResult`.
5. It checks `must_contain` and `must_not_contain`.
6. It compares exact text with `snapshots.json` when a snapshot exists.
7. It writes a JSON report and exits `1` on failures.

Current status before refactor:

- `validate_qa_skill.ps1`: PASS
- `run_qa_skill_tests.ps1`: PASS (`20/20`)

## Current Dataset Update Flow

There are currently two update-related flows:

1. `regenerate_brse_investigation_dataset.ps1`
   - reads an input dataset
   - converts legacy or normalizes current records
   - can write to a separate output file
   - can also rewrite the main gold dataset directly with `-RewriteGoldDataset`

2. `import_stellaria_gold_qa.ps1`
   - reads a fixed external attachment path
   - creates a backup automatically
   - derives multiple records with custom parsing logic
   - appends to `gold_dataset.jsonl`
   - writes a custom report

Key findings:

- There is no generic `import_gold_qa.ps1` yet.
- One script can rewrite the gold dataset directly.
- The Stellaria importer uses absolute paths and task-specific parsing rules.
- Backup files now live under `references/`, so the validator should explicitly avoid treating them as runtime dataset.

## Duplicated Logic

Repeated patterns already visible:

- path construction and absolute default paths across nearly every script
- repeated `Get-Content ... | ConvertFrom-Json`
- repeated report directory creation
- repeated fixture-to-record mapping in:
  - `run_qa_skill_tests.ps1`
  - `update_qa_snapshots.ps1`
- repeated UTF-8 BOM writing
- repeated dataset loading and writing

## Rule Conflicts And Overlap

Current overlap exists between:

- `SKILL.md`
- `agents/openai.yaml`
- `references/output-template.md`
- `qa_skill_lib.ps1`

Examples:

- "do not use old headings" appears in both prompt docs and validation logic
- "do not invent CSV/batch/API/DB/master/authority/phase details" appears in `SKILL.md`, `openai.yaml`, and indirectly in validator rules
- opening and closing expectations are expressed in both docs and machine validation

Recommended source of truth:

- skill behavior and governance: `SKILL.md`
- QA format and examples: `references/output-template.md`
- category taxonomy: `references/qa-groups.md`
- machine checks: `scripts/validate_qa_skill.ps1` and shared validation helpers

## Notable Weak Points

- `build_prompt_bundle.ps1` does not read `SKILL.md`
- `openai.yaml` duplicates behavior instead of staying lightweight
- every main script uses hard-coded absolute paths
- scripts do not consistently use `[CmdletBinding()]`
- log format is inconsistent and not standardized
- exit code `2` for invalid arguments is not implemented
- `update_qa_snapshots.ps1` overwrites snapshots without confirmation
- `validate_qa_skill.ps1` validates content only, not overall skill structure
- `export_qa_skill_report.ps1` contains outdated hard-coded narrative about a previous migration
- `import_stellaria_gold_qa.ps1` is highly task-specific and not reusable as the general import entry point

## Deprecated Or Specialized Candidates

- `scripts/import_stellaria_gold_qa.ps1`
  Reason:
  - useful as a one-off migration artifact
  - not suitable as the primary import tool because it hard-codes source assumptions and absolute attachment paths

Potential follow-up:

- keep it for traceability, but document it as a specialized migration script

## Proposed Changes

1. Add a shared path and IO layer to `qa_skill_lib.ps1`.
2. Refactor scripts to use relative paths resolved from the QA root instead of absolute machine paths.
3. Make `build_prompt_bundle.ps1` read `SKILL.md` and emit a fixed, explicit bundle order:
   - Skill role
   - Core instructions
   - QA category rules
   - Output template
   - Relevant gold examples
   - User input
4. Expand validation to cover:
   - required files
   - markdown sections
   - JSONL correctness
   - duplicate IDs
   - category validity
   - runtime dataset path safety
   - script conventions
5. Require an explicit confirmation flag for snapshot updates.
6. Add a generic `scripts/import_gold_qa.ps1` with `-DryRun` and `-Apply`.
7. Restrict dataset regeneration to safe modes by default and avoid direct gold overwrite unless explicitly requested.
8. Add small `README.md` files so developers can understand the runtime/test/update flow without reading every script first.

## Refactor Constraints

- Keep the PowerShell-based implementation.
- Keep current QA generation behavior stable unless a change is needed to meet the requested structure and safety requirements.
- Do not remove existing gold records.
- Do not move to a large new architecture.
