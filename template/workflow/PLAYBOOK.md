# Workflow Playbook

This document defines how an agent executes work from spec to merged PR.

## Global Rules

- Work from a single feature ID at a time.
- Keep branch scope aligned to the spec's Affected Areas.
- Record non-obvious decisions in `/decisions/` before continuing.
- Move forward only when the current phase gate is satisfied.
- Reference `.specify/constitution.md` for alignment on all design decisions.

## Project-Level Phase Gates (V2)

| Phase | Required Input | Required Output | Gate to Advance |
| ----- | -------------- | --------------- | --------------- |
| Compass | Scaffold files placed | `.specify/constitution.md` populated | All 8 sections have content (no placeholders) |
| Define Features | Constitution | Feature specs with Compass mapping | At least one feature spec exists |
| Scaffold Project | Feature specs | AGENTS.md Code Conventions + Core Commands | Neither section contains `[PROJECT-SPECIFIC]` |
| Fine-tune Plan | Architecture plan | Ordered tasks, ACs, model assignments | EARS/GWT ACs present, branch names assigned |
| Code | Fine-tuned specs | Passing code on feature branch | All tasks marked Complete, tests pass |
| Test | Implementation | Verified ACs, bug log reviewed | No blocking bugs, all ACs pass |
| Maintain | Shipped features | README, CONTRIBUTING, security baseline | Documentation exists and reflects current state |

## Feature-Level Phase Contract

| Phase | Required Input | Required Output | Gate to Advance |
| ----- | -------------- | --------------- | --------------- |
| Scope | Issue or request | `/specs/[feature-id]-[slug].md` | 3–7 testable acceptance criteria with IDs |
| Plan | Spec | `/tasks/[feature-id]-[slug].md` | Every criterion mapped to one or more tasks |
| Test | Task file + spec | Failing tests committed | At least one failing test per criterion |
| Implement | Failing tests + task file | Passing code commits | Task statuses updated with evidence |
| Review | Spec + task file + diff | PASS/FAIL review report | All criteria have passing test evidence |
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
