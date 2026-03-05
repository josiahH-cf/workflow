---
mode: agent
description: "Order specs for execution, assign models, create branches"
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
---
<!-- role: derived | canonical-source: meta-prompts/minor/05-fine-tune-plan.md -->

# Fine-Tune — Phase 5: Execution Plan Finalization

Finalize the build plan: order task breakdowns, write acceptance criteria, assign models, and name branches.

## Prerequisites

- `.specify/constitution.md` must exist
- Feature specs in `/specs/` with Technical Approach filled in
- `AGENTS.md` Core Commands and Code Conventions populated

## Steps

### 1. Order Task Breakdowns

For each feature spec, produce an ordered list of tasks sized for one commit.

### 2. Write Acceptance Criteria

Use the EARS + GWT format from `.specify/acceptance-criteria-template.md`:

**EARS** — `When [trigger], the system shall [response]`
**GWT** — `Given [context], When [action], Then [outcome]`

Every criterion must be a machine-parseable checkbox: `- [ ] criterion`.

### 3. Assign Models

Reference `AGENTS.md → Agent Routing Matrix` to assign each task:
- **Claude** — complex reasoning, multi-file refactors
- **Copilot** — UI iteration, single-file edits, chat-driven work
- **Codex** — batch/CI tasks, unattended operations

### 4. Name Branches

Apply `AGENTS.md → Branch Naming`:
```
model/type-short-description
```
Example: `claude/feat-auth-flow`, `codex/chore-lint-fix`

### 5. Second-Model Review

Each task should note which model will review it (different from the implementer).

## Outputs

- Updated feature specs with ordered tasks and ACs
- Model assignments and branch names recorded
- Summary table for developer approval
