# R-001: `/continue` FAST Router Decision Forks

## Problem

`/continue` routes deterministically from state but does not proactively ask at decision forks where multiple logical next actions are valid.

## Goal

Add a non-disruptive FAST router layer that:
- asks a full mini-checklist only at true forks
- checks before Phase 6 implement loops
- checks before maintain/operationalize entry
- continues autonomously when no fork exists

## Expected Behavior

1. Detect ambiguity/fork before dispatch.
2. Ask concise but complete checklist once.
3. Prioritize blockers first.
4. Proceed immediately after responses.
5. Avoid repeated questioning in the same loop unless state changes.

## Candidate Files

- `meta-prompts/phase-10-continue.md`
- `template/workflow/ORCHESTRATOR.md`
- `template/workflow/LIFECYCLE.md`
- `template/workflow/PLAYBOOK.md`

## Acceptance Criteria

- Fork detector is specified and deterministic.
- Fork checklist includes feature continuation and review-bot decision prompts.
- Non-fork paths remain uninterrupted.
- Dispatch behavior is consistent across meta-prompt and template orchestrator docs.

## Validation

- Simulated state with no fork: no extra questions.
- Simulated state with fork: checklist appears once, then route executes.
- Blocking bug scenario still routes to `/bugfix` first.

## Implementation Notes

### Status: Complete

### Decisions

- **Forks are stop gates** — user must reply with option number; no auto-continue with defaults.
- **Review path fork (F-2) included** — user chooses bot review vs manual review after post-test passes.
- **`7a-review-bot` added as valid `projectPhase`** — was present in ORCHESTRATOR.md dispatch table but missing from meta-prompt state contract; now consistent.
- **Fork detection positioned as Step 2c** — runs after bug-log check (Step 2b) to ensure blocking bugs always route to `/bugfix` first.
- **Step 2 updated** — auto-selects only when exactly one incomplete task file exists; defers to Fork F-1 when multiple exist.
- **One fork per condition per feature cycle** — no re-asking unless underlying state changes.

### Fork Definitions Implemented

| Fork ID | Condition | Trigger Point |
|---------|-----------|---------------|
| F-1: Feature Selection | `6-code`, `currentTaskFile` empty, >1 incomplete tasks | Step 2c |
| F-2: Review Path | `7-test`, `testMode=post`, all ACs pass, no blocking bugs | Step 2c / dispatch table |
| F-3: Post-Ship Continuation | Feature shipped, incomplete tasks remain | Dispatch table (after 7a/7b) |
| F-4: Maintenance Level | `8-maintain`, `maintenanceLevel` empty | Dispatch table |

### Files Changed

- `meta-prompts/phase-10-continue.md` — Added Step 2c (Fork Detection), updated Step 2 (conditional auto-select), updated Step 3 dispatch table (F-2 at 7-test, 7a-review-bot row, F-4 at 8-maintain), added fork stop gate, added fork-once rule, added `7a-review-bot` to state contract.
- `template/workflow/ORCHESTRATOR.md` — Added step 4 (Fork Detection) to Loop Protocol, updated Dispatch Table (F-2, F-3, F-4 references), updated Feature Cycling (fork-aware), added fork stop condition.
- `template/workflow/LIFECYCLE.md` — Updated `/continue` description to mention fork detection.
- `template/workflow/PLAYBOOK.md` — Updated Test and Maintain gates to reference fork detection.
- `prompts/phase-10-continue.prompt.md` — Regenerated via `sync-prompts.sh`.
- `template/.claude/commands/continue.md` — Regenerated via `sync-prompts.sh`.

### Validation Evidence

- `./scripts/sync-prompts.sh --check` → **OK: All derived prompt files are in sync.**
- `./scripts/test-scripts.sh` → **32/32 tests pass, 0 failures.**
- **Trace 1 (no-fork):** State `6-code`/`implement` with active task → no fork condition matches → dispatch proceeds uninterrupted. **PASS.**
- **Trace 2 (F-1 feature selection):** State `6-code`, empty `currentTaskFile`, 2+ incomplete tasks → Step 2 defers (does not auto-select) → Step 2c detects F-1 → checklist presented. **PASS.** (Initially failed due to Step 2 auto-selecting; fixed by adding count check.)
- **Trace 3 (F-2 review path):** State `7-test`/`post`, ACs pass → Step 2c detects F-2 → offers bot vs manual. Dispatch table routes to `7a-review-bot` or `7b-review-ship` per user choice. **PASS.**
- **Trace 4 (blocking bug priority):** Blocking bug in bugs/LOG.md → Step 2b routes to `/bugfix` → Step 2c never reached. **PASS.**
- **Consistency check:** Dispatch tables in meta-prompt and ORCHESTRATOR.md are consistent for all fork-relevant rows.
