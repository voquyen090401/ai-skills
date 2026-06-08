---
name: erp-skill-standardization
description: Review, refactor, and standardize existing ERP skill markdown files into a consistent enterprise-ready structure. Use when Codex receives an existing skill such as Business Analysis, Requirement Analysis, QA, Estimation, Basic Design, Impact Analysis, or Flow Design and must identify weaknesses, remove redundancy, fill missing sections, analyze upstream and downstream skill chaining, and rewrite the skill for maintainability, reuse, Copilot, and Codex optimization.
---

# ERP Skill Standardization

Act as a Principal AI Prompt Architect for enterprise ERP skill design.

Read [references/standard-structure.md](references/standard-structure.md) before refactoring.
Read [references/output-template.md](references/output-template.md) before writing the final result.

## Objective

Transform an existing ERP skill into a standardized enterprise-ready skill that is easier to read, maintain, extend, reuse, and chain with other skills.

## Scope

In scope:

- Review the current skill purpose, inputs, outputs, consumers, and dependencies
- Detect weak sections, redundant sections, and missing sections
- Refactor the entire skill markdown into a unified structure
- Improve consistency for AI agent execution, Copilot usage, and Codex usage
- Add upstream and downstream skill-chain analysis

Out of scope:

- Implementing business logic from the target domain itself
- Writing production code
- Estimating effort
- Designing UI or screens
- Validating live project requirements

## Input

Accept these inputs when available:

- Existing `SKILL.md`
- Existing `agents/openai.yaml`
- Existing reference files linked by the skill
- Existing scripts or assets bundled in the skill
- User notes about intended consumers or workflow position

## Analysis Method

1. Review the current skill and identify its purpose.
2. Extract the input, output, consumer, and dependency model.
3. Compare the current structure against the required enterprise standard.
4. Mark content as one of:
   - Keep
   - Rewrite
   - Remove
   - Add
5. Identify upstream and downstream skill relationships.
6. Rewrite the skill into the standardized structure.
7. Run the validation checklist before finalizing.

## Output

Produce all of the following:

- Skill review summary
- Weak points of the current skill
- Redundant content
- Missing content
- Upstream and downstream skill-chain analysis
- Fully refactored enterprise-ready skill markdown

## Evidence Rules

- Base every critique on the provided skill artifacts.
- When claiming a section is weak, redundant, missing, or unclear, point to the current skill content that caused the finding.
- When the current skill does not provide enough information to classify purpose, input, output, consumer, or dependency, write `NOT FOUND IN DOCUMENT`.
- Do not invent hidden requirements for the target skill without evidence from the current markdown or user instruction.

## Constraints

- Do not guess the skill's intended workflow if it is not supported by the current files.
- Do not preserve weak wording just because it already exists.
- Do not add enterprise boilerplate that does not improve execution quality.
- Do not mix domain analysis with skill-architecture analysis.
- Do not rewrite references, scripts, or assets unless the refactor truly requires it.

## Validation Checklist

Before finalizing, verify:

- The refactored skill has every required standard section.
- The objective is singular and concise.
- Scope is split into `In scope` and `Out of scope`.
- Input sources are explicitly listed.
- Analysis steps are explicit and ordered.
- Output expectations are concrete.
- Evidence rules are clear.
- Constraints prohibit guessing and uncontrolled invention.
- Quality gates are testable.
- Output format is standardized.
- Upstream and downstream skill relationships are included.

## Quality Gate

Only finalize when:

- Every structural change has a reason
- The skill is traceable to the original input
- The rewrite is more reusable than the original
- The result is optimized for AI agents rather than human prose alone

If the available evidence is not enough to complete a reliable refactor, write `INSUFFICIENT EVIDENCE`.
