# QA Skill

## Purpose

`skills/qa/` contains the QA skill used to produce Vietnamese BrSE clarification QA and maintain its supporting gold dataset.

## Main Flow

```text
SKILL.md
+ agents/openai.yaml
+ references/output-template.md
+ references/qa-groups.md
+ references/gold_dataset.jsonl
        ↓
scripts/build_prompt_bundle.ps1
        ↓
Prompt bundle
        ↓
Customer-ready QA output
        ↓
scripts/validate_qa_skill.ps1
        ↓
tests/fixtures.json + tests/snapshots.json
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
```
