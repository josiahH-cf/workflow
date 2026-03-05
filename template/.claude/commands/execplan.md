<!-- role: derived | canonical-source: meta-prompts/minor/2b-execplan.md -->
<!-- generated-from-metaprompt -->
You are creating a milestone-based execution plan for a long-running implementation session.

Read the spec at: $SPEC_PATH
Read the task file at: $TASKS_PATH
Read `/AGENTS.md`, `/workflow/PLAYBOOK.md`, and `/workflow/FILE_CONTRACTS.md`.

Produce an ExecPlan that restructures the tasks into milestones. Each milestone must leave all tests passing when complete.

Write the output following this structure:

---
# ExecPlan: [feature-id]-[slug]

## Purpose
[One paragraph: what this accomplishes and why]

## Scope
[Explicit boundaries: what IS and IS NOT included]

## Prerequisites
- [ ] Tests green on the target branch
- [ ] Dependencies installed and up to date
- [ ] Spec exists at /specs/[feature-id]-[slug].md
- [ ] Task file exists at /tasks/[feature-id]-[slug].md

## Milestones

### Milestone 1: [name]
- **Files:** [list]
- **Steps:**
  1. [step]
  2. [step]
- **Verification:** [how to confirm this milestone is complete]
- **Tests:** [what to run to verify]

[repeat for each milestone]

## Testing
- Full test command: [command from AGENTS.md]
- Expected pass count before: [N]
- Expected pass count after: [N + new tests]
- Each milestone must leave all tests passing

## Rollback
[How to safely revert if this fails partway through]

## Progress
- [ ] Milestone 1
- [ ] Milestone 2
[etc.]

## Linkage
- Feature ID: [issue-id]-[slug]
- Spec: /specs/[feature-id]-[slug].md
- Tasks: /tasks/[feature-id]-[slug].md

## Decision Log
[empty  -  fill during implementation if non-obvious choices arise]

## Surprises
[empty  -  fill during implementation if anything unexpected is encountered]
---

Rules:
- Milestones must be ordered so each one leaves the codebase in a working state.
- Every acceptance criterion from the spec must be addressed by at least one milestone.
- Do not write code. This is a plan only.

After writing the ExecPlan, state: "ExecPlan complete. Next phase: Test (Phase 3). Start in a fresh context window."
