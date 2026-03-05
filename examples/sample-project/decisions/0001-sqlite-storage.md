# Decision 0001: Use SQLite for Local Storage

**Date:** 2026-02-15
**Status:** Accepted
**Task:** `../tasks/001-task-crud.md` (T-3)

## Context

TaskFlow needs a storage backend for task data. The constitution requires
zero external services and sub-200ms command latency. Options considered:

1. **Plain JSON file** — Simple but no query support, risky with concurrent
   writes, and performance degrades beyond a few hundred tasks.
2. **SQLite** — Single-file, ACID-compliant, built into Python's standard
   library, handles 10k+ rows trivially.
3. **TinyDB** — JSON-based document store. Adds a dependency and lacks the
   query performance of SQLite.

## Decision

Use SQLite via Python's built-in `sqlite3` module. Store the database at
`~/.taskflow/tasks.db`.

## Consequences

- **Positive:** Zero additional dependencies. ACID transactions prevent data
  corruption. Query performance well within the 200ms budget.
- **Positive:** Schema migrations are straightforward with `CREATE TABLE IF
  NOT EXISTS` for the initial version.
- **Negative:** Binary file format means tasks are not human-readable on disk.
  Mitigated by the `taskflow list` command.
- **Negative:** Future multi-device sync would require a separate solution.
  Accepted as out of scope per Spec 001.
