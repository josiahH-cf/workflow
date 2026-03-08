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
