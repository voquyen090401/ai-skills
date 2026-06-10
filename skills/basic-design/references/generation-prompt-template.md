# Generation Prompt Template

Use this template when invoking the skill for a new feature.

```text
Use $basic-design to create a Japanese-style Basic Design workbook in `.xlsx` format.

Goal:
- Generate a review-ready Basic Design workbook that feels like the same family as the MA-style Japanese enterprise samples.
- Match workbook composition, sheet naming, sheet ordering, metadata header pattern, table structure, document granularity, and handoff completeness.
- Do not copy old business content.

Style contract:
- Use `references/source-workbooks.md` as the primary orientation source.
- If attached sample `.xlsx` files are available, use them only as secondary references.
- Do not depend on any local absolute path or machine-specific folder.

Output expectations:
- Create `{feature_id}_{feature_name}.xlsx`
- Prefer workbook-first output
- Keep Japanese sheet names
- Keep only needed sheets
- Mark unknowns explicitly with `TODO`, `要確認`, or `未確定`
- Do not silently invent unsupported business rules

Required input:
- feature ID: {feature_id}
- feature name: {feature_name}
- system name: {system_name}
- business area name: {business_area_name}
- author: {author}
- reviewer or modifier: {reviewer}
- created date: {created_date}
- revised date: {revised_date}
- requirement inputs: {requirements}

Optional input:
- screen mockups: {screen_mockups}
- CSV layout notes: {csv_notes}
- API notes: {api_notes}
- SQL notes: {sql_notes}
- attached sample workbooks: {sample_files}

Sheet-selection rules:
- Always consider `変更履歴`, `画面遷移図`, `外部仕様書`, `画面項目定義書`, `メッセージ定義書`
- Add `画面レイアウト定義書` or numbered variants when screens exist
- Add `処理概要` when process logic is important
- Add `帳票レイアウト定義書`, `帳票項目定義書`, `出力項目定義書` for output, CSV, import, or report functions
- Add one SQL sheet per SQL ID when SQL behavior matters
- Add `【別紙】...` or `【参考】...` only if needed for BA or dev handoff

Content rules:
- `外部仕様書`: overview, assumptions, processing summary, I/O expectations, business constraints, edge cases, downstream impact
- `画面レイアウト定義書`: search, result, detail, action areas; control behavior; scenario splits
- `画面項目定義書`: field definitions, data types, lengths, required flags, editability, defaults, notes
- `メッセージ定義書`: guide, confirmation, warning, error messages with display conditions
- `処理概要`: validation, search, register or update or delete, SQL or API calls, exception path, rollback or retry
- `SQL定義書`: SQLID, purpose, volume limit, usage context, table usage, conditions, sort, update target, business notes

Quality checklist:
- Cover business rules and state transitions
- Cover search defaults, sort, pagination, AND or OR conditions
- Cover master or code sources
- Cover downstream CSV, reports, APIs, batch, interfaces when relevant
- Cover zero-result, over-limit, duplicate, invalid-status, permission, and concurrency concerns
- Cover audit, history, and data consistency implications
- If information is missing, leave no silent blanks; mark the exact unresolved point
```
