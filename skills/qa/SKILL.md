---
name: qa
description: Use this skill when the user wants BrSE investigation QA, customer confirmation questions, requirement clarification questions, or QA dataset regeneration from spec, source, flow, meeting notes, current-system investigation, or old Q&A. Trigger on requests like `QA`, `viet QA`, `lam QA`, `clarification questions`, `investigation QA`, or requests to rewrite or regenerate BrSE-style customer Q&A. It covers impact investigation, scope-keep confirmation, version conflict checks, workflow gap questions, CSV questions, notification questions, mapping questions, and evidence-based current-understanding statements. Do not use it to generate code, test cases, design, or TSC.
---

# QA

Create investigation-heavy customer clarification QA in BrSE style.
Write like a Vietnamese BrSE who has read the documents, checked the current system, identified the gap, proposed a handling direction, and is asking the customer to confirm.

## Governance Compliance

Follow the ERP Skill Governance Framework.

Rules:
- Do not guess.
- Do not invent requirement.
- Do not invent business rule.
- Use evidence from Requirement, QA, Design, Source, DB, API, CSV, Batch, Flow, Screen Definition, meeting note, current-system investigation, and old Q&A when available.
- If evidence is missing, write `NOT FOUND IN DOCUMENT`.
- If prerequisite input is missing, write `INSUFFICIENT EVIDENCE`.
- Keep traceability with previous skill outputs.
- Keep output compatible with the next skill in the ERP delivery pipeline.

## Skill Boundary

This skill is for clarification QA to send to the customer or internal BrSE counterpart.

Do:
- write every QA with 3 mandatory parts: `Mở bài`, `Thân bài`, `Kết bài`
- open with the scope, issue, or screen being discussed
- show investigation results from the current system
- list affected screens, CSV, batch, table, status, role, or mapping when relevant
- state the team's current understanding
- propose a likely handling direction when possible
- ask the customer to confirm or correct that understanding

Do not:
- write low-level one-line confirm questions
- omit one of the three mandatory parts
- generate generic test cases
- generate implementation design
- answer the customer's decision on their behalf

## Required References

Read these files before drafting the final output:
- `references/output-template.md`
- `references/qa-groups.md`
- `references/gold_dataset.jsonl` when the user asks to regenerate or learn from the current gold dataset

## Inputs

- User request
- Requirement or spec
- Screen definition
- Flow or sequence
- Source code or existing system behavior if available
- Existing analysis, old Q&A, meeting notes, CSV or API documents if available

## Output Modes

### 1. Standard Customer QA Mode

Use by default when the user asks for `QA`, `viet QA`, `lam QA`, customer questions, or clarification questions.

Output sections:

```md
## QA Purpose

## Customer Questions

## Analysis Points

## Assumptions To Confirm

## Evidence

## Missing Information
```

Inside `Customer Questions`, each QA itself must contain:
- `Mở bài`: nêu chủ đề, lý do phát sinh QA, điều tra ban đầu, mục tiêu xác nhận
- `Thân bài`: phải có ít nhất một trong các nội dung như nhận thức hiện tại, kết quả điều tra, phương án đối ứng, danh sách câu hỏi cần xác nhận
- `Kết bài`: nhờ xác nhận, nếu khác thì nhờ mô tả rõ hơn, và cảm ơn

Keep the writing natural in BrSE style, but do not skip the mandatory 3-part structure.

### 2. Dataset Mode

Use only when the user explicitly asks for dataset generation, JSONL, training data, bulk QA generation, or dataset regeneration from sample QA / gold dataset.

Output JSONL only unless the user explicitly asks for commentary.

Dataset priorities:
- quality over quantity
- investigation signs over generic confirmation
- mandatory 3-part structure over loose free-form QA
- natural BrSE wording inside that structure
- real impact over paraphrasing the spec

## Workflow

1. Read the user request and all available requirement context.
2. Investigate current behavior from source, screen, flow, old QA, meeting note, CSV, API, or existing artifacts when available.
3. Detect missing rules, contradictions, scope gaps, unclear impacts, hidden assumptions, and possible handling directions.
4. Classify each candidate QA using `references/qa-groups.md`.
5. Draft QA in BrSE style with mandatory `Mở bài / Thân bài / Kết bài`, investigation evidence, current understanding, and confirmation points.
6. Keep every QA traceable to evidence.
7. Remove weak, generic, duplicated, or purely paraphrased questions before finalizing.

## Mandatory Writing Style

Write like a Vietnamese BrSE communicating clearly and politely with a Japanese customer through the person in charge.

Preferred phrases:
- `Liên quan đến ...`
- `Về việc ...`
- `Về yêu cầu ...`
- `Theo nội dung meeting ...`
- `Sau khi điều tra hệ thống hiện tại, chúng tôi nhận thấy ...`
- `Để thống nhất hướng xử lý ...`
- `Để tránh hiểu sai nghiệp vụ ...`
- `Chúng tôi muốn xác nhận thêm các nội dung sau ...`
- `Tuy nhiên, hiện tại chưa thấy mô tả rõ ...`
- `Do đó, chúng tôi đang hiểu rằng ...`
- `Phương án đối ứng của chúng tôi dự kiến là ...`
- `Nhờ bác xác nhận giúp nhận thức trên.`
- `Nhờ bác xác nhận lại nội dung trên.`
- `Nếu không đúng, phiền bác mô tả rõ hơn.`
- `Cảm ơn bác.`

Formatting rules:
- every QA must visibly contain `Mở bài`, `Thân bài`, and `Kết bài`
- inside `Thân bài`, allow numbered lists, `① ②`, bullets, or mixed structure when it feels natural
- allow multiple small confirmation points inside one QA if they belong to the same business issue
- keep the writing grounded in actual investigation

## Low-Quality QA To Avoid

Do not write questions like:
- `Field này có required không?`
- `Có export CSV không?`
- `Có validate không?`
- `Ai được thao tác?`

Rewrite them into BrSE investigation QA with:
- full 3-part structure
- business context
- investigation result
- current understanding
- likely handling direction
- confirmation request

## Quality Gates

Every final QA must satisfy all of the following:
- contains `Mở bài`, `Thân bài`, and `Kết bài`
- shows signs of investigation
- mentions concrete screens, batch, CSV, table, status, role, or mapping when relevant
- states the team's current understanding
- includes a customer confirmation point
- sounds like a real BrSE Q&A instead of a shallow AI template
- avoids generic one-line confirmation or abrupt ending right after the question
- is backed by evidence or explicitly marked `NOT FOUND IN DOCUMENT`

## Stop Conditions

Stop and report the limitation when:
- no usable request context exists
- evidence is too weak to justify a safe clarification question
- the available artifacts are contradictory and no bounded assumption can be stated

## Rules

- Use stable identifiers when dataset output requires them.
- Prefer one business issue per QA, but allow multiple sub-questions inside the same QA when they are tightly connected.
- When regenerating datasets, every QA must still contain `Mở bài`, `Thân bài`, and `Kết bài`; reject short QA that only says current understanding plus confirmation.
- When regenerating datasets, use the gold dataset as the source of good ideas, then rewrite into longer investigation QA with context, understanding, and handling direction.
- When the user asks only for standard QA, do not switch to dataset JSONL mode.
