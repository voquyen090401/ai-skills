---
name: qa
description: Use this skill when the user wants BrSE investigation QA, customer confirmation questions, requirement clarification questions, or QA dataset regeneration from spec, source, flow, meeting notes, current-system investigation, or old Q&A. Trigger on requests like `QA`, `viet QA`, `lam QA`, `clarification questions`, `investigation QA`, or requests to rewrite or regenerate BrSE-style customer Q&A. It covers impact investigation, scope-keep confirmation, version conflict checks, workflow gap questions, CSV questions, notification questions, mapping questions, and evidence-based current-understanding statements. Do not use it to generate code, test cases, design, or TSC.
---

# QA

Create Vietnamese BrSE-style clarification QA that can be sent to the customer immediately.

This skill is for business clarification, not for implementation, design, or test-case authoring.

## Purpose

Use this skill when we already have some requirement evidence and need to:

- confirm business understanding with the customer
- ask bounded clarification questions
- investigate scope, rules, mapping, CSV, API, DB, workflow, authority, or exception handling
- regenerate or import QA dataset records used by the skill

## Expected Input

Useful inputs include:

- requirement text
- screen definition
- sheet name or line number
- old Q&A
- source investigation notes
- current-system findings
- flow, API, DB, CSV, or batch evidence

If the evidence is too weak, do not guess. State the limitation clearly.

## Governance Compliance

Rules:

- Do not guess.
- Do not invent requirement.
- Do not invent business rule.
- Use only evidence from Requirement, QA, Design, Source, DB, API, CSV, Batch, Flow, Screen Definition, meeting note, current-system investigation, and old Q&A when available.
- If evidence is missing, write `NOT FOUND IN DOCUMENT`.
- If prerequisite input is missing, write `INSUFFICIENT EVIDENCE`.

## Skill Boundary

Do:

- keep the QA grounded in the exact request scope
- preserve screen names, screen codes, sheet names, line numbers, block names, item names, status names, and Japanese terms when they exist in the input
- present the team's current business understanding before asking for confirmation
- group complex QA by topic or by case when that makes the message easier to confirm
- keep the tone polite, natural, short, and business-friendly
- choose the most suitable QA format instead of forcing one rigid template

Do not:

- ask direct isolated questions without current understanding
- add impacted screens, CSV, batch, API, database, master, authority, or phase details when the evidence does not mention them
- change exact business conditions such as `販売部門 = 19` into vague paraphrases
- print internal headings such as `■ Bối cảnh`, `■ Nhận thức hiện tại`, `■ Câu hỏi xác nhận`
- force every QA into the same wording

## Required References

Read these files before drafting the final output:

- `references/output-template.md`
- `references/qa-groups.md`
- `references/gold_dataset.jsonl` when the user asks to regenerate, import, or learn from the gold dataset

Reference ownership:

- output format and examples: `references/output-template.md`
- category taxonomy: `references/qa-groups.md`
- approved gold examples: `references/gold_dataset.jsonl`

## Output Modes

### 1. Standard Customer QA Mode

Use by default when the user asks for customer-facing QA.

Return only the final customer message.

Required content flow:

1. opening with concrete scope
2. current business understanding
3. unclear point or confirmation point
4. polite closing

### 2. Dataset Mode

Use only when the user explicitly asks for dataset generation, JSONL, training data, import, bulk QA generation, or dataset regeneration.

Return JSONL only unless the user explicitly asks for commentary.

Preferred dataset path:

- runtime gold dataset: `references/gold_dataset.jsonl`
- generated candidate dataset: `references/candidate_dataset.generated.jsonl`

## Workflow

1. Read the request and all available evidence.
2. Identify the concrete scope being confirmed.
3. Choose the smallest matching QA group from `references/qa-groups.md`.
4. Write the current understanding first.
5. Follow the output structure from `references/output-template.md`.
6. Use gold examples from `references/gold_dataset.jsonl` only as quality references, not as a template to copy mechanically.
7. Ask only evidence-backed confirmation points.
8. Keep the final QA natural enough to send to the customer immediately.

## Gold Dataset Usage

Use `references/gold_dataset.jsonl` for:

- few-shot examples when building a runtime prompt bundle
- validation of category coverage and dataset quality
- importing approved human QA into the runtime dataset

Do not:

- treat backup files as runtime dataset
- mix candidate records into the gold dataset without review
- rewrite old gold records when only new records need to be appended

## Validation And Commands

Primary commands:

- build prompt bundle: `./skills/qa/scripts/build_prompt_bundle.ps1 -InputPath <file>`
- validate skill: `./skills/qa/scripts/validate_qa_skill.ps1`
- run tests: `./skills/qa/scripts/run_qa_skill_tests.ps1`
- update snapshots intentionally: `./skills/qa/scripts/update_qa_snapshots.ps1 -ConfirmUpdate`
- import approved gold QA: `./skills/qa/scripts/import_gold_qa.ps1 -InputPath <file> -DryRun`
- regenerate candidate dataset: `./skills/qa/scripts/regenerate_brse_investigation_dataset.ps1 -DryRun`
- specialized Stellaria import: `./skills/qa/scripts/import_stellaria_gold_qa.ps1 -SourcePath <file>`

## Quality Gates

Every final QA must satisfy all of the following:

- has a concrete opening scope
- shows current business understanding
- contains at least one confirmation point
- preserves important screen/item/condition terms from the input
- does not contain internal headings
- does not read like a bare checklist of direct questions
- ends politely
- stays below the threshold of invented business content

## Stop Conditions

Stop and report the limitation when:

- no usable request context exists
- evidence is too weak to justify a safe clarification question
- the available artifacts are contradictory and no bounded assumption can be stated
