# AISkill

Kho nay tap trung cac ERP skill vao mot git repository chung de:

- quan ly version de dang
- tai su dung skill nhat quan
- refactor skill theo cung mot chuan
- de chaining giua BA, QA, Estimation, va Basic Design

## Cau truc repo

```text
skills/
  basic-design/
  business-analysis/
  erp-skill-standardization/
  estimation/
  qa/
```

Moi skill la mot thu muc doc lap, thuong gom:

- `SKILL.md`: huong dan chinh cua skill
- `agents/openai.yaml`: metadata hien thi va prompt mac dinh
- `references/`: tai lieu tham chieu chi nap khi can
- `scripts/`: script ho tro, neu skill can xu ly co tinh lap lai

## Danh sach skill

| Skill | Muc dich | Dung khi |
| --- | --- | --- |
| `business-analysis` | Phan tich requirement ERP theo huong evidence-first | Can tai dung he thong dang lam gi, se thay doi gi, va tong hop phan tich cho BA, SA, Dev, QA, Architect |
| `qa` | Review dac ta ERP theo goc nhin BA Nhat | Can tao QA gia tri cao, tim gap nghiep vu, state, downstream risk, concurrency, audit |
| `estimation` | Tach task estimation ERP theo bang chung | Can phan ra Big/Medium/Small task ma khong doan logic va khong estimate man-day |
| `basic-design` | Tao workbook Basic Design kieu MA | Can tao tai lieu thiet ke co cau truc Excel theo phong cach MA |
| `erp-skill-standardization` | Review va refactor skill ERP | Can chuan hoa mot skill hien co thanh ban enterprise-ready de de maintain va chaining |

## Cach dung nhanh

Dung ten skill theo dang `$skill-name` trong prompt. Vi du:

```text
Use $business-analysis to analyze the provided ERP requirement, flow, and design documents.
```

```text
Use $qa to review the provided ERP documents and output only high-value QA.
```

```text
Use $estimation to produce an evidence-based Big/Medium/Small task breakdown in Vietnamese.
```

```text
Use $basic-design to create an MA-style Basic Design workbook from the requirement inputs.
```

```text
Use $erp-skill-standardization to refactor the provided ERP skill into an enterprise-ready standard structure.
```

## Goi y chaining

Day la flow goi y de dung skill lien hoan:

1. `business-analysis`
2. `qa`
3. `estimation`
4. `basic-design`

Neu can nang cap hoac dong bo lai chat luong skill, dung:

1. `erp-skill-standardization`

## Nguyen tac dung skill

- Uu tien evidence-first
- Neu thieu bang chung, ghi ro `NOT FOUND IN DOCUMENT`
- Khong doan logic, khong tu them flow, status, API, table, validation
- Chi nap them file trong `references/` khi thuc su can
- Giu `SKILL.md` gon, dua noi dung tham chieu dai sang `references/`

## Quy uoc dat ten skill

- Dung lowercase va hyphen-case
- Ten thu muc phai trung voi `name:` trong `SKILL.md`
- Ten hien thi cho nguoi dung nam trong `agents/openai.yaml`

## Khi them hoac sua skill

Checklist toi thieu:

1. Tao thu muc moi trong `skills/`
2. Tao `SKILL.md` voi `name` va `description` ro rang
3. Them `agents/openai.yaml`
4. Tach tai lieu dai sang `references/` neu can
5. Cap nhat lai README nay

## Muc tieu cua repo nay

Repo nay uu tien cac skill:

- de doc
- de bao tri
- de mo rong
- de reuse
- de chaining
- toi uu cho Codex va AI agent
