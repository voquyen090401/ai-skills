---
name: estimation
description: Use this skill when the user wants task breakdown, WBS creation, estimation preparation, complexity classification, ERP work decomposition, or ERP man-day estimation. It covers Big/Medium/Small task breakdown, type and complexity classification, and BE/FE/UT effort estimation from documentary evidence.
---

# Estimation

# GOVERNANCE COMPLIANCE

This skill must comply with the ERP Skill Governance Framework.

Rules:
- Do not guess.
- Do not invent requirement.
- Do not invent business rule.
- Use evidence from Requirement, QA, Design, Source, DB, API, CSV, Batch, Flow, Screen Definition.
- If evidence is missing, write `NOT FOUND IN DOCUMENT`.
- If evidence is not enough to estimate effort, write `NOT ESTIMATED`.
- If prerequisite input is missing, write `INSUFFICIENT EVIDENCE`.
- Keep traceability with previous skill outputs.
- Output must be compatible with the next skill in the ERP Delivery Pipeline.

Create task breakdowns and effort estimates only from documentary evidence.

## Inputs

- Requirement Summary
- Impact Matrix
- Affected Objects

## Outputs

```md
## Task Breakdown

| ProgramID | 機能区分 | 機能名 | Big | Medium | Small | Note | Type | Complexity | BE | FE | UT |
```

## Dependencies

- `business-analysis`
- `impact-analysis`

## Next Skill

`basic-design`

## Workflow

1. Read requirement summary and impact matrix first.
2. Extract only supported tasks.
3. Build Big at business-processing level.
4. Choose Medium from the standard processing objective of that Big.
5. Put validation, API, mapping, loading, message, and normal error handling into Small instead of splitting them into separate Medium items.
6. Write Small as a short processing sentence that starts with an action verb.
7. Assign Type and Complexity.
8. Estimate `BE`, `FE`, and `UT` from the actual changed objects.
9. Remove micro technical splitting and merge overlapping Medium or Small items inside the same Big.

## Stop Conditions

- no requirement summary
- no impact matrix
- evidence is too weak for task grouping

## Quality Gates

- Big, Medium, and Small exist
- Type and Complexity exist
- BE, FE, and UT exist on every row
- Medium is not split by API call, validation step, mapping step, loading step, or message handling
- Small starts with a processing verb and stays at business-feature level
- initialization data loading is grouped into `Khoi tao man hinh` or `Khoi tao du lieu`
- effort cells contain only numeric values or `NOT ESTIMATED`

## Rules

- Break tasks by screen behavior and business processing objective.
- Do not break tasks by field, component, function, API call, loading step, mapping step, validation step, message step, or normal error step.
- `Medium` must be a short, clear, non-overlapping processing objective inside one `Big`.
- `Small` must be a short, clear processing sentence inside one `Medium`.
- `Small` must start with an action verb and directly describe the processed data or function.
- Prefer the structure `Thuc hien + noi dung xu ly + doi tuong`.
- Do not create separate Medium for validate, API call, request mapping, response mapping, loading, message, normal error handling, individual master load, individual dropdown load, individual function, or technical event.
- Do not split `Small` by API call, field, function, mapping step, loading step, message, or technical event.
- Do not list code-level detail inside `Small` such as API names, request-response mapping, state update, event handler, or message text.
- All automatic data loading when opening a screen belongs to:
  - `Khoi tao man hinh` for list/search/create screens
  - `Khoi tao du lieu` for detail/update/delete screens
- Use standard Medium names when the evidence matches them, for example:
  - list screen: `Khoi tao man hinh`, `Thuc hien lay danh sach va hien thi du lieu`, `Thuc hien export CSV`
  - create screen: `Khoi tao man hinh`, `Thuc hien them moi du lieu`
  - update screen: `Khoi tao du lieu`, `Thuc hien cap nhat du lieu`
  - delete screen: `Khoi tao du lieu`, `Thuc hien xoa du lieu`
  - popup: `Khoi tao popup`, `Thuc hien lay va hien thi du lieu`, `Thuc hien xac nhan du lieu`
  - import CSV: `Khoi tao man hinh`, `Thuc hien import CSV`, `Hien thi ket qua import`
  - batch: `Khoi tao xu ly batch`, `Thuc hien xu ly batch`, `Ghi nhan ket qua xu ly`
- Remove unsupported standard Medium if the document has no evidence for it.
- Merge Medium items that share the same processing objective inside one Big.
- Merge Small items that still serve the same processing objective inside one Medium.
- Put technical detail into the scope of `Small` without spelling out technical steps.
- `BE` is effort for backend changes such as API, server business logic, DB, transaction, batch, interface, CSV server processing, or response data changes.
- `FE` is effort for frontend changes such as screen initialization, display, input form, client validation, popup, button action, state control, request sending, or result display.
- `UT` is effort for unit test preparation, execution, bug fixing in UT, and retest of the same task.
- Do not infer `BE` or `FE` from the Medium name alone; use the actual impacted objects.
- `Khoi tao man hinh` and `Khoi tao du lieu` can still have `BE > 0` when API creation or API change is required.
- For `Thuc hien export CSV`, default to `BE > 0`, `FE = 0`, `UT > 0` unless the evidence shows frontend changes.
- Effort cells must contain only numeric values such as `0`, `0.25`, `0.5`, `0.75`, `1`, `1.5`, `2`, or `NOT ESTIMATED`.
- Do not convert `Complexity` into effort without explicit evidence-based sizing judgment.
- Use `TASK-xxx` identifiers when a stable trace ID is needed.
