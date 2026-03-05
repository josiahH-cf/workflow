## Artifact Directory Map

```
.specify/
  constitution.md                    ← project identity (written in Phase 2)
  spec-template.md                   ← copy to /specs/ for each new feature
  acceptance-criteria-template.md    ← AC format reference (EARS + GWT)

/specs/[feature-id]-[slug].md        ← one per feature (created in Phase 3+)
/tasks/[feature-id]-[slug].md        ← one per feature (authoritative execution artifact; created in Phase 5+)
/decisions/[NNNN]-[slug].md          ← architecture choices (any phase)
/bugs/LOG.md                         ← append-only bug log (any phase)
/.codex/PLANS.md                     ← Codex long-run execution plan (Phase 6+)
/workflow/STATE.json                 ← orchestration state for /continue
```

Feature ID format: `[issue-id]-[slug]` (example: `42-user-auth`). Spec and task files share the same feature ID.

# File Contracts

Machine-readable behavior starts with stable artifact contracts.

## Artifact Contracts

| Artifact | Owner | Updated When | Required Fields | Validation Signal |
| -------- | ----- | ------------ | --------------- | ----------------- |
| `.specify/constitution.md` | Compass interview | Phase 2 (Compass) or `/compass-edit` | 8 sections: Problem, User, Success, Capabilities, Out-of-Scope, Principles, Security, Testing | No `[PROJECT-SPECIFIC]` placeholders remain |
| `/specs/[feature-id]-[slug].md` | Builder agent | Scope changes | Feature ID, criteria IDs, affected areas, out-of-scope, Compass mapping | Criteria count 3–7 and IDs present |
| `/tasks/[feature-id]-[slug].md` | Builder agent | Plan + every task completion | Task IDs, criterion mapping, status counts, session log, model assignment, branch name | All criteria mapped, status math consistent |
| `/decisions/[NNNN]-[slug].md` | Builder/reviewer/human | Non-obvious forks or conflicts | Trigger, options, decision, consequences, rollback impact | Decision linked from task/spec when needed |
| `/bugs/LOG.md` | Any agent via `/bug` | Bug discovered in any phase | BUG-NNN, description, location, phase, severity, expected, actual, status | Sequential BUG-NNN IDs, status field present |
| `/.codex/PLANS.md` (instance copy) | Builder agent | Long-run execution only | Milestones, verification, progress | Milestones map to task IDs |
| `/workflow/STATE.json` | Orchestrator (`/continue`) | Phase transitions and task selection | `projectPhase`, `currentFeatureId`, `currentTaskFile`, `testMode`, `updatedAt` (`schemaVersion` optional) | Valid JSON and phase/task references resolve |
| Review report in PR body | Reviewer agent | Review phase | PASS/FAIL per criterion + scope checks + rubric scores | No unchecked criterion |

## Linkage Rules

- Feature ID format: `[issue-id]-[slug]` (example: `42-user-auth`).
- Spec filename and task filename share the same feature ID.
- Acceptance criteria IDs use `AC-1..N`.
- Tasks use `T-1..N` and must cite covered `AC-*` IDs.
- Decisions referenced by ID in tasks or PR when they affect behavior.
- `/workflow/STATE.json` `currentTaskFile` must point to an existing `/tasks/[feature-id]-[slug].md`.

## Invalid State Conditions

Treat as blocking failures:

- Spec exists without a matching task file.
- Any criterion has no test mapping.
- Task status counts do not match task checklist states.
- Out-of-scope files changed with no decision record.
- PR missing verification or rollback sections.
- `workflow/STATE.json` points to a missing task file or invalid phase identifier.
