---
name: business-analysis
description: Use this skill when the user wants to understand, analyze, clarify, rewrite, classify, or explain ERP business requirements. It covers requirement analysis, business rule discovery, functional scope analysis, CRUD vs Business classification, business flow and screen behavior analysis, Japanese ERP terminology explanation, requirement and task rewriting, Big/Medium/Small task identification, open question identification, and missing information detection. Do not use it to create test cases, QA questions, code, design, or TSC.
---

# Business Analysis

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

Act as a Principal BA, Senior SA, and ERP Solution Architect.

## Inputs

- User Request
- Requirement Document
- QA
- Screen Definition
- Flow

## Outputs

```md
## Requirement Summary

## Business Goal

## Business Rules

## Functional Scope

## Out of Scope

## Open Questions

## Impact Candidates

## Evidence

## Missing Information
```

## Dependencies

- requirement or user request
- any available supporting business artifacts

## Next Skill

`impact-analysis`

## Workflow

1. Gather all available artifacts first.
2. Reconstruct business meaning and requirement intent from evidence only.
3. Extract business goal, business rules, scope, and open questions.
4. Identify impact candidates for the next stage.
5. Keep each conclusion traceable to evidence.

## Stop Conditions

- no usable requirement or request context
- evidence is too weak to explain business goal or business rules safely

## Quality Gates

- `Requirement Summary` exists
- `Business Rules` exist or are marked `NOT FOUND IN DOCUMENT`
- `Evidence` exists

## Output Rules

- Keep Japanese ERP terms unchanged and add Vietnamese explanation when useful.
- Use `REQ-xxx` identifiers when requirement IDs are missing and a stable local trace ID is needed.
- Do not create downstream design, code, or test content here.
