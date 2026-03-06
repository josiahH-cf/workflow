# Workflow Playbook

This document defines how an agent executes work from spec to merged PR.

## Global Rules

- Work from a single feature ID at a time.
- Keep branch scope aligned to the spec's Affected Areas.
- Record non-obvious decisions in `/decisions/` before continuing.
- Move forward only when the current phase gate is satisfied.
- Reference `.specify/constitution.md` for alignment on all design decisions.

## Project-Level Phase Gates

| Phase | Required Input | Required Output | Gate to Advance |
| ----- | -------------- | --------------- | --------------- |
| Compass | Scaffold files placed | `.specify/constitution.md` populated | All relevant themes addressed (no `[PROJECT-SPECIFIC]` placeholders in covered sections); ambiguities documented |
| Define Features | Constitution | Feature specs with Compass mapping | At least one feature spec exists in `/specs/` with Compass capability mapping; every constitution capability has at least one feature mapping; no orphan features (every feature traces to a capability) |
| Scaffold Project | Feature specs | `workflow/COMMANDS.md` Code Conventions + Core Commands | Neither section contains `[PROJECT-SPECIFIC]` |
| Fine-tune Plan | Architecture plan | `/tasks/[feature-id]-[slug].md` files + ordered AC/task/model/branch mappings | Every active spec has a matching task file; all ACs mapped to tasks |
| Code | Fine-tuned specs + task files + pre-tests | Passing code on feature branch | All tasks marked Complete, tests pass |
| Test | Implementation | Verified ACs, bug log reviewed | No blocking bugs, all ACs pass in `/test post` mode |
| Maintain | Shipped features | Maintenance mode active (level selected) | Maintenance level recorded in STATE.json; all items for selected level completed |

## Feature-Level Phase Contract

| Phase | Required Input | Required Output | Gate to Advance |
| ----- | -------------- | --------------- | --------------- |
| Scope | Issue or request | `/specs/[feature-id]-[slug].md` | 3–7 testable acceptance criteria with IDs |
| Plan | Spec | `/tasks/[feature-id]-[slug].md` | Every criterion mapped to one or more tasks |
| Test (`pre`) | Task file + spec | Failing tests committed | At least one failing test per criterion |
| Implement | Failing tests + task file | Passing code commits | Task statuses updated with evidence |
| Test (`post`) | Implemented feature + task file + spec | AC verification report + bug entries | All ACs verified or logged as bugs |
| Review | Spec + task file + diff + post-test report | PASS/FAIL review report | All criteria have passing test evidence |
| PR | Review PASS | Open PR with required checklist | CI and policy checks green |
| Merge | Approved PR | Merged branch + cleanup | Human merge approval or repo policy approval |

## Definition of Done

A feature is done only when all are true:

- Task file status counts show zero remaining tasks.
- Full test suite passes.
- Review report is PASS with criterion-level evidence.
- PR template is complete with verification and rollback.

## Context Discipline

- Start each phase in a fresh session when context quality drops.
- Prefer file artifacts over chat memory for continuity.
- If compacting repeatedly, split the feature and continue in a new branch.
- Persist orchestration state transitions in `/workflow/STATE.json` when using `/continue`.
