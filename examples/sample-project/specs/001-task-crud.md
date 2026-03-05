# Spec 001: Task CRUD Operations

**Feature ID:** 001-task-crud
**Status:** Done
**Constitution:** `../.specify/constitution.md`
**Decision Records:** `../decisions/0001-sqlite-storage.md`

## Description

Implement create, read, update, and delete operations for tasks via the CLI. Each task has a title, status (todo/done), and timestamps. This is the core functionality required before any other feature.

## Acceptance Criteria

- [x] **AC-1:** GIVEN the CLI is installed, WHEN the user runs `taskflow add "Buy milk"`, THEN the system creates a task with status `todo` and prints the new task ID to stdout.

- [x] **AC-2:** GIVEN at least one task exists, WHEN the user runs `taskflow list`, THEN the system displays all tasks in a table with columns: ID, Title, Status.

- [x] **AC-3:** GIVEN task 1 exists with status `todo`, WHEN the user runs `taskflow done 1`, THEN the system sets task 1 status to `done` and prints confirmation.

- [x] **AC-4:** GIVEN task 1 exists, WHEN the user runs `taskflow rm 1`, THEN the system permanently deletes task 1 and prints confirmation.

- [x] **AC-5:** GIVEN no task with ID 999 exists, WHEN the user runs any command targeting ID 999, THEN the system prints an error message to stderr and exits with code 1.

## Affected Areas

- `src/taskflow/repository.py` — SQLite data access layer
- `src/taskflow/service.py` — Business logic and validation
- `src/taskflow/cli.py` — Click CLI commands
- `tests/test_cli.py` — Integration tests

## Constraints

- All operations must complete in < 200ms (constitution principle: speed over features)
- Zero network access (constitution principle: offline-first)
- Single-file SQLite storage at `~/.taskflow/tasks.db`

## Out of Scope

- Subtasks, tags, and priorities (planned for Spec 002)
- Cloud sync or multi-device support
- GUI or TUI interface

## Dependencies

- Python 3.10+ standard library (`sqlite3`, `pathlib`)
- Click (CLI framework)

## Verification Map

| AC | Test File | Test Function | Assertion |
|----|-----------|---------------|-----------|
| AC-1 | `tests/test_cli.py` | `test_add_task` | Exit code 0, task ID printed, DB contains new row |
| AC-2 | `tests/test_cli.py` | `test_list_tasks` | Exit code 0, output contains table headers and task data |
| AC-3 | `tests/test_cli.py` | `test_done_task` | Exit code 0, DB row status = "done", confirmation printed |
| AC-4 | `tests/test_cli.py` | `test_rm_task` | Exit code 0, DB row deleted, confirmation printed |
| AC-5 | `tests/test_cli.py` | `test_missing_task_error` | Exit code 1, stderr contains error message |

## Contracts

- Exposes: `TaskRepository` class with `add()`, `list()`, `complete()`, `delete()` methods
- Exposes: CLI commands `add`, `list`, `done`, `rm` via Click
- Consumes: SQLite3 standard library

## Execution Linkage

- Task file: `/tasks/001-task-crud.md`
- Task ordering, model assignment, and branch naming live in the task file

## Notes

- Decision record `0001-sqlite-storage.md` documents why SQLite was chosen over JSON/TinyDB
- The 200ms performance constraint should be tested with a fixture of 1000 rows
