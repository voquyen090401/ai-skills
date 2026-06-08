# Output Template

Use this shape for the final response.

## Executive Summary

- What the current skill is trying to do
- Whether it is enterprise-ready or not
- Main refactor direction

## Findings

### Weak Points

- List structural weaknesses
- List wording weaknesses
- List execution weaknesses

### Redundant Parts

- List duplicated guidance
- List sections that repeat the same rule
- List enterprise boilerplate that adds no value

### Missing Parts

- Missing standard sections
- Missing dependency analysis
- Missing evidence rules
- Missing quality controls

## Analysis

### Purpose

Explain what problem the current skill solves.

### Input

List what documents or artifacts the skill needs.

### Output

List what the skill produces.

### Consumer

List likely consumers such as:

- BA
- SA
- Dev
- QA
- PM
- Architect

### Dependency

State:

- Which upstream skills provide data
- Which downstream skills consume the output

## Evidence

For each major finding, cite the relevant part of the current skill or supporting files.
If not available, write `NOT FOUND IN DOCUMENT`.

## Issues

List the risks if the skill remains unrefactored.

## Recommendations

List the refactor decisions that should be applied.

## Refactored Skill

Output the full enterprise-ready rewritten skill using the standardized structure.
