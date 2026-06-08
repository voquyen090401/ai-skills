# Test Design Rules

Apply these rules before and during testcase generation.

## Core Rules

- Do not generate testcase from assumption.
- Do not create business flow that is not evidenced.
- Do not create expected result that cannot be verified.
- Do not skip operation steps.
- Do not produce generic lines such as `He thong hoat dong dung`, `Khong loi`, or `Display dung`.
- Use `NOT FOUND IN DOCUMENT` for unsupported rules, fields, messages, transitions, DB effects, API effects, or permissions.

## ID Rule

Use sequential IDs with no gaps and no duplicates.

Example:

- `ITC_001`
- `ITC_002`
- `ITC_003`

## Test Type Rule

Use only applicable types:

- `App`
- `API`
- `DB`
- `CSV`
- `Batch`
- `Permission`
- `Regression`

## Summary Rule

Summary should represent the test group, not the tiny variation.

Examples:

- Verify screen display
- Verify search behavior
- Verify successful registration
- Verify successful update
- Verify required-field validation
- Verify access permission
- Verify CSV export
- Verify DB state after registration

## Pattern Rule

Pattern should describe the concrete condition or variation.

Examples:

- Verify title display
- Verify required field left empty
- Verify input exceeds max length
- Verify duplicate data registration
- Verify unauthorized user cannot update
- Verify API returns forbidden response

## Pre-condition Rule

Pre-condition must make the testcase reproducible.

Examples:

- User is on target screen
- User has update permission
- User does not have delete permission
- Record already exists in DB
- Duplicate record does not exist before registration
- CSV file is prepared with valid format

## Operation Step Rule

Write explicit execution steps.

Good:

1. Open the target screen.
2. Input valid customer code.
3. Click `Dang ky`.
4. Observe the message and resulting state.

Bad:

- Check screen
- Test registration
- Confirm function works

## Expected Result Rule

Expected result must be observable and checkable.

Good:

- Title `Login` is displayed.
- Error message `PIN khong dung` is shown.
- Screen transitions to target menu.
- Record is inserted into target table.
- Update button is disabled.

Bad:

- Works correctly
- Display correctly
- No error
- OK

## Mandatory Coverage Areas

Generate testcase for these areas when evidence exists:

- UI Display
- Initial or Default Value
- Search
- Register
- Update
- Delete
- Validation
- Permission
- API
- DB Verification
- CSV
- Batch
- Report
- Notification
- Workflow
- Regression

## Boundary Design Hints

Create boundary cases only when the rule exists in evidence.

Common candidates:

- Empty
- Null
- Space only
- Max length minus 1
- Max length
- Max length plus 1
- Half-width
- Full-width
- Special character
- Number
- Decimal
- Past date
- Future date

## Regression Rule

Do not skip regression.
Identify affected existing areas such as:

- Related screens
- Shared APIs
- Shared DB tables
- Batch jobs
- CSV import or export
- Reports
- Permissions
- Workflow transitions

## Quality Rule

Before final output, confirm:

- Every major requirement has evidence-backed coverage.
- Every matrix contributes to testcase design.
- Every testcase has concrete steps and concrete expected result.
- Duplicate testcase rows are removed.
- Generic testcase wording is removed.
