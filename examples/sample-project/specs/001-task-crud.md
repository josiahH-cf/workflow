# Spec 001: Task CRUD Operations

**Status:** Done
**Constitution:** `../.specify/constitution.md`
**Decision Records:** `../decisions/0001-sqlite-storage.md`

## Summary

Implement create, read, update, and delete operations for tasks via the CLI.
Each task has a title, optional description, status (todo/doing/done), and
timestamps.

## Motivation

Core functionality required before any other feature can be built. Referenced
in Constitution Section 2 (Purpose).

## Acceptance Criteria

- [x] AC-1: Create task — When the user runs `taskflow add "Buy milk"`, the
  system creates a task with status `todo` and prints the task ID.
  Verification: `pytest tests/test_cli.py::test_add_task` passes.

- [x] AC-2: List tasks — When the user runs `taskflow list`, the system
  displays all tasks in a table with ID, title, and status columns.
  Verification: `pytest tests/test_cli.py::test_list_tasks` passes.

- [x] AC-3: Update status — When the user runs `taskflow done 1`, the system
  sets task 1 status to `done` and prints confirmation.
  Verification: `pytest tests/test_cli.py::test_done_task` passes.

- [x] AC-4: Delete task — When the user runs `taskflow rm 1`, the system
  removes task 1 and prints confirmation.
  Verification: `pytest tests/test_cli.py::test_rm_task` passes.

- [x] AC-5: Error handling — When the user references a non-existent task ID,
  the system prints an error message and exits with code 1.
  Verification: `pytest tests/test_cli.py::test_missing_task_error` passes.

## Out of Scope

- Subtasks, tags, and priorities (planned for Spec 002).
- Syncing or cloud storage.
