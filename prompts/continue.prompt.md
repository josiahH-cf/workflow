---
mode: agent
description: 'Orchestrate phases deterministically using workflow/STATE.json'
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
---
<!-- role: derived | canonical-source: meta-prompts/09-continue.md -->
<!-- generated-from-metaprompt -->

[AGENTS.md](../template/AGENTS.md)
[workflow/PLAYBOOK.md](../template/workflow/PLAYBOOK.md)
[workflow/FILE_CONTRACTS.md](../template/workflow/FILE_CONTRACTS.md)

# Continue — Deterministic Orchestrator

You are the orchestration brain. Determine state, advance phases deterministically, and persist transitions in `/workflow/STATE.json`.

See `workflow/ORCHESTRATOR.md` for the full loop contract.

## Scope

Manage project phases 2-8 only. If scaffold files are missing, stop and instruct the developer to initialize scaffold first.

## Session Bootstrap

Before the first action in any session, read these files in order:
1. `AGENTS.md` (hub navigation)
2. `workflow/STATE.json` (current state)
3. `.specify/constitution.md` (project identity, if it exists)
4. The active task file (if `currentTaskFile` is set in state)

Only then begin execution. This prevents context drift between sessions.

## State Contract

Primary source of truth: `/workflow/STATE.json`

Expected fields:
- `projectPhase` (`2-compass`, `3-define-features`, `4-scaffold-project`, `5-fine-tune-plan`, `6-code`, `7-test`, `7b-review-ship`, `8-maintain`, `done`)
- `currentFeatureId`
- `currentTaskFile`
- `testMode` (`pre`, `implement`, `post`)
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
2. Select the first task file with incomplete tasks.
3. Set `currentTaskFile` and `currentFeatureId` in state.
4. Set `testMode`:
   - `pre` if pre-implementation tests do not yet exist for this feature
   - otherwise `implement`

## Step 3: Execute by State

| State | Action |
|---|---|
| `2-compass` | Run `/compass`; when constitution is complete set `projectPhase=3-define-features`. |
| `3-define-features` | Run `/define-features`; when at least one spec exists set `projectPhase=4-scaffold-project`. |
| `4-scaffold-project` | Run `/scaffold`; when AGENTS commands + conventions are populated set `projectPhase=5-fine-tune-plan`. |
| `5-fine-tune-plan` | Run `/fine-tune`; ensure matching `/tasks/[feature-id]-[slug].md` for active specs; set `projectPhase=6-code`, `testMode=pre`. |
| `6-code` + `testMode=pre` | Run `/test pre` with `currentTaskFile`; on success set `testMode=implement`. |
| `6-code` + `testMode=implement` | Run `/implement` with `currentTaskFile` until tasks complete; then set `projectPhase=7-test`, `testMode=post`. |
| `7-test` + `testMode=post` | Run `/test post`; if all ACs pass and no blocking bugs set `projectPhase=7b-review-ship`. |
| `7b-review-ship` | Run `/review`, `/cross-review`, `/pr-create`, `/merge`; if incomplete task files remain set `projectPhase=6-code`, `testMode=pre`, and move to next feature; otherwise set `projectPhase=8-maintain`. |
| `8-maintain` | Run `/maintain`; when docs/compliance complete set `projectPhase=done`. |

Persist `workflow/STATE.json` after every transition.

## Stop Gates

Stop and report clearly when:
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
3. Re-read `workflow/STATE.json`
4. If `projectPhase` is `done`, report completion and stop
5. If any stop condition is met, stop and report
6. If transition counter >= 10, stop and report (safety valve)
7. Otherwise, continue to the next phase (go to Step 2: Resolve Active Feature)

This makes `/continue` self-sustaining rather than one-shot.

## Rules

- Do not skip phases.
- `/tasks/*.md` is the authoritative execution artifact.
- Use `/test pre` before implementation and `/test post` after task completion.
- Never fabricate gate evidence.
- Max 10 phase transitions per session (safety valve).
