# Agent Routing, Branches & Concurrency

> Referenced from `AGENTS.md`. This is part of the canonical workflow — see `/governance/REGISTRY.md`.

## Agent Routing Matrix

Model assignment is determined by the rule set below. The developer does not select the model manually unless overriding.

| Task Type | Assigned Model | Branch Prefix | Reason |
|-----------|---------------|---------------|--------|
| Complex architecture, refactoring | Claude | `claude/` | Deep reasoning, large context |
| UI/frontend, iterative design | Copilot | `copilot/` | Fast iteration, inline suggestions |
| Batch operations, migrations | Codex | `codex/` | Unattended execution, structured plans |
| Bug reproduction & fix | Claude | `claude/` | Diagnostic reasoning |
| Test writing | Claude or Copilot | varies | Depends on complexity |
| Documentation, boilerplate | Copilot | `copilot/` | Fast generation |
| CI/CD, infrastructure | Codex | `codex/` | Deterministic execution |

## Branch Naming

Format: `model/type-short-description`

- **model:** `claude`, `copilot`, or `codex` (matches the agent doing the work)
- **type:** `feat`, `bug`, `refactor`, `chore`, `docs`
- **short-description:** 2–4 word kebab-case summary

Examples:

- `claude/feat-auth-flow`
- `copilot/feat-dashboard-layout`
- `codex/bug-login-crash`
- `claude/refactor-db-queries`

## Concurrency Rules

- Worktree pattern: `.trees/<model>-<task>/`
- Max parallel agents: `3` (override in AGENTS.md if needed)
- Rule: never two agents editing the same file simultaneously
- Setup: `scripts/setup-worktree.sh <model> <type> <description>`

## Concurrency-Aware Task Assignment

When assigning tasks for parallel execution:

1. Verify no file overlap between tasks (check `Files:` fields in task files)
2. If overlap exists, reassign to a single agent or redesign the split
3. Run `scripts/clash-check.sh` after worktree creation to detect existing conflicts
4. See `workflow/CONCURRENCY.md` for full concurrency safety reference
