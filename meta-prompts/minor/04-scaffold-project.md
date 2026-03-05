<!-- role: canonical-source -->
<!-- phase: 4 -->
<!-- description: Reason about technical architecture — produce a plan, not code -->
# Phase 4 — Scaffold Project

**Objective:** Reason about the technical architecture needed to deliver the defined features. Produce a plan, NOT code.

**Trigger:** Phase 3 complete (feature specs exist).

**Entry commands:**
- Claude: `/scaffold`
- Copilot: `scaffold.prompt.md`

---

## What Happens

1. Read constitution and all feature specs
2. Reason about 7 dimensions:
   - Folder/module structure
   - Dependencies and frameworks
   - Install and setup steps
   - Target environments
   - API surfaces between modules
   - Data models and entities
   - Gaps and unknowns
3. Present options for tradeoffs — don't decide unilaterally
4. Mark items needing developer input as `[DECISION NEEDED]`
5. List gaps explicitly — never skip unknowns

## Gate

- `AGENTS.md → Code Conventions` section populated (not placeholder)
- `AGENTS.md → Core Commands` section populated with project-specific commands
- Folder structure documented
- Decisions logged in `/decisions/`

## Output

- Updated `AGENTS.md` (Code Conventions, Core Commands)
- Technical approach documented in feature specs
- Decision records in `/decisions/`

## Rules

- **No application code is written in this phase.** Planning outputs may update AGENTS/spec/decision artifacts only.
- Multiple passes expected — iterate with the developer

## See Also

- v1 equivalent: Part of Phase 2 (Plan) — v2 separates architecture reasoning from task breakdown
