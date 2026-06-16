# Output Template

Use the concise customer confirmation style below unless the user explicitly asks for another format.

## Mandatory Structure

Every QA must contain all 3 content parts below, then end with the fixed closing:

1. `Mở đầu`
2. `Nội dung đang hiểu`
3. `Các điểm cần confirm`

If one part is missing, the QA is not acceptable.
In normal output, do not print the literal labels above; keep them as hidden structure only.

## Core Writing Pattern

Each QA should usually flow like this:

1. `Mở đầu`: Use exactly this sentence pattern: `Liên quan đến yêu cầu [tên yêu cầu/nội dung yêu cầu], chúng tôi đang hiểu như sau và muốn confirm lại với bác:`
2. `Nội dung đang hiểu`: Summarize the current understanding in a short paragraph, usually within 3 to 5 sentences
3. `Các điểm cần confirm`: Write `Chúng tôi muốn confirm thêm các điểm sau:` and list the numbered confirmation points
4. `Kết thúc`: Close with exactly:
   `Nhờ bác confirm giúp nội dung trên có đúng không?`
   `Cảm ơn bác.`

Keep exactly one blank line between these parts.
In standard customer QA mode, output only the final message content.

## Required Writing Rules

- Keep the tone polite, natural, short, and easy to send to the customer.
- Keep the writing easy for a business user to read.
- Do not add information that is not present in the input or evidence.
- If the input has many conditions or spec rules, group them into easier business logic without changing the meaning.
- If a point is unclear, move it into the numbered confirmation list.
- Prefer 2 to 4 confirmation questions when the evidence supports them.
- Each question must ask only one point.
- If there are multiple business possibilities, write them clearly so the customer can choose.
- Use `1. 2. 3. 4.` numbering only.
- Do not write overly long or complicated sentences.
- If one sentence becomes too long, split it into shorter sentences.

## Technical-Term Simplification Rules

- Avoid table names, column names, schema names, technical IDs, and raw database wording unless the customer already uses them or truly needs them.
- Convert technical wording into easier business wording whenever possible.

Examples:
- `I_RCP_NO` -> `dòng dữ liệu được chọn` or `dữ liệu của phiếu nhập tiền`
- `I_RCP_DETAIL_NO` -> `dữ liệu chi tiết`
- `record` -> `dòng dữ liệu`
- `search result` -> `kết quả search`
- `export` -> `xuất CSV`

If a Japanese term, field name, or technical name must remain for accuracy, wrap it in an easier business explanation.

## Preferred Natural Pattern

```text
Liên quan đến yêu cầu [ABC], chúng tôi đang hiểu như sau và muốn confirm lại với bác:

[Viết ngắn gọn phần đang hiểu tại đây, tối đa 3 đến 5 câu. Ưu tiên mô tả theo thao tác, màn hình, dữ liệu người dùng nhìn thấy, hoặc luồng nghiệp vụ.]

Chúng tôi muốn confirm thêm các điểm sau:

1. [Câu hỏi confirm 1]
2. [Câu hỏi confirm 2]
3. [Câu hỏi confirm 3]

Nhờ bác confirm giúp nội dung trên có đúng không?
Cảm ơn bác.
```

## Example A

```text
Liên quan đến yêu cầu bổ sung thông tin tiêu chuẩn tại màn hình AAA, chúng tôi đang hiểu như sau và muốn confirm lại với bác:

Theo tài liệu hiện tại, thông tin này được nhập tại màn hình AAA. Ngoài ra, một số màn hình khác và file xuất CSV cũng đang dùng lại cùng dữ liệu này. Vì vậy, chúng tôi đang hiểu rằng khi bổ sung nội dung trên, các chỗ đang hiển thị hoặc sử dụng cùng dữ liệu cũng cần được xử lý đồng bộ để tránh lệch nghiệp vụ.

Chúng tôi muốn confirm thêm các điểm sau:

1. Các màn hình BBB, CCC và file xuất CSV liên quan có nằm trong cùng phạm vi xử lý của yêu cầu này không?
2. Nếu có chức năng chỉ cần giữ dữ liệu cũ mà không cần hiển thị nội dung mới, mong bác chỉ rõ giúp phạm vi.
3. Trong release này, chúng tôi có thể hiểu là cách lưu dữ liệu hiện tại vẫn giữ nguyên, đúng không?

Nhờ bác confirm giúp nội dung trên có đúng không?
Cảm ơn bác.
```

## Example B

```text
Liên quan đến yêu cầu về các màn hình chưa được mô tả trong sheet XXX, chúng tôi đang hiểu như sau và muốn confirm lại với bác:

Trong tài liệu hiện tại, các màn hình AAA, BBB và CCC đang được liệt kê là đối tượng liên quan. Tuy nhiên, chúng tôi chưa thấy mô tả thay đổi cụ thể cho các màn hình này. Vì vậy, hiện tại chúng tôi đang hiểu rằng các màn hình trên sẽ giữ nguyên xử lý hiện tại nếu không có chỉ định bổ sung.

Chúng tôi muốn confirm thêm các điểm sau:

1. AAA, BBB và CCC sẽ giữ nguyên xử lý hiện tại trong release này, đúng không?
2. Nếu vẫn có màn hình cần chỉnh sửa nhưng chưa được mô tả trong sheet XXX, mong bác chỉ rõ tên màn hình và nội dung thay đổi.

Nhờ bác confirm giúp nội dung trên có đúng không?
Cảm ơn bác.
```

## Writing Checklist

Before finalizing each QA, confirm:
- `Mở đầu` exists and uses the required sentence pattern
- `Nội dung đang hiểu` exists and contains a short current-understanding paragraph
- `Các điểm cần confirm` exists and contains numbered confirmation questions
- `Kết thúc` exists and uses the required closing lines
- The final QA does not print literal labels unless explicitly requested.
- The parts are separated by one blank line only.
- The wording sounds natural for a business customer.
- The current understanding is explicit.
- The numbered list contains only true confirmation points.
- The final text avoids unnecessary technical terms.
- No extra information was added beyond the input or evidence.

## Weak Patterns To Avoid

Avoid:

```text
- Field này có required không?
- Có export CSV không?
- Có validate không?
- Ai được thao tác?
```

Rewrite them into short, business-friendly QA with evidence and current understanding.

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
- Every QA must contain `Mở đầu`, `Nội dung đang hiểu`, `Các điểm cần confirm`, and `Kết thúc` in structure.
- Every QA must include at least one investigation element.
- Prefer natural flow and high information density.
- Prefer clear context, understanding, and confirmation points over short confirm-only QA.
- Quality is more important than count.
