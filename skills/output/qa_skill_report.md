# QA Skill Report

## Runtime Files
- SKILL: `skills/qa/SKILL.md`
- Agent config: `skills/qa/agents/openai.yaml`
- Output rules: `skills/qa/references/output-template.md`
- QA groups: `skills/qa/references/qa-groups.md`
- Gold dataset: `skills/qa/references/gold_dataset.jsonl`

## Script Roles
- Build prompt: `skills/qa/scripts/build_prompt_bundle.ps1`
- Validate skill: `skills/qa/scripts/validate_qa_skill.ps1`
- Run tests: `skills/qa/scripts/run_qa_skill_tests.ps1`
- Update snapshots: `skills/qa/scripts/update_qa_snapshots.ps1`
- Import gold QA: `skills/qa/scripts/import_gold_qa.ps1`
- Regenerate candidate dataset: `skills/qa/scripts/regenerate_brse_investigation_dataset.ps1`

## Dataset Summary
- Total records: 104
- Needs review: 2
- Duplicate IDs: 0
- Duplicate QA bodies: 0

### Category Distribution
- api: 4
- batch: 3
- csv_output: 6
- database: 5
- display_label: 7
- exception_case: 6
- file_export: 2
- impact_investigation: 4
- import_csv: 5
- mapping: 4
- master_data: 3
- multi_rule: 14
- notification: 4
- permission: 6
- scope_keep: 3
- search_item: 9
- validation: 5
- version_conflict: 4
- workflow_gap: 10

### Difficulty Distribution
- high: 55
- medium: 49

### Module Distribution
- FA10: 2
- MA10: 67
- STELLARIA: 35

### Screen Distribution
- Admin: 1
- Cadii連携: 1
- Course: 2
- FA1021: 1
- FA1030: 1
- Lesson: 1
- MA10: 1
- MA1010: 14
- MA1011: 2
- MA1012: 5
- MA1020: 2
- MA1030: 12
- MA1032: 4
- MA1070: 8
- MA1072: 3
- MA10xx: 6
- Mail service: 2
- mapping table: 1
- My Page: 1
- Nightly sync: 1
- Organization: 1
- SA1040: 1
- SA1100: 1
- SFA連携: 1
- Student: 11
- Students: 1
- Subject: 4
- TMS00090: 2
- レッスン: 1
- 受講確認: 2
- 成績確認: 9
- 管理者: 1

## Validation
- Passed: True
- Issue count: 0

## Tests
- Total: 20
- Passed: 20
- Failed: 0