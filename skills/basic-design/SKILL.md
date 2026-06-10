---
name: basic-design
description: Use this skill when the user wants solution design for an ERP feature. It covers Basic Design, screen, input, output, validation, business logic, API, DB, CSV, batch, mail, authority, error handling, and sequence design. Do not use it to generate production code or test cases.
---

# Basic Design

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

Prefer `spreadsheets:Spreadsheets` when the final deliverable must be `.xlsx`.

## Inputs

- Requirement Summary
- Business Rules
- Impact Matrix
- Task Breakdown

## Outputs

```md
## Design Summary

## Screen Design

## Input/Output Design

## Business Logic Design

## Validation Design

## DB Design

## API Design

## CSV Design

## Batch Design

## Mail Design

## Authority Design

## Error Handling

## Traceability Matrix

## Missing Information
```

## Dependencies

- `business-analysis`
- `impact-analysis`
- `estimation` when task breakdown is required

## Next Skill

`feature-implementation`

## Workflow

1. Rebuild design scope from requirement summary and impact matrix.
2. Cover the affected screen, business logic, DB, API, CSV, batch, mail, and authority areas.
3. Keep traceability from requirement and task to design.
4. Mark missing detail explicitly instead of inventing it.

## Stop Conditions

- requirement is still unclear
- impact is still unclear
- no safe basis for business logic or design decisions

## Quality Gates

- `Business Logic Design` exists
- screen, DB, and API impact are handled
- `Traceability Matrix` exists

## Rules

- Use `DES-xxx` identifiers when a stable trace ID is needed.
- Do not silently design unsupported business rules.
