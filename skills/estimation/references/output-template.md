# Output Template

Chỉ xuất kết quả theo đúng bảng sau:

| ProgramID | 機能区分 | 機能名 | Big | Medium | Small | Note | Type | Complexity |
| --------- | -------- | ------ | --- | ------ | ----- | ---- | ---- | ---------- |

Quy tắc điền:

- `ProgramID`: lấy từ tài liệu; nếu không có thì ghi `NOT FOUND IN DOCUMENT`
- `機能区分`: giữ nguyên thuật ngữ Nhật từ tài liệu; nếu không có thì ghi `NOT FOUND IN DOCUMENT`
- `機能名`: giữ nguyên thuật ngữ Nhật từ tài liệu; nếu không có thì ghi `NOT FOUND IN DOCUMENT`
- `Big`: tên chức năng tổng thể bằng tiếng Việt
- `Medium`: tên nhóm xử lý chính bằng tiếng Việt
- `Small`: câu ngắn gọn mô tả xử lý cụ thể nhưng không quá vi mô
- `Note`: ghi chú ngắn nếu cần, ví dụ `NOT FOUND IN DOCUMENT`, `MERGED WITH EXISTING TASK`, hoặc giới hạn phạm vi
- `Type`: chỉ dùng `initialize`, `CRUD`, `Business`, `Batch`
- `Complexity`: chỉ dùng `Low`, `Medium`, `High`

Ví dụ văn phong `Small`:

- Hiển thị các điều kiện tìm kiếm.
- Tìm kiếm danh sách theo điều kiện nhập.
- Hiển thị chi tiết kế hoạch được chọn.
- Cập nhật kế hoạch từ popup.
- Tạo file CSV danh sách master đơn giá.
- Gửi yêu cầu online batch và chuyển điều kiện tìm kiếm sang batch.

Không xuất thêm các section như summary, out of scope, missing information, hay giải thích dài dòng nếu user không yêu cầu riêng.
