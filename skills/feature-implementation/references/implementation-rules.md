# Implementation Rules

Apply these rules as mandatory constraints.

## Evidence Rules

- Do not guess.
- Do not infer unsupported business logic.
- Do not add new business rules, fields, validations, APIs, tables, permissions, error messages, reports, notifications, or batches unless evidence exists.
- Use only Requirement, QA, Basic Design, and current Source Code as the basis for change decisions.
- If a required business or design fact cannot be found, write `NOT FOUND IN REQUIREMENT`.
- If a required implementation fact cannot be found in the codebase, write `NOT FOUND IN SOURCE`.

## Mandatory Investigation Scope

Before coding, investigate all relevant layers that can be affected:

- Screen
- Route
- API
- Controller
- Service
- Repository
- Database
- DTO or request or response model
- CSV import or export
- Batch or scheduler
- Report or print
- Notification, queue, or mail
- Permission, role, authority, and menu

## Mandatory Reuse Search

Find and evaluate these existing assets before designing new ones:

- Similar screen
- Similar API
- Similar service
- Similar validation
- Similar frontend component
- Similar batch
- Similar CSV logic
- Similar permission rule
- Similar error message

## Mandatory Design Coverage

When evidence exists, the technical design must cover:

- Business flow
- Screen design
- API design
- Database design
- Validation design
- Transaction design
- Error handling design
- Permission design
- CSV design
- Batch design
- Migration design

If an area has no impact, say so explicitly instead of ignoring it.

## Implementation Principles

- Prefer extending current architecture over adding parallel logic.
- Keep backend, frontend, and database changes aligned to the same evidence set.
- Keep naming and coding patterns consistent with the current source code.
- Treat source code as implementation evidence, not automatically as the business source of truth, unless the user says otherwise.
- Do not claim completion if analysis, impact review, or self-review remains incomplete.
