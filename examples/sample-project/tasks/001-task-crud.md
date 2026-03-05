# Tasks for Spec 001: Task CRUD Operations

**Spec:** `../specs/001-task-crud.md`
**Status:** 7/7 complete

## Tasks

- [x] T-1: Initialize SQLite database and schema migration on first run.
  Covers: AC-1.

- [x] T-2: Implement `TaskRepository` with `create`, `get`, `list`, `update`,
  and `delete` methods. Covers: AC-1, AC-2, AC-3, AC-4.

- [x] T-3: Implement `TaskService` with business logic and validation.
  Covers: AC-5. Decision: `../decisions/0001-sqlite-storage.md`.

- [x] T-4: Implement `taskflow add` CLI command. Covers: AC-1.

- [x] T-5: Implement `taskflow list` CLI command with table output.
  Covers: AC-2.

- [x] T-6: Implement `taskflow done` and `taskflow rm` CLI commands.
  Covers: AC-3, AC-4.

- [x] T-7: Write integration tests for all CLI commands using `CliRunner`.
  Covers: AC-1, AC-2, AC-3, AC-4, AC-5.

## Summary

| Status | Count |
|--------|-------|
| Done   | 7     |
| Doing  | 0     |
| Todo   | 0     |
| **Total** | **7** |
