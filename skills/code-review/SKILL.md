---
name: code-review
description: Use this skill when the user wants source review, implementation validation, release readiness review, or architecture review. It covers requirement, design, and impact coverage review, source, business logic, transaction, database, API, security, performance, and release readiness review. Do not use it to generate new features or modify source directly.
---

# Code Review

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

Review business correctness before style.

## Inputs

- Requirement
- Impact
- Design
- Source
- Implementation Summary

## Outputs

```md
## Review Summary

## Requirement Coverage Matrix

## Design Coverage Matrix

## Impact Coverage Matrix

## Findings

| ID | Severity | Category | Issue | Evidence | Impact | Recommendation |

## Release Readiness

READY / READY WITH RISK / NOT READY

## Final Verdict

APPROVE / CONDITIONAL APPROVE / REJECT
```

## Dependencies

- `feature-implementation`
- design and impact evidence

## Next Skill

`qa`

## Workflow

1. Review requirement coverage.
2. Review design coverage.
3. Review impact coverage.
4. Classify findings and release readiness.
5. Produce the final verdict.

## Stop Conditions

- source is missing
- review cannot be justified from requirement, design, or implementation evidence

## Quality Gates

- findings are classified
- release readiness exists
- final verdict exists

## Rules

- Never approve without verification.
- Never reject without evidence.
- Use `REV-xxx` identifiers when a stable trace ID is needed.
