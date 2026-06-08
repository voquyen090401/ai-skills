# Standard Structure

Every refactored ERP skill must use the following structure in this order:

1. `# Skill Name`
2. `# Objective`
3. `# Scope`
4. `# Input`
5. `# Analysis Method`
6. `# Output`
7. `# Evidence Rules`
8. `# Constraints`
9. `# Validation Checklist`
10. `# Quality Gate`
11. `# Output Format`
12. `# Upstream Skill`
13. `# Downstream Skill`

## Section Rules

### Objective

- State only why the skill exists.
- Keep it concise.
- Do not drift into workflow detail.

### Scope

Split clearly into:

- `In scope`
- `Out of scope`

### Input

List all allowed data sources explicitly.

### Analysis Method

Use numbered steps.
Do not write free-form paragraphs.

### Output

State exactly what the skill must produce.

### Evidence Rules

Require evidence for every conclusion.
If evidence is missing, write `NOT FOUND IN DOCUMENT`.

### Constraints

Always prohibit:

- Guessing
- Uncontrolled inference
- Adding logic
- Adding flow
- Adding requirement
- Adding table
- Adding API

### Validation Checklist

At minimum check:

- Evidence exists
- No screens are omitted
- No rules are omitted
- No validations are omitted
- No statuses are omitted
- No emails are omitted
- No APIs are omitted

### Quality Gate

Only allow final output when:

- There is enough evidence
- There is no speculative logic
- The output is traceable

If not, write `INSUFFICIENT EVIDENCE`.

### Output Format

Use these sections:

- `## Executive Summary`
- `## Findings`
- `## Analysis`
- `## Evidence`
- `## Issues`
- `## Recommendations`
- `## Refactored Skill`

### Upstream Skill

State which skill or artifacts provide input to the target skill.

### Downstream Skill

State which later skills consume the target skill's output.
