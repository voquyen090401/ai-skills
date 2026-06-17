# Estimation Workflow

## Muc dich

Tai lieu nay mo ta cach skill `estimation` hien tai thuc hien task breakdown va estimate man-day cho bai toan ERP.

Skill nay:

- tao bang `Big`, `Medium`, `Small`
- gan `Type` va `Complexity`
- estimate `BE`, `FE`, `UT` theo bang chung tai lieu
- khong dung de viet design
- khong dung de generate code

## Skill nay tao ra cai gi

Ket qua chinh la mot bang breakdown phuc vu estimation theo cac cot:

- `ProgramID`
- `機能区分`
- `機能名`
- `Big`
- `Medium`
- `Small`
- `Note`
- `Type`
- `Complexity`
- `BE`
- `FE`
- `UT`

Gia tri `BE`, `FE`, `UT` chi duoc la so hoac `NOT ESTIMATED`.

## Input bat buoc

Skill hien tai dua tren:

- `Requirement Summary`
- `Impact Matrix`
- `Affected Objects`

Neu evidence ho tro co san, skill tiep tuc doi chieu voi:

- Requirement
- QA
- Design
- Source
- DB
- API
- CSV
- Batch
- Flow
- Screen Definition

Neu thieu evidence:

- ghi `NOT FOUND IN DOCUMENT` cho gia tri khong tim thay
- ghi `NOT ESTIMATED` cho effort chua du bang chung
- hoac tra `INSUFFICIENT EVIDENCE` neu thieu dieu kien dau vao quan trong

## Phu thuoc truoc khi estimation

Skill nay duoc thiet ke de di sau:

- `business-analysis`
- `impact-analysis`

## Cach minh lam estimation theo skill hien tai

## 1. Doc tai lieu theo thu tu uu tien

Thu tu doc evidence:

1. Requirement
2. Screen Definition
3. Flow Diagram
4. Sequence Diagram
5. Database Definition
6. CSV Definition
7. API Definition
8. Existing Source Code
9. Existing System Behavior

Muc tieu:

- xac dinh chuc nang co that trong tai lieu
- xac dinh object bi anh huong
- xac dinh don vi xu ly chinh la screen, popup, CSV, batch, hay business flow

## 2. Xac dinh dinh danh chuc nang

Truoc khi breakdown, can chot:

- `ProgramID`
- `機能区分`
- `機能名`

Nguyen tac:

- lay dung tu tai lieu neu co
- giu nguyen tieng Nhat neu tai lieu dung tieng Nhat
- neu khong co thi ghi `NOT FOUND IN DOCUMENT`

## 3. Chi tao task khi co evidence

Day la rule cung:

- khong doan
- khong tu them chuc nang
- khong them task theo thoi quen du an
- khong suy dien neu tai lieu khong noi

Mot task chi duoc tao khi co evidence nhu:

- requirement id
- requirement line
- screen item
- flow node
- sequence step
- API endpoint
- CSV item
- table definition
- source code reference
- existing function

## 4. Breakdown theo Big / Medium / Small

### Big

`Big` la chuc nang tong the o muc business processing hoac man hinh.

Vi du:

- Tra cuu danh sach
- Them moi du lieu
- Cap nhat du lieu
- Xoa du lieu
- Export CSV
- Import CSV
- Xu ly popup
- Xu ly batch

### Medium

`Medium` la nhom xu ly chinh ben trong mot `Big`.

Rule bat buoc:

- ngan gon
- de hieu
- the hien mot muc tieu xu ly chinh
- khong trung muc tieu voi Medium khac trong cung Big
- du lon de estimate
- khong mo ta tung buoc ky thuat

Khong tao Medium rieng cho:

- validate
- goi API
- mapping request
- mapping response
- set loading
- hien thi message
- xu ly exception thong thuong
- lay tung master
- lay tung dropdown
- tung function hoac event ky thuat

### Quy tac khoi tao

Moi du lieu duoc tu dong lay khi mo man hinh deu thuoc:

- `Khoi tao man hinh` doi voi list/search/create screen
- `Khoi tao du lieu` doi voi detail/update/delete screen

Bao gom:

- nhan parameter
- thiet lap gia tri mac dinh
- lay du lieu chi tiet
- lay master
- lay du lieu dropdown
- lay quyen hoac trang thai
- hien thi du lieu ban dau
- thiet lap enable, disable, show, hide ban dau

Khong tach thanh Medium rieng nhu:

- Lay master
- Lay du lieu chi tiet
- Lay dropdown
- Hien thi du lieu ban dau

### Small

`Small` la cau mo ta ngan gon noi dung thuc hien cua `Medium`.

Rule bat buoc:

- bat dau bang dong tu xu ly
- noi truc tiep du lieu hoac chuc nang duoc xu ly
- uu tien cau truc `Thuc hien + noi dung xu ly + doi tuong`
- khong viet thanh doan giai thich dai
- khong liet ke chi tiet ky thuat nhu API, field, function, mapping, loading, message, hay technical event
- khong tach Small thanh nhieu dong chi vi khac API, field, function, message, hoac buoc xu ly ky thuat
- thuong chi nen la 1 cau ngan, uu tien duoi 15 tu neu van giu du nghia

Vi du dung:

- Thuc hien khoi tao man hinh danh sach ABC
- Thuc hien khoi tao man hinh tao moi ABC
- Thuc hien khoi tao du lieu cap nhat ABC
- Thuc hien tim kiem va hien thi danh sach ABC
- Thuc hien them moi du lieu ABC da nhap
- Thuc hien validate va luu du lieu ABC da thay doi
- Thuc hien export danh sach ABC ra CSV

Vi du sai vi qua vi mo:

- Goi API search
- Mapping request ABC
- Set loading
- Hien thi message thanh cong
- Goi function luu

## 5. Mau Medium chuan

### Man hinh danh sach

Chi su dung Medium phu hop voi evidence:

- `Khoi tao man hinh`
- `Thuc hien lay danh sach va hien thi du lieu`
- `Thuc hien export CSV`

Khong tach rieng:

- Tim kiem du lieu
- Goi API tim kiem
- Lay danh sach
- Mapping danh sach
- Hien thi danh sach

### Man hinh them moi

Medium chuan:

- `Khoi tao man hinh`
- `Thuc hien them moi du lieu`

Khong tach rieng:

- Validate du lieu
- Kiem tra trung
- Goi API them moi
- Xu ly response
- Hien thi message thanh cong

### Man hinh cap nhat

Medium chuan:

- `Khoi tao du lieu`
- `Thuc hien cap nhat du lieu`

Khong tach rieng:

- Lay du lieu chi tiet
- Hien thi du lieu
- Validate cap nhat
- Goi API cap nhat
- Hien thi message

## 6. Rule khong trung Medium va Small

Trong cung mot `Big`, cac Medium khong duoc chong cheo muc tieu.

Trong cung mot `Medium`, khong tao nhieu Small cho cung mot muc tieu xu ly.

Vi du sai:

- `Thuc hien tim kiem`
- `Lay danh sach`
- `Hien thi danh sach`

Phai merge thanh:

- `Thuc hien lay danh sach va hien thi du lieu`

Vi du sai:

- `Thuc hien validate du lieu da nhap`
- `Thuc hien goi API luu du lieu`
- `Thuc hien xu ly ket qua luu`

Phai merge thanh:

- `Thuc hien validate va luu du lieu da nhap`

## 7. Gan Type, Complexity, BE, FE, UT

Skill van giu nguyen rule hien tai:

- `Type`: `initialize`, `CRUD`, `Business`, `Batch`
- `Complexity`: `Low`, `Medium`, `High`

Rule effort moi:

- `BE` co effort khi co thay doi API, business logic server, DB, transaction, batch, interface, CSV server, hoac response
- `FE` co effort khi co thay doi giao dien, form, popup, nut, validate client, request tu man hinh, hoac hien thi ket qua
- `UT` la effort unit test cua cung task, khong tach thanh task rieng
- task khoi tao van co the co `BE > 0` neu can tao moi hoac sua API
- export CSV mac dinh `FE = 0` neu chi sua Backend
- neu chua du evidence de estimate thi dung `NOT ESTIMATED`

## 8. Dinh dang output

Bang output bat buoc:

| ProgramID | 機能区分 | 機能名 | Big | Medium | Small | Note | Type | Complexity | BE | FE | UT |

Chi dung gia tri effort nhu:

- `0`
- `0.25`
- `0.5`
- `0.75`
- `1`
- `1.5`
- `2`
- `NOT ESTIMATED`

Khong dung:

- `1 ngay`
- `1 MD`
- `1-2`
- `TBD`

## 9. Self-review truoc khi tra ket qua

Theo skill hien tai, can tu review:

1. Loai task khong co evidence
2. Loai task trung
3. Loai task qua vi mo
4. So lai voi granularity guide
5. Xac nhan moi dong van la mot goi estimation co y nghia nghiep vu
6. Xac nhan khong con Medium nao bi tach theo API, validate, mapping, loading, message, hoac master/dropdown rieng le
7. Xac nhan Small bat dau bang dong tu xu ly va khong bi tach theo API, field, function, hoac message
8. Xac nhan du lieu khoi tao da duoc gom vao `Khoi tao man hinh` hoac `Khoi tao du lieu`
9. Xac nhan task khoi tao co sua API da duoc estimate `BE`
10. Xac nhan export CSV chi sua Backend da co `FE = 0`
11. Xac nhan moi dong da co du `BE`, `FE`, `UT`
12. Xac nhan output dung thu tu cot va effort dung dinh dang

## Dau ra ly tuong cua skill

Mot dau ra tot se:

- co du `Big`, `Medium`, `Small`
- co `Type`, `Complexity`, `BE`, `FE`, `UT`
- khong tach Medium theo API/validate/loading/mapping/message
- Small ngan, ro, bat dau bang dong tu xu ly, va khong liet ke chi tiet ky thuat
- dua toan bo du lieu load khi mo man hinh vao `Khoi tao man hinh` hoac `Khoi tao du lieu`
- estimate effort theo object bi anh huong thuc te
- giu traceability voi requirement va impact analysis
