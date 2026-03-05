---
mode: agent
description: 'Adaptive interview to establish project identity and boundaries'
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
---
<!-- role: derived | canonical-source: meta-prompts/minor/02-compass.md -->
<!-- generated-from-metaprompt -->

[AGENTS.md](../template/AGENTS.md)

# Phase 2 — Compass

**Objective:** Conduct an adaptive interview to establish the project's identity, goals, success criteria, and boundaries. This produces the constitution — the source of truth that all later phases reference.

**Trigger:** Phase 1 complete (scaffold files in place) or `/compass` invoked manually.

**Entry commands:**
- Claude: `/compass`
- Copilot: `compass.prompt.md`
- Codex: see `.codex/AGENTS.md`

---

## What Happens

An adaptive interview (not a scripted checklist) covers:

1. **Problem Statement** — What problem does this project solve?
2. **Target User** — Who is the primary audience?
3. **Definition of Success** — How do we know the project succeeds?
4. **Core Capabilities** — What must the project do? (features at the capability level)
5. **Out-of-Scope Boundaries** — What will this project explicitly NOT do?
6. **Inviolable Principles** — What rules can never be broken?
7. **Security Requirements** — What security standards apply?
8. **Testing Requirements** — What testing standards apply?

The interview is adaptive — follow-up questions are driven by the developer's answers, not a fixed script.

## Gate

- `.specify/constitution.md` exists with all 8 sections populated (no `[PROJECT-SPECIFIC]` placeholders)
- `AGENTS.md → Overview` section is filled with project description

## Output

- `.specify/constitution.md` — project identity document
- `AGENTS.md → Overview` — one-paragraph project description

## Editing the Constitution

Use `/compass-edit` (Claude) to modify the constitution after initial creation. This requires explicit developer approval and shows a diff of changes.

## See Also

- Constitution template: `.specify/constitution.md`
- Edit gate: `.claude/commands/compass-edit.md`
- v1 equivalent: Phase 0 (Ideate) — v2 absorbs ideation into the Compass interview
