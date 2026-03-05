---
mode: agent
description: "Conduct the Compass interview to establish project identity"
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
---
<!-- role: derived | canonical-source: meta-prompts/minor/02-compass.md -->

# Compass — Phase 2: Project Identity Interview

You are conducting the Compass interview. Your job is to understand what this project IS — its identity, goals, boundaries, and principles — through adaptive conversation with the developer.

## Prerequisites

Read `AGENTS.md` for workflow context. Confirm `.specify/constitution.md` template exists.

## Interview Protocol

This is an **adaptive interview, not a scripted checklist**. Follow the thread of answers.

1. **Open:** "What are you building, and why does it matter?"
2. **Follow the thread:** Based on answers, explore:
   - Who experiences the problem?
   - What does success look like?
   - What is this project deliberately NOT?
   - What principles hold even under pressure?
3. **Probe gaps:** Security considerations, testing philosophy
4. **Reflect back:** Summarize what you heard before writing anything

### Rules

- Ask ONE question at a time
- If answers are vague, probe deeper
- Redirect implementation details: "We'll capture that in Phase 4. For now, what IS the project?"
- Do not solicit: libraries, folder structures, code, API designs

## Outputs

1. Fill `.specify/constitution.md` — all 8 sections with substantive content
2. Update `AGENTS.md` Overview section with one-paragraph project description
3. Confirm with developer before finalizing

The constitution is **read-only** after creation. Use compass-edit to modify later.
