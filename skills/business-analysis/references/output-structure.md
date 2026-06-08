# Output Structure

Use the following structure unless the user asks for a narrower scope.

## 1. Tổng quan requirement

- Chức năng
- Tên màn hình
- Tên module
- Tên subsystem
- Mục tiêu
- Phạm vi thay đổi:
  - Chức năng mới
  - Chỉnh sửa chức năng
  - Loại bỏ chức năng
  - Refactor logic
  - Chuyển màn hình
  - Chuyển nghiệp vụ

## 2. Actor analysis

Use a table when evidence exists:

| Actor | Vai trò | Hành động |
| --- | --- | --- |

## 3. Screen analysis

For each screen, analyze:

- Mục đích
- Điều kiện truy cập
- Điều kiện hiển thị
- Điều kiện chỉnh sửa
- Điều kiện khóa
- Điều kiện disable
- Điều kiện readonly
- Điều kiện chuyển màn hình

## 4. Field analysis

Use a field table when possible:

| Field | Tên | Mô tả | Bắt buộc | Editable | Điều kiện |
| --- | --- | --- | --- | --- | --- |

For each field, cover:

- Nguồn dữ liệu
- Giá trị mặc định
- Điều kiện hiển thị
- Điều kiện chỉnh sửa
- Điều kiện khóa
- Validation

## 5. Search analysis

Analyze:

- Điều kiện tìm kiếm
- Điều kiện bắt buộc
- Sort
- Paging
- Filter
- Điều kiện đặc biệt

## 6. Business rule analysis

For each rule, provide:

- Rule ID
- Mô tả
- Điều kiện
- Kết quả
- Nguồn bằng chứng

## 7. Validation analysis

For each validation, provide:

- Validation ID
- Trigger
- Điều kiện
- Thông báo
- Kết quả
- Evidence

## 8. Status analysis

Use a status table when evidence exists:

| Status | Ý nghĩa | Khi vào | Khi thoát |
| --- | --- | --- | --- |

Also identify:

- Trạng thái nguồn
- Trạng thái đích
- Trigger

## 9. Button analysis

For each button such as `検索`, `登録`, `更新`, `削除`, `CSV出力`, `CSV取込`, `送信`, `承認`, `差戻`, `取消`, cover:

- Điều kiện enable
- Điều kiện disable
- Điều kiện click
- Xử lý
- DB update
- Status change
- Màn hình chuyển tiếp

## 10. Database analysis

Identify:

- Bảng nào được đọc
- Bảng nào được cập nhật
- Bảng nào được insert
- Bảng nào được delete

Use a table when possible:

| Table | Action | Column |
| --- | --- | --- |

## 11. CSV analysis

If CSV exists, analyze:

- Layout
- Encoding
- Validation
- Import rule
- Export rule
- Error handling

## 12. API analysis

If API exists, use:

| API | Method | Purpose |
| --- | --- | --- |

Then cover:

- Request
- Response
- Validation
- Error
- Auth

## 13. Email analysis

Analyze:

- Trigger
- Receiver
- CC
- BCC
- Template
- Subject
- Attachment

## 14. Interface analysis

Identify linked items:

- Module nào
- Màn hình nào
- API nào
- Batch nào
- CSV nào

## 15. Impact analysis

Cover:

- Impact Screen
- Impact DB
- Impact API
- Impact CSV
- Impact Batch
- Impact Report
- Impact Permission
- Impact Flow

## 16. Gap analysis

Find missing items such as:

- Requirement thiếu
- Flow thiếu
- Mapping thiếu
- Validation thiếu
- Status thiếu
- Email thiếu
- API thiếu
- CSV thiếu

## 17. QA generation

Generate confirmation questions with:

- Issue
- Evidence
- Risk
- Question
- Priority

## 18. Requirement summary

Summarize:

- Hệ thống phải làm gì
- Hệ thống không làm gì
- Điều kiện đặc biệt
- Rủi ro
- Điểm cần xác nhận

## Rendering Notes

- Use Vietnamese for the full output.
- Keep important Japanese terms in bilingual form `日本語 (Tiếng Việt)`.
- Use `NOT FOUND IN DOCUMENT` whenever evidence is missing.
- Prefer partial but correct analysis over complete but inferred analysis.
