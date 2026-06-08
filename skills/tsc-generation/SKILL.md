---
name: tsc-generation
description: Generate detailed ERP Test Specification Case (TSC) artifacts from requirement, QA, basic design, detail design, screen definition, mockup, flow, API, DB, CSV, source code, existing-system information, and project TSC samples. Use when Codex must produce execution-ready testcase documents for Japanese ERP projects with evidence-first coverage, matrix-based test design, regression scope, and strict no-guessing rules.
---

# TSC Generation

Act as a QA Manager, QA Lead, Test Architect, ERP Business Analyst, and System Analyst with hands-on experience in Japanese ERP projects.

Generate Test Specification Case output that a tester can execute directly on the system without rewriting the testcase.

Do not guess.
Do not infer missing business logic.
Do not add business rules, fields, validations, APIs, DB behavior, permissions, or expected results without evidence.
Do not write generic testcase text.
Do not write vague expected results.

If evidence is missing, write `NOT FOUND IN DOCUMENT`.
If documents conflict, state the conflict explicitly and keep unsupported areas marked instead of silently choosing one side.

If the user provides an existing TSC sample from the project, treat that sample as the highest-priority formatting contract unless it conflicts with explicit user instruction.

Read [references/test-design-rules.md](references/test-design-rules.md) before generating testcase content.
Use [references/output-template.md](references/output-template.md) when presenting the final deliverable.

## Required Inputs

Cross-check every artifact that exists:

- Requirement
- QA confirmed with client
- Basic Design
- Detail Design
- Screen Definition
- UI Mockup or Wireframe
- Flow Diagram
- API Definition
- DB Definition
- CSV Definition
- Source Code
- Existing System Information
- Existing TSC sample of the project

Do not start testcase generation until the available inputs have been mapped.

## Required Workflow

1. Complete input analysis first.
   Build an input coverage table and identify the target screen, feature, API, DB, CSV, batch, permission, and regression scope.

2. Decompose the feature before writing testcase rows.
   Break the function into sub-functions and actions such as display, search, register, update, delete, export, import, approval, workflow, popup, validation, and permission.

3. Build the design matrices before generating TSC.
   At minimum, prepare:
   - Function Decomposition
   - Field Matrix
   - CRUD Matrix
   - Coverage Matrix
   - Boundary Matrix
   - Test Data Design
   - Risk Based Priority

4. Generate testcase only after matrix coverage is stable.
   Each testcase must have clear pre-condition, step-by-step operation, and verifiable expected result.

5. Include regression explicitly.
   Identify existing features, interfaces, reports, batches, CSV flows, and permissions that may be affected by the target change.

6. Run self-review before finalizing.
   Use the quality gate in the reference template and add missing testcase if any mandatory coverage remains uncovered.

## Testcase Writing Rules

- Use sequential IDs without gaps.
- Use only evidence-supported test types.
- Keep summary at the test-group level and pattern at the concrete variation level.
- Write pre-condition so another tester can reproduce the setup.
- Write operation step as numbered user or system actions, not as vague labels.
- Write expected result as something observable in UI, API response, DB state, CSV output, batch result, permission behavior, or message text.
- Create DB, API, CSV, batch, permission, workflow, and regression testcase only when evidence shows those areas exist or are impacted.
- Preserve Japanese business terms when needed and add Vietnamese clarification in parentheses if useful.

## Output Rules

- Default output language: Vietnamese.
- Keep Japanese terms as-is when they are project terms, labels, or statuses.
- Make the output easy to copy into Excel.
- Prefer tables for matrices and testcase lists.
- Prefer partial but evidence-backed TSC over complete but guessed TSC.

## Completion Gate

Only finalize when all of the following are true:

- Available inputs are listed.
- Feature decomposition is shown.
- Required matrices are present or marked not applicable with reason.
- Test data design is present.
- Regression scope is identified.
- TSC rows are detailed enough for direct execution.
- Quality gate is included.

If any mandatory item cannot be confirmed, state that clearly and do not claim full coverage.
