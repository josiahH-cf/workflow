# Phase 5: Spec & Acceptance Criteria Enhancement (EARS/GWT)

**Status:** not-started
**Depends on:** Phase 1 (AGENTS.md decomposition must be complete)
**Parallelizable with:** Phases 3, 4, 6, 7

## Objective

Upgrade spec and AC templates to use EARS/GWT notation (`GIVEN [precondition], WHEN [action], THEN [expected outcome]`) for machine-verifiable acceptance criteria. Strengthen the spec → test → code traceability chain.

## Rationale

GitHub Spec Kit's EARS notation makes acceptance criteria directly translatable to test cases. Current templates use generic "testable statement" format (`AC-1: [Criterion 1]`) without structured notation. This leaves room for vague, untestable criteria that agents struggle to verify. The GWT format creates a 1:1 mapping between criteria and test assertions.

## Context Files to Read First

- `template/specs/_TEMPLATE.md` — Current spec template (will be enhanced)
- `template/tasks/_TEMPLATE.md` — Current task template (will be enhanced)
- `template/workflow/SPECS.md` — (from Phase 1) Specification workflow reference (add notation guide)
- `examples/sample-project/specs/001-task-crud.md` — Example spec (will be rewritten)
- `examples/sample-project/tasks/001-task-crud.md` — Example tasks (reference for traceability)
- `examples/sample-project/.specify/constitution.md` — Example constitution (context for spec rewrite)
- `building-agents-examples.md` — Search for "EARS notation", "GIVEN", "acceptance criteria"

## Steps

### Step 1: Update `template/specs/_TEMPLATE.md`

Replace the generic AC format with EARS/GWT notation. Enhance the verification map.

**Current AC section:**
```markdown
## Acceptance Criteria
- [ ] **AC-1:** [Criterion 1]
- [ ] **AC-2:** [Criterion 2]
- [ ] **AC-3:** [Criterion 3]
```

**New AC section:**
```markdown
## Acceptance Criteria

<!-- 3–7 testable criteria using GIVEN/WHEN/THEN (GWT) format.
     Each criterion must be independently verifiable by an automated test.

     Format:
       GIVEN [precondition or initial state],
       WHEN [action or event],
       THEN [expected outcome or observable result].

     EARS extensions (optional):
       WHILE [ongoing state], WHEN [trigger], THEN [outcome]  — for state-dependent behavior
       WHERE [feature is supported], WHEN [action], THEN [outcome]  — for conditional features
       IF [condition], THEN [outcome]  — for unconditional requirements
-->

- [ ] **AC-1:** GIVEN [precondition], WHEN [action], THEN [expected outcome]
- [ ] **AC-2:** GIVEN [precondition], WHEN [action], THEN [expected outcome]
- [ ] **AC-3:** GIVEN [precondition], WHEN [action], THEN [expected outcome]
```

**Current Verification Map:**
```markdown
## Verification Map
- AC-1 → [test file or suite]
- AC-2 → [test file or suite]
```

**New Verification Map:**
```markdown
## Verification Map

<!-- Map each criterion to its exact test location. Every AC must have a test. -->

| AC | Test File | Test Function | Assertion |
|----|-----------|---------------|-----------|
| AC-1 | [path/to/test_file.py] | [test_function_name] | [what the test asserts] |
| AC-2 | [path/to/test_file.py] | [test_function_name] | [what the test asserts] |
| AC-3 | [path/to/test_file.py] | [test_function_name] | [what the test asserts] |
```

**Add new section after Verification Map:**
```markdown
## Contracts

<!-- Interfaces, types, or API contracts this feature exposes or consumes.
     Define these BEFORE implementation to enable parallel agent work.
     Leave empty if this feature has no public interfaces. -->

- Exposes: [interface/type/endpoint]
- Consumes: [interface/type/endpoint]
```

### Step 2: Update `template/tasks/_TEMPLATE.md`

Enhance the task template with test-first traceability.

**Add new section after Status block:**
```markdown
## Pre-Implementation Tests

<!-- List test files to create BEFORE coding. These are written during `/test pre` mode. -->

| AC | Test File | Status |
|----|-----------|--------|
| AC-1 | [path/to/test_file.py::test_name] | [ ] Not written |
| AC-2 | [path/to/test_file.py::test_name] | [ ] Not written |
| AC-3 | [path/to/test_file.py::test_name] | [ ] Not written |
```

**Enhance each task block** — add a `Test File` field:
```markdown
### T-1: [name]

- **Files:** [list]
- **Test File:** [test file covering this task's criteria]
- **Done when:** [one sentence]
- **Criteria covered:** [AC-1, AC-2]
- **Model:** [claude|copilot|codex]
- **Branch:** [model/type-short-description]
- **Status:** [ ] Not started
```

### Step 3: Add notation reference to `template/workflow/SPECS.md`

This file was created in Phase 1 (extracted from AGENTS.md). Add a notation reference section at the end:

```markdown
## Acceptance Criteria Notation

This project uses **GWT (Given/When/Then)** notation for all acceptance criteria, based on the EARS (Easy Approach to Requirements Syntax) framework.

### Format

```
GIVEN [precondition or initial state],
WHEN [action or event],
THEN [expected outcome or observable result].
```

### EARS Extensions

| Pattern | Use When | Example |
|---------|----------|---------|
| `GIVEN...WHEN...THEN` | Standard behavior | GIVEN a logged-in user, WHEN they click logout, THEN the session is destroyed |
| `WHILE...WHEN...THEN` | State-dependent behavior | WHILE the server is offline, WHEN a request arrives, THEN it is queued locally |
| `WHERE...WHEN...THEN` | Conditional features | WHERE dark mode is enabled, WHEN the page loads, THEN the dark theme is applied |
| `IF...THEN` | Unconditional requirement | IF the input is empty, THEN display a validation error |

### Why GWT?

- **Translatable to tests:** Each GWT criterion maps directly to a test: the GIVEN is the setup, the WHEN is the action, the THEN is the assertion.
- **Machine-verifiable:** Agents can parse GWT format to auto-generate test skeletons.
- **Prevents vague criteria:** Forces specificity about preconditions and expected outcomes.

### Anti-patterns

- ❌ `AC-1: The system should work correctly` — not testable
- ❌ `AC-1: Users should be able to log in` — no precondition or expected outcome
- ✅ `AC-1: GIVEN valid credentials, WHEN the user submits the login form, THEN the system redirects to the dashboard and sets a session cookie`
```

### Step 4: Rewrite `examples/sample-project/specs/001-task-crud.md`

Rewrite the example spec using EARS/GWT notation to serve as a reference implementation.

**Current format:**
```
- [x] AC-1: Create task — When the user runs `taskflow add "Buy milk"`, the
  system creates a task with status `todo` and prints the task ID.
```

**New format (rewrite the full file):**
```markdown
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
```

## Verification Checklist

- [ ] `template/specs/_TEMPLATE.md` uses GWT format for all AC placeholders
- [ ] `template/specs/_TEMPLATE.md` has enhanced Verification Map with table format (AC, Test File, Test Function, Assertion)
- [ ] `template/specs/_TEMPLATE.md` has a Contracts section
- [ ] `template/tasks/_TEMPLATE.md` has a Pre-Implementation Tests section with table
- [ ] `template/tasks/_TEMPLATE.md` task blocks include a `Test File` field
- [ ] `template/workflow/SPECS.md` has Acceptance Criteria Notation section with GWT format, EARS extensions, anti-patterns
- [ ] `examples/sample-project/specs/001-task-crud.md` uses GWT format for all 5 ACs
- [ ] `examples/sample-project/specs/001-task-crud.md` has Verification Map table, Contracts section, Feature ID
- [ ] There are no remaining generic `[Criterion N]` placeholders in the spec template (replaced with GWT)
- [ ] GWT notation guide includes at least 3 EARS extension patterns

## Completion

When all verification checks pass, update this file:
- Change `**Status:** not-started` to `**Status:** done`
- Add completion timestamp
