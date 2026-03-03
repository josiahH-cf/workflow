# File Contracts

Machine-readable behavior starts with stable artifact contracts.

## Artifact Contracts

| Artifact | Owner | Updated When | Required Fields | Validation Signal |
| -------- | ----- | ------------ | --------------- | ----------------- |
| `/specs/[feature-id]-[slug].md` | Builder agent | Scope changes | Feature ID, criteria IDs, affected areas, out-of-scope | Criteria count 3–7 and IDs present |
| `/tasks/[feature-id]-[slug].md` | Builder agent | Plan + every task completion | Task IDs, criterion mapping, status counts, session log | All criteria mapped, status math consistent |
| `/decisions/[NNNN]-[slug].md` | Builder/reviewer/human | Non-obvious forks or conflicts | Trigger, options, decision, consequences, rollback impact | Decision linked from task/spec when needed |
| `/.codex/PLANS.md` (instance copy) | Builder agent | Long-run execution only | Milestones, verification, progress | Milestones map to task IDs |
| Review report in PR body | Reviewer agent | Review phase | PASS/FAIL per criterion + scope checks | No unchecked criterion |

## Linkage Rules

- Feature ID format: `[issue-id]-[slug]` (example: `42-user-auth`).
- Spec filename and task filename share the same feature ID.
- Acceptance criteria IDs use `AC-1..N`.
- Tasks use `T-1..N` and must cite covered `AC-*` IDs.
- Decisions referenced by ID in tasks or PR when they affect behavior.

## Invalid State Conditions

Treat as blocking failures:

- Spec exists without a matching task file.
- Any criterion has no test mapping.
- Task status counts do not match task checklist states.
- Out-of-scope files changed with no decision record.
- PR missing verification or rollback sections.
