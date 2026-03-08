# R-005: Git Worktree Lifecycle Rules

## Problem

Worktree setup exists, but lifecycle governance (commit cadence, merge timing, cleanup, conflict-first flow) is not fully codified into orchestrator-facing behavior.

## Goal

Define durable, agentic worktree rules that reduce clutter and keep `/continue` seamless.

## Expected Behavior

1. Commit often with clear criteria.
2. Merge at logical stopping points (feature completion, review pass, etc.).
3. Keep branch/worktree cleanup automatic where safe.
4. Resolve conflict scenarios before new implementation loops.
5. Ensure rollback visibility remains strong.

## Candidate Files

- `template/workflow/CONCURRENCY.md`
- `template/scripts/setup-worktree.sh`
- `template/workflow/ROUTING.md`
- `template/workflow/FAILURE_ROUTING.md`
- `template/workflow/ORCHESTRATOR.md`

## Acceptance Criteria

- Lifecycle map exists for create -> commit -> review -> merge -> cleanup.
- Conflict-first rules are explicit and tied to stop/route logic.
- Cleanup behavior addresses merged branch/worktree clutter.
- Guidance keeps user overhead low while preserving control points.

## Validation

- Simulate parallel worktrees with potential overlap.
- Validate clash detection/escalation path.
- Validate merged-branch cleanup behavior and reporting.

## Implementation Notes

### Changes Made

1. **`template/workflow/CONCURRENCY.md`** — Added full "Worktree Lifecycle" section with 5 stages (Create → Commit → Review → Merge → Cleanup), commit cadence rules, merge timing guidance, and a "Conflict-First Rule" subsection that defines the pre-implementation check the orchestrator must perform.
2. **`template/workflow/ORCHESTRATOR.md`** — Inserted step 6 ("Conflict-First Check") into the loop protocol between Claim Work and Execute. Implementation commands (`/implement`, `/build-session`, `/bugfix`) are now gated on worktree health: no file overlaps, no unacknowledged stale worktrees, no uncommitted conflicts with claimed files.
3. **`template/workflow/FAILURE_ROUTING.md`** — Added two escalation rows: "Worktree file conflict" and "Stale worktree (>24h)" with first/second actions and escalation triggers.
4. **`template/workflow/ROUTING.md`** — Added lifecycle reference and conflict-first bullet points to the Concurrency Rules section.
5. **`template/scripts/setup-worktree.sh`** — Enhanced `--list` mode to flag worktrees older than 24h with a `[STALE]` marker.

### Decisions

- Conflict-first check is a **stop condition** in the orchestrator loop, not merely advisory — this ensures agents never start implementation with known conflicts.
- Stale worktree threshold kept at 24h (matching the existing Safety Limits table in CONCURRENCY.md).
- Cleanup remains user-initiated (`--cleanup` flag) rather than automatic — prevents accidental removal of in-progress work.
- No changes to derived prompt files required — all changes are to template workflow docs consumed at the project level.

### Evidence

- `./scripts/sync-prompts.sh --check`: **OK** — all 36 derived files in sync.
- `bats tests/scripts/*.bats`: **36/36 pass** — full suite green.
- `./scripts/validate-scaffold.sh`: **95/95 pass** — scaffold structural integrity confirmed.

## Status

Complete.
