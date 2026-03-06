# AGENTS

Canonical entrypoint for all coding agents. Read this first, then follow links to detailed references.

## Overview

`[PROJECT-SPECIFIC]` — Filled during Compass phase (Phase 2).

## Workflow Phases

The project lifecycle follows 8 phases plus a parallel Bug Track.

### Phase 1 — Scaffold Import
- **Entry:** Run `initialization.md` meta-prompt
- **Gate:** Empty or new project repository → **Output:** Scaffold files placed → **Next:** Phase 2

### Phase 2 — Compass
- **Entry:** Claude: `/compass` · Copilot: `phase-2-compass.prompt.md` · Codex: `.codex/AGENTS.md`
- **Gate:** Scaffold present → **Output:** `.specify/constitution.md` populated (themes addressed, ambiguities documented) → **Next:** Phase 3

### Phase 3 — Define Features
- **Entry:** Claude: `/define-features` · Copilot: `phase-3-define-features.prompt.md`
- **Gate:** Constitution complete → **Output:** Feature specs in `/specs/` → **Next:** Phase 4

### Phase 4 — Scaffold Project
- **Entry:** Claude: `/scaffold` · Copilot: `phase-4-scaffold.prompt.md`
- **Gate:** Feature specs exist → **Output:** Architecture plan, `workflow/COMMANDS.md` finalized (no code) → **Next:** Phase 5

### Phase 5 — Fine-tune Plan
- **Entry:** Claude: `/fine-tune` · Copilot: `phase-5-fine-tune.prompt.md`
- **Gate:** Scaffold plan exists → **Output:** `/tasks/` files with AC, model, branch → **Next:** Phase 6

### Phase 6 — Code
- **Entry:** Claude: `/implement` · Copilot: `phase-6-implement.prompt.md`
- `/implement` is **direct single-feature execution** — use when you know which feature to build
- **Session mode:** `/build-session` — sustained multi-feature implementation session
- **Gate:** Task file + pre-impl tests exist → **Output:** Passing code on feature branch → **Next:** Phase 7

### Phase 7 — Test
- **Entry:** Claude: `/test` · Copilot: `phase-7-test.prompt.md`
- **Gate:** Implementation on feature branch → **Output:** Test results, bug log → **Next:** Phase 7b

### Phase 7b — Review & Ship
- **Entry:** Claude: `/review-session` · Copilot: `phase-7d-review-session.prompt.md`
- **Optional:** `/cross-review` — second-opinion review from a different agent
- **Gate:** All ACs pass → **Output:** Approved PR merged → **Next:** Phase 8 or next feature

### Phase 8 — Maintain
- **Entry:** Claude: `/maintain` · Copilot: `phase-8-maintain.prompt.md`
- **Gate:** Feature shipped → **Output:** Updated docs, compliance report → **Next:** Next cycle

### Bug Track (Parallel)
- **Entry:** Claude: `/bug` · Copilot: `phase-7b-bug.prompt.md` — invoke from any phase
- **Fix flow:** `/bugfix` — reproduce → diagnose → fix → verify → PR

### Orchestrator
- **Entry:** Claude: `/continue` · Copilot: `phase-9-continue.prompt.md`
- `/continue` is the **orchestrator**, not a direct implementation command. It reads `workflow/STATE.json`, determines the next action (including bug-routing), dispatches to the appropriate phase command, and auto-advances. At Phase 6 it delegates to `/implement`.
- See `workflow/ORCHESTRATOR.md` for the loop contract

## Quick Reference

| Section | Reference |
|---------|-----------|
| Agent routing, branches, concurrency | `workflow/ROUTING.md` |
| Concurrency safety, drift detection | `workflow/CONCURRENCY.md` |
| Build/test/lint commands, code conventions | `workflow/COMMANDS.md` |
| Boundaries (best practices, review points, avoid patterns), bug tracking | `workflow/BOUNDARIES.md` |
| Lifecycle phases (detailed) | `workflow/LIFECYCLE.md` |
| Phase execution gates | `workflow/PLAYBOOK.md` |
| Artifact ownership & contracts | `workflow/FILE_CONTRACTS.md` |
| Failure routing & escalation | `workflow/FAILURE_ROUTING.md` |
| Autonomous loop contract | `workflow/ORCHESTRATOR.md` |
| Policy changes | `governance/CHANGE_PROTOCOL.md` |
| Policy validation | `governance/POLICY_TESTS.md` |
| File registry | `governance/REGISTRY.md` |
| Orchestrator state | `workflow/STATE.json` |
