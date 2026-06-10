---
name: estimation
description: Use this skill when the user wants task breakdown, WBS creation, estimation preparation, complexity classification, or ERP work decomposition. It covers Big/Medium/Small task breakdown, WBS creation, type and complexity classification, estimation preparation, and scope decomposition. Do not use it to generate design or code, and do not estimate man-days unless explicitly requested.
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
