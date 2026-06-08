# AISkill

AISkill la kho chua cac ERP skill dung chung cho Codex va AI agent, tap trung vao cac bai toan phan tich, review, thiet ke, implementation, va test specification trong du an ERP kieu Nhat.

Muc tieu cua repo:

- quan ly version skill tap trung
- tai su dung skill nhat quan giua nhieu du an
- standardize cau truc va chat luong skill
- toi uu cho chaining giua BA, QA, Estimation, Design, Implementation, va Testing
- giu moi skill de doc, de maintain, de mo rong

## Repo Structure

```text
skills/
  basic-design/
  business-analysis/
  estimation/
  feature-implementation/
  qa/
  tsc-generation/
```

Moi skill la mot thu muc doc lap. Cau truc thuong gap:

- `SKILL.md`: huong dan chinh, workflow, constraints, va quality gate
- `agents/openai.yaml`: metadata hien thi va default prompt
- `references/`: tai lieu tham chieu, template, output structure, rules
- `scripts/`: script ho tro cho cac tac vu lap lai hoac can tinh on dinh

## Skill Catalog

| Skill | Vai tro chinh | Dung khi nao |
| --- | --- | --- |
| `business-analysis` | phan tich requirement ERP theo huong evidence-first | can tai dung he thong dang lam gi, logic hien tai la gi, se thay doi gi, va tong hop phan tich cho BA, SA, Dev, QA, Estimation, Architect |
| `qa` | review dac ta ERP theo goc nhin BA Nhat cap cao | can tim business gap, missing state, missing condition, downstream risk, concurrency risk, audit risk, production risk |
| `estimation` | tach task estimation ERP theo bang chung | can phan ra Big, Medium, Small task theo work package ma khong doan logic va khong estimate man-day |
| `basic-design` | tao hoac cap nhat workbook Basic Design kieu MA | can sinh file `.xlsx` review-ready theo format Basic Design cua du an Nhat |
| `feature-implementation` | implement feature ERP tren codebase hien co | can di tu requirement, QA, design, source investigation, impact analysis den code change va test ma khong doan logic |
| `tsc-generation` | sinh Test Specification Case chi tiet | can tao TSC execute duoc truc tiep, co matrix coverage, test data, boundary, regression, va quality gate |

## Suggested Usage

Goi skill bang ten `$skill-name` trong prompt. Vi du:

```text
Use $business-analysis to analyze the provided ERP requirement, design, flow, and source artifacts.
```

```text
Use $qa to review the provided ERP documents and output only high-value QA.
```

```text
Use $estimation to produce an evidence-based Big/Medium/Small ERP task breakdown in Vietnamese.
```

```text
Use $basic-design to create an MA-style Basic Design workbook from the provided requirement inputs.
```

```text
Use $feature-implementation to implement the ERP feature from the provided requirement, QA, design, and source artifacts.
```

```text
Use $tsc-generation to generate a detailed ERP Test Specification Case from the provided requirement, design, source, and project TSC sample.
```

## Suggested Chaining

Tuy theo muc tieu, co the dung skill theo cac flow sau.

### 1. Requirement to review flow

1. `business-analysis`
2. `qa`
3. `estimation`

### 2. Requirement to design flow

1. `business-analysis`
2. `qa`
3. `basic-design`

### 3. Requirement to implementation flow

1. `business-analysis`
2. `qa`
3. `feature-implementation`

### 4. Requirement to testing flow

1. `business-analysis`
2. `qa`
3. `tsc-generation`

## Shared Principles

Tat ca skill trong repo nay uu tien cac nguyen tac sau:

- evidence-first
- khong doan logic
- khong tu them flow, state, table, API, validation, permission, message
- neu thieu bang chung thi ghi ro `NOT FOUND IN DOCUMENT`, `NOT FOUND IN REQUIREMENT`, hoac thong diep tuong ung theo rule cua skill
- uu tien partial but correct hon la complete but guessed
- giu `SKILL.md` gon, day noi dung dai sang `references/` khi phu hop
- output phai huu ich de dung tiep, khong chi de doc

## Naming Convention

- ten skill dung lowercase va hyphen-case
- ten thu muc phai trung voi `name:` trong `SKILL.md`
- ten hien thi cho UI nam trong `agents/openai.yaml`
- chi tao `scripts/`, `references/`, `assets/` khi thuc su can

## When Adding Or Updating A Skill

Checklist toi thieu:

1. Tao hoac cap nhat thu muc trong `skills/`
2. Dam bao `SKILL.md` co `name` va `description` ro rang
3. Them hoac cap nhat `agents/openai.yaml`
4. Tach rule, template, output format dai sang `references/` neu can
5. Bo sung `scripts/` neu co phan xu ly lap lai can tinh on dinh
6. Cap nhat README nay neu repo structure hoac skill catalog thay doi

## Repository Intent

Repo nay khong chi la noi luu prompt. Day la bo skill ERP huong enterprise, duoc thiet ke de:

- giup Codex tai lap quy trinh lam viec on dinh
- giam kha nang hallucination trong bai toan ERP
- de mo rong thanh workflow chaining giua cac phase
- de review va refactor skill theo mot chuan chung
- de dung lai tren nhieu du an va nhieu artifact khac nhau
