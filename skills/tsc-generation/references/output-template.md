# Output Template

Use the following structure unless the user asks for a narrower scope or provides a project-specific TSC template that must be followed.

## 1. Input Analysis

| Input | Role | Used | Note |
| --- | --- | --- | --- |

Also identify:

- Target screen
- Target function
- API scope
- DB scope
- CSV scope
- Batch scope
- Permission scope
- Regression scope

## 2. Function Decomposition

| Function | Sub Function | Action | Evidence |
| --- | --- | --- | --- |

## 3. Field Matrix

| Field | Type | Display | Input | Required | Length | Format | Default | Search | Register | Update | DB Column | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

## 4. CRUD Matrix

| Function | Create | Read | Update | Delete | Search | Export | Import | Need Test | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

## 5. Coverage Matrix

| Area | Coverage Required | Test Required | Reason |
| --- | --- | --- | --- |

## 6. Boundary Matrix

| Field | Rule | Normal | Boundary | Abnormal | Evidence |
| --- | --- | --- | --- | --- | --- |

## 7. Test Data Design

| Data ID | Purpose | Input Data | DB Precondition | Expected Use |
| --- | --- | --- | --- | --- |

## 8. Risk Based Priority

| Area | Risk | Priority | Reason |
| --- | --- | --- | --- |

Priority values:

- `Critical`
- `High`
- `Medium`
- `Low`

## 9. Test Specification Case

| ID | Test Type | Summary | Pattern | Pre-condition | Operation Step | Expected Result | Result Round 1 | Result Round 2 | Comment |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

## 10. Regression Checklist

| Area | Impacted | Why | Required Test |
| --- | --- | --- | --- |

## 11. TSC Quality Gate

| Check Item | Status | Note |
| --- | --- | --- |

Suggested check items:

- Requirement covered
- QA covered
- Basic Design covered
- UI Display covered
- Field Matrix covered
- CRUD covered
- Validation covered
- Boundary covered
- Business Rule covered
- API covered
- DB covered
- CSV assessed
- Batch assessed
- Permission covered
- Error Message covered
- Regression covered
- Test Data sufficient
- Expected Result clear
- No duplicate testcase
- No generic testcase

Status values:

- `PASS`
- `FAIL`
- `NOT APPLICABLE`

If any row is `FAIL`, add missing testcase or state why the gap remains blocked.
