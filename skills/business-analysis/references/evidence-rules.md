# Evidence Rules

## Non-Negotiable Rules

- Do not guess.
- Do not infer missing business logic.
- Do not add requirement, flow, validation, mapping, API, table, status, actor, or permission without evidence.
- Every conclusion must be tied to evidence from provided artifacts.
- If evidence is missing, write `NOT FOUND IN DOCUMENT`.

## Evidence Sources

Use only facts supported by available artifacts, for example:

- Requirement IDs or requirement lines
- Screen definitions and field descriptions
- Flow nodes and transitions
- Sequence steps
- Mapping definitions
- Database tables and columns
- CSV layouts
- API request or response definitions
- Source-code references
- Existing-system behavior explicitly provided by the user

## Analysis Method

1. Collect evidence relevant to the target feature.
2. Cross-check requirement, design, flow, mapping, source code, and database.
3. Identify contradictions across artifacts.
4. List unclear points.
5. Conclude only after evidence review.

## Conflict Handling

When documents disagree:

- State which artifacts conflict.
- Quote the conflicting concepts in paraphrased form.
- Avoid choosing a winner unless the user explicitly names the source of truth.

## Missing Information Handling

When a needed detail is absent:

- Write `NOT FOUND IN DOCUMENT`.
- Do not fill the gap with common ERP assumptions.
- Keep downstream sections partial if upstream evidence is partial.

## Language Rules

- Write the final analysis in Vietnamese.
- Keep Japanese business terms in bilingual format when they appear:
  - `作図実績 (Thực tích tạo bản vẽ)`
  - `出図実績 (Thực tích xuất bản vẽ)`
  - `設計担当者 (Người phụ trách thiết kế)`
- Do not leave important business terms in Japanese only.
- Do not translate away terms that are important for traceability.

## Source Code Positioning

- Treat source code as implementation evidence.
- Do not automatically treat source code as the final specification unless the user explicitly says code is the source of truth.

## Final Review Checklist

Before responding, verify:

- Is there evidence for this conclusion?
- Is this statement inferred rather than proven?
- Is any rule, status, validation, or screen relation missing?
- Is a contradiction being hidden?
- Should this line be `NOT FOUND IN DOCUMENT` instead?
