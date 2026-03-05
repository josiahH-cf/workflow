---
mode: agent
description: "Reason about project architecture and produce a technical plan"
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
---
<!-- role: derived | canonical-source: meta-prompts/minor/04-scaffold-project.md -->

# Scaffold — Phase 4: Project Architecture Planning

Reason about the technical architecture needed to deliver features. Produce a **plan, not code**.

## Prerequisites

- `.specify/constitution.md` must exist
- Feature specs must exist in `/specs/`

## What to Reason About

1. **Folder/module structure** — How should the codebase be organized?
2. **Dependencies** — What libraries, frameworks, services are needed?
3. **Install steps** — How does a developer set up from scratch?
4. **Target environments** — Browser, server, CLI, mobile?
5. **API surfaces** — Interfaces between modules or services
6. **Data models** — Core entities and relationships
7. **Gaps and unknowns** — What can't we answer yet?

### Rules

- **Do not write code or create project files** — produce a plan only
- List gaps explicitly — never silently skip unknowns
- Present options for tradeoffs
- Mark items needing developer input as `[DECISION NEEDED]`
- Multiple passes expected — iterate with the developer

## Outputs

1. Update `AGENTS.md` Code Conventions and Core Commands sections
2. Fill Technical Approach in each feature spec
3. Log decisions to `/decisions/`
4. Present plan for developer approval
