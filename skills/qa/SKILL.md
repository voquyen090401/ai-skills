---
name: qa
description: Use this skill when the user wants BrSE investigation QA, customer confirmation questions, requirement clarification questions, or QA dataset regeneration from spec, source, flow, meeting notes, current-system investigation, or old Q&A. Trigger on requests like `QA`, `viet QA`, `lam QA`, `clarification questions`, `investigation QA`, or requests to rewrite or regenerate BrSE-style customer Q&A. It covers impact investigation, scope-keep confirmation, version conflict checks, workflow gap questions, CSV questions, notification questions, mapping questions, and evidence-based current-understanding statements. Do not use it to generate code, test cases, design, or TSC.
---

# QA

Create customer clarification QA in concise Vietnamese BrSE style.
Write like a Vietnamese BrSE who has read the documents, checked the current system, and is sending a short, easy-to-understand confirmation message to a business customer.

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
- write every customer QA with exactly 3 mandatory parts in structure: `Mở đầu`, `Nội dung đang hiểu`, `Các điểm cần confirm`, then close with the required ending
- open with the exact confirmation sentence pattern required by this skill
- show the current understanding based only on available evidence
- summarize the current understanding in short business language, usually within 3 to 5 sentences
- list 2 to 4 numbered confirmation questions when the evidence supports them
- keep each confirmation question focused on one idea only
- write from the user/business-operation point of view whenever possible
- convert technical wording into customer-friendly wording whenever possible
- keep the message polite, natural, short, and easy to send to the customer
- preserve the customer's pronoun style from the input; if the input uses `bác`, the output must use `bác`

Do not:
- omit one of the mandatory parts
- generate generic test cases
- generate implementation design
- answer the customer's decision on their behalf
- add handling directions or business rules that are not present in the input or evidence
- add commentary outside the final customer message in standard QA mode
- write long investigation reports, internal notes, or implementation suggestions
- use table names, column names, technical IDs, or database terminology unless the customer already uses them or they are truly necessary for understanding
- combine multiple unrelated confirmation points into one long sentence
- force 2 to 4 questions by inventing content that is not supported by evidence

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

Every QA must contain exactly these 3 parts in content flow:

1. `Mở đầu`
2. `Nội dung đang hiểu`
3. `Các điểm cần confirm`

Use the required wording pattern:

- `Mở đầu`:
  `Liên quan đến yêu cầu [tên yêu cầu/nội dung yêu cầu], chúng tôi đang hiểu như sau và muốn confirm lại với bác:`
- `Nội dung đang hiểu`:
  - summarize the current understanding in short and clear Vietnamese
  - keep this part concise, normally 3 to 5 sentences maximum
  - if the source contains technical detail, rewrite it in business wording first
- `Các điểm cần confirm`:
  - write exactly:
    `Chúng tôi muốn confirm thêm các điểm sau:`
  - then list numbered points `1.`, `2.`, `3.`, `4.` only for unclear or high-risk items that need confirmation
  - prefer 2 to 4 questions
  - each numbered item must ask only one point
  - if there are multiple possible business directions, write them clearly so the customer can choose
- `Kết thúc`:
  `Nhờ bác confirm giúp nội dung trên có đúng không?`
  `Cảm ơn bác.`

If the evidence safely supports only one confirmation point, ask one overall confirmation question rather than inventing extra questions.
Do not print the literal labels `Mở đầu`, `Nội dung đang hiểu`, `Các điểm cần confirm`, or `Kết thúc` unless the user explicitly asks for visible headings.

### 2. Dataset Mode

Use only when the user explicitly asks for dataset generation, JSONL, training data, bulk QA generation, or dataset regeneration from sample QA / gold dataset.

Output JSONL only unless the user explicitly asks for commentary.

Dataset priorities:
- quality over quantity
- evidence-grounded current understanding over generic confirmation
- mandatory 3-part structure over loose free-form QA
- natural BrSE wording inside that structure
- business-friendly wording over technical wording unless the source requires technical precision
- real business ambiguity over paraphrasing the spec

## Workflow

1. Read the user request and all available requirement context.
2. Investigate current behavior from source, screen, flow, old QA, meeting note, CSV, API, or existing artifacts when available.
3. Detect missing rules, contradictions, scope gaps, unclear impacts, hidden assumptions, and possible handling directions.
4. Classify each candidate QA using `references/qa-groups.md`.
5. Draft QA in short BrSE style with mandatory `Mở đầu / Nội dung đang hiểu / Các điểm cần confirm / Kết thúc`, using only evidence-backed current understanding and confirmation points.
6. Rewrite technical terms into easier business wording unless the technical term is necessary for customer understanding.
7. Keep every QA traceable to evidence.
8. Remove weak, generic, duplicated, overly technical, or purely paraphrased questions before finalizing.

## Mandatory Writing Style

Write like a Vietnamese BrSE communicating clearly and politely with a Japanese customer through the person in charge.

Preferred phrases:
- `Liên quan đến ...`
- `Về việc ...`
- `Về yêu cầu ...`
- `Theo nội dung meeting ...`
- `Sau khi rà soát tài liệu hiện có, chúng tôi đang hiểu rằng ...`
- `Để tránh hiểu sai nghiệp vụ ...`
- `Chúng tôi muốn confirm thêm các điểm sau:`
- `Hiện tại chúng tôi chưa thấy mô tả rõ ...`
- `Do đó, chúng tôi đang hiểu rằng ...`
- `Nhờ bác confirm giúp nội dung trên có đúng không?`
- `Cảm ơn bác.`

Formatting rules:
- every QA must structurally contain `Mở đầu`, `Nội dung đang hiểu`, `Các điểm cần confirm`, and `Kết thúc` in flow, without showing the literal labels in normal output
- standard customer QA mode must return only the final message content
- separate the main parts by one blank line only
- use numbered lists `1. 2. 3. 4.` for confirm points
- keep sentences short, polite, and easy to copy
- do not let one sentence become longer than about 2 lines if it can be split more clearly
- keep the writing grounded in actual investigation
- do not add information not present in the input or evidence
- prefer business wording such as thao tác, dữ liệu đang chọn, kết quả search, dữ liệu chi tiết, xuất CSV
- avoid raw technical wording such as table, column, schema, record, technical ID, null, API realtime, batch timing unless the customer needs that detail

## Technical-Term Simplification Rules

When the source contains technical wording, convert it into customer-friendly wording whenever possible.

Examples:
- `I_RCP_NO` -> `dòng dữ liệu được chọn` or `dữ liệu của phiếu nhập tiền`
- `I_RCP_DETAIL_NO` -> `dữ liệu chi tiết`
- `record` -> `dòng dữ liệu`
- `search result` -> `kết quả search`
- `export` -> `xuất CSV`
- `table` / `column` / `schema` -> describe the business data or current data structure in easier wording
- `ID kỹ thuật` -> the related business object, screen item, or selected data

Only keep raw field names, table names, or Japanese item names when:
- the customer already uses them in the input, or
- removing them would make the question ambiguous

Even in those cases, prefer adding an easier business explanation around the term.

## Low-Quality QA To Avoid

Do not write questions like:
- `Field này có required không?`
- `Có export CSV không?`
- `Có validate không?`
- `Ai được thao tác?`

Rewrite them into customer-friendly QA with:
- full 3-part structure
- short business context
- current understanding
- 2 to 4 clear confirmation questions when supported by evidence

## Quality Gates

Every final QA must satisfy all of the following:
- contains `Mở đầu`, `Nội dung đang hiểu`, `Các điểm cần confirm`, and `Kết thúc` in structure, not necessarily as visible labels
- standard customer QA mode returns only the final message content
- shows signs of investigation when evidence exists
- states the team's current understanding
- includes at least one customer confirmation point
- prefers 2 to 4 confirmation questions when evidence supports them
- sounds like a real BrSE Q&A instead of a shallow AI template
- avoids generic one-line confirmation or abrupt ending right after the question
- groups complex conditions into short and understandable business logic
- uses polite, short, copyable Vietnamese
- avoids unnecessary technical or database terminology
- is backed by evidence or explicitly marked `NOT FOUND IN DOCUMENT`

## Stop Conditions

Stop and report the limitation when:
- no usable request context exists
- evidence is too weak to justify a safe clarification question
- the available artifacts are contradictory and no bounded assumption can be stated

## Rules

- Use stable identifiers when dataset output requires them.
- Prefer one business issue per QA, but allow multiple tightly related confirmation questions inside the same QA.
- When regenerating datasets, every QA must still contain `Mở đầu`, `Nội dung đang hiểu`, `Các điểm cần confirm`, and `Kết thúc` in structure.
- When regenerating datasets, use the gold dataset as the source of good ideas, then rewrite into evidence-grounded QA with clear context and confirmation points.
- When the user asks only for standard QA, do not switch to dataset JSONL mode.
