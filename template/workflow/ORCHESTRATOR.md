# Orchestrator Contract

The orchestrator (`/continue`) is the persistent loop that drives the project from Phase 2 through Phase 9. It is not a direct implementation command — it reads state, selects the next action (including bug-routing), dispatches to the appropriate phase command, and advances. At Phase 6 it delegates to `/implement`.

## Loop Protocol

1. **Bootstrap**: Read `workflow/STATE.json` + `.specify/constitution.md` + active spec/task file
2. **Check Claims**: Read `activeClaims` in STATE.json. If another agent has claimed work, skip those tasks and their locked files.
3. **Check Bug Log**: If `bugs/LOG.md` exists, check for open blocking bugs on the current feature. Blocking bugs should be resolved (via `/bugfix`) before proceeding to the next task; if the bug requires a design change or is outside automated fix scope, escalate per `workflow/FAILURE_ROUTING.md`. Non-blocking bugs remain logged for a later review cycle.
4. **Detect Forks (FAST Router)**: Before dispatching, check whether the current state matches a decision fork — a point where multiple valid next actions exist and the user must choose. If exactly one valid path exists, skip to step 5. Fork detection runs after bug-log checks so that blocking bugs are always resolved first.

   | Fork ID | Condition | Checklist |
   |---------|-----------|----------|
   | **F-1: Feature Selection** | `projectPhase` is `6-code`, `currentTaskFile` is empty, and more than one incomplete task file exists | List incomplete features by file order. Ask which to work on next. |
   | **F-2: Review Path** | `projectPhase` is `7-test`, `testMode` is `post`, all ACs pass, and no blocking bugs | 1. Bot review (`/review-bot`) ← recommended 2. Manual review (`/review-session`) |
   | **F-3: Post-Ship Continuation** | Feature just shipped (from `7a-review-bot` or `7b-review-ship`) and incomplete task files remain | 1. Next feature in priority order ← recommended 2. Choose a different feature 3. Enter maintenance early |
   | **F-4: Maintenance Level** | `projectPhase` is `8-maintain` and `maintenanceLevel` is empty in STATE.json | 1. Light 2. Standard ← recommended 3. Deep |

   **Fork rules:** Forks are stop gates — wait for user reply. One fork per condition per feature cycle (do not re-ask unless state changes). Non-fork states skip this step.

   **Format:**
   ```
   [FORK] <brief description>
     1. <option> ← recommended
     2. <option>
   Reply with option number to proceed.
   ```

5. **Claim Work**: Identify the next unclaimed, file-disjoint unit of work. Write a claim into `STATE.json → activeClaims` with `taskFile`, `agent` (session identifier), `claimedAt` (ISO timestamp), and `lockedFiles` (files the task will modify). If no unclaimed work exists, report "nothing to claim" and stop.
6. **Conflict-First Check**: Before dispatching implementation (`/implement`, `/build-session`, `/bugfix`), verify worktree health: (a) `scripts/clash-check.sh` shows no file overlaps, (b) no stale worktrees (>24h) exist without acknowledgment, (c) no uncommitted changes in other active worktrees conflict with claimed files. If any check fails, stop and resolve before proceeding. See `workflow/CONCURRENCY.md → Conflict-First Rule`.
7. **Execute**: Run the command for the current phase (see dispatch table below)
8. **Verify Gate**: Check that the phase gate is satisfied (per PLAYBOOK.md)
9. **Release & Advance**: Remove the claim from `activeClaims`. Update STATE.json to the next phase.
10. **Repeat**: Go to step 1

The loop continues until `projectPhase` reaches `9-operationalize` and automation configuration is complete, or a stop condition is hit.

### Single-Agent Mode

When only one agent is running, the claim mechanism adds no friction — `activeClaims` will be empty, and the agent simply claims and releases as it goes. The protocol is backward-compatible with single-agent workflows.

## Session Bootstrap

Every session (fresh context) MUST begin with:
1. Read `AGENTS.md` (hub navigation)
2. Read `workflow/STATE.json` (current state)
3. Read `.specify/constitution.md` (project identity)
4. Read the active task file if `currentTaskFile` is set
5. Only then begin execution

This prevents context drift between sessions.

## Context-Sensitive Advisory Guidance

The orchestrator adapts advisory tone and specificity based on context signals read during bootstrap. This is a lightweight, always-on behavior — not a gate or enforcement mechanism.

### Advisory Profile

`STATE.json → advisoryProfile` stores the current advisory style. Valid values:

| Value | Behavior | Auto-detected When |
|-------|----------|--------------------|
| `concise` | Minimal guidance — actions and gates only, no explanations | Experienced user signal; advanced project type; many features already shipped |
| `standard` | Balanced — brief rationale with suggestions | Default when no signal is available |
| `detailed` | Thorough — full rationale, alternative options, learning context | New project (Phase 2–3); first feature cycle; user explicitly requests detail |

The profile is **auto-detected** during Phase 2 (Compass) based on project complexity and user responses. It can be **changed at any time** by the user ("switch to concise") or updated by the orchestrator when context shifts (e.g., moving from first feature to fifth feature).

If `advisoryProfile` is empty, treat as `standard`.

### Advisory Tiers

All suggestions in the workflow use one of three tiers. The tier determines language strength, not enforceability — all remain optional:

| Tier | Language | Use When |
|------|----------|----------|
| **Inform** | "Note: ..." / "FYI: ..." | Low-stakes context; background awareness |
| **Suggest** | "Consider ..." / "You may want to ..." | Moderate confidence; actionable but skippable |
| **Recommend** | "Recommended: ..." / "Strongly consider ..." | High confidence; skipping has known trade-offs |

Tier escalation is context-driven:
- Early phases (2–4): prefer Inform and Suggest
- Implementation phases (5–7): prefer Suggest and Recommend for quality-affecting choices
- Late phases (8–9): prefer Inform (user has established patterns)

### Periodic Advisory Callout

During `/continue` loops, after every 3rd phase transition (or at the start of a new feature cycle), emit a brief advisory status line:

```
[ADVISORY] Profile: <profile> | Phase: <phase> | Tip: <context-relevant suggestion>
```

This keeps the user aware of the active profile and surfaces one actionable, phase-relevant suggestion. If the user has not changed the profile and context signals suggest a shift, append: `(profile shift available — say "switch to <profile>" to change)`.

## Dispatch Table

| projectPhase | testMode | Command |
|---|---|---|
| `2-compass` | — | `/compass` |
| `3-define-features` | — | `/define-features` |
| `4-scaffold-project` | — | `/scaffold` |
| `5-fine-tune-plan` | — | `/fine-tune` |
| `6-code` | `pre` | `/test pre` |
| `6-code` | `implement` | Check bug log: resolve open blocking bugs via `/bugfix` first, then `/implement` |
| `7-test` | `post` | `/test post` — if all ACs pass and no blocking bugs, trigger **Fork F-2** (review path selection) |
| `7a-review-bot` | — | `/review-bot` → on PASS auto-merge, then **Fork F-3** if incomplete task files remain; on FAIL → findings file + revert to `6-code` |
| `7b-review-ship` | — | `/review-session` → `/cross-review` (manual fallback only) — then **Fork F-3** if incomplete task files remain |
| `8-maintain` | — | If `maintenanceLevel` is empty, trigger **Fork F-4** (maintenance level selection). Then `/maintain` |
| `9-operationalize` | — | `/operationalize` |

## Feature Cycling

After `7a-review-bot` auto-merges a feature:
- Trigger **Fork F-3** (Post-Ship Continuation) if incomplete task files remain
- If user selects next feature: set `projectPhase=6-code`, `testMode=pre`, advance to chosen feature
- If user selects maintenance: set `projectPhase=8-maintain`
- If only one incomplete task file remains (no fork): auto-advance to it

After `8-maintain` completes its current maintenance pass:
- If `.github/maintenance-config.yml` does not exist or user requests automation setup: set `projectPhase=9-operationalize`
- If automation is already configured: remain at `8-maintain` (ongoing)

After `7a-review-bot` FAILS:
- Findings file written to `/reviews/[feature-id]-bot-findings.md`
- Set `projectPhase=6-code`, `testMode=implement`
- On next `/continue`, the implementing agent reads the findings file and addresses each issue
- After fixes, the loop advances through test → review-bot again
- If bot FAIL repeats after two fix cycles, escalate to manual `/review-session` (per `workflow/FAILURE_ROUTING.md`)

Manual path via `7b-review-ship` still works for features that need human review.

## Stop Conditions

The loop MUST stop and report when:
- A fork checklist is awaiting user response (step 4 — Fork Detection)
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
