# Output Template

Luôn nhóm kết quả theo đủ 10 heading.
Không xuất phần tóm tắt hoặc danh sách chức năng trước các section QA.
Chỉ xuất QA đạt điểm `4` hoặc `5`.

## Section format

```text
1. Business Logic QA

- QA-BL-01 | Điểm rủi ro: 5 | Critical | Tài liệu liên quan: Requirement, Basic Design, Flow Diagram
  Nội dung QA:
  Liên quan đến chức năng [tên chức năng] tại [màn hình/flow], hiện tại chúng tôi hiểu như sau:
  1. ...
  2. ...
  3. ...
  Tuy nhiên hiện tại chúng tôi chưa thấy mô tả rõ về ...
  Giả định hiện tại của chúng tôi là ...
  Do đó chúng tôi muốn xác nhận:
  1. ...
  2. ...
  3. ...
  Nhờ Bác xác nhận giúp.
```

If no meaningful QA exists in a section, write:

```text
Không phát sinh QA cần xác nhận trong nhóm này.
```

## Writing Checklist

Trước khi chốt từng QA, tự kiểm tra:

- Ngữ cảnh đã nêu rõ function, screen, flow, batch, hoặc interface.
- Nhận thức hiện tại xuất phát từ tài liệu cụ thể, không phải chỉ đoán.
- Điểm chưa khớp hoặc còn thiếu đã được chỉ ra rõ ràng.
- Giả định đã được viết tường minh nếu spec còn thiếu.
- Các điểm cần xác nhận là cụ thể và chỉ xoay quanh một chủ đề nghiệp vụ.
- QA chứng minh được lý do đạt điểm `4` hoặc `5`.
- QA thuộc đúng một nhóm chính.
- Câu hỏi không phải kiểu xin giải thích chung chung.

## Strong QA Example

```text
- QA-IF-02 | Điểm rủi ro: 5 | Critical | Tài liệu liên quan: Detail Design, Sequence Diagram, Interface Specification
  Nội dung QA:
  Liên quan đến interface gửi dữ liệu đơn hàng sang hệ thống kế toán, hiện tại chúng tôi hiểu như sau:
  1. API được gọi tại thời điểm đơn hàng chuyển sang trạng thái "Approved".
  2. Nếu API trả về thành công thì hệ thống cập nhật cờ gửi interface = Done.
  3. Sequence Diagram có mô tả xử lý success, tuy nhiên chưa thấy mô tả cách xử lý khi timeout hoặc trả về lỗi.
  Tuy nhiên hiện tại chúng tôi chưa thấy mô tả về cách ngăn gửi trùng khi user thực hiện thao tác retry trong lúc kết quả lần gửi trước chưa được phản ánh.
  Giả định hiện tại của chúng tôi là trong trường hợp timeout, hệ thống chưa cập nhật trạng thái gửi và cho phép retry bằng batch hoặc thao tác tay.
  Do đó chúng tôi muốn xác nhận:
  1. Trường hợp timeout có được phép retry từ màn hình hay chỉ từ batch.
  2. Hệ thống dùng khóa nào để ngăn duplicate interface.
  3. Nếu hệ thống nhận được response thành công trễ sau khi đã retry, trạng thái cuối cùng được xác định theo nguyên tắc nào.
  Nhờ Bác xác nhận giúp.
```

## Weak QA Patterns To Avoid

Tránh các dạng sau:

```text
- Chức năng này dùng để làm gì?
- Logic này như thế nào?
- Xin xác nhận màn hình này.
- Các QA chỉ có giá trị tham khảo nhưng chưa cho thấy rủi ro nghiệp vụ hoặc production.
```

Hãy viết lại thành QA có ngữ cảnh rõ ràng, nêu nhận thức hiện tại, nêu gap, rồi mới xác nhận.
