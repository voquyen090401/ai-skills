# Output Template

Use this section order in the final result:

1. `Change Summary`
2. `Change Classification`
3. `Upstream Analysis`
4. `Current Analysis`
5. `Downstream Analysis`
6. `CRUD Impact`
7. `Status Impact`
8. `DB Impact`
9. `API Impact`
10. `CSV Impact`
11. `Batch Impact`
12. `Mail Impact`
13. `Authority Impact`
14. `Existing Data Impact`
15. `Risk Analysis`
16. `Impact Matrix`
17. `Feed For Estimation`
18. `Feed For Basic Design`
19. `Feed For Feature Implementation`
20. `Feed For QA`
21. `Missing Information`
22. `Final Conclusion`

Use these table patterns when applicable:

## Upstream Analysis

| Object | Source | Evidence |
| ------ | ------ | -------- |

## Downstream Analysis

| Object | Destination | Evidence |
| ------ | ----------- | -------- |

## CRUD Impact

| Operation | Impact | Evidence |
| --------- | ------ | -------- |

## Status Impact

| Item | Impact | Evidence |
| ---- | ------ | -------- |

## DB Impact

| Object | Impact | Risk |
| ------ | ------ | ---- |

## Authority Impact

| Authority | Impact | Evidence |
| --------- | ------ | -------- |

## Mail Impact

| Mail Object | Impact | Evidence |
| ----------- | ------ | -------- |

## CSV Impact

| CSV | Impact | Evidence |
| --- | ------ | -------- |

## Batch Impact

| Batch | Impact | Evidence |
| ----- | ------ | -------- |

## Risk Analysis

| Risk | Level | Description |
| ---- | ----- | ----------- |

## Impact Matrix

| Category | Object | Impact Type | Evidence |
| -------- | ------ | ----------- | -------- |

Allowed `Impact Type` values:

- `Add`
- `Modify`
- `Delete`
- `No Impact`
- `Need Investigation`

If requirement, design, source, flow, or DB definition are insufficient, write this clearly in `Missing Information` and `Final Conclusion`:

```text
INSUFFICIENT EVIDENCE

Additional investigation required.
```
