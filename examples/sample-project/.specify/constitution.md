<!-- This file is generated during Phase 2 (Compass). It is read-only during normal workflow. Edit only via /compass-edit or equivalent. -->

# Project Constitution

This document defines the project's identity, goals, and boundaries. It is the source of truth that every downstream phase references.

## Problem Statement

Developers manage tasks across multiple tools (Jira, Trello, sticky notes, text files), causing context-switching overhead. They need a fast, local-first task manager that lives in the terminal — where they already work.

## Target User

Individual developers and small teams who work primarily in the terminal. Comfortable with CLI tools, use git daily, value speed over GUI polish. Pain point: existing task managers require leaving the terminal or an internet connection.

## Definition of Success

A developer can add, list, complete, and delete tasks from the terminal in under 200ms per operation. Tasks persist locally in a single SQLite file. The tool is pip-installable and works offline.

## Core Capabilities

1. **Task CRUD:** Create, read, update, and delete tasks from the CLI
2. **Status tracking:** Mark tasks as todo, in-progress, or done with filtering
3. **Persistent storage:** SQLite-backed storage in `~/.taskflow/tasks.db`
4. **Fast operations:** All commands complete in under 200ms for up to 10,000 tasks

## Out-of-Scope Boundaries

- Not: a project management platform (no teams, no boards, no sprints)
- Not: a sync service (no cloud, no remote storage, no collaboration)
- Not: a GUI application (terminal-only)

## Inviolable Principles

1. Speed over features: never add a feature that makes any operation exceed 200ms
2. Offline-first: zero network dependencies at runtime
3. Single-file storage: the database is one portable SQLite file

## Security Requirements

No authentication needed (local-only tool). Database file permissions set to user-only (0600). No network access. No secrets or credentials stored.

## Testing Requirements

TDD required. pytest with pytest-cov, minimum 90% coverage. Unit tests for service and repository layers. Integration tests for CLI commands using Click's CliRunner. No mocking of SQLite — use in-memory database for tests. CI runs `ruff check`, `ruff format --check`, and `pytest` on every push.
