---
name: qa
description: Use this skill when the user wants BrSE investigation QA, customer confirmation questions, requirement clarification questions, or QA dataset regeneration from spec, source, flow, meeting notes, current-system investigation, or old Q&A. Trigger on requests like `QA`, `viet QA`, `lam QA`, `clarification questions`, `investigation QA`, or requests to rewrite or regenerate BrSE-style customer Q&A. It covers impact investigation, scope-keep confirmation, version conflict checks, workflow gap questions, CSV questions, notification questions, mapping questions, and evidence-based current-understanding statements. Do not use it to generate code, test cases, design, or TSC.
---

# QA

Create customer clarification QA in concise Vietnamese BrSE style.
Write like a Vietnamese BrSE who has read the documents, checked the current system, grouped the logic clearly, and is asking the customer to confirm the current understanding.

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
- write every customer QA with exactly 3 mandatory parts in structure: `Mở đầu`, `Nội dung đang hiểu + điểm cần confirm`, `Kết thúc`
- open with the exact confirmation sentence pattern required by this skill
- show the current understanding based only on available evidence
- group multiple conditions or spec details into clear business logic when relevant
- list unclear points as numbered confirmation items
- keep Japanese terms and field names unchanged
- ask the customer to confirm or correct that understanding

Do not:
- omit one of the three mandatory parts
- generate generic test cases
- generate implementation design
- answer the customer's decision on their behalf
- add handling directions or business rules that are not present in the input or evidence
- add commentary outside the final customer message in standard QA mode

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

Return only the final customer message.
Do not add headings such as `QA Purpose`, `Analysis`, `Evidence`, or any explanation outside the message.

Every QA must contain exactly these 3 parts:

1. `Mở đầu`
2. `Nội dung đang hiểu + điểm cần confirm`
3. `Kết thúc`

Use the required wording pattern:

- `Mở đầu`:
  `Liên quan đến yêu cầu [tên yêu cầu/nội dung yêu cầu], chúng tôi đang hiểu như sau và muốn confirm lại với bác:`
- `Nội dung đang hiểu + điểm cần confirm`:
  - first, summarize the current understanding in short and clear Vietnamese
  - then write:
    `Chúng tôi muốn confirm thêm các điểm sau:`
  - then list numbered points `1.`, `2.`, `3.` only for unclear or high-risk items that need confirmation
- `Kết thúc`:
  `Nhờ bác confirm giúp nội dung trên có đúng không?`
  `Cảm ơn bác.`

If there is no confirm point, still keep the 3-part structure and use one numbered item to confirm the overall understanding.
Do not print the literal labels `Mở đầu`, `Nội dung đang hiểu + điểm cần confirm`, or `Kết thúc` unless the user explicitly asks for visible headings.

### 2. Dataset Mode

Use only when the user explicitly asks for dataset generation, JSONL, training data, bulk QA generation, or dataset regeneration from sample QA / gold dataset.

Output JSONL only unless the user explicitly asks for commentary.

Dataset priorities:
- quality over quantity
- evidence-grounded current understanding over generic confirmation
- mandatory 3-part structure over loose free-form QA
- natural BrSE wording inside that structure
- real business ambiguity over paraphrasing the spec

## Workflow

1. Read the user request and all available requirement context.
2. Investigate current behavior from source, screen, flow, old QA, meeting note, CSV, API, or existing artifacts when available.
3. Detect missing rules, contradictions, scope gaps, unclear impacts, hidden assumptions, and possible handling directions.
4. Classify each candidate QA using `references/qa-groups.md`.
5. Draft QA in BrSE style with mandatory `Mở đầu / Nội dung đang hiểu + điểm cần confirm / Kết thúc`, using only evidence-backed current understanding and confirmation points.
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
- `Để tránh hiểu sai nghiệp vụ ...`
- `Chúng tôi muốn confirm thêm các điểm sau:`
- `Tuy nhiên, hiện tại chưa thấy mô tả rõ ...`
- `Do đó, chúng tôi đang hiểu rằng ...`
- `Nhờ bác confirm giúp nội dung trên có đúng không?`
- `Cảm ơn bác.`

Formatting rules:
- every QA must structurally contain `Mở đầu`, `Nội dung đang hiểu + điểm cần confirm`, and `Kết thúc`
- standard customer QA mode must return only the final message content
- do not print the literal headings in normal output
- separate the 3 parts by one blank line only
- use numbered lists `1. 2. 3.` for confirm points
- keep sentences short, polite, and easy to copy
- keep the writing grounded in actual investigation
- do not add information not present in the input or evidence

## Low-Quality QA To Avoid

Do not write questions like:
- `Field này có required không?`
- `Có export CSV không?`
- `Có validate không?`
- `Ai được thao tác?`

Rewrite them into BrSE investigation QA with:
- full 3-part structure
- business context
- investigation result when available
- current understanding
- confirmation request

## Quality Gates

Every final QA must satisfy all of the following:
- contains `Mở đầu`, `Nội dung đang hiểu + điểm cần confirm`, and `Kết thúc` in structure, not necessarily as visible labels
- standard customer QA mode returns only the final message content
- shows signs of investigation when evidence exists
- mentions concrete screens, batch, CSV, table, status, role, or mapping when relevant
- states the team's current understanding
- includes at least one customer confirmation point
- sounds like a real BrSE Q&A instead of a shallow AI template
- avoids generic one-line confirmation or abrupt ending right after the question
- groups complex conditions into short and understandable logic
- uses polite, short, copyable Vietnamese
- is backed by evidence or explicitly marked `NOT FOUND IN DOCUMENT`

## Stop Conditions

Stop and report the limitation when:
- no usable request context exists
- evidence is too weak to justify a safe clarification question
- the available artifacts are contradictory and no bounded assumption can be stated

## Rules

- Use stable identifiers when dataset output requires them.
- Prefer one business issue per QA, but allow multiple sub-questions inside the same QA when they are tightly connected.
- When regenerating datasets, every QA must still contain `Mở đầu`, `Nội dung đang hiểu + điểm cần confirm`, and `Kết thúc` in structure.
- When regenerating datasets, use the gold dataset as the source of good ideas, then rewrite into evidence-grounded QA with clear context and confirmation points.
- When the user asks only for standard QA, do not switch to dataset JSONL mode.
