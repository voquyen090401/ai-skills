# QA Groups

Dùng đúng 10 nhóm này và giữ nguyên thứ tự.
Chỉ giữ các QA đạt điểm `4` hoặc `5`.

## 1. Business Logic QA

Dùng khi gap liên quan đến:

- Điều kiện chuyển trạng thái
- Điều kiện hoàn thành, hủy, close, reopen, hoặc lock
- Thời điểm hoặc quyền chỉnh sửa
- Thời điểm update, thời điểm recalculation, hoặc commit point

Tín hiệu thường gặp:
Tài liệu có mô tả chuyện gì xảy ra, nhưng chưa mô tả khi nào được phép, khi nào bị chặn, khi nào finalized, hoặc khi nào được quay lại.
Nhóm này cũng phải bắt được dead-end flow và các trạng thái thiếu đường ra hoặc đường quay lại.

## 2. Data Source QA

Dùng khi gap liên quan đến:

- Source of truth từ master hoặc transaction
- Dữ liệu hiện tại hay dữ liệu lịch sử
- Công thức tính giá trị dẫn xuất hoặc nguồn lookup
- Cách xử lý khi source data bị thiếu hoặc bị xóa
- Nguồn migration từ hệ thống cũ hoặc fallback source

Tín hiệu thường gặp:
Màn hình hoặc interface cần một giá trị nhưng chưa rõ lấy từ table, master, history, hoặc hệ thống cũ nào.

## 3. Search Condition QA

Dùng khi gap liên quan đến:

- Điều kiện AND hay OR
- Giá trị mặc định
- Khoảng ngày mặc định
- Ưu tiên hoặc precedence giữa các điều kiện
- Cách xử lý khi không nhập điều kiện
- Pagination hoặc giới hạn số bản ghi

Tín hiệu thường gặp:
Điều kiện search đã có nhưng filter logic, default, hoặc extraction scope chưa được mô tả đầy đủ.

## 4. Display QA

Dùng khi gap liên quan đến:

- Điều kiện hiển thị hoặc ẩn
- Điều kiện enable, disable, readonly
- Thứ tự hiển thị hoặc việc đóng/mở section
- Format, placeholder, hoặc fallback display behavior

Tín hiệu thường gặp:
Item có xuất hiện trên màn hình nhưng logic hiển thị hoặc state control chưa rõ.

## 5. Mail Notification QA

Dùng khi gap liên quan đến:

- Đối tượng nhận mail
- Rule CC hoặc BCC
- Thời điểm gửi
- Mail template
- Nhiều người nhận hoặc duplicate notification
- Phân nhánh người nhận theo phòng ban hoặc role

Tín hiệu thường gặp:
Flow có nhắc việc gửi mail nhưng recipients, trigger, hoặc content source chưa khép kín.

## 6. Approval Flow QA

Dùng khi gap liên quan đến:

- Cách xác định approver
- Delegate hoặc proxy approval
- Điều kiện reject, send-back, re-apply, hoặc re-approve
- Thay đổi approval route sau khi resubmit
- Hành vi của final approver khi dữ liệu nền bị thay đổi

Tín hiệu thường gặp:
Có approval flow nhưng authority chain hoặc hành vi khi resubmission chưa đầy đủ.

## 7. CSV QA

Dùng khi gap liên quan đến:

- Phạm vi export
- Sort mặc định
- Encoding
- Quy tắc header
- Cách xuất null, blank, hoặc code-name
- Validation khi import hoặc partial-success behavior

Tín hiệu thường gặp:
Đã có CSV nhưng quy ước input hoặc output mới được định nghĩa một phần.

## 8. Interface QA

Dùng khi gap liên quan đến:

- Thời điểm gọi API
- Retry policy
- Timeout
- Failure handling
- Idempotency hoặc duplicate send control
- Thời điểm phản ánh callback hoặc kết quả
- Thời điểm handover dữ liệu với hệ thống cũ

Tín hiệu thường gặp:
Có external interface nhưng operational behavior chưa được định nghĩa đầy đủ.

## 9. Master QA

Dùng khi gap liên quan đến:

- Có cần master mới hay không
- Có tái sử dụng master hiện hữu hay không
- Owner chịu trách nhiệm maintain
- Effective period hoặc activation rule
- Liên hệ giữa master và screen input validation

Tín hiệu thường gặp:
Cần code, list, hoặc category có thể cấu hình nhưng ownership hoặc maintenance policy chưa rõ.

## 10. Exception QA

Dùng khi gap liên quan đến:

- Dữ liệu bị xóa hoặc invalid
- Record đã được downstream xử lý
- Rollback, send-back, recall, hoặc undo
- Duplicate data
- Concurrent updates
- Partial completion hoặc xử lý bị gián đoạn
- Thiếu audit trail hoặc recovery path khi xảy ra abnormal case

Tín hiệu thường gặp:
Happy path đã có nhưng abnormal handling hoặc boundary handling chưa khép kín.

## Prioritization Heuristic

Đánh `Critical` khi câu trả lời có thể làm thay đổi:

- Kết quả quyết định nghiệp vụ
- Approval authority
- Kết quả dữ liệu được lưu
- Hành vi của hệ thống bên ngoài
- Auditability hoặc operational recovery
- Độ ổn định vận hành production

Đánh `High` khi câu trả lời ảnh hưởng đến:

- Tính nhất quán thao tác của operator
- Độ chính xác của report
- Độ chính xác của search hoặc export có ảnh hưởng nghiệp vụ đáng kể
- Khả năng kiểm soát invalid hoặc stale master data

Không xuất các QA mức `Medium` hoặc `Low`.
