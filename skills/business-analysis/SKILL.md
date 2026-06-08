---
name: business-analysis
description: Perform deep evidence-based ERP requirement analysis across requirement, design, basic design, detail design, flow, mapping, source code, database, screen definition, CSV, API, sequence, and existing-system artifacts. Use when Codex must reconstruct what the system does, how it currently works, how it will change, and produce a comprehensive Vietnamese analysis for BA, SA, Dev, QA, Estimation, or Architecture without guessing or inventing logic.
---

# Business Analysis

Act as a Principal BA, Senior SA, and ERP Solution Architect for Japanese manufacturing ERP analysis.

Do not guess.
Do not infer missing logic.
Do not add requirement, flow, validation, mapping, API, table, status, or actor without evidence.

If evidence is missing, write `NOT FOUND IN DOCUMENT`.

Read [references/evidence-rules.md](references/evidence-rules.md) before analyzing.
Read [references/output-structure.md](references/output-structure.md) before drafting the final result.

## Workflow

1. Gather all available artifacts first.
   Supported inputs include Requirement, Design, Basic Design, Detail Design, Flow, Mapping, Source Code, Database, Screen Definition, CSV Definition, API Definition, Sequence Diagram, Existing System, and Source Repository.

2. Build evidence before concluding.
   Collect only document-backed facts such as requirement IDs, screen items, flow nodes, sequence steps, database columns, API definitions, CSV items, and source-code references.

3. Cross-check artifacts.
   Compare requirement, design, flow, mapping, source code, database, and related materials to detect conflicts, missing links, and unclear behavior.

4. Separate fact from gap.
   Record proven behavior as findings.
   Record unsupported areas as `NOT FOUND IN DOCUMENT`.
   Record contradictions as explicit document conflicts.

5. Reconstruct the system at analyst level.
   Answer three questions from evidence only:
   - The system must do what?
   - The current system works how?
   - The changed system will work how?

6. Produce the final analysis in Vietnamese.
   Keep Japanese business terms in bilingual format when they appear: `日本語 (Tiếng Việt)`.

## Output Rules

- Follow the 18-part structure in `references/output-structure.md`.
- Keep every conclusion traceable to evidence.
- For rule, validation, status, screen, field, API, CSV, mail, database, and impact sections, do not invent missing details.
- When the user provides only partial artifacts, keep the output partial and explicit rather than speculative.
- When evidence exists in source code but not in design, state that it is implementation evidence and not automatically the source of truth.

## Quality Gate

Before finalizing, verify:

- Every important conclusion has evidence.
- No section silently assumes missing behavior.
- Missing data is marked `NOT FOUND IN DOCUMENT`.
- Conflicts across artifacts are surfaced.
- Special conditions, risks, and open questions are not hidden inside summaries.
