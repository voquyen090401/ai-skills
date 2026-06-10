---
name: tsc-generation
description: Generate final ERP technical specification artifacts from requirement, impact, design, implementation summary, QA, and code-review outputs. Use when Codex must produce traceable technical documentation from requirement through code and test evidence, including screen, API, DB, CSV, batch, mail, authority, and release notes, without guessing.
---

# TSC Generation

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

Generate final technical specification, not raw analysis notes.

## Inputs

- Requirement
- Impact
- Design
- Implementation Summary
- QA
- Code Review

## Outputs

```md
## Technical Specification

## Functional Overview

## Processing Detail

## Screen Detail

## API Detail

## DB Detail

## CSV Detail

## Batch Detail

## Mail Detail

## Authority Detail

## Error Handling

## Traceability Matrix

## Release Notes
```

## Dependencies

- design, implementation, QA, and review evidence

## Workflow

1. Consolidate requirement, impact, design, implementation, QA, and review outputs.
2. Build the technical specification in release-ready structure.
3. Preserve traceability from requirement to code and test.
4. Mark unsupported details explicitly.

## Stop Conditions

- missing source, design, or QA evidence
- traceability cannot be completed safely

## Quality Gates

- technical specification structure exists
- traceability matrix exists
- release notes exists

## Rules

- Use `TSC-xxx` identifiers when a stable trace ID is needed.
- Do not silently fill missing technical detail.
