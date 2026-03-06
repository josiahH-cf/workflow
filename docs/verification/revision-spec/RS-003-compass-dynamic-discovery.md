# RS-003 Compass Dynamic Discovery

## Status: DONE (2026-03-06)

## Goal
Define Compass behavior as a dynamic discovery process that starts broad and narrows only as context justifies specificity.

## In Scope
- Broad-to-specific interviewing expectation.
- Dynamic stage depth based on context quality.
- Optional persona use without requiring fixed persona sets.
- Explicit synthesis of what the project is, is not, and still ambiguous.

## Out of Scope
- Fixed question bank implementation details.
- Rigid stage count requirements.

## Observable Outcomes
- Compass interactions avoid premature technical narrowing.
- Output includes boundaries and ambiguity summary.

## Dependencies
- None.

## Linked Meta-Prompt
- `docs/verification/revision-meta-prompts/03-compass-dynamic-discovery.md`

## Evidence of Completion

### Files Modified
- `meta-prompts/phase-2-compass.md` — Rewrote "What Happens" to dynamic discovery model with guiding themes, optional personas, and ambiguity tracking
- `meta-prompts/phase-2b-compass-edit.md` — Relaxed fixed 8-section constraint to allow dynamic structure
- `prompts/phase-2-compass.prompt.md` — Mirrored canonical changes
- `prompts/phase-2b-compass-edit.prompt.md` — Mirrored canonical changes
- `template/.claude/commands/compass.md` — Mirrored canonical changes
- `template/.claude/commands/compass-edit.md` — Mirrored canonical changes
- `template/workflow/FILE_CONTRACTS.md` — Updated constitution contract from fixed 8-section to theme-based
- `template/workflow/PLAYBOOK.md` — Updated Compass gate from "All 8 sections" to theme coverage + ambiguity documented
- `template/workflow/BOUNDARIES.md` — Updated Phase 2 write-exception wording
- `template/workflow/FAILURE_ROUTING.md` — Updated compass-gap fallback to reference theme coverage
- `template/.specify/constitution.md` — Restructured template with guiding themes, renamed sections, added Ambiguity Tracking section
- `prompts/initialization.prompt.md` — Updated STEP 6 compass description to dynamic discovery
- `template/.claude/commands/initialization.md` — Mirrored STEP 6 changes
- `meta-prompts/admin/initialization.md` — Mirrored STEP 6 changes
- `prompts/phase-9-continue.prompt.md` — Updated 2-compass action to reference theme coverage
- `template/.claude/commands/continue.md` — Mirrored continue changes
- `meta-prompts/phase-9-continue.md` — Mirrored continue changes
- `template/AGENTS.md` — Updated Phase 2 description and output
- `template/CLAUDE.md` — Updated Phase 2 one-liner
- `template/workflow/LIFECYCLE.md` — Updated Phase 2 action description
- `README.md` — Updated compass description
- `docs/quickstart-first-success.md` — Updated compass user-facing description

### Key Changes
1. **8-section checklist → guiding themes**: The 8 topics are now themes explored with variable depth, not mandatory sequential sections
2. **Ambiguity tracking**: New first-class concept — constitution documents what is known, unknown, and deferred
3. **Gate criteria**: Shifted from "all 8 sections populated" to "all relevant themes addressed, ambiguities documented"
4. **Constitution template**: Restructured with renamed sections (Problem Statement → Problem & Context, etc.) and new Ambiguity Tracking section
5. **Section flexibility**: `/compass-edit` can now add/restructure sections with developer approval
6. **Personas optional**: Explicitly documented as use-when-helpful, not required
