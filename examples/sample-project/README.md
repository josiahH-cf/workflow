# Sample Project: TaskFlow CLI

This directory shows what a **completed** project looks like after going through
all 8 phases of the Agent Workflow Scaffold.

**TaskFlow** is a fictional CLI task manager that stores tasks in SQLite. It
serves as a reference so you can see what each artifact looks like when fully
filled in.

## Artifact Map

| Artifact | Path | Phase |
|---|---|---|
| Constitution | `.specify/constitution.md` | 1 - Scaffold / Import |
| Feature Spec | `specs/001-task-crud.md` | 3 - Define Features |
| Task Breakdown | `tasks/001-task-crud.md` | 5 - Fine-Tune Plan |
| Decision Record | `decisions/0001-sqlite-storage.md` | 6 - Code |

## How Artifacts Reference Each Other

- The **spec** references the constitution for project-level constraints.
- The **tasks** reference the spec they implement.
- The **decision record** references the task that triggered the decision.

Browse each file to see realistic examples of EARS/GWT acceptance criteria,
task status tracking, and architectural decision records.
