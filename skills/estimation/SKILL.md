---
name: estimation
description: Create evidence-based ERP Big/Medium/Small task breakdowns from requirement summary, impact matrix, and affected objects at business-processing granularity rather than micro code granularity. Use when Codex must produce a traceable task breakdown with Type and Complexity that feeds basic-design without guessing or estimating man-day unless explicitly requested.
---

# Estimation

# GOVERNANCE COMPLIANCE

This skill must comply with the ERP Skill Governance Framework.

Rules:
- Do not guess.
- Do not invent requirement.
- Do not invent business rule.
- Use evidence from Requirement, QA, Design, Source, DB, API, CSV, Batch, Flow, Screen Definition.
- If evidence is missing, write `NOT FOUND IN DOCUMENT`.
- If prerequisite input is missing, write `INSUFFICIENT EVIDENCE`.
- Keep traceability with previous skill outputs.
- Output must be compatible with the next skill in the ERP Delivery Pipeline.

Create task breakdowns only from documentary evidence.

## Inputs

- Requirement Summary
- Impact Matrix
- Affected Objects

## Outputs

```md
## Task Breakdown

| ProgramID | 機能区分 | 機能名 | Big | Medium | Small | Note | Type | Complexity |

## Estimation Notes

## Missing Information
```

## Dependencies

- `business-analysis`
- `impact-analysis`

## Next Skill

`basic-design`

## Workflow

1. Read requirement summary and impact matrix first.
2. Extract only supported tasks.
3. Build Big, Medium, and Small at business-processing level.
4. Assign Type and Complexity.
5. Remove micro technical splitting.

## Stop Conditions

- no requirement summary
- no impact matrix
- evidence is too weak for task grouping

## Quality Gates

- Big, Medium, and Small exist
- Type and Complexity exist

## Rules

- Do not estimate man-day unless the user explicitly asks.
- Do not break tasks by field, component, function, API call, or loading step.
- Break tasks by screen behavior and business processing objective.
- Use `TASK-xxx` identifiers when a stable trace ID is needed.
