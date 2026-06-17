# Output Template

Use this document as the source of truth for QA output shape.

Do not treat it as a rigid sentence generator.

## Core Principle

Every QA should follow this business flow:

```text
Yêu cầu hoặc vị trí trong tài liệu
→ Nhận thức nghiệp vụ hiện tại
→ Phân chia từng trường hợp hoặc từng nhóm nội dung khi cần
→ Điểm chưa xác định được
→ Câu hỏi xác nhận với khách hàng
```

## Mandatory Outcome

Every QA must:

- open with concrete scope
- show the team's current understanding before asking
- include at least one point that still needs confirmation
- preserve important screen names, sheet names, line numbers, item names, status names, and Japanese terms when available
- close politely

Never print internal headings such as:

- `■ Bối cảnh`
- `■ Nhận thức hiện tại`
- `■ Câu hỏi xác nhận`

## Accepted Formats

### Format A: Confirm Multiple Understandings

```text
Liên quan đến [nội dung], chúng tôi đang hiểu nghiệp vụ như sau:

1. ...
2. ...
3. ...

Nhờ Bác xác nhận giúp cách hiểu trên có đúng không ạ?
```

### Format B: Group By Topic

```text
Liên quan đến [nội dung], chúng tôi muốn xác nhận nhận thức như sau:

1. Về [nhóm nội dung A]:
...

2. Về [nhóm nội dung B]:
...

Nhờ Bác xác nhận giúp chúng tôi các nội dung trên.
```

### Format C: Group By Business Case

```text
Liên quan đến [nội dung], chúng tôi đang hiểu nghiệp vụ như sau:

1. [Rule chung]

2. Trường hợp [điều kiện A]:
   - ...

3. Trường hợp [điều kiện B]:
   - ...

Nhờ Bác xác nhận giúp cách hiểu trên có đúng không ạ?
```

### Format D: State Transition

```text
Liên quan đến [điều kiện hoặc item], chúng tôi đang hiểu nghiệp vụ như sau:

1. Khi [điều kiện được thỏa]:
   - ...

2. Khi [điều kiện không được thỏa]:
   - ...

Nhờ Bác xác nhận giúp cách hiểu trên có đúng không ạ?
```

### Format E: Proposal

```text
Liên quan đến [nội dung], chúng tôi đang hiểu nghiệp vụ như sau:

1. ...
2. Tuy nhiên chúng tôi nhận thấy...
3. Do đó chúng tôi đề xuất...

Nhờ Bác xác nhận giúp hướng xử lý trên có phù hợp không ạ?
```

## Opening Rules

When the input contains them, keep these in the opening:

- screen name
- screen code
- sheet name
- line number
- block name
- item name
- function name
- status name
- Japanese term

Good:

```text
Liên quan đến phần 検索結果 được mô tả tại line 659 của màn hình 作図・出図状況一覧, chúng tôi muốn xác nhận nhận thức như sau:
```

Avoid:

```text
Liên quan đến yêu cầu trên...
```

## Writing Rules

- present current understanding first
- keep direct questions tied to that understanding
- split by topic when one QA covers different business concerns
- split by case when the logic depends on specific conditions
- keep exact business conditions from the input
- keep wording natural and polite
- prefer short sentences

Preferred phrases:

- `Chúng tôi đang hiểu...`
- `Chúng tôi đang nhận thức...`
- `Chúng tôi hiểu nghiệp vụ như sau...`
- `Nếu cách hiểu trên là đúng...`
- `Nhờ Bác cho biết...`
- `Nhờ Bác xác nhận giúp...`

## Good Examples

### Good Example: Mapping Clarification

```text
Liên quan đến phần 検索結果 được mô tả tại line 659 của màn hình 作図・出図状況一覧, chúng tôi đang hiểu nghiệp vụ như sau:

1. Màn hình đang thống kê kết quả theo từng 品目中分類.
2. Giá trị hiển thị trong từng ô là số lượng đối tượng đang thuộc trạng thái tương ứng tại ngày đó.
3. Chưa rõ 品目中分類 được tham chiếu từ master nào.

Nhờ Bác xác nhận thêm giúp các điểm sau:
1. các giá trị 品目中分類 được tham chiếu từ master hoặc thông tin nào?
2. đơn vị thống kê trong từng ô là số lượng record（件数） hay số lượng 製番?

Nhờ Bác xác nhận giúp cách hiểu trên có đúng không ạ?
```

### Good Example: Case Split

```text
Liên quan đến đối tượng nhận email được mô tả tại line 467-469 của màn hình 新規 作図実績（NEW）, chúng tôi đang hiểu nghiệp vụ như sau:

1. Đối tượng nhận email được chia theo từng điều kiện của 販売部門.

2. Trường hợp 「販売部門 = 19」:
   - gửi cho 得意先 trên Order

3. Trường hợp 「販売部門 <> 19」:
   - tham chiếu Master Bộ phận nhận để lấy địa chỉ email

Nhờ Bác xác nhận giúp cách hiểu trên có đúng không ạ?
```

## Bad Examples

### Bad Example: Direct Questions Only

```text
1. Có ảnh hưởng CSV không?
2. Có ảnh hưởng batch không?
3. Có dùng master nào không?
```

Why bad:

- no current understanding
- asks broad questions without evidence
- easy to hallucinate scope

### Bad Example: Old Internal Template

```text
■ Bối cảnh
...
■ Nhận thức hiện tại
...
■ Câu hỏi xác nhận
...
```

Why bad:

- internal heading style must not be sent to the customer

## Hard Avoids

Do not:

- ask direct isolated questions with no understanding
- fabricate other screens, CSV, batch, API, DB, authority, master, or phase information
- force the old phrase `Theo tài liệu hiện tại...` into every QA
- create a fixed `Tuy nhiên hiện chưa rõ...` paragraph when the issue can be placed naturally right after the related understanding
- replace exact conditions such as `販売部門 = 19` with vague paraphrases

## Dataset Notes

For dataset records:

- each JSON object must be on one physical line
- keep the QA natural, not templated
- preserve the source scope and exact terms
- allow multiple accepted formats
