# QA Skill

## Purpose

`skills/qa/` contains the QA skill for Vietnamese BrSE-style clarification QA and the tooling that maintains its gold dataset safely.

## Directory Layout

```text
skills/qa/
|-- agents/
|   `-- openai.yaml
|-- references/
|   |-- README.md
|   |-- gold_dataset.jsonl
|   |-- gold_dataset.backup-before-stellaria.jsonl
|   |-- output-template.md
|   `-- qa-groups.md
|-- scripts/
|   |-- build_prompt_bundle.ps1
|   |-- export_qa_skill_report.ps1
|   |-- import_gold_qa.ps1
|   |-- import_stellaria_gold_qa.ps1
|   |-- qa_skill_lib.ps1
|   |-- regenerate_brse_investigation_dataset.ps1
|   |-- run_qa_skill_tests.ps1
|   |-- update_qa_snapshots.ps1
|   |-- validate_qa_skill.ps1
|   `-- modules/
|       |-- qa_dataset.ps1
|       |-- qa_generation.ps1
|       |-- qa_prompt_bundle.ps1
|       |-- qa_runtime.ps1
|       `-- qa_validation.ps1
|-- tests/
|   |-- README.md
|   |-- fixtures.json
|   `-- snapshots.json
|-- QA_SKILL_ANALYSIS.md
|-- README.md
`-- SKILL.md
```

## Architecture

- `scripts/*.ps1` are public entry points only.
- `scripts/qa_skill_lib.ps1` is a compatibility loader that keeps old commands working.
- `scripts/modules/qa_runtime.ps1` owns path resolution, file IO, logging, and required-file inventory.
- `scripts/modules/qa_prompt_bundle.ps1` owns few-shot selection and prompt bundle assembly.
- `scripts/modules/qa_dataset.ps1` owns dataset statistics, fixture mapping, and schema-level checks.
- `scripts/modules/qa_generation.ps1` owns QA text generation, legacy normalization, and opening/grouping logic.
- `scripts/modules/qa_validation.ps1` owns QA validation, markdown validation, script parsing checks, and the validation report.

## Main Flows

### Customer QA runtime

```text
SKILL.md
+ references/output-template.md
+ references/qa-groups.md
+ references/gold_dataset.jsonl
        |
        v
scripts/build_prompt_bundle.ps1
        |
        v
Prompt bundle
        |
        v
Customer-ready QA
```

### Validation and regression

```text
references/gold_dataset.jsonl
+ scripts/modules/*.ps1
+ tests/fixtures.json
+ tests/snapshots.json
        |
        +--> scripts/validate_qa_skill.ps1
        |
        `--> scripts/run_qa_skill_tests.ps1
```

### Safe dataset update

```text
Load input
-> parse
-> normalize
-> validate merged dataset
-> backup current gold dataset
-> write temp output
-> revalidate temp output
-> replace target dataset
```

## Commands

```powershell
# Validate the whole skill
./skills/qa/scripts/validate_qa_skill.ps1

# Run regression tests
./skills/qa/scripts/run_qa_skill_tests.ps1

# Update snapshots intentionally
./skills/qa/scripts/update_qa_snapshots.ps1 -ConfirmUpdate

# Build a prompt bundle
./skills/qa/scripts/build_prompt_bundle.ps1 -InputPath .\input.txt

# Preview approved QA import
./skills/qa/scripts/import_gold_qa.ps1 -InputPath .\new-gold-qa.txt -DryRun

# Apply approved QA import
./skills/qa/scripts/import_gold_qa.ps1 -InputPath .\new-gold-qa.txt -Apply

# Regenerate candidate dataset safely
./skills/qa/scripts/regenerate_brse_investigation_dataset.ps1 -DryRun

# Export report
./skills/qa/scripts/export_qa_skill_report.ps1

# Specialized one-off Stellaria import
./skills/qa/scripts/import_stellaria_gold_qa.ps1 -SourcePath .\stellaria.txt
```

## Dataset Safety Rules

- Do not write AI-generated records directly into `references/gold_dataset.jsonl`.
- Use `import_gold_qa.ps1` for controlled imports with `-DryRun` or `-Apply`.
- Treat `gold_dataset.backup-before-stellaria.jsonl` as backup data, not runtime input.
- Run `validate_qa_skill.ps1` after dataset changes.

## Testing

- `tests/fixtures.json` stores structured fixture input and content checks.
- `tests/snapshots.json` stores exact expected QA text.
- Snapshot updates require `-ConfirmUpdate`.

## Extending The Skill

### Add a new validator rule

- Put reusable validation logic in `scripts/modules/qa_validation.ps1`.
- Keep `validate_qa_skill.ps1` as argument parsing plus report writing only.

### Add a new prompt rule

- Update `SKILL.md`, `references/output-template.md`, or `references/qa-groups.md` based on the rule's ownership.
- Rebuild a prompt bundle with `build_prompt_bundle.ps1` to verify the runtime order.

### Add a new reference

- Place long-lived prompt/reference material under `references/`.
- Update any path consumers through `qa_runtime.ps1` helpers instead of hard-coding absolute paths.
