# Orchestrator Contract

The orchestrator (`/continue`) is the persistent loop that drives the project from Phase 2 through completion. It is not a direct implementation command — it reads state, selects the next action (including bug-routing), dispatches to the appropriate phase command, and advances. At Phase 6 it delegates to `/implement`.

## Loop Protocol

1. **Bootstrap**: Read `workflow/STATE.json` + `.specify/constitution.md` + active spec/task file
2. **Check Bug Log**: If `bugs/LOG.md` exists, check for open blocking bugs on the current feature. Blocking bugs must be resolved (via `/bugfix`) before proceeding to the next task. Non-blocking bugs remain logged for a later review cycle.
3. **Execute**: Run the command for the current phase (see dispatch table below)
4. **Verify Gate**: Check that the phase gate is satisfied (per PLAYBOOK.md)
5. **Advance**: Update STATE.json to the next phase
6. **Repeat**: Go to step 1

The loop continues until `projectPhase` reaches `8-maintain` and the current maintenance pass is complete, or a stop condition is hit.

## Session Bootstrap

Every session (fresh context) MUST begin with:
1. Read `AGENTS.md` (hub navigation)
2. Read `workflow/STATE.json` (current state)
3. Read `.specify/constitution.md` (project identity)
4. Read the active task file if `currentTaskFile` is set
5. Only then begin execution

This prevents context drift between sessions.

## Dispatch Table

| projectPhase | testMode | Command |
|---|---|---|
| `2-compass` | — | `/compass` |
| `3-define-features` | — | `/define-features` |
| `4-scaffold-project` | — | `/scaffold` |
| `5-fine-tune-plan` | — | `/fine-tune` |
| `6-code` | `pre` | `/test pre` |
| `6-code` | `implement` | Check bug log: resolve open blocking bugs via `/bugfix` first, then `/implement` |
| `7-test` | `post` | `/test post` |
| `7b-review-ship` | — | `/review-session` → `/cross-review` |
| `8-maintain` | — | `/maintain` |

## Feature Cycling

After `7b-review-ship` completes for one feature:
- Check `/tasks/*.md` for remaining incomplete task files
- If found: set `projectPhase=6-code`, `testMode=pre`, advance to next feature
- If none: set `projectPhase=8-maintain`

## Stop Conditions

The loop MUST stop and report when:
- Human input is required (interview questions, approval gates)
- A blocking bug exists with no automated fix path
- Required artifacts are missing and cannot be inferred
- Tests fail after 2 focused fix attempts
- Security/privacy/destructive operations need approval
- Context is degraded (>60% utilization — compact or restart)

## Resume Protocol

When stopped, the orchestrator reports:
1. Current state (projectPhase, currentFeatureId, testMode)
2. What completed since last resume
3. What blocks progress
4. Exact resume command: `/continue`

## Safety Limits

- Max phase transitions per session: 10 (prevents runaway in corrupted state)
- Max consecutive failures on same phase: 2 (then stop and report)
- Context compaction trigger: 60% utilization
