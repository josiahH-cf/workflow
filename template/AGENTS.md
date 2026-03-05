# AGENTS

Canonical entrypoint for all coding agents. This is the universal routing hub — every agent reads this first.

## Overview

`[PROJECT-SPECIFIC]` — Filled during Compass phase (Phase 2). One paragraph describing what this project is, who it serves, and what success looks like.

## Workflow Phases

The project lifecycle follows 8 phases plus a parallel Bug Track. Each phase has entry commands per platform, a gate (what must be true before starting), and an output.

### Phase 1 — Scaffold Import

- **Purpose:** Import workflow files into the project and establish baseline structure
- **Entry:** Run `initialization.md` meta-prompt
- **Gate:** Empty or new project repository
- **Output:** Scaffold files placed, project ready for Compass
- **Next:** Automatically triggers Phase 2

### Phase 2 — Compass

- **Purpose:** Adaptive interview to establish project identity, goals, and boundaries
- **Entry:** Claude: `/compass` · Copilot: `compass.prompt.md` · Codex: see `.codex/AGENTS.md`
- **Gate:** Scaffold files present
- **Output:** `.specify/constitution.md` populated, `AGENTS.md` Overview section filled
- **Next:** Phase 3

### Phase 3 — Define Features

- **Purpose:** Translate the Compass into a concrete feature set with priorities
- **Entry:** Claude: `/define-features` · Copilot: `define-features.prompt.md`
- **Gate:** Constitution exists and is complete
- **Output:** Feature specs in `/specs/`, mapped to Compass capabilities
- **Next:** Phase 4

### Phase 4 — Scaffold Project

- **Purpose:** Reason about technical architecture from the feature set — produce a plan, not code
- **Entry:** Claude: `/scaffold` · Copilot: `scaffold.prompt.md`
- **Gate:** Feature specs exist
- **Output:** Proposed folder structure, dependency list, environment declarations, unresolved questions
- **Next:** Phase 5

### Phase 5 — Fine-tune Plan

- **Purpose:** Create ordered, model-assigned feature specs with branches and acceptance criteria
- **Entry:** Claude: `/fine-tune` · Copilot: `fine-tune.prompt.md`
- **Gate:** Scaffold plan exists
- **Output:** Ordered specs with ACs, model assignments, branch names. Second-model review completed.
- **Next:** Phase 6

### Phase 6 — Code

- **Purpose:** Implement features following TDD from the spec
- **Entry:** Claude: `/implement` · Copilot: `implement.prompt.md`
- **Gate:** Fine-tuned spec with ACs exists for the assigned feature
- **Output:** Passing code on a feature branch, tests written before implementation
- **Next:** Phase 7

### Phase 7 — Test & Mark Changes

- **Purpose:** Run tests against acceptance criteria, log bugs, verify behavior
- **Entry:** Claude: `/test` · Copilot: `test.prompt.md`
- **Gate:** Implementation exists on feature branch
- **Output:** Test results, bug log entries, updated spec if behavior deviated
- **Note:** `/test` has two modes — run in **pre-implementation mode** (before `/implement`) to author failing tests, and **post-implementation mode** (after `/implement`) to verify all ACs pass.
- **Next:** Phase 7b (or back to Phase 6 if failures)


### Phase 7b — Review & Ship

- **Purpose:** Review implementation against spec; create and merge PR
- **Entry:** Claude: `/review`, then `/cross-review`, then `/pr-create`, then `/merge`
- **Gate:** All ACs pass, no blocking bugs
- **Output:** Approved PR merged to main
- **Next:** Phase 8 (or next feature's Phase 6)

### Phase 8 — Maintain

- **Purpose:** Produce/update documentation, enforce standards, check compliance
- **Entry:** Claude: `/maintain` · Copilot: `maintain.prompt.md`
- **Gate:** Feature shipped or periodic trigger
- **Output:** Updated README, CONTRIBUTING, release notes, compliance report
- **Next:** Next feature cycle or done

### Delivery Pipeline (V1 Commands)

These commands handle the Review → PR → Merge flow for each feature branch. They are invoked as Phase 7b and are also available standalone:

- `/review` — Review completed feature branch against spec and acceptance criteria
- `/cross-review` — Independent second-agent review of the same branch (different model)
- `/pr-create` — Create pull request with AC evidence, review summary, and rollback plan
- `/merge` — Assist with merge checklist; confirms all gates are met before merging

> **V1 vs V2:** The commands above are V1 commands that integrate into the V2 workflow at Phase 7b. All other phases (2–8) use V2 commands (`/compass`, `/define-features`, `/scaffold`, `/fine-tune`, `/implement`, `/test`, `/maintain`, `/continue`). Use `/continue` to orchestrate automatically — it will invoke these delivery commands at the right time.

### Bug Track (Parallel)

- **Purpose:** Capture bugs discovered during any phase without interrupting workflow
- **Entry:** Claude: `/bug` · Copilot: `bug.prompt.md`
- **Gate:** None — can be invoked from any phase
- **Output:** Structured bug log entry. Backlog review cycle treats bugs as specs.
- **Fix flow:** `/bugfix` — reproduce (failing test) → diagnose → fix → verify → PR

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

## Core Commands

| Command | Value |
|---------|-------|
| Install | `[PROJECT-SPECIFIC]` |
| Build | `[PROJECT-SPECIFIC]` |
| Test (all) | `[PROJECT-SPECIFIC]` |
| Test (single) | `[PROJECT-SPECIFIC]` |
| Lint | `[PROJECT-SPECIFIC]` |
| Format | `[PROJECT-SPECIFIC]` |
| Type-check | `[PROJECT-SPECIFIC]` |

## Code Conventions

`[PROJECT-SPECIFIC]` — Filled during Scaffold Project phase (Phase 4). Includes language, style guide, architecture patterns, naming conventions.

## Specification Workflow

All work flows from specifications:

1. Read `.specify/constitution.md` before any implementation — it is the project's identity
2. Check `/specs/` for the current feature spec (copy `.specify/spec-template.md` when creating new specs)
3. Write acceptance criteria using `.specify/acceptance-criteria-template.md` as reference
4. Verify all acceptance criteria pass before creating a PR

Spec artifacts:

- Constitution: `.specify/constitution.md`
- Spec template: `.specify/spec-template.md`
- AC template: `.specify/acceptance-criteria-template.md`
- Per-feature specs: `/specs/[feature-id]-[slug].md`
- Task breakdowns: `/tasks/[feature-id]-[slug].md`
- Decisions: `/decisions/[NNNN]-[slug].md`

## Concurrency Rules

- Worktree pattern: `.trees/<model>-<task>/`
- Max parallel agents: `3` (override in AGENTS.md if needed)
- Rule: never two agents editing the same file simultaneously
- Setup: `scripts/setup-worktree.sh <model> <type> <description>`

## Boundaries

### ALWAYS

- Read the spec before implementation
- Run tests before commit
- Include acceptance criteria evidence in every PR
- Follow branch naming conventions
- Reference the constitution for alignment on any design decision

### ASK FIRST

- Adding new dependencies
- Modifying CI workflows
- Changing the constitution (use `/compass-edit`)
- Modifying this file (`AGENTS.md`)
- Architectural decisions not covered by the spec

### NEVER

- Commit secrets or `.env` files
- Modify files outside the assigned scope
- Auto-merge without human approval
- Skip tests
- Make decisions not traceable to a spec or constitution principle

## Bug Tracking

Use `/bug` (Claude) or `bug.prompt.md` (Copilot) from any phase:

```
Description: [what's wrong]
Location: [file:line or component]
Phase found: [which phase discovered this]
Severity: blocking | non-blocking
Expected: [what should happen]
Actual: [what does happen]
Fix-as-you-go: yes | no
```

- Small bugs (fix-as-you-go = yes): fix in place, log the fix
- Large bugs: add to backlog as a spec, assign model + branch when picked up
- Backlog review cycle: treat queued bugs as specs with full AC/branch/model assignment

## Reference Index

- Lifecycle map: `/workflow/LIFECYCLE.md`
- Phase execution contract: `/workflow/PLAYBOOK.md`
- Artifact ownership: `/workflow/FILE_CONTRACTS.md`
- Failure routing: `/workflow/FAILURE_ROUTING.md`
- Policy changes: `/governance/CHANGE_PROTOCOL.md`
- Policy tests: `/governance/POLICY_TESTS.md`
- File registry: `/governance/REGISTRY.md`
