---
name: basic-design
description: Create or update MA-style Basic Design Excel workbooks for Japanese core-system or ERP functions from requirements, BRD, screen mockups, CSV definitions, API notes, or SQL notes. Use when Codex must generate a review-ready `.xlsx` that matches Japanese enterprise Basic Design workbook conventions, using orientation notes as the primary style contract and optional attached sample files as secondary references, while marking unsupported details with explicit `TODO` or `未確定` notes.
---

# Basic Design

Prefer `spreadsheets:Spreadsheets` to create or edit the final `.xlsx`.

Treat [references/source-workbooks.md](references/source-workbooks.md) as the primary style contract for workbook composition, sheet ordering, naming, metadata headers, and document granularity. Do not depend on any machine-specific folder or private absolute path.

Read [references/generation-prompt-template.md](references/generation-prompt-template.md) when you need a reusable invocation template.

If sample `.xlsx` files are explicitly attached or added to the repo, use them only as secondary references to refine layout or sheet composition. Run `scripts/inspect-ma-xlsx.ps1 -Path <workbook.xlsx>` when you need to confirm sheet order, sheet names, or top-row structure from an attached `.xlsx` file without Excel.

## Workflow

1. Read the new feature inputs first.
   Inputs may include requirement text, BRD, flow, screen mockups, CSV layout, API notes, SQL notes, or pasted metadata.

2. Establish the style baseline before writing.
   Use `references/source-workbooks.md` first.
   If sample workbooks are attached explicitly, inspect the closest `.xlsx` examples next.
   Use old revisions only when you need historical comparison or numbering rationale.

3. Choose the workbook scope from the requirement.
   Name the output file `{feature_id}_{feature_name}.xlsx`.
   Keep only the sheets that are truly needed for the feature.
   Reuse the MA Japanese sheet naming conventions exactly.
   If the feature has multiple screens or multiple layout blocks, number sheets like `画面レイアウト定義書1`, `画面レイアウト定義書2`.
   If the feature has major SQL statements, create one `SQL定義書` sheet per `SQLID`.

4. Reproduce the MA document frame.
   Put base metadata in `変更履歴`.
   Keep the same header style across all sheets as the orientation notes or closest attached sample indicate.
   Carry the same workbook-level identifiers consistently across sheets:
   - `システム名`
   - `業務名` when present in the chosen pattern
   - `ドキュメント名`
   - `機能名`
   - `機能ID`
   - `作成日`
   - `修正日`
   - `作成者`
   - `修正者`

5. Build sheet content to MA detail level.
   Write enough content for dev and BA review, not an empty shell.
   Copy the structure and granularity of the style contract, not just the sheet titles.
   If a required detail is missing from the input, write `TODO`, `要確認`, or `未確定` at the exact missing point and state what is missing.

6. Resolve conflicts carefully.
   If the input conflicts with the sample workbook, prioritize the new business input and note the discrepancy clearly in the relevant sheet.
   Do not invent business rules, states, search conditions, or downstream effects without evidence.

7. Self-review before handing off.
   Confirm there are no blank leftover sheets, no stray copied business text, and no style drift that makes the workbook look unlike the MA family.

8. Keep the workflow portable.
   Do not require any private path, desktop folder, or machine-local workbook directory.
   Make the skill usable from a GitHub repository with only requirement inputs, orientation notes, and optionally attached samples.

## Sheet Selection Guide

Always consider these core sheets first:
- `変更履歴`
- `画面遷移図`
- `外部仕様書`
- `画面項目定義書`
- `メッセージ定義書`

Add these only when the feature requires them:
- `画面レイアウト定義書`, `画面レイアウト定義書1`, `画面レイアウト定義書2`
- `処理概要`, `処理概要1`
- `帳票レイアウト定義書`
- `帳票項目定義書`
- `出力項目定義書`, `出力項目定義書1`, `出力項目定義書2`
- `SQLID` sheets such as `MA10200201`
- `【別紙】...`
- `【参考】...`

Do not carry over old or reference sheets from a source workbook unless they are truly needed for the new feature.

## Minimum Content Rules By Sheet Type

`外部仕様書`
- Cover `概要`, `前提条件`, main processing flow or `処理概要`, input and output conditions, business constraints, important exception cases, and cross-module impact.

`画面レイアウト定義書`
- Describe the screen in MA style.
- Separate search area, result area, detail area, and buttons.
- State enable, disable, readonly, or visibility rules when known.

`画面項目定義書`
- Follow the closest sample's visual table.
- At minimum cover fields equivalent to `No.`, `項目名`, `種類`, `データ型`, `桁数`, `入出力`, `入力`, `入力範囲`, `必須`, `ソート`, `初期値`, `編集可否`, `備考`.
- Keep any extra useful columns from the closest sample.

`メッセージ定義書`
- At minimum cover `No.`, `分類`, `メッセージコード`, `メッセージ`, `パラメータ`, `表示条件`.
- Split guide, confirmation, warning, and error messages realistically.

`処理概要`
- Describe each major step, validations, searches, register or update or delete actions, SQL or API calls, table updates, result messages, exceptions, and retry or rollback behavior when relevant.

`出力項目定義書` or `帳票項目定義書`
- At minimum cover `No.`, `項目名`, `項目ID`, `データ型`, `桁数`, `入力` or `出力`, `入力範囲`, `初期値`, `備考`.

`SQL定義書`
- At minimum cover `SQLID`, `概要`, `取得データ件数制限`, calling screen or process, tables used, search and join conditions, sort order, update target when applicable, and related business notes.

## Missing-Information Rules

Do not leave silent blanks for unresolved logic.

Mark unknowns with `TODO`, `要確認`, or `未確定` and make each note actionable. Good notes are specific, for example:
- missing search default value
- missing AND or OR condition
- missing over-limit behavior
- missing duplicate handling
- missing lock or concurrency rule
- missing audit fields or history update rule
- missing downstream CSV, batch, report, or API impact

Avoid vague notes like "confirm logic".

## Final Checks

Before finishing, verify:
- business rules are not invented
- state and transition gaps are marked
- search defaults, sort, pagination, and AND or OR conditions are covered or marked
- code list and master sources are identified or marked
- zero-result, over-limit, duplicate, invalid-status, and permission messages exist where needed
- concurrent update risk is covered when multiple users can act at once
- audit and data consistency concerns are covered when updating multiple tables
- the workbook still looks like an MA document family member
