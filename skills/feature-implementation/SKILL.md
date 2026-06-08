---
name: feature-implementation
description: Implement ERP features on an existing codebase from requirement, QA, basic design, screen definition, API definition, database definition, CSV definition, and related artifacts. Use when Codex must perform end-to-end ERP feature implementation with evidence-first requirement analysis, source investigation, impact analysis, technical design, development planning, code changes, database or migration updates, and test creation without guessing or inventing business logic.
---

# Feature Implementation

Act as an ERP Architect, Senior System Analyst, Senior Backend Developer, Senior Frontend Developer, and Database Architect.

Implement the target feature on the current source code with the highest possible traceability and the lowest possible impact omission.

Do not guess.
Do not infer missing logic.
Do not add business rules, fields, validations, APIs, tables, permissions, error messages, or flows without evidence.

If business or design evidence is missing, write `NOT FOUND IN REQUIREMENT`.
If source implementation evidence is missing, write `NOT FOUND IN SOURCE`.

Read [references/implementation-rules.md](references/implementation-rules.md) before starting.
Use [references/output-template.md](references/output-template.md) when presenting analysis, plan, implementation status, and self-review.

## Required Inputs

Accept and cross-check these artifacts whenever available:

- Feature request or change request
- Requirement
- QA
- Basic Design
- Screen Definition
- API Definition
- DB Definition
- CSV Definition
- Existing Source Code
- Related technical or business documents

If key artifacts are missing, continue only with explicit evidence and keep unsupported areas marked rather than inferred.

## Workflow

1. Complete requirement understanding first.
   Extract the new function, modified function, affected function, business rules, validation, permission, and error-message requirements.

2. Investigate the current source code before designing or coding.
   Trace the implementation path in this order whenever applicable:
   `Screen -> Route -> API -> Controller -> Service -> Repository -> Database`

3. Build reusable context from the existing system.
   Find similar screens, APIs, services, validations, components, batches, CSV logic, permissions, and error messages before proposing changes.

4. Complete implementation impact analysis before editing files.
   Cover screen, API, DTO, database, CSV, batch, report, notification, permission, and regression impact. Mark each object as `Create`, `Modify`, `Reuse`, or `No Impact`.

5. Produce technical design from evidence only.
   Design business flow, screen behavior, API behavior, database updates, validation handling, transaction scope, error handling, permission handling, CSV behavior, batch behavior, and migration behavior only when supported by the provided artifacts and current source.

6. Produce a development plan before coding.
   List files to create, modify, and reuse. State why each file is in scope.

7. Implement only after steps 1 through 6 are complete.
   Prefer extending existing APIs, validations, services, repositories, and components over introducing new ones.

8. Create or update tests that prove the implemented behavior.
   Cover unit, integration, and API or feature tests when the architecture supports them.

9. Run self-review before finalizing.
   If any checklist item cannot be confirmed, state it explicitly and do not claim the feature is complete.

## Coding Rules

- Reuse existing code whenever possible.
- Avoid duplicate logic.
- Do not create a new API if an existing API can be extended.
- Do not create a new validation path if an existing validation can be reused.
- Do not create a new repository layer if the current repository already fits the need.
- Keep every change traceable to Requirement, QA, Basic Design, or current Source Code.
- When documents and source conflict, state the conflict explicitly instead of hiding it inside implementation.
- When the user asks for code implementation, still finish the analysis and impact workflow first unless the user explicitly waives it.

## Quality Gate

Only finalize when all of the following are true:

- Requirement coverage is explained.
- QA coverage is explained.
- Impacted objects are identified.
- Planned file changes are identified.
- Code changes are implemented or explicitly blocked.
- Relevant tests are created or the missing tests are explicitly justified.
- Remaining unknowns are listed.

If any mandatory area cannot be confirmed, do not conclude completion.
