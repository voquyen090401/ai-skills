---
name: feature-implementation
description: Use this skill when the user wants coding, implementation, source generation, source modification, bug fixing, or ERP feature development. It covers code generation, feature, API, screen, DB, and batch implementation, bug fixing, refactoring, and source modification. Use it only when requirement exists and design should exist. Do not use it to analyze requirement from scratch, create QA, or create TSC.
---

# Feature Implementation

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

Implement only from approved design and current source evidence.

## Inputs

- Basic Design
- Traceability Matrix
- Source Code
- Existing Pattern

## Outputs

```md
## Implementation Summary

## Modified Files

## Added Files

## Deleted Files

## Implemented Scope

## Not Implemented Scope

## Known Limitations

## Impact Coverage

## How To Test

## Missing Information
```

## Dependencies

- `basic-design`
- current source code

## Next Skill

`code-review`

## Workflow

1. Confirm implementation scope from design and traceability.
2. Reuse existing patterns before editing.
3. Implement only supported logic.
4. Record modified, added, and deleted files.
5. Explain implemented and not implemented scope.

## Stop Conditions

- no usable design
- no source context
- design contradicts requirement or impact with no resolution

## Quality Gates

- `Modified Files` exists
- `Implemented Scope` exists
- `Impact Coverage` exists

## Rules

- Do not code outside design.
- Do not invent logic.
- Keep current coding pattern.
- Use `CODE-xxx` identifiers when a stable trace ID is needed.
