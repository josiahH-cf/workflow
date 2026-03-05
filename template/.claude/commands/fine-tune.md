<!-- role: derived | canonical-source: meta-prompts/minor/05-fine-tune-plan.md -->
description: Create ordered feature specs with model assignments, branches, and acceptance criteria

# Fine-tune Plan — Phase 5: Spec Finalization

You are finalizing feature specs into execution-ready work items with model assignments, branch names, and ordered task breakdowns.

## Prerequisites

- `.specify/constitution.md` must exist (project identity)
- Feature specs must exist in `/specs/` with Technical Approach filled (from Phase 4)
- `AGENTS.md` must have Core Commands and Code Conventions filled (from Phase 4)
- If prerequisites are missing, tell the developer which phase to run first

## What This Does

For each feature spec:

1. **Create ordered task breakdown** — Break the feature into 2–5 implementation tasks, ordered by dependency
2. **Write acceptance criteria** — Each task gets specific, testable ACs in EARS + GWT format with verification commands
3. **Assign models** — Using the Agent Routing Matrix in `AGENTS.md`, assign each task to the appropriate model
4. **Create branch names** — Each task gets a branch: `model/type-short-description`
5. **Set scope boundaries** — Each task lists exactly which files it will touch
6. **Order for execution** — Tasks are numbered in the order they should be implemented (dependency-aware)

## Protocol

1. **Read all feature specs** — understand scope, ACs, technical approach
2. **Read AGENTS.md** — get routing matrix, branch naming rules, conventions
3. **Break each feature into tasks** — each task should be:
   - Completable in a single agent session
   - Independently testable
   - Mapped to specific acceptance criteria (T-1 covers AC-1, etc.)
4. **Assign models per routing matrix** — use task characteristics to determine:
   - Complex logic → Claude
   - UI/frontend → Copilot
   - Batch/migration → Codex
5. **Name branches** — `model/type-short-description` format
6. **Present specs to developer** for review

## Second-Model Review

Before finalizing, each spec should be reviewed by a different model than the one that created it. This catches errors, omissions, and scope issues.

- If you (Claude) created the specs, note: _"These specs should be reviewed by a second agent (Copilot or human) before execution begins."_
- Flag this as a manual step — present the specs and instruct the developer to request a review

## Key Rules

- Every task must map to at least one acceptance criterion
- Every acceptance criterion must have a verification command
- Branch names must follow the `model/type-short-description` format from AGENTS.md
- Model assignment must reference the routing matrix, not arbitrary choice
- If a task is too large for one session, split it further

## Outputs

For each feature spec, update:

1. **Task Breakdown section** — ordered tasks with descriptions, model assignments, branch names, AC coverage
2. **Model Assignment section** — table mapping tasks to models with reasoning
3. **Acceptance Criteria section** — finalized with verification commands

Also:

4. **Create branches** in the repository (or instruct the developer to create them)
5. **Present the complete execution plan** — ordered list of all tasks across all features, showing the build sequence

## After Completion

The execution plan is the input to Phase 6 (Code). The `/continue` command can auto-advance from here — it reads the fine-tuned specs and begins implementation in task order.
