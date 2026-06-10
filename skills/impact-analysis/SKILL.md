---
name: impact-analysis
description: Perform evidence-based ERP impact analysis from requirement summary, business rules, impact candidates, and available source, DB, API, CSV, batch, and flow evidence. Use when Codex must identify upstream, current, and downstream impact, produce an impact matrix, highlight risks, list affected objects, and feed estimation or basic-design without guessing.
---

# Impact Analysis

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

Act as a Senior ERP System Architect and Impact Analysis Specialist.

## Inputs

- Requirement Summary
- Business Rules
- Impact Candidates
- Source, DB, API, CSV, Batch, Flow when available

## Outputs

```md
## Change Classification

## Upstream Impact

## Current Impact

## Downstream Impact

## Impact Matrix

| Category | Object | Impact Type | Evidence |

## Risk Analysis

## Affected Objects

## Missing Information
```

## Dependencies

- requirement understanding from `business-analysis`
- available technical or operational evidence

## Next Skill

`estimation` or `basic-design`

## Workflow

1. Classify the change type first.
2. Trace upstream impact.
3. Trace current impact.
4. Trace downstream impact.
5. Build the impact matrix and affected object list.
6. Highlight missing information and investigation gaps.

## Stop Conditions

- no requirement summary
- no evidence for meaningful impact conclusion

## Quality Gates

- `Impact Matrix` exists
- `Affected Objects` exists
- `Risk Analysis` exists or is marked `NOT FOUND IN DOCUMENT`

## Output Rules

- Use `IMP-xxx` identifiers when a stable trace ID is needed.
- Do not estimate, design, code, or test here.
- If hard evidence is missing, use `INSUFFICIENT EVIDENCE`.
