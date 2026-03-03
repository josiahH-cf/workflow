# Policy Tests

Map policy requirements to validation signals.

## Required Checks

| Requirement | Signal | Source |
|---|---|---|
| Spec has Feature ID and AC IDs | Pattern check in spec file | `/specs/*.md` |
| Task file maps tasks to AC IDs | Pattern check in task file | `/tasks/*.md` |
| Task status counts are coherent | Status/checklist consistency check | `/tasks/*.md` |
| PR includes verification and rollback | PR template checklist complete | `/.github/pull_request_template.md` |
| Build, lint, test commands are defined | No placeholder commands in AGENTS | `/AGENTS.md` |
| Adapter files do not redefine canon | Adapter references AGENTS/workflow docs | `/CLAUDE.md`, `/.github/copilot-instructions.md` |

## CI Mapping

- Run structural checks before language-specific checks.
- Run build/lint/test checks using AGENTS command values.
- Block merge on any failed policy test.

## Failure Semantics

- Policy test failure means process drift, not optional warning.
- Fix policy or artifact shape before continuing feature delivery.
