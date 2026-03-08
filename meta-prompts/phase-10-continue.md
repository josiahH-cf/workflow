<!-- role: canonical-source -->
<!-- phase: orchestration -->
<!-- description: Orchestrate phases deterministically using workflow/STATE.json -->
# Continue — Deterministic Orchestrator

`/continue` is the **orchestrator**, not a direct implementation command. It reads project state, determines the next action, and dispatches to the appropriate phase command (e.g., `/compass`, `/implement`, `/test`). At Phase 6 it delegates to `/implement` — it does not duplicate `/implement`'s behavior. Its unique value is **state management, phase advancement, bug-routing, and next-action selection**.

Use `/implement` when you know exactly which feature to build. Use `/continue` when you want the orchestrator to determine and execute the next right action.

See `workflow/ORCHESTRATOR.md` for the full loop contract.

## Scope

Manage project phases 2-9 only. If scaffold files are missing, stop and instruct the developer to initialize scaffold first.

## Session Bootstrap

Before the first action in any session, read these files in order:
1. `AGENTS.md` (hub navigation)
2. `workflow/STATE.json` (current state)
3. `.specify/constitution.md` (project identity, if it exists)
4. The active task file (if `currentTaskFile` is set in state)
5. The **Session Log** table at the bottom of the active task file — read the latest row to determine: last completed task, next planned action, and any blockers.

Only then begin execution. This prevents context drift between sessions.

## State Contract

Primary source of truth: `/workflow/STATE.json`

Expected fields:
- `projectPhase` (`2-compass`, `3-define-features`, `4-scaffold-project`, `5-fine-tune-plan`, `6-code`, `7-test`, `7a-review-bot`, `7b-review-ship`, `8-maintain`, `9-operationalize`)
- `currentFeatureId`
- `currentTaskFile`
- `testMode` (`pre`, `implement`, `post`)
- `advisoryProfile` (`concise`, `standard`, `detailed`, or empty — see `workflow/ORCHESTRATOR.md → Context-Sensitive Advisory Guidance`)
- `updatedAt`
- `schemaVersion` (optional, if present must be numeric)

If `workflow/STATE.json` is missing or invalid:
1. Infer phase once from artifacts (`constitution`, `specs`, `tasks`, bug log, docs).
2. Create a valid state file.
3. Continue only from persisted state.

## Step 1: Validate Scaffold and Load State

1. Confirm scaffold roots exist: `AGENTS.md`, `.specify/`, `workflow/`.
2. Load `workflow/STATE.json`.
3. If missing/invalid, run one-time inference and write state.

## Step 2: Resolve Active Feature

When `projectPhase` is `6-code` or later and `currentTaskFile` is empty:
1. List `/tasks/*.md`.
2. Count task files with incomplete tasks.
3. If exactly one incomplete task file exists, select it automatically — set `currentTaskFile` and `currentFeatureId` in state.
4. If more than one incomplete task file exists, **do not auto-select** — defer to Step 2c (Fork Detection, F-1).
5. If a task file was selected, set `testMode`:
   - `pre` if pre-implementation tests do not yet exist for this feature
   - otherwise `implement`

## Step 2b: Check Bug Log

Before executing the current phase action, check `bugs/LOG.md` (if it exists) for open bugs:

- **Blocking bugs** (severity: blocking) for the current feature → run `/bugfix` to resolve before continuing to the next task. A blocking bug means the current task cannot be completed until the bug is fixed.
- **Non-blocking bugs** (severity: non-blocking) → remain logged for a later review cycle. Do not interrupt the current workflow to fix them.

This ensures the "next right action" always prioritizes unresolved blockers over new task work.

## Step 2c: Fork Detection (FAST Router)

Before dispatching, check whether the current state matches a **decision fork** — a point where multiple valid next actions exist and the user must choose. If exactly one valid path exists, skip this step and dispatch normally.

Fork detection runs **after** bug-log checks (Step 2b) so that blocking bugs are always resolved first — they are not forks.

### Fork Conditions

| Fork ID | Condition | Checklist |
|---------|-----------|----------|
| **F-1: Feature Selection** | `projectPhase` is `6-code`, `currentTaskFile` is empty, and more than one incomplete task file exists in `/tasks/` | List incomplete features by file order. Ask which to work on next. |
| **F-2: Review Path** | `projectPhase` is `7-test`, `testMode` is `post`, all ACs pass, and no blocking bugs | 1. Bot review (`/review-bot`) ← recommended 2. Manual review (`/review-session`) |
| **F-3: Post-Ship Continuation** | Feature just shipped (from `7a-review-bot` or `7b-review-ship`) and incomplete task files remain | 1. Next feature in priority order ← recommended 2. Choose a different feature 3. Enter maintenance early |
| **F-4: Maintenance Level** | `projectPhase` is `8-maintain` and `maintenanceLevel` is empty in STATE.json | 1. Light 2. Standard ← recommended 3. Deep |

### Checklist Format

```
[FORK] <brief description of the decision>
  1. <option> ← recommended
  2. <option>
  ...
Reply with option number to proceed.
```

### Fork Rules

- **Forks are stop gates.** The orchestrator stops and waits for the user to reply with an option number. Do not auto-continue with a default.
- **One fork per condition per feature cycle.** Do not re-ask the same fork unless the underlying state changes (e.g., a new feature ships, a task file is added or completed).
- **Non-fork states skip this step entirely.** Single incomplete task file → auto-select. All features done → go to `8-maintain`. Phases 2–5 → linear dispatch. Active task with `testMode` set → continue current workflow.

## Step 3: Execute by State

| State | Action |
|---|---|
| `2-compass` | Run `/compass`; when constitution themes are addressed and ambiguities documented, set `projectPhase=3-define-features`. |
| `3-define-features` | Run `/define-features`; when at least one spec exists set `projectPhase=4-scaffold-project`. |
| `4-scaffold-project` | Run `/scaffold`; when AGENTS commands + conventions are populated set `projectPhase=5-fine-tune-plan`. |
| `5-fine-tune-plan` | Run `/fine-tune`; ensure matching `/tasks/[feature-id]-[slug].md` for active specs; set `projectPhase=6-code`, `testMode=pre`. |
| `6-code` + `testMode=pre` | Run `/test pre` with `currentTaskFile`; on success set `testMode=implement`. |
| `6-code` + `testMode=implement` | Check bug log (Step 2b): resolve blocking bugs via `/bugfix` first. Then run `/implement` with `currentTaskFile` until tasks complete; then set `projectPhase=7-test`, `testMode=post`. |
| `7-test` + `testMode=post` | Run `/test post` (includes launch/smoke check — see phase-7-test.md); if all ACs pass, launch check passes or is skipped, and no blocking bugs, trigger **Fork F-2** (review path selection). Route to `7a-review-bot` or `7b-review-ship` based on user response. |
| `7a-review-bot` | Run `/review-bot`; on PASS auto-merge — then trigger **Fork F-3** if incomplete task files remain (set `projectPhase=6-code`, `testMode=pre` for the chosen feature), otherwise set `projectPhase=8-maintain`. On FAIL write findings file, set `projectPhase=6-code`, `testMode=implement`. |
| `7b-review-ship` | Run `/review-session`, `/cross-review`; then trigger **Fork F-3** if incomplete task files remain (set `projectPhase=6-code`, `testMode=pre` for the chosen feature), otherwise set `projectPhase=8-maintain`. |
| `8-maintain` | If `maintenanceLevel` is empty, trigger **Fork F-4** (maintenance level selection). Then run `/maintain` with selected level; when maintenance pass complete and automation not yet configured, set `projectPhase=9-operationalize`. |
| `9-operationalize` | Run `/operationalize`; when interview complete and workflows generated, remain at `9-operationalize` (re-enterable) or return to `8-maintain` for ongoing mode. |

Persist `workflow/STATE.json` after every transition.

After every state transition, also append a row to the active task file's **Session Log** table:

| Date | Last Completed | Next Action | Blockers | State Link |
|------|---------------|-------------|----------|------------|

This ensures any future `/continue` session can resume from the latest Session Log entry + `workflow/STATE.json` together, regardless of context loss.

## Stop Gates

Stop and report clearly when:
- A fork checklist is awaiting user response (Step 2c)
- Human input is required
- A blocking bug exists
- Required artifacts are missing (`spec`, `task`, or `state` cannot be reconciled)
- Tests remain unresolved after two focused attempts
- Security/privacy/destructive operations require approval
- Transition counter reaches 10 (safety valve)
- Context is degraded (>60% utilization — compact or restart)

When stopping, always report:
1. Current state (`projectPhase`, `currentFeatureId`, `testMode`)
2. What completed
3. What blocks progress
4. Resume command: `/continue`

## Outer Loop

After completing a phase action and persisting the state transition:

1. Increment the session transition counter (initialized to 0 at session start)
2. Emit progress: `[ORCHESTRATOR] Phase X → Phase Y | Feature: [id] | Transitions: N/10`
3. **Advisory callout** (every 3rd transition or start of a new feature cycle): emit `[ADVISORY] Profile: <advisoryProfile> | Phase: <phase> | Tip: <context-relevant suggestion>`. If context signals suggest the profile should shift (e.g., user is experienced and profile is still `detailed`), append: `(profile shift available — say "switch to <profile>" to change)`. See `workflow/ORCHESTRATOR.md → Context-Sensitive Advisory Guidance`.
4. Re-read `workflow/STATE.json`
5. If `projectPhase` is `9-operationalize` and automation configuration is complete, report status and stop
6. If `projectPhase` is `8-maintain` and current maintenance pass is complete, check if automation is configured; if not prompt for Phase 9
7. If any stop condition is met, stop and report
8. If transition counter >= 10, stop and report (safety valve)
9. Otherwise, continue to the next phase (go to Step 2: Resolve Active Feature)

This makes `/continue` self-sustaining rather than one-shot.

## Rules

- Do not skip phases.
- `/tasks/*.md` is the authoritative execution artifact.
- Use `/test pre` before implementation and `/test post` after task completion.
- Never fabricate gate evidence.
- Max 10 phase transitions per session (safety valve).
- Fork detection (Step 2c) fires once per fork condition per feature cycle. Do not re-ask a fork unless the underlying state changes.
