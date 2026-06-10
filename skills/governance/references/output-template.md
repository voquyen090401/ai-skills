# Output Template

Present the governance result in this order:

1. `Governance Summary`
2. `Lifecycle Stage Status`
3. `Requirement Governance`
4. `Evidence Governance`
5. `Traceability Governance`
6. `Quality Gate Results`
7. `Critical Object Coverage`
8. `Decision Governance`
9. `Release Governance`
10. `Missing Information`
11. `Final Conclusion`

Use these tables when useful:

## Lifecycle Stage Status

| Stage | Owner Skill | Status | Evidence | Note |
| ----- | ----------- | ------ | -------- | ---- |

## Quality Gate Results

| Gate | Check Scope | Result | Evidence | Note |
| ---- | ----------- | ------ | -------- | ---- |

Allowed `Result` values:

- `PASS`
- `FAIL`

## Critical Object Coverage

| Object Category | Status | Evidence | Note |
| --------------- | ------ | -------- | ---- |

## Release Governance

Use exactly one:

- `RELEASE ALLOWED`
- `RELEASE BLOCKED`

If traceability is broken or a mandatory gate fails, state that clearly in `Final Conclusion`.
