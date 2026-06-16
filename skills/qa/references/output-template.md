# Output Template

Use the concise customer confirmation style below unless the user explicitly asks for another format.

## Mandatory Structure

Every QA must contain all 3 parts below:

1. `Mở đầu`
2. `Nội dung đang hiểu + điểm cần confirm`
3. `Kết thúc`

If one part is missing, the QA is not acceptable.
In normal output, do not print the literal labels above; keep them as hidden structure only.

## Core Writing Pattern

Each QA should usually flow like this:

1. `Mở đầu`: Use exactly this sentence pattern: `Liên quan đến yêu cầu [tên yêu cầu/nội dung yêu cầu], chúng tôi đang hiểu như sau và muốn confirm lại với bác:`
2. `Nội dung đang hiểu + điểm cần confirm`: Summarize the current understanding in a short paragraph, then write `Chúng tôi muốn confirm thêm các điểm sau:` and list the numbered confirmation points
3. `Kết thúc`: Close with exactly:
   `Nhờ bác confirm giúp nội dung trên có đúng không?`
   `Cảm ơn bác.`

Keep exactly one blank line between these parts.
In standard customer QA mode, output only the final message content.

## Required Writing Rules

- Keep the tone polite, clear, short, and easy to copy to the customer.
- Do not add information that is not present in the input or evidence.
- If the input has many conditions or spec rules, group them into easier business logic without changing the meaning.
- If a point is unclear, move it into the numbered confirmation list.
- Keep Japanese terms and field names unchanged.
- Use `1. 2. 3.` numbering only.
- Do not write overly long sentences.

## Preferred Natural Pattern

```text
Liên quan đến yêu cầu [ABC], chúng tôi đang hiểu như sau và muốn confirm lại với bác:

[Trình bày ngắn gọn phần đang hiểu tại đây. Nếu có nhiều điều kiện, hãy gom nhóm và viết lại dễ hiểu.]

Chúng tôi muốn confirm thêm các điểm sau:

1. [Điểm confirm 1]
2. [Điểm confirm 2]
3. [Điểm confirm 3]

Nhờ bác confirm giúp nội dung trên có đúng không?
Cảm ơn bác.
```

## Example A

```text
Liên quan đến yêu cầu bổ sung item 「標準時間」 tại màn hình AAA, chúng tôi đang hiểu như sau và muốn confirm lại với bác:

Theo tài liệu hiện tại và kết quả điều tra hệ thống, item 「標準時間」 không chỉ ảnh hưởng đến màn hình AAA mà còn đang được sử dụng tại BBB, CCC và CSV export liên quan. Vì vậy, chúng tôi đang hiểu rằng khi bổ sung item này, các chức năng liên quan cũng cần xử lý đồng bộ để tránh lệch dữ liệu và điều kiện hiển thị.

Chúng tôi muốn confirm thêm các điểm sau:

1. BBB, CCC và CSV export có nằm trong cùng scope xử lý của yêu cầu này không?
2. Nếu có chức năng nào chỉ cần giữ tương thích mà không cần hiển thị item mới, mong bác chỉ rõ phạm vi.
3. Trường hợp chưa có chỉ thị thay đổi schema, chúng tôi có thể hiểu là giữ nguyên cấu trúc dữ liệu hiện tại, đúng không?

Nhờ bác confirm giúp nội dung trên có đúng không?
Cảm ơn bác.
```

## Example B

```text
Liên quan đến yêu cầu về các màn hình không được mô tả trong sheet XXX, chúng tôi đang hiểu như sau và muốn confirm lại với bác:

Trong file 基幹システム機能一覧精査, các màn hình AAA, BBB và CCC đang được liệt kê là đối tượng liên quan. Tuy nhiên, sau khi rà soát các tài liệu hiện có, chúng tôi chưa thấy mô tả thay đổi cụ thể cho các màn hình này. Vì vậy, hiện tại chúng tôi đang hiểu rằng các màn hình trên sẽ giữ nguyên xử lý hiện tại.

Chúng tôi muốn confirm thêm các điểm sau:

1. AAA, BBB và CCC sẽ giữ nguyên xử lý hiện tại trong release này, đúng không?
2. Nếu vẫn có màn hình cần chỉnh sửa nhưng chưa được mô tả trong sheet XXX, mong bác chỉ rõ tên màn hình và nội dung thay đổi.

Nhờ bác confirm giúp nội dung trên có đúng không?
Cảm ơn bác.
```

## Writing Checklist

Before finalizing each QA, confirm:
- `Mở đầu` exists and uses the required sentence pattern
- `Nội dung đang hiểu + điểm cần confirm` exists and contains a short current-understanding paragraph plus numbered confirm points
- `Kết thúc` exists and uses the required closing lines
- The final QA does not print literal labels unless explicitly requested.
- The 3 parts are separated by one blank line only.
- There is a concrete investigation signal when evidence exists.
- The QA lists specific screens, CSV, batch, table, status, role, or mapping when relevant.
- The current understanding is explicit.
- The wording sounds like a BrSE, not an AI template.
- No extra information was added beyond the input or evidence.
- The numbered list contains only true confirmation points.

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
- Every QA must contain `Mở đầu`, `Nội dung đang hiểu + điểm cần confirm`, and `Kết thúc` in structure.
- Every QA must include at least one investigation element.
- Prefer natural flow and high information density.
- Prefer clear context, understanding, and confirmation points over short confirm-only QA.
- Quality is more important than count.
