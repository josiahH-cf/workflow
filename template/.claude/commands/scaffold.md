<!-- role: derived | canonical-source: meta-prompts/minor/04-scaffold-project.md -->
description: Reason about project architecture and produce a technical plan (no code)

# Scaffold — Phase 4: Project Architecture Planning

You are reasoning about the technical architecture needed to deliver the features defined in Phase 3. You produce a plan — NOT code.

## Prerequisites

- `.specify/constitution.md` must exist (project identity)
- Feature specs must exist in `/specs/` (from Phase 3)
- If either is missing, tell the developer which phase to run first

## What This Does

Takes the feature specs and reasons about:

1. **Folder/module structure** — How should the codebase be organized?
2. **Dependencies** — What libraries, frameworks, or services are needed?
3. **Install steps** — How does a developer set up the project?
4. **Target environments** — Where does this run? (browser, server, CLI, mobile, etc.)
5. **API surfaces** — What interfaces exist between modules or services?
6. **Data models** — What are the core entities and their relationships?
7. **Gaps and unknowns** — What can't we answer yet? What needs research or decisions?

## What This Does NOT Do

- **This phase does not write code or create files** — it produces a plan
- Does not choose specific libraries without developer input
- Does not make irreversible architectural decisions without flagging them

## Protocol

1. **Read all feature specs** — understand the full scope
2. **Read the constitution** — check constraints (security, testing, principles)
3. **Reason through each dimension** listed above
4. **Surface unknowns explicitly** — gaps are listed, not silently skipped. For each gap:
   - What's unknown
   - What decision is needed
   - What the impact is of deferring
5. **Present the plan** to the developer for review
6. **Iterate** — multiple passes expected. Developer may redirect, add constraints, or resolve gaps.

## Key Rules

- List gaps explicitly — never silently skip something you're unsure about
- Present options when there are tradeoffs (e.g., "We could use X for speed or Y for flexibility")
- Do not make architectural decisions that conflict with the constitution's Inviolable Principles
- Mark anything that requires developer input as `[DECISION NEEDED]`

## Outputs

When the developer approves the scaffold plan:

1. **Update `AGENTS.md` Code Conventions section** — Replace placeholder with actual conventions (language, style, patterns)
2. **Update `AGENTS.md` Core Commands section** — Fill in actual build/test/lint commands
3. **Update each feature spec's Technical Approach section** — Fill in the architecture relevant to that feature
4. **Log any decisions** made during this phase to `/decisions/`

## After Completion

The scaffold plan feeds into Phase 5 (Fine-tune), where each feature spec gets broken into ordered tasks with model assignments and branches.
