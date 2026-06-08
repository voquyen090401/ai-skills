# Source Workbook Notes

These notes are the portable orientation layer for the MA-style workbook family.

Use them as the primary reference when no sample workbooks are attached in the current run.
If sample `.xlsx` files are attached explicitly, use these notes first and then refine from the attached files.

## Observed Common Pattern

- The workbook usually starts with `変更履歴`, `画面遷移図`, and `外部仕様書`.
- Each major sheet repeats a common MA-style metadata header near the top.
- In the sampled workbooks, `システム名` is on the first row and `ドキュメント名` is on the second row, with the value placed several columns to the right.
- Table content begins only after the metadata block, not at row 1.
- The same workbook may contain numbered layout sheets, numbered output definition sheets, SQL sheets named by `SQLID`, and annex sheets prefixed with `【別紙】` or `【参考】`.

## Workbook Families Observed

The examples below describe workbook families that were previously inspected and distilled into this note. They are included as pattern references, not as runtime path dependencies.

### `MA1010_品番サブマスタ登録.xlsx`

- Broadest sample; useful for understanding a large MA workbook family.
- Contains:
  - `変更履歴`
  - `画面遷移図`
  - `外部仕様書`
  - `画面レイアウト定義書1`
  - `画面レイアウト定義書2`
  - `画面項目定義書_補足`
  - `画面項目定義書`
  - `帳票レイアウト定義書`
  - `帳票項目定義書`
  - `処理概要`
  - `メッセージ定義書`
  - several `【別紙】`, `【参考】`, and old or comparison sheets
- Use this sample for:
  - multi-layout screens
  - report sheets
  - supplement sheets
  - large workbook organization
- Do not blindly copy the many legacy and reference sheets into a new workbook.

### `MA1020_出図受付・計画.xlsx`

- Typical screen-plus-SQL sample.
- Contains:
  - `変更履歴`
  - `画面遷移図`
  - `外部仕様書`
  - `画面レイアウト定義書`
  - `画面レイアウト定義書2`
  - `画面項目定義書`
  - `【別紙】処理概要補足１`
  - `メッセージ定義書`
  - SQL sheets `MA10200201`, `MA10200301`, `MA10200302`, `MA10200501`
  - data or annex sheets `明細データ`, `週間実績データ`, `単価0明細データ`
- Use this sample when the new feature has search screens, result operations, and explicit SQL definitions.

### `MA1030_出図実績.xlsx`

- Strong sample for process-heavy screen behavior plus report and CSV output.
- Contains:
  - `変更履歴`
  - `画面遷移図`
  - `外部仕様書`
  - `画面レイアウト定義書`
  - `画面項目定義書`
  - `処理概要１`
  - several `【別紙】処理概要補足...`
  - `帳票レイアウト定義書`
  - `帳票項目定義書`
  - `メッセージ定義書`
  - many SQL sheets such as `MA10300201`, `MA10300301`
- Use this sample when the feature mixes screen operations, processing steps, report layouts, and multiple SQL calls.

### `MA1040_T-SCRUM対象品番判定.xlsx`

- Good sample for multiple related screens in one workbook.
- Contains:
  - `変更履歴`
  - `画面遷移図`
  - `外部仕様書`
  - `画面レイアウト定義書１`
  - `画面レイアウト定義書２`
  - `画面項目定義書`
  - `【別紙】処理概要補足１`
  - `【別紙】処理概要補足２`
  - `メッセージ定義書`
  - several reference sheets
- Use this sample when one feature bundles multiple closely related screens and decision logic.

### `Y0192_MA1070_品目サブマスタ一括変更.xlsx`

- Compact sample for bulk-update behavior.
- Contains:
  - `変更履歴`
  - `画面遷移図`
  - `外部仕様書`
  - `画面レイアウト定義書1`
  - `画面項目定義書`
  - `出力項目定義書`
  - `処理概要1`
  - `メッセージ定義書`
- Use this sample when the feature performs master bulk change and needs an output-item definition rather than report sheets.

### `Y0192_MA1070_品目サブマスタ出力＆取込.xlsx`

- Best sample for CSV export and import style work.
- Contains:
  - `変更履歴`
  - `画面遷移図`
  - `外部仕様書`
  - `画面レイアウト定義書`
  - `画面項目定義書`
  - `出力項目定義書1`
  - `出力項目定義書2`
  - `処理概要`
  - `補足）処理概要`
  - `メッセージ定義書`
- Use this sample when the feature has separate output and import phases.

## Specific Structure Hints

### `画面項目定義書`

- In the inspected files, the visible header starts with `No.` and `項目名`.
- A control-type column such as `種類` appears far to the right because the sheet uses a wide merged layout.
- Do not rebuild this sheet from plain text alone. Preserve the visual table pattern from the closest workbook.

### `メッセージ定義書`

- The sampled message sheets clearly separate categories such as `ガイド`, `確認`, `警告`, and `エラー`.
- Message codes may be shared common codes like `M00001` or screen-specific codes like `MA10.MA1030.E00001`.

### `出力項目定義書`

- The sampled output sheets usually start with `No.`, `項目名`, and `項目ID`.
- Some sheets include the target master or table identifier in the body, for example `TMS00090`.

### `SQLID` Sheets

- SQL definition sheets use `ドキュメント名 = SQL定義書`.
- The top block usually contains `SQLID`, `概要`, and `取得データ件数制限` before the SQL body.
- For SQL-heavy features, keep one main sheet per SQL identifier instead of mixing multiple SQL blocks in one sheet.

## Practical Selection Rules

- Prefer the closest business shape over the closest feature number.
- Use MA1020 or MA1030 when SQL definitions are required.
- Use MA1070 output/import when CSV layout and import processing dominate.
- Use MA1010 only for extended workbook composition patterns, not as a default source to copy all sheets from.
- Keep `【別紙】` and `【参考】` sheets only when they carry information the dev team truly needs.
