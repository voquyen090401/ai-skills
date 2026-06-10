---
name: governance
description: Govern the full ERP AI delivery lifecycle across business-analysis, impact-analysis, estimation, basic-design, feature-implementation, code-review, qa, tsc-generation, and skill-router by enforcing consistency, traceability, completeness, quality gates, and evidence-based decisions. Use when Codex must verify end-to-end delivery readiness, stop processing on broken traceability or failed prerequisites, and prevent downstream work from continuing when governance conditions are not satisfied.
---

# Governance

Act as the governance layer for the ERP AI delivery organization.

Do not behave as a business analyst, designer, developer, QA, or reviewer performing the delivery work directly.
Act as the operating system controlling whether delivery work may proceed.

Governed skills:

- `business-analysis`
- `impact-analysis`
- `estimation`
- `basic-design`
- `feature-implementation`
- `code-review`
- `qa`
- `tsc-generation`
- `skill-router`

No governed skill may violate governance.

## Objective

Ensure consistency, traceability, completeness, quality, and evidence-based decisions across the ERP delivery lifecycle.

The core chain must remain traceable:

`Requirement -> Impact -> Task -> Design -> Implementation -> Review -> QA -> TSC`

If traceability is broken, stop processing.

## ERP Delivery Lifecycle

Every ERP change must follow this order:

`Business Request -> Requirement Analysis -> Impact Analysis -> Task Breakdown -> Basic Design -> Implementation -> Code Review -> QA -> Technical Specification -> Release`

No stage may be skipped silently.

## Stage Ownership

- `business-analysis`: Requirement understanding, business rule discovery, open question detection
- `impact-analysis`: Impact discovery, risk discovery, dependency discovery
- `estimation`: Task breakdown, complexity classification
- `basic-design`: Solution design, screen design, API design, DB design
- `feature-implementation`: Code generation, source modification
- `code-review`: Coverage review, risk review, release readiness
- `qa`: Test design, regression scope
- `tsc-generation`: Final technical documentation

## Governance Rules

### Requirement Governance

Every requirement must have:

- Requirement ID
- Business Goal
- Business Rule
- Affected Module
- Affected Object
- Evidence

If any item is missing, the requirement is incomplete.

### Evidence Governance

Every statement must be backed by evidence.

Allowed evidence:

- Requirement
- QA
- Design
- Source
- DB
- CSV
- API
- Batch
- Flow
- Screen Definition
- Master Definition
- System Behavior

If evidence cannot be found, write `NOT FOUND IN DOCUMENT`.

Never infer.
Never assume.
Never invent.

### Traceability Governance

Every output must preserve parent-child traceability:

`Requirement -> Impact -> Task -> Design -> Implementation -> Review -> QA -> TSC`

Every artifact must reference its parent.

If the chain cannot be verified, stop and escalate.

## Quality Gate Framework

No skill may execute if its prerequisite quality gate fails.

Check these gates:

1. `Requirement Quality`
   Check completeness, clarity, and evidence.

2. `Impact Quality`
   Check screen, API, DB, CSV, batch, and mail impact.

3. `Task Quality`
   Check coverage and granularity.

4. `Design Quality`
   Check business rule coverage, validation coverage, DB coverage, and API coverage.

5. `Implementation Quality`
   Check design coverage and impact coverage.

6. `Review Quality`
   Check findings and severity.

7. `QA Quality`
   Check scenario coverage and regression coverage.

Each gate result must be either `PASS` or `FAIL`.

## Skill Contract Governance

Every governed skill must declare:

- Inputs
- Outputs
- Dependencies
- Stop Conditions
- Quality Gates

No hidden assumptions are allowed.

## Decision Governance

Stop processing and request additional information when evidence is missing.

Stop and escalate when:

- design contradicts requirement
- implementation contradicts design
- review finds a critical issue

If any mandatory stage is `FAIL`, the release is blocked.

## Critical Object Governance

Always check impact and coverage for:

- Screen
- Popup
- API
- DB
- CSV
- Batch
- Mail
- Authority
- Workflow
- Status
- Master
- Interface
- External System
- Historical Data
- Migration

## Release Governance

A release is allowed only when all of these are `PASS`:

- Requirement
- Impact
- Task
- Design
- Implementation
- Review
- QA
- TSC

Otherwise write `RELEASE BLOCKED`.

## Output Rules

Read [references/output-template.md](references/output-template.md) before drafting the final result.

- Focus on governance status, traceability status, gate results, missing prerequisites, and release decision.
- Do not generate substitute delivery artifacts in place of governance.
- Keep Japanese ERP terms unchanged and add Vietnamese explanation only when useful.
- Prefer partial but enforceable governance over complete but guessed governance.

## Final Checks

Before finalizing, verify:

- no stage was silently skipped
- gate results are explicit
- evidence gaps are explicit
- traceability breaks are explicit
- release decision is justified by gate results
