# Output Template

Present the review in this order:

1. `Findings`
2. `Open Questions Or Missing Evidence`
3. `Requirement Coverage Matrix`
4. `Impact Coverage Matrix`
5. `Release Readiness Assessment`
6. `Top 10 Predicted Production Risks`
7. `Final Verdict`

Use these structures when applicable:

## Findings

List findings ordered by severity.

Each finding should include:

- severity
- affected object
- evidence
- impact
- recommendation

## Requirement Coverage Matrix

| Requirement | Design | Source | Status |
| ----------- | ------ | ------ | ------ |

Allowed `Status` values:

- `PASS`
- `PARTIAL`
- `FAIL`

## Impact Coverage Matrix

| Object | Expected | Actual | Status |
| ------ | -------- | ------ | ------ |

## Release Readiness Assessment

Use exactly one:

- `READY`
- `READY WITH RISK`
- `NOT READY`

## Final Verdict

Use exactly one:

- `APPROVE`
- `CONDITIONAL APPROVE`
- `REJECT`

If the verdict is `REJECT`, include:

- evidence
- impact
- recommendation

If evidence is insufficient for a complete review, state that clearly under `Open Questions Or Missing Evidence`.
