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
- **Entry:** Claude: `/compass` · Copilot: `compass.prompt.md` · Codex: `.codex/AGENTS.md`
- **Gate:** Scaffold present → **Output:** `.specify/constitution.md` populated → **Next:** Phase 3

### Phase 3 — Define Features
- **Entry:** Claude: `/define-features` · Copilot: `define-features.prompt.md`
- **Gate:** Constitution complete → **Output:** Feature specs in `/specs/` → **Next:** Phase 4

### Phase 4 — Scaffold Project
- **Entry:** Claude: `/scaffold` · Copilot: `scaffold.prompt.md`
- **Gate:** Feature specs exist → **Output:** Architecture plan (no code) → **Next:** Phase 5

### Phase 5 — Fine-tune Plan
- **Entry:** Claude: `/fine-tune` · Copilot: `fine-tune.prompt.md`
- **Gate:** Scaffold plan exists → **Output:** `/tasks/` files with AC, model, branch → **Next:** Phase 6

### Phase 6 — Code
- **Entry:** Claude: `/implement` · Copilot: `implement.prompt.md`
- **Gate:** Task file + pre-impl tests exist → **Output:** Passing code on feature branch → **Next:** Phase 7

### Phase 7 — Test
- **Entry:** Claude: `/test` · Copilot: `test.prompt.md`
- **Gate:** Implementation on feature branch → **Output:** Test results, bug log → **Next:** Phase 7b

### Phase 7b — Review & Ship
- **Entry:** `/review` → `/cross-review` → `/pr-create` → `/merge`
- **Gate:** All ACs pass → **Output:** Approved PR merged → **Next:** Phase 8 or next feature

### Phase 8 — Maintain
- **Entry:** Claude: `/maintain` · Copilot: `maintain.prompt.md`
- **Gate:** Feature shipped → **Output:** Updated docs, compliance report → **Next:** Next cycle

### Bug Track (Parallel)
- **Entry:** Claude: `/bug` · Copilot: `bug.prompt.md` — invoke from any phase
- **Fix flow:** `/bugfix` — reproduce → diagnose → fix → verify → PR

## Quick Reference

| Section | Reference |
|---------|-----------|
| Agent routing, branches, concurrency | `workflow/ROUTING.md` |
| Build/test/lint commands, code conventions | `workflow/COMMANDS.md` |
| Boundaries (always/ask/never), bug tracking | `workflow/BOUNDARIES.md` |
| Specification workflow, artifact paths | `workflow/SPECS.md` |
| Lifecycle phases (detailed) | `workflow/LIFECYCLE.md` |
| Phase execution gates | `workflow/PLAYBOOK.md` |
| Artifact ownership & contracts | `workflow/FILE_CONTRACTS.md` |
| Failure routing & escalation | `workflow/FAILURE_ROUTING.md` |
| Policy changes | `governance/CHANGE_PROTOCOL.md` |
| Policy validation | `governance/POLICY_TESTS.md` |
| File registry | `governance/REGISTRY.md` |
| Orchestrator state | `workflow/STATE.json` |
