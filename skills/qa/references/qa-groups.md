# QA Groups

Use these groups when writing or regenerating BrSE investigation QA.
Pick the smallest group that best matches the business gap.

## 1. impact_investigation

Use when an item is added, removed, or changed and you need to investigate affected screens, CSV, batch, table, search condition, report, or downstream module.

## 2. scope_keep

Use when some screens are listed in scope files but are not described in the target sheet, and you need to confirm they remain unchanged.

## 3. version_conflict

Use when old and new materials conflict and you need the customer to confirm which version is correct.

## 4. search_item

Use when a search input is added or changed and you need to confirm placement, UI type, choices, AND/OR logic, or grouping.

## 5. workflow_gap

Use when a screen or business step is removed, merged, or changed and the replacement flow is not fully described.

## 6. import_csv

Use when CSV import behavior is unclear, including template, encoding, rollback policy, update logic, error handling, or permission.

## 7. csv_output

Use when CSV output columns, header, source table, mapping, sort order, or compatibility behavior are unclear.

## 8. display_label

Use when label conversion, icon/text choice, color, tooltip, or display priority is unclear.

## 9. notification

Use when email or system notification behavior is unclear, including recipients, To/Cc, template, timing, and failure handling.

## 10. mapping

Use when item names differ across screen, DB, CSV, API, or add-item sheets and you need to confirm the correct mapping.

## 11. permission

Use when the behavior depends on role, department, button authority, override rules, or visibility by user type.

## 12. master_data

Use when dropdown or input values depend on master data and you need to confirm the source master, inactive handling, or parent-child relation.

## 13. multi_rule

Use when multiple rules overlap and you need to confirm the priority or conflict resolution.

## 14. batch

Use when batch timing, snapshot timing, rerun behavior, log output, or integration with manual operations is unclear.

## 15. api

Use when API timing, retry, timeout, callback, idempotency, or interface behavior is unclear.

## 16. database

Use when table/column reuse, null handling, history retention, or migration/backfill behavior is unclear.

## 17. exception_case

Use when rollback, duplicate, concurrent update, downstream mismatch, invalid data, or other abnormal cases are unclear.
