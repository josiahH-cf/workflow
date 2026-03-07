# Governance Impact Matrix

Classification of every rule in `POLICY_TESTS.md` as a **hard constraint** (blocks progress) or **advisory** (informational, does not block).

## Policy Test Rules

| # | Requirement | Type | Blocks? | When It Applies | What Happens on Failure |
|---|---|---|---|---|---|
| 1 | Spec has Feature ID and AC IDs | Hard constraint | Yes | Any spec file exists | Merge blocked — spec is structurally invalid |
| 2 | Task file maps tasks to AC IDs | Hard constraint | Yes | Any task file exists | Merge blocked — tasks can't be traced to acceptance criteria |
| 3 | Task status counts are coherent | Hard constraint | Yes | Any task file exists | Merge blocked — task tracking has drifted |
| 4 | Every spec has matching task file | Hard constraint | Yes | Specs directory has files | Merge blocked — spec exists without a work breakdown |
| 5 | PR includes verification and rollback | Hard constraint | Yes | Any PR | Merge blocked — PR template checklist incomplete |
| 6 | Constitution placeholders resolved after Compass | Hard constraint | Yes | Phase >= 3 (Define Features) | Merge blocked — `[PROJECT-SPECIFIC]` still present in constitution |
| 7 | AGENTS placeholders resolved after Scaffold | Hard constraint | Yes | Phase >= 5 (Fine-Tune Plan) | Merge blocked — `[PROJECT-SPECIFIC]` still present in AGENTS |
| 8 | Build, lint, test commands are defined | Hard constraint | Yes | Phase >= 5 (Fine-Tune Plan) | Merge blocked — placeholder commands remain in AGENTS or CI |
| 9 | Continue state is valid | Hard constraint | Yes | `STATE.json` exists | Merge blocked — `/continue` would fail to resume |
| 10 | Adapter files do not redefine canon | Hard constraint | Yes | Adapters exist | Merge blocked — adapter overrides canonical policy |
| 11 | AGENTS.md links resolve | Hard constraint | Yes | Always | Merge blocked — broken references in entrypoint doc |
| 12 | Modular workflow files present | Hard constraint | Yes | Always | Merge blocked — required workflow files missing |
| 13 | Workflow lint runs without error | Advisory | No | `workflow-lint.sh` exists | Lint report generated — findings are informational |
| 14 | Lint contract present | Hard constraint | Yes | Always | Merge blocked — lint contract file or categories missing |

## Legend

- **Hard constraint**: Failure means process drift. Must be fixed before feature delivery continues. CI blocks merge.
- **Advisory**: Findings are surfaced for awareness. Does not block merge or phase transitions.

## Notes

- Rules 6–8 are **phase-gated** — they only activate after the project reaches a specific lifecycle phase. Before that phase, the check is not applicable.
- Rule 13 is the only advisory in the current policy test set. All other checks are hard stops.
- The **Change Protocol** (`CHANGE_PROTOCOL.md`) itself is a process constraint — it governs how you modify these rules, but it's enforced by human review, not CI automation.
