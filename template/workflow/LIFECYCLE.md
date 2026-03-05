# Feature Lifecycle

This file is the lifecycle index. For execution and validation rules, use:

- `/workflow/PLAYBOOK.md`
- `/workflow/FILE_CONTRACTS.md`
- `/workflow/FAILURE_ROUTING.md`

## Project-Level Phases (V2 Agentic Workflow)

The project lifecycle follows 8 phases plus a parallel Bug Track. These are one-time or periodic phases that establish the project foundation.

| Phase | Input | Action | Output |
| ----- | ----- | ------ | ------ |
| 1. Scaffold Import | Empty/new repo | Run `initialization.md` | Scaffold files placed |
| 2. Compass | Scaffold in place | Adaptive interview (`/compass`) | `.specify/constitution.md`, AGENTS.md Overview |
| 3. Define Features | Constitution | Feature interview (`/define-features`) | Feature specs with Compass mapping |
| 4. Scaffold Project | Feature specs | Architecture reasoning (`/scaffold`) | AGENTS.md Code Conventions + Core Commands |
| 5. Fine-tune Plan | Architecture plan | Spec + task finalization (`/fine-tune`) | Updated specs + `/tasks/[feature-id]-[slug].md` with task/model/branch mappings |
| 6. Code | Fine-tuned specs + task files + pre-tests | TDD implementation (`/implement`) | Passing code on feature branches |
| 7. Test | Feature branch state | `pre` mode: failing tests, `post` mode: AC verification (`/test`) | Test results, bug log entries |
| 8. Maintain | Shipped features | Documentation + compliance (`/maintain`) | README, CONTRIBUTING, compliance report |
| Bug Track | Any phase | Bug logging (`/bug`) + fixing (`/bugfix`) | Bug log entries, fix PRs |

Use `/continue` to auto-advance through phases based on exit criteria and persisted orchestrator state in `/workflow/STATE.json`.

## Feature-Level Phases (Per-Feature Lifecycle)

> **Note on phase numbering:** Project-Level Phases (above) run once per project setup. Feature-Level Phases (below) run once per feature, nested within Project Phases 3–8. When `continue.md` refers to "Phase 6", it means the Project-Level Code phase. Inside Phase 6, the Feature-Level cycle (Scope → Plan → Test → Implement → Review → PR → Merge) applies to each feature. The two numbering systems are independent — a feature at Feature-Level Phase 4 (Implement) is still within Project-Level Phase 6 (Code).


Every phase produces a named artifact; the next phase consumes it.

| Phase | Input | Action | Output | Who |
| ----- | ----- | ------ | ------ | --- |
| 0. Ideate | Raw idea | Human writes GitHub Issue | Issue (labeled `status:idea`) | Human |
| 1. Scope | Issue | Scoping process | `/specs/[feature-id]-[slug].md` + label → `status:scoped` | Any agent |
| 2. Plan | Spec | Planning process | `/tasks/[feature-id]-[slug].md` + label → `status:planned` | Any agent |
| 3. Test | Tasks | Test authoring process | Committed failing tests + label → `status:tests-written` | Any agent |
| 4. Implement | Tests + Tasks | Implementation process (per task) | Passing code + label → `status:implemented` | Any agent |
| 5. Review | Branch diff + Spec | Review process + cross-agent review | PASS/FAIL report with criterion evidence + label → `status:reviewed` | Different agent |
| 6. PR | Review pass | PR creation process | Open PR | Any agent |
| 7. Merge | Approved PR | Human merges | Merged + branch deleted + label → `status:done` | Human |

## Label Conventions

- `status:idea`  -  raw, unscoped
- `status:scoped`  -  spec written, ready to plan
- `status:planned`  -  tasks written, ready to build
- `status:tests-written`  -  failing tests committed
- `status:implemented`  -  all tasks complete, tests pass
- `status:reviewed`  -  cross-agent review passed
- `status:done`  -  merged

- `size:S` / `size:M` / `size:L`  -  effort estimate
- `agent:claude` / `agent:codex` / `agent:copilot`  -  assigned agent (optional)

## Bulk Issue Creation

When creating multiple features, write all issues first (labeled `status:idea`), then scope them one at a time. Each issue must be independently actionable; note explicit dependencies in the issue body.

## Feature Identity

- Feature ID format: `[issue-id]-[slug]` (example: `42-user-auth`)
- Spec and task files must share the same feature ID
- Criteria IDs in spec: `AC-1..N`
- Task IDs in tasks file: `T-1..N`
- Orchestration state file: `/workflow/STATE.json`
