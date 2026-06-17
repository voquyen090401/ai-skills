# QA Groups

This file is the source of truth for QA category selection.

Pick the smallest category that matches the real business gap being confirmed.

Default style:

```text
business_understanding_confirm
```

Do not use `investigation_confirm` as a generic catch-all label.

## impact_investigation

Use:
- when the request is about affected scope, related screens, related outputs, or downstream impact already evidenced

Avoid:
- when the main uncertainty is only one field's display, mapping, or validation

Topic examples:
- impacted screens
- impacted CSV or report outputs
- downstream consumers

Evidence patterns:
- "ngoài màn hình A còn màn hình nào"
- "các chức năng đang tiêu thụ dữ liệu này"

Confirmation patterns:
- "ngoài ... còn ..."
- "có cần cập nhật thêm ... không"

## scope_keep

Use:
- when the main point is confirming that an object remains unchanged because no detailed change is described

Avoid:
- when the screen does have explicit new logic to clarify

Topic examples:
- KEEP scope
- out-of-scope confirmation

Evidence patterns:
- "KEEP"
- "không có detail spec"

Confirmation patterns:
- "có nằm ngoài phạm vi thay đổi không"
- "có thể treat là KEEP không"

## version_conflict

Use:
- when old and new materials conflict and the team must confirm which source is official

Avoid:
- when there is only one source and the issue is simply unclear

Topic examples:
- old QA vs new spec
- course filter scope mismatch

Evidence patterns:
- "tuy nhiên tại QA cũ"
- "mô tả mới và mô tả cũ khác nhau"

Confirmation patterns:
- "source nào là official"
- "ưu tiên theo tài liệu nào"

## search_item

Use:
- when a search condition is added, moved, hidden, grouped, enabled, disabled, or has unclear behavior

Avoid:
- when the issue is really a workflow step or role permission

Topic examples:
- default values
- checkbox behavior
- filter scope

Evidence patterns:
- "điều kiện search"
- "filter"
- "checkbox"

Confirmation patterns:
- "khi chọn / không chọn"
- "mặc định hiển thị thế nào"

## workflow_gap

Use:
- when a step, screen, navigation, or transition in the business flow is missing or unclear

Avoid:
- when the issue is only field mapping or one display label

Topic examples:
- duplicate flow
- navigation source
- missing transition

Evidence patterns:
- "sau khi"
- "điều hướng"
- "bước xử lý chưa rõ"

Confirmation patterns:
- "sau khi ... thì ..."
- "người dùng sẽ đi từ đâu sang đâu"

## import_csv

Use:
- when CSV import behavior is unclear, including template, encoding, validation, rollback, or error handling

Avoid:
- when the issue is CSV output only

Topic examples:
- import template
- rollback
- per-row validation

Evidence patterns:
- "CSV import"
- "template"
- "rollback"

Confirmation patterns:
- "chặn toàn bộ hay partial"
- "error handling như thế nào"

## csv_output

Use:
- when CSV output items, mapping sources, display rules, filename, or meaning of output values are unclear

Avoid:
- when the export target is not CSV

Topic examples:
- output item source
- export hierarchy
- value meaning

Evidence patterns:
- "CSV output"
- "item output"
- "file CSV"

Confirmation patterns:
- "nguồn tham chiếu của item"
- "hiển thị đầy đủ item nào"

## file_export

Use:
- when the request is about exporting HTML, Excel, PDF, or another non-CSV file, including export scope, output structure, filename, styling, and disabled behavior in exported content

Avoid:
- when the file is CSV output

Topic examples:
- HTML export
- PDF filename
- Excel structure

Evidence patterns:
- "HTML export"
- "filename"
- "disabled trong file export"

Confirmation patterns:
- "file export có bao gồm ..."
- "tên file mong muốn là gì"

## display_label

Use:
- when the main uncertainty is how a value, label, icon, text, status, or color should be displayed

Avoid:
- when the question is about business flow or data source

Topic examples:
- label text
- status display
- icon/color meaning

Evidence patterns:
- "hiển thị"
- "label"
- "status text"

Confirmation patterns:
- "mặc định hiển thị"
- "phân loại trạng thái"

## notification

Use:
- when the main question is recipient, timing, destination, template, or failure handling of a notification

Avoid:
- when the issue is workflow only and mail is not involved

Topic examples:
- mail recipient
- send timing
- retry or fail case

Evidence patterns:
- "mail"
- "thông báo"
- "recipient"

Confirmation patterns:
- "gửi cho ai"
- "trường hợp fail thì xử lý thế nào"

## mapping

Use:
- when the team needs to confirm a source reference, mapping source, count unit, semantic meaning, or grouping logic of a field

Avoid:
- when the main point is validation or role permission

Topic examples:
- source master
- count unit
- semantic meaning

Evidence patterns:
- "lấy từ đâu"
- "tham chiếu từ master nào"
- "đơn vị thống kê"

Confirmation patterns:
- "nguồn tham chiếu là gì"
- "đơn vị tính là gì"

## permission

Use:
- when the logic depends on role, department, or operation authority

Avoid:
- when the difference is data scope only and not role-driven

Topic examples:
- System Admin vs Contract Admin
- edit authority
- button enable/disable by role

Evidence patterns:
- "role"
- "quyền"
- "admin"

Confirmation patterns:
- "với role ... thì ..."
- "button nào disable"

## master_data

Use:
- when the value source is a master and the main question is which master or how inactive data is handled

Avoid:
- when the main issue is transaction history or migration

Topic examples:
- source master
- inactive master handling

Evidence patterns:
- "master"
- "giá trị tham chiếu"

Confirmation patterns:
- "tham chiếu từ master nào"
- "inactive data có hiển thị không"

## validation

Use:
- when the main uncertainty is required checks, format checks, uniqueness checks, numeric range checks, or whether the same validation rule is shared across UI, import, and update flows

Avoid:
- when the issue is only business flow or downstream impact

Topic examples:
- required field rule
- uniqueness
- numeric and format validation

Evidence patterns:
- "required"
- "validate"
- "0/1"

Confirmation patterns:
- "có áp dụng cùng rule không"
- "giá trị nào được coi là invalid"

## multi_rule

Use:
- when multiple business rules, conditions, or branches overlap and need to be separated clearly

Avoid:
- when a single simple category is enough

Topic examples:
- several rule branches
- mixed condition logic

Evidence patterns:
- "2 cách hiểu"
- "nhiều điều kiện"
- "nhiều branch"

Confirmation patterns:
- "trường hợp A / trường hợp B"
- "áp dụng rule nào"

## batch

Use:
- when the behavior depends on batch timing, snapshot timing, rerun, or handoff with manual operations

Avoid:
- when no timing or background processing is involved

Topic examples:
- rerun timing
- snapshot timing
- retry flow

Evidence patterns:
- "batch"
- "timing"
- "snapshot"

Confirmation patterns:
- "sau batch nào"
- "rerun thì xử lý thế nào"

## api

Use:
- when the main uncertainty is API timing, retry, timeout, callback, request/response contract, or interface behavior

Avoid:
- when the issue is internal screen logic only

Topic examples:
- request parameter
- callback timing
- API compatibility

Evidence patterns:
- "API"
- "request"
- "param"

Confirmation patterns:
- "cần bổ sung param nào"
- "hệ thống ngoài gọi tương thích thế nào"

## database

Use:
- when the unresolved point is data storage, migration, null handling, history, or existing data behavior

Avoid:
- when the issue is a simple master mapping

Topic examples:
- migration
- null/blank handling
- history retention

Evidence patterns:
- "DB"
- "migration"
- "NULL"

Confirmation patterns:
- "giữ nguyên dữ liệu cũ hay clear"
- "có cần migration không"

## exception_case

Use:
- when the uncertainty is about abnormal cases, duplicate handling, rollback, mismatch, recovery path, or user-visible error behavior

Avoid:
- when the issue is a normal-path rule only

Topic examples:
- duplicate input
- mail failed after status updated
- cross-system mismatch

Evidence patterns:
- "trường hợp lỗi"
- "rollback"
- "recovery"

Confirmation patterns:
- "nếu fail thì ..."
- "có warning riêng không"
