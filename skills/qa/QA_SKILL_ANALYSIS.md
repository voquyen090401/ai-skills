# QA Skill Analysis

## A. Current-state analysis

### Entry points

- `scripts/build_prompt_bundle.ps1`
- `scripts/validate_qa_skill.ps1`
- `scripts/run_qa_skill_tests.ps1`
- `scripts/update_qa_snapshots.ps1`
- `scripts/import_gold_qa.ps1`
- `scripts/regenerate_brse_investigation_dataset.ps1`
- `scripts/export_qa_skill_report.ps1`
- `scripts/import_stellaria_gold_qa.ps1`

### Main flows before refactor

- Prompt construction loaded `SKILL.md`, `references/output-template.md`, `references/qa-groups.md`, and `references/gold_dataset.jsonl`, then built a few-shot bundle.
- Runtime QA generation, legacy record normalization, dataset statistics, validation, markdown checks, path resolution, and script inspection were all concentrated in `scripts/qa_skill_lib.ps1`.
- Regression tests built QA from `tests/fixtures.json`, validated the output, and compared with `tests/snapshots.json`.
- Dataset update used two paths:
  - `import_gold_qa.ps1` for generic free-text or JSONL import.
  - `import_stellaria_gold_qa.ps1` for a specialized one-off Stellaria migration flow.

### Issues observed from code

- `scripts/qa_skill_lib.ps1` held too many responsibilities: path/config, IO, prompt bundling, QA generation, dataset helpers, validation, and script parsing.
- `import_stellaria_gold_qa.ps1` used absolute machine-specific defaults.
- Validation previously reasoned about `scripts/*.ps1` only, so deeper modularization would not be inspected unless the validator changed with it.
- Docs described a partially outdated architecture and no longer matched the real code paths.
- Backup/runtime/reference responsibilities were clear in intent but not clearly reflected in the internal module structure.

### Risks before refactor

- Harder maintenance because unrelated changes landed in one large library file.
- Higher chance of accidental breakage because path, generation, and validation logic were tightly coupled.
- Poor extensibility for adding new validator rules, generation rules, or dataset behaviors without growing the same file further.

## B. Architecture decisions

### Principles used

- Keep public command paths stable.
- Move reusable logic behind focused modules instead of moving behavior into new wrappers.
- Keep PowerShell and current runtime behavior.
- Do not introduce empty abstraction layers or duplicate implementations.

### New structure

```text
scripts/
|-- qa_skill_lib.ps1
`-- modules/
    |-- qa_runtime.ps1
    |-- qa_prompt_bundle.ps1
    |-- qa_dataset.ps1
    |-- qa_generation.ps1
    `-- qa_validation.ps1
```

### Responsibility rules

- `qa_runtime.ps1`
  - Allowed: root resolution, path helpers, required-file inventory, file IO, logging.
  - Not allowed: QA business rules, validation rules, prompt assembly logic.
- `qa_prompt_bundle.ps1`
  - Allowed: example selection and prompt bundle assembly.
  - Not allowed: dataset mutation or QA validation.
- `qa_dataset.ps1`
  - Allowed: dataset statistics, fixture mapping, schema-level record checks.
  - Not allowed: prompt assembly or script inspection.
- `qa_generation.ps1`
  - Allowed: QA formatting, opening selection, grouping, normalization of legacy/current records.
  - Not allowed: filesystem concerns or command-line orchestration.
- `qa_validation.ps1`
  - Allowed: QA validation, markdown validation, script parsing checks, full validation report assembly.
  - Not allowed: prompt bundle construction or dataset writes.
- `qa_skill_lib.ps1`
  - Allowed: compatibility loading only.
  - Not allowed: new business logic.

### Patterns used

- Loader compatibility layer for old script imports.
- Shared runtime/path module.
- Focused service-style modules grouped by business responsibility.

### Patterns intentionally not used

- No large class hierarchy.
- No separate CLI framework.
- No duplicated old/new implementation tree.

## C. Final directory tree

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

## D. Migration summary

| Old file | New file | Change | Why |
| -------- | -------- | ------ | --- |
| `scripts/qa_skill_lib.ps1` | `scripts/qa_skill_lib.ps1` | keep as loader | preserve every existing script import path |
| `scripts/qa_skill_lib.ps1` | `scripts/modules/qa_runtime.ps1` | extract | isolate path/config/IO logic |
| `scripts/qa_skill_lib.ps1` | `scripts/modules/qa_prompt_bundle.ps1` | extract | isolate prompt-bundle logic |
| `scripts/qa_skill_lib.ps1` | `scripts/modules/qa_dataset.ps1` | extract | isolate dataset statistics and fixture/schema helpers |
| `scripts/qa_skill_lib.ps1` | `scripts/modules/qa_generation.ps1` | extract | isolate QA generation and normalization |
| `scripts/qa_skill_lib.ps1` | `scripts/modules/qa_validation.ps1` | extract | isolate QA and script validation/report logic |
| `scripts/import_stellaria_gold_qa.ps1` | `scripts/import_stellaria_gold_qa.ps1` | keep and harden | keep the specialized flow but remove machine-specific path defaults |

## E. Functional changes

### Structure-only changes

- Split the large shared library into focused modules.
- Kept public script names and call patterns unchanged.

### Internal changes with preserved behavior

- `qa_skill_lib.ps1` now loads focused modules instead of containing all logic directly.
- Validation now scans the module files as part of script parsing/inspection.
- QA root resolution now works from the module location rather than assuming the old single-file layout.

### Intentional behavior changes

- `import_stellaria_gold_qa.ps1` no longer defaults to machine-specific absolute paths.
- Missing `SourcePath` for the Stellaria importer now fails explicitly instead of silently assuming an attachment path from one developer machine.

### Safety-focused additions

- Module files are treated as first-class required runtime assets by the validator.
- Script discovery now recurses under `scripts/` so validation keeps covering the new modular layout.

## F. Compatibility

- Existing public commands kept the same paths:
  - `validate_qa_skill.ps1`
  - `run_qa_skill_tests.ps1`
  - `update_qa_snapshots.ps1`
  - `build_prompt_bundle.ps1`
  - `import_gold_qa.ps1`
  - `regenerate_brse_investigation_dataset.ps1`
  - `export_qa_skill_report.ps1`
- Existing dot-source import path stayed the same:
  - `scripts/qa_skill_lib.ps1`
- No breaking change was introduced to the runtime gold dataset schema.

## G. Verification result

### Commands run

```powershell
./skills/qa/scripts/validate_qa_skill.ps1
./skills/qa/scripts/run_qa_skill_tests.ps1
```

### Results

- Validation: PASS
- Regression tests: PASS
- Test count: `20`
- Passed tests: `20`
- Failed tests: `0`

### Manual checks

- Confirmed module path resolution works from the new `scripts/modules/` location.
- Confirmed the validator still inspects scripts after modularization.
- Confirmed the Stellaria importer no longer carries absolute default paths.

## H. Remaining issues

- `import_stellaria_gold_qa.ps1` is still a specialized migration script with a large amount of task-specific parsing logic. It is safer now, but it remains intentionally specialized rather than being turned into the default import path.
- The generated report script can be expanded further if richer module-level reporting becomes necessary in future work.
