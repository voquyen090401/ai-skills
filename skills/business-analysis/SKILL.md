---
name: business-analysis
description: Perform evidence-based ERP requirement analysis across requirement, QA, screen definition, flow, design, source, database, CSV, API, and existing-system artifacts. Use when Codex must understand business intent, clarify business rules, rewrite requirements, define functional scope, and produce a requirement summary that can feed impact-analysis in the ERP delivery pipeline without guessing.
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
