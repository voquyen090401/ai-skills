---
name: estimation
description: Create evidence-based ERP estimation task breakdowns in Vietnamese for Japanese manufacturing ERP projects. Use when Codex must analyze requirement, screen, flow, sequence, database, CSV, API, source code, or existing-system documents and produce Big/Medium/Small estimation tasks at work-package level without estimating man-day, hours, or cost.
---

# Estimation

Create task breakdowns only from documentary evidence.

Keep all task names in Vietnamese.

Do not estimate man-day, hours, or cost.

Do not infer missing behavior, add habitual project tasks, or invent functions that are not proven by the source documents.

If a claimed function, hidden task, impact area, or technical layer is not supported by evidence, write `NOT FOUND IN DOCUMENT` and do not create the task.

If required artifacts are missing, write `MISSING INFORMATION` and stop short of inference.

Read [references/erp-breakdown-rules.md](references/erp-breakdown-rules.md) before drafting the breakdown. Use it as the authoritative checklist for document order, evidence rules, task hierarchy, type classification, complexity, duplicate handling, hidden-task detection, out-of-scope detection, and self-review.

Use [references/output-template.md](references/output-template.md) when formatting the response.

## Workflow

1. Read the available project artifacts in this order whenever they exist: Requirement, Screen Definition, Flow Diagram, Sequence Diagram, Database Definition, CSV Definition, API Definition, Existing Source Code, Existing System Behavior.
2. Extract documentary evidence before creating any task. Accept only requirement IDs or lines, screen items, flow nodes, sequence steps, API endpoints, CSV items, table definitions, source code references, or existing functions.
3. Identify impact areas from the documents only: Frontend, Backend, Database, Batch, CSV, API, Mail, Permission, Master, Interface.
4. Build `Big` tasks as independent business objectives.
5. Build `Medium` tasks as estimation groups under each `Big`.
6. Build `Small` tasks as estimation work packages, not micro coding steps. Merge closely related validations, queries, updates, and message handling into one `Small` when they belong to the same processing objective. For each one, assign `Type`, `Technical Layer`, `Complexity`, `Feature Count`, `Evidence`, and `Impact Area`.
7. Run duplicate review. If a new task overlaps an existing task's processing objective, merge it and record `MERGED WITH EXISTING TASK`.
8. Detect hidden tasks only when the documents explicitly support them. Check permission, status transition, logging, rollback, error handling, message handling, mail trigger, CSV validation, and transaction control.
9. Mark any explicitly excluded item as `OUT OF SCOPE` and do not break it down.
10. Finish with the required self-review sequence: remove tasks without evidence, remove duplicates, remove inferred tasks, check requirement coverage, and check impact coverage.

## Output Rules

Use Vietnamese for `Big`, `Medium`, and `Small` task names.

Keep section labels and status markers exactly as defined in the template and rules references.

In `# DANH SÁCH TASK`, put `ProgramID` as the first column of every row.

Prefer missing-task tolerance over speculative completeness. A smaller output with clean evidence is better than a fuller output with invented work.

Prefer estimation-ready task grouping over implementation micro-splitting. Do not create separate `Small` tasks for each field, each validation line, each SQL query, or each UI event when the documents describe them as one processing objective.
