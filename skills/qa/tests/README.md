# Tests

## Files

- `fixtures.json`
  Structured test input plus lightweight expectations such as `must_contain` and `must_not_contain`.

- `snapshots.json`
  Exact QA snapshots for regression comparison.

## Commands

```powershell
# Run tests
./skills/qa/scripts/run_qa_skill_tests.ps1

# Update snapshots intentionally
./skills/qa/scripts/update_qa_snapshots.ps1 -ConfirmUpdate
```

## Rules

- Running tests must not update snapshots.
- Snapshot changes should be reviewed before calling the update script.
