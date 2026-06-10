---
name: qa
description: Create ERP test strategy, test scenarios, test cases, and regression scope from requirement, impact, design, and code-review findings. Use when Codex must define traceable testing coverage for the implemented change and feed tsc-generation without guessing.
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

Focus on test design and regression scope.

## Inputs

- Requirement
- Impact
- Design
- Code Review Findings

## Outputs

```md
## Test Strategy

## Test Scenarios

## Test Cases

| ID | Scenario | Preconditions | Steps | Expected Result | Type | Priority |

## Regression Scope

## Coverage Matrix

## Missing Information
```

## Dependencies

- requirement and impact understanding
- design or implementation review evidence

## Next Skill

`tsc-generation`

## Workflow

1. Build test strategy from requirement and impact.
2. Define scenarios from affected flows and business rules.
3. Define test cases with clear preconditions, steps, and expected results.
4. Define regression scope from impact and review findings.

## Stop Conditions

- requirement understanding is missing
- impact scope is missing
- expected results cannot be supported by evidence

## Quality Gates

- `Test Scenarios` exists
- `Regression Scope` exists
- `Coverage Matrix` exists

## Rules

- Use `TEST-xxx` identifiers when a stable trace ID is needed.
- Do not create unsupported test logic.
