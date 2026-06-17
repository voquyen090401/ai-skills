# References

## Source Of Truth

- `gold_dataset.jsonl`
  Runtime gold QA dataset used for examples, validation, and approved imports.

- `output-template.md`
  Source of truth for QA output shape, accepted formats, openings, closings, and good/bad examples.

- `qa-groups.md`
  Source of truth for QA category selection.

## Notes

- Backup files are not runtime inputs.
- Candidate or generated data should not be mixed into `gold_dataset.jsonl` until reviewed and imported intentionally.
