# Output Template

Use the natural BrSE investigation style below unless the user explicitly asks for another format.

## Core Writing Pattern

Each QA should usually flow like this:

1. Open with the scope or topic
2. State what the current document says
3. State what the current-system investigation found
4. State the team's current understanding
5. State the likely handling direction
6. Ask the customer to confirm

## Preferred Natural Patterns

### Pattern A: Impact Investigation

```text
Liên quan đến việc xóa/bổ sung item 「XXX」

Theo tài liệu hiện tại, item này được mô tả tại màn hình AAA.

Tuy nhiên, sau khi điều tra hệ thống hiện tại, chúng tôi nhận thấy item này còn được sử dụng tại:

* BBB: dùng cho hiển thị / tham chiếu
* CCC: dùng cho CSV export
* DDD: dùng cho CSV import
* EEE: dùng cho search condition

Do đó, chúng tôi đang hiểu rằng khi xử lý item này ở AAA, các màn hình BBB/CCC/DDD/EEE cũng cần được cập nhật đồng bộ.

Phương án đối ứng của chúng tôi dự kiến là:

* cập nhật màn hình chính AAA
* cập nhật các màn hình / CSV / batch liên quan
* giữ nguyên database nếu không có chỉ thị thay đổi schema

Nhờ bác xác nhận lại nội dung trên.
Cảm ơn bác.
```

### Pattern B: Scope Keep

```text
Về các màn hình không mô tả trong sheet XXX

Các màn hình dưới đây không được mô tả trong sheet XXX, nhưng được liệt kê là đối tượng trong file 基幹システム機能一覧精査:

* AAA
* BBB
* CCC

Chúng tôi hiểu rằng các màn hình này sẽ giữ nguyên xử lý hiện tại.

Nhờ bác xác nhận giúp nhận thức trên.
```

### Pattern C: Version Conflict

```text
Về việc giữ lại hay xóa chức năng 「XXX」

Theo tài liệu A ngày yyyy/mm/dd, chúng tôi thấy có mô tả rằng chức năng XXX sẽ bị xóa.
Tuy nhiên, theo tài liệu B ngày yyyy/mm/dd, chúng tôi thấy chức năng này vẫn đang được giữ lại.

Do đó, chúng tôi đang hiểu rằng cần chốt lại version chính thức trước khi tiến hành design và estimate.

Nhờ bác xác nhận giúp chức năng XXX vẫn sẽ được giữ lại trên hệ thống hiện tại, đúng không?
```

### Pattern D: Workflow Gap

```text
① Chúng tôi đang hiểu là sẽ thực hiện xóa màn hình XXX ra khỏi hệ thống.
Phiền bác xác nhận lại nội dung này.

② Q&A xác nhận phạm vi thay thế sau khi xóa XXX

Màn hình XXX hiện tại thực hiện các chức năng chính:

1. ...
2. ...
3. ...

Sau khi điều tra hệ thống hiện tại, chúng tôi nhận thấy các chức năng trên đang ảnh hưởng đến các màn hình / flow liên quan như sau:

* AAA: ...
* BBB: ...

Do đó, chúng tôi đang hiểu rằng cần xác nhận rõ màn hình nào sẽ tiếp nhận trách nhiệm thay thế.

Nhờ bác xác nhận giúp.
```

## Writing Checklist

Before finalizing each QA, confirm:
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
- Do not force rigid headings on every QA.
- Every QA must include at least one investigation element.
- Prefer natural flow and high information density.
- Quality is more important than count.
