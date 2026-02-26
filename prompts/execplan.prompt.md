---
description: 'Convert a task plan into a milestone-based execution plan'
agent: 'agent'
---
<!-- generated-from-metaprompt -->

[AGENTS.md](../../AGENTS.md)

You are creating a milestone-based execution plan for a long-running implementation session.

Read the spec at: ${input:specPath:Path to the spec file}
Read the task file at: ${input:tasksPath:Path to the task file}
Read the project's conventions file (AGENTS.md).

Produce an ExecPlan that restructures the tasks into milestones. Each milestone must leave all tests passing when complete.

Write the output following this structure:

# ExecPlan: [feature-name]

## Purpose
[One paragraph: what this accomplishes and why]

## Scope
[Explicit boundaries: what IS and IS NOT included]

## Prerequisites
- [ ] Tests green on the target branch
- [ ] Dependencies installed and up to date
- [ ] Spec exists at /specs/[feature-name].md

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

## Decision Log
[empty — fill during implementation if non-obvious choices arise]

## Surprises
[empty — fill during implementation if anything unexpected is encountered]

Rules:
- Milestones must be ordered so each one leaves the codebase in a working state.
- Every acceptance criterion from the spec must be addressed by at least one milestone.
- Do not write code. This is a plan only.

After writing the ExecPlan, state: "ExecPlan complete. Next phase: Test (Phase 3). Start in a fresh context window."
