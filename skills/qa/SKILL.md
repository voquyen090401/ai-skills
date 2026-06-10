---
name: qa
description: Use this skill when the user wants QA, customer confirmation questions, requirement clarification questions, or analysis points to ask the customer. If the user says only `QA`, `viet QA`, `lam QA`, or similar shorthand, default to this skill unless they explicitly ask for code, design, TSC, estimation, or impact analysis instead. It covers QA generation, customer confirmation questions, requirement clarification questions, analysis points, assumptions to confirm, and missing information detection. Do not use it to generate code, create design, or create TSC.
---

# QA

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

Focus on customer confirmation questions and clarification analysis.

## Inputs

- User Request
- Requirement
- Screen Definition
- Flow
- Existing Analysis if available

## Outputs

```md
## QA Purpose

## Customer Questions

## Analysis Points

## Assumptions To Confirm

## Evidence

## Missing Information
```

## Dependencies

- user request or requirement context
- any available supporting business artifacts

## Next Skill

`impact-analysis`

## Workflow

1. Read the user request and any available requirement context.
2. Identify missing business rules, scope gaps, unclear flows, and confirmation points.
3. Write concrete QA questions the user can send to the customer.
4. Add analysis points and assumptions that still need confirmation.
5. Keep each question traceable to available evidence.

## Stop Conditions

- no usable request context exists
- evidence is too weak to justify any safe confirmation question

## Quality Gates

- `Customer Questions` exists
- `Analysis Points` exists
- `Evidence` exists

## Rules

- Use `QA-xxx` identifiers when a stable trace ID is needed.
- Do not invent customer answers or unsupported business rules.
