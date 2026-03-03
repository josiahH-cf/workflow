# Claude Code  -  Session Rules

@AGENTS.md

Canonical workflow policy lives in `AGENTS.md`, `/workflow/*.md`, and `/governance/*.md`.
This file is an adapter for Claude-specific session mechanics.

## Context Discipline

- Start every task in a fresh session
- Compact at 60 percent context usage  -  do not wait until 95 percent
- If you compact more than twice, stop  -  the task is too large
- Include only files the current task touches via @ references
- Never carry planning context into implementation  -  write to a file, clear, restart

## Planning

- Begin complex work in Plan Mode
- Write plans to `/specs/` or `/tasks/`  -  never keep plans only in chat

## Testing

- Follow `/workflow/PLAYBOOK.md` and `/workflow/FILE_CONTRACTS.md` for phase gates and evidence
- Use a subagent for test verification when the test suite is large

## Implementation

- One task per session
- Orient first: read the task file, relevant source files, and test file before writing
- Follow existing patterns  -  read before writing
- When uncertain, write the decision to `/decisions/` before proceeding

## Scope Discipline

- Do not add code style rules here  -  linters enforce style
- Do not generate entire modules in a single pass
- Do not refactor code outside the current task scope

## Escalation

- Use `/workflow/FAILURE_ROUTING.md` for retry, model-switch, and escalation paths
- If policy docs conflict, follow precedence in `AGENTS.md`

## Personal Overrides

- Use `/CLAUDE.local.md` (project root, gitignored) for personal behavioral preferences
- Use `.claude/settings.local.json` (inside `.claude/`, gitignored) for permission-mode overrides (YOLO)
- Do not put project rules in either local file

## File References

- Specs: `/specs/[feature-id]-[slug].md`
- Tasks: `/tasks/[feature-id]-[slug].md`
- Decisions: `/decisions/[NNNN]-[slug].md`
- ExecPlan template: `/.codex/PLANS.md`
