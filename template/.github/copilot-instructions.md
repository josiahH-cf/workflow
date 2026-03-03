# Copilot Instructions

## Project Standards

- Read `/AGENTS.md` before starting any task
- Follow `/workflow/PLAYBOOK.md` for phase gates and `/workflow/FILE_CONTRACTS.md` for artifact requirements
- Follow `/workflow/FAILURE_ROUTING.md` when blocked

## Completions

- Match naming conventions and patterns in the file being edited
- Prefer explicit types over inferred when the language supports both
- Do not generate placeholder or TODO comments

## Code Review

- Flag functions over 50 lines
- Flag nesting deeper than 3 levels
- Flag missing error handling on I/O operations
- Flag tests that assert only the happy path
- Flag hardcoded values that should be configuration
- Verify every acceptance criterion from the linked spec has a test
- Verify task file criteria mappings (`AC-*`) align with tests and PR evidence

## PR Descriptions

- State what changed, why, and how to verify
- Link the Feature ID plus matching spec/task files
- List files changed, grouped by concern

## Coding Agent

- Read the linked spec before starting
- Do not modify files outside the scope described in the issue
- Treat `/AGENTS.md` and `/workflow/*.md` as canonical; do not redefine policy in ad hoc notes
