# Output Template

Use the natural BrSE investigation style below unless the user explicitly asks for another format.

## Mandatory Structure

Every QA must contain all 3 parts below:

1. `Mở bài`
2. `Thân bài`
3. `Kết bài`

If one part is missing, the QA is not acceptable.

## Core Writing Pattern

Each QA should usually flow like this:

1. `Mở bài`: Open with the scope or topic, explain why the QA appears, mention the initial investigation, and state what must be confirmed
2. `Thân bài`: State the current-system investigation findings, the team's current understanding, the likely handling direction, and the confirmation questions
3. `Kết bài`: Ask the customer to confirm, ask them to clarify if the understanding is incorrect, and close politely

## Preferred Natural Patterns

### Pattern A: Impact Investigation

```text
Mở bài:

Liên quan đến việc xóa/bổ sung item 「XXX」.

Theo tài liệu hiện tại, item này được mô tả tại màn hình AAA.

Tuy nhiên, sau khi điều tra hệ thống hiện tại, chúng tôi nhận thấy item này còn được sử dụng tại:

* BBB: dùng cho hiển thị / tham chiếu
* CCC: dùng cho CSV export
* DDD: dùng cho CSV import
* EEE: dùng cho search condition

Để thống nhất hướng xử lý giữa các chức năng liên quan, chúng tôi muốn xác nhận thêm các nội dung dưới đây.

Thân bài:

Do đó, chúng tôi đang hiểu rằng khi xử lý item này ở AAA, các màn hình BBB/CCC/DDD/EEE cũng cần được cập nhật đồng bộ.

Phương án đối ứng của chúng tôi dự kiến là:

* cập nhật màn hình chính AAA
* cập nhật các màn hình / CSV / batch liên quan
* giữ nguyên database nếu không có chỉ thị thay đổi schema

Các nội dung cần xác nhận:

① BBB/CCC/DDD/EEE có nằm trong cùng scope release này hay không?
② Nếu có chức năng chỉ cần giữ tương thích mà không hiển thị item mới, mong bác chỉ rõ phạm vi.
③ Trường hợp chưa đổi schema, chúng tôi có thể giữ nguyên dữ liệu cũ và chỉ áp dụng cho dữ liệu phát sinh mới hay không?

Kết bài:

Nhờ bác xác nhận lại nội dung trên.
Nếu không đúng, phiền bác mô tả rõ hơn.
Cảm ơn bác.
```

### Pattern B: Scope Keep

```text
Mở bài:

Về các màn hình không mô tả trong sheet XXX.

Các màn hình dưới đây không được mô tả trong sheet XXX, nhưng được liệt kê là đối tượng trong file 基幹システム機能一覧精査:

* AAA
* BBB
* CCC

Sau khi rà soát các tài liệu liên quan, hiện tại chúng tôi chưa thấy mô tả thay đổi cụ thể cho các màn hình này.

Để tránh hiểu sai phạm vi release, chúng tôi muốn xác nhận thêm như sau.

Thân bài:

Chúng tôi hiểu rằng các màn hình này sẽ giữ nguyên xử lý hiện tại.

Phương án đối ứng dự kiến:

* chưa mở rộng implement cho các màn hình chưa có mô tả thay đổi
* chỉ xử lý thêm nếu khách hàng xác nhận có scope bổ sung

Các nội dung cần xác nhận:

① AAA/BBB/CCC sẽ giữ nguyên xử lý hiện tại, đúng không?
② Nếu có màn hình nào vẫn cần chỉnh sửa nhưng chưa được mô tả trong sheet XXX, mong bác chỉ rõ tên màn hình và nội dung thay đổi.

Kết bài:

Nhờ bác xác nhận giúp nhận thức trên.
Nếu không đúng, phiền bác mô tả rõ hơn.
Cảm ơn bác.
```

### Pattern C: Version Conflict

```text
Mở bài:

Về việc giữ lại hay xóa chức năng 「XXX」.

Theo tài liệu A ngày yyyy/mm/dd, chúng tôi thấy có mô tả rằng chức năng XXX sẽ bị xóa.
Tuy nhiên, theo tài liệu B ngày yyyy/mm/dd, chúng tôi thấy chức năng này vẫn đang được giữ lại.

Để thống nhất version tài liệu áp dụng trước khi design và estimate, chúng tôi muốn xác nhận thêm như sau.

Thân bài:

Do đó, chúng tôi đang hiểu rằng cần chốt lại version chính thức trước khi tiến hành design và estimate.

Các nội dung cần xác nhận:

① Ở release hiện tại, chức năng XXX sẽ được giữ lại hay xóa khỏi hệ thống?
② Nếu tài liệu B là bản mới nhất, mong bác cho biết tài liệu A có thể xem là obsolete hay không?

Kết bài:

Nhờ bác xác nhận giúp chức năng XXX vẫn sẽ được giữ lại trên hệ thống hiện tại, đúng không?
Nếu không đúng, phiền bác mô tả rõ hơn.
Cảm ơn bác.
```

### Pattern D: Workflow Gap

```text
Mở bài:

Liên quan đến việc thay đổi flow hoặc xóa màn hình XXX ra khỏi hệ thống.

Màn hình XXX hiện tại thực hiện các chức năng chính:

1. ...
2. ...
3. ...

Sau khi điều tra hệ thống hiện tại, chúng tôi nhận thấy các chức năng trên đang ảnh hưởng đến các màn hình / flow liên quan như sau:

* AAA: ...
* BBB: ...

Để thống nhất trách nhiệm thay thế sau khi thay đổi flow, chúng tôi muốn xác nhận thêm các nội dung dưới đây.

Thân bài:

Do đó, chúng tôi đang hiểu rằng cần xác nhận rõ màn hình nào sẽ tiếp nhận trách nhiệm thay thế.

Phương án đối ứng dự kiến:

* xóa hoặc ẩn XXX theo đúng yêu cầu nếu đã có chức năng thay thế
* điều chuyển trách nhiệm nghiệp vụ sang AAA/BBB hoặc flow liên quan sau khi được xác nhận

Các nội dung cần xác nhận:

① Sau khi xóa XXX, màn hình hoặc flow nào sẽ tiếp nhận từng chức năng 1/2/3 nêu trên?
② Có cần dữ liệu hoặc status nào được migrate/giữ lại để flow mới tiếp tục sử dụng hay không?
③ Nếu chưa có chức năng thay thế đầy đủ, team có cần giữ tạm một phần behavior hiện tại hay không?

Kết bài:

Nhờ bác xác nhận giúp.
Nếu không đúng, phiền bác mô tả rõ hơn.
Cảm ơn bác.
```

## Writing Checklist

Before finalizing each QA, confirm:
- `Mở bài` exists and clearly states context, reason, investigation, and objective
- `Thân bài` exists and contains at least one of: current understanding, investigation result, proposed handling, confirmation questions
- `Kết bài` exists and does not end abruptly right after the questions
- There is a concrete investigation signal.
- The QA lists specific screens, CSV, batch, table, status, role, or mapping when relevant.
- The current understanding is explicit.
- The likely handling direction is explicit when possible.
- The wording sounds like a BrSE, not an AI template.

## Weak Patterns To Avoid

Avoid:

```text
- Field này có required không?
- Có export CSV không?
- Có validate không?
- Ai được thao tác?
```

Rewrite them into investigation QA with evidence and current understanding.

## Dataset Output

For dataset regeneration, each line must be one JSON object:

```json
{
  "id": "BI-QA-0001",
  "category": "impact_investigation",
  "module": "MA10",
  "screen": "MA1010",
  "topic": "standard_time_reference_items",
  "style": "investigation_confirm",
  "source_pattern": "impact_list_screens",
  "difficulty": "high",
  "qa": "..."
}
```

Rules:
- Every QA must contain `Mở bài`, `Thân bài`, and `Kết bài`.
- Every QA must include at least one investigation element.
- Prefer natural flow and high information density.
- Prefer longer QA with context, understanding, and handling direction over short confirm-only QA.
- Quality is more important than count.
