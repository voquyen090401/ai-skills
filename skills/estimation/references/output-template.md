# Output Template

Chi xuat ket qua theo dung bang sau:

| ProgramID | 機能区分 | 機能名 | Big | Medium | Small | Note | Type | Complexity | BE | FE | UT |
| --------- | -------- | ------ | --- | ------ | ----- | ---- | ---- | ---------- | -- | -- | -- |

Thu tu cot bat buoc:

1. `ProgramID`
2. `機能区分`
3. `機能名`
4. `Big`
5. `Medium`
6. `Small`
7. `Note`
8. `Type`
9. `Complexity`
10. `BE`
11. `FE`
12. `UT`

Quy tac dien:

- `ProgramID`: lay tu tai lieu; neu khong co thi ghi `NOT FOUND IN DOCUMENT`
- `機能区分`: giu nguyen thuat ngu Nhat tu tai lieu; neu khong co thi ghi `NOT FOUND IN DOCUMENT`
- `機能名`: giu nguyen thuat ngu Nhat tu tai lieu; neu khong co thi ghi `NOT FOUND IN DOCUMENT`
- `Big`: ten chuc nang tong the bang tieng Viet
- `Medium`: ten nhom xu ly chinh bang tieng Viet, ngan gon, de hieu, du lon de estimate, va khong trung muc tieu voi Medium khac trong cung mot Big
- `Small`: cau ngan gon mo ta xu ly cua Medium, bat dau bang dong tu xu ly, ro doi tuong xu ly, va khong qua vi mo
- `Note`: ghi chu ngan neu can, vi du `NOT FOUND IN DOCUMENT`, `NOT ESTIMATED`, `MERGED WITH EXISTING TASK`, hoac gioi han pham vi
- `Type`: chi dung `initialize`, `CRUD`, `Business`, `Batch`
- `Complexity`: chi dung `Low`, `Medium`, `High`
- `BE`: man-day Backend, chi ghi so hoac `NOT ESTIMATED`
- `FE`: man-day Frontend, chi ghi so hoac `NOT ESTIMATED`
- `UT`: man-day Unit Test, chi ghi so hoac `NOT ESTIMATED`

Gia tri effort hop le:

- `0`
- `0.25`
- `0.5`
- `0.75`
- `1`
- `1.5`
- `2`
- `NOT ESTIMATED`

Khong ghi:

- `1 ngay`
- `1 MD`
- `1-2`
- `Low`
- `TBD`

Quy tac bat buoc cho `Medium`:

- Khong tao Medium rieng cho validate du lieu
- Khong tao Medium rieng cho goi API
- Khong tao Medium rieng cho mapping request hoac response
- Khong tao Medium rieng cho set loading
- Khong tao Medium rieng cho hien thi message
- Khong tao Medium rieng cho xu ly loi thong thuong
- Khong tao Medium rieng cho tung master, tung dropdown, tung function, hoac tung technical event
- Cac xu ly tren phai duoc gom vao Medium tuong ung va mo ta trong `Small`

Quy tac bat buoc cho `Small`:

- `Small` la mo ta ngan gon noi dung xu ly cua `Medium`
- `Small` phai de hieu, bat dau bang dong tu xu ly, va noi thang vao du lieu hoac chuc nang duoc xu ly
- Uu tien cau truc `Thuc hien + noi dung xu ly + doi tuong`
- Khong liet ke chi tiet ky thuat nhu API, field, function, mapping, loading, message, hay technical event
- Khong tach `Small` thanh nhieu dong chi vi khac API, field, function, message, hoac buoc xu ly ky thuat
- `Small` thuong chi nen la 1 cau ngan, uu tien duoi 15 tu neu van giu du nghia

Quy tac effort:

- `BE` co effort khi co thay doi API, business logic server, validate server, DB, transaction, batch, interface, CSV server, hoac response data
- `FE` co effort khi co thay doi man hinh, hien thi, form nhap, validate client, popup, nut, state item, request gui tu man hinh, hoac hien thi ket qua
- `UT` la effort unit test cua cung task, khong tach thanh task rieng
- `Khoi tao man hinh` va `Khoi tao du lieu` van co the co `BE > 0` neu can tao moi hoac sua API
- `Thuc hien export CSV` mac dinh co `FE = 0` neu chi sua Backend
- Neu chua du evidence de estimate thi dung `NOT ESTIMATED`

Mau Medium chuan:

- man hinh danh sach:
  - `Khoi tao man hinh`
  - `Thuc hien lay danh sach va hien thi du lieu`
  - `Thuc hien export CSV`
- man hinh them moi:
  - `Khoi tao man hinh`
  - `Thuc hien them moi du lieu`
- man hinh cap nhat:
  - `Khoi tao du lieu`
  - `Thuc hien cap nhat du lieu`

Vi du van phong `Small`:

- Thuc hien khoi tao man hinh danh sach ABC.
- Thuc hien khoi tao man hinh tao moi ABC.
- Thuc hien khoi tao du lieu cap nhat ABC.
- Thuc hien tim kiem va hien thi danh sach ABC.
- Thuc hien them moi du lieu ABC da nhap.
- Thuc hien validate va luu du lieu ABC da thay doi.
- Thuc hien xoa du lieu ABC da chon.
- Thuc hien export danh sach ABC ra CSV.
- Thuc hien import du lieu ABC tu CSV.

Khong ghi Small o muc code nhu:

- Goi API
- Mapping request
- Mapping response
- Tao bien
- Set state
- Call function
- Bat su kien onClick
- Set loading
- Hien thi message

Khong xuat them cac section nhu summary, out of scope, missing information, hay giai thich dai dong neu user khong yeu cau rieng.
