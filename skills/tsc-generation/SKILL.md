---
name: tsc-generation
description: Use this skill when the user wants a Technical Specification Document (TSC) generated from requirement, design, source code, QA, UI, API, DB, CSV, batch, or implementation artifacts. It covers Technical Specification, Technical Design Document, Technical Sheet, Traceability Matrix, Functional Documentation, and System Documentation. Do not use it to generate code or estimate effort.
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
