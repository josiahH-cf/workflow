# Phase 2: Autonomous Loop Architecture

**Status:** not-started
**Depends on:** Phase 1 (AGENTS.md decomposition must be complete)
**Estimated files:** ~5 modified or created

## Objective

Build a persistent top-level orchestrator that drives the entire project from interview through shipping without requiring manual re-invocation between phases. Both agent-side (enhanced `/continue`) and CI-side (GitHub Actions loop).

## Rationale

The user's core vision: "a loop at the top that continues to build and direct and implement until finished." Current `/continue` (in `meta-prompts/minor/09-continue.md`) requires manual re-invocation after each phase transition. The best practices document emphasizes "the model capability, not the scaffold complexity, is the dominant factor" — so the loop should be thin but persistent.

## Context Files to Read First

- `meta-prompts/minor/09-continue.md` — Current continue orchestrator (will be enhanced)
- `prompts/continue.prompt.md` — Copilot-derived prompt (must be synced)
- `template/workflow/PLAYBOOK.md` — Phase gates (loop must respect these)
- `template/workflow/STATE.json` — State schema the loop manages
- `meta-prompts/major/` — Existing batch meta-prompts (new one will join them)
- `template/AGENTS.md` — Must reference the new ORCHESTRATOR.md in its Quick Reference table

## Steps

### Step 1: Create `template/workflow/ORCHESTRATOR.md`

This is the **master loop specification** — the contract that any orchestrator (agent-side or CI-side) must follow.

Content:

```markdown
# Orchestrator Contract

The orchestrator is the persistent loop that drives the project from Phase 2 through completion.

## Loop Protocol

1. **Bootstrap**: Read `workflow/STATE.json` + `.specify/constitution.md` + active spec/task file
2. **Execute**: Run the command for the current phase (see dispatch table below)
3. **Verify Gate**: Check that the phase gate is satisfied (per PLAYBOOK.md)
4. **Advance**: Update STATE.json to the next phase
5. **Repeat**: Go to step 1

The loop continues until `projectPhase` reaches `done` or a stop condition is hit.

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
| `6-code` | `implement` | `/implement` |
| `7-test` | `post` | `/test post` |
| `7b-review-ship` | — | `/review` → `/cross-review` → `/pr-create` → `/merge` |
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
```

### Step 2: Enhance `meta-prompts/minor/09-continue.md`

Add these capabilities to the existing continue meta-prompt:

1. **Session bootstrap preamble** — Before the first action, always read:
   - `AGENTS.md`
   - `workflow/STATE.json`
   - `.specify/constitution.md` (if it exists)
   - The active task file (if `currentTaskFile` is set in state)

2. **Outer loop** — After completing a phase action, instead of stopping:
   - Re-read `workflow/STATE.json`
   - If `projectPhase` is not `done` and no stop condition is met, continue to the next phase
   - This makes `/continue` self-sustaining rather than one-shot

3. **Iteration counter** — Track transitions within the session:
   - Initialize `transitions = 0` at session start
   - Increment after each phase advance
   - Stop if `transitions >= 10` (safety valve)

4. **Progress reporting** — After each phase transition, emit:
   ```
   [ORCHESTRATOR] Phase X → Phase Y | Feature: [id] | Transitions: N/10
   ```

5. **Reference** — Add `See workflow/ORCHESTRATOR.md for the full loop contract.`

**Important:** Keep the existing state contract, step 1-3 logic, stop gates, and rules intact. The enhancements wrap around the existing behavior, they don't replace it.

### Step 3: Sync `prompts/continue.prompt.md`

Mirror the meta-prompt enhancements for the Copilot prompt file. The sync should follow the same pattern as `scripts/sync-prompts.sh` uses (extract operational block, add frontmatter).

### Step 4: Create `meta-prompts/major/00-full-build.md`

This is the **"one command to rule them all"** — a single meta-prompt that runs the entire lifecycle from scratch.

Content outline:

```markdown
# Full Build — Start-to-Finish Autonomous Execution

You are an autonomous build agent. Your job is to take a project from zero to shipped using the workflow scaffold.

## Prerequisites
- Scaffold files must be installed (run `initialization.md` meta-prompt first if not present)
- Developer is available for interview (Phase 2) and merge approval (Phase 7b)

## Execution

1. Read `workflow/ORCHESTRATOR.md` for the loop contract
2. Read `workflow/STATE.json` to determine starting point
3. If no state exists, initialize at `2-compass`
4. Execute the orchestrator loop:
   - Run the command for the current phase
   - Verify the phase gate is satisfied
   - Advance STATE.json
   - Continue to the next phase
5. Repeat until `projectPhase` reaches `done` or a stop condition is hit

## Rules
- Follow `workflow/ORCHESTRATOR.md` for all loop behavior
- Follow `workflow/PLAYBOOK.md` for all phase gates
- Follow `workflow/BOUNDARIES.md` for all behavioral rules
- Use `workflow/FAILURE_ROUTING.md` for error recovery
- Never skip phases or fabricate gate evidence
- When stopped, report state + blocker + resume instructions clearly

## Session Limits
- If context degrades (>60%), stop and instruct developer to re-run this meta-prompt
- Max 10 phase transitions per invocation
```

### Step 5: Update `template/AGENTS.md` Quick Reference

Add `ORCHESTRATOR.md` to the Quick Reference table created in Phase 1:

```markdown
| Autonomous loop contract | `workflow/ORCHESTRATOR.md` |
```

## Verification Checklist

- [ ] `template/workflow/ORCHESTRATOR.md` exists with loop protocol, dispatch table, stop conditions, safety limits
- [ ] `meta-prompts/minor/09-continue.md` has session bootstrap, outer loop, iteration counter, progress reporting
- [ ] `prompts/continue.prompt.md` is in sync with the meta-prompt changes
- [ ] `meta-prompts/major/00-full-build.md` exists and references ORCHESTRATOR.md
- [ ] `template/AGENTS.md` Quick Reference includes ORCHESTRATOR.md
- [ ] The enhanced `/continue` re-reads STATE.json after each phase and continues automatically
- [ ] Stop conditions are preserved from the original continue meta-prompt
- [ ] Safety valve: max 10 transitions per session is documented in both ORCHESTRATOR.md and continue meta-prompt

## Completion

When all verification checks pass, update this file:
- Change `**Status:** not-started` to `**Status:** done`
- Add completion timestamp
