# Router Index

Use this file as the single source of truth for loop routing.

## Status Values
- `PENDING`
- `IN_PROGRESS`
- `DONE`
- `BLOCKED`

## Table
| Order | Meta Prompt Path | Goal | Depends On | Status | Completed On | Notes |
|---|---|---|---|---|---|---|
| 0 | docs/verification/revision-meta-prompts/00-router-wrapper.md | Route to next executable prompt repeatedly | none | DONE | 2026-03-06 | Bootstrap router created |
| 1 | docs/verification/revision-meta-prompts/01-command-flow-unification.md | Unify /implement and /continue goal semantics and bug routing | 0 | DONE | 2026-03-06 | Role clarity + bug-routing + next-action definition applied across 9 files |
| 2 | docs/verification/revision-meta-prompts/02-tool-call-flexibility.md | Remove avoidable internal tool constraints | 0 | DONE | 2026-03-06 | Full restriction audit across 18 files; validation: docs/verification/revision-meta-prompts/02-validation-note.md |
| 3 | docs/verification/revision-meta-prompts/03-compass-dynamic-discovery.md | Make Compass dynamic broad-to-specific discovery | 0 | DONE | 2026-03-06 | Dynamic discovery model, guiding themes, ambiguity tracking, constitution template updated |
| 4 | docs/verification/revision-meta-prompts/04-define-features-interview-and-test-planning.md | Enforce interview-first define-features and plan-only test intent | 3 | DONE | 2026-03-06 | Interview-first with critical-thinking questions, drill-down rule, test planning intent section in spec template |
| 5 | docs/verification/revision-meta-prompts/05-scaffold-agents-ownership.md | Clarify AGENTS ownership handoff between Compass and Scaffold | 3 | DONE | 2026-03-06 | Ownership split: Compass→Overview+constitution, Scaffold→COMMANDS.md; FILE_CONTRACTS.md rows added; init writes initial values to COMMANDS.md, Phase 4 finalizes |
| 6 | docs/verification/revision-meta-prompts/06-fine-tune-stability-routing-and-roadmap.md | Improve fine-tune stability and advisory routing roadmap outputs | 1 | DONE | 2026-03-06 | Structural anti-stall, advisory routing plan, session log resumption |
| 7 | docs/verification/revision-meta-prompts/07-maintain-levels-and-project-status.md | Define 3-level project-wide maintenance semantics | 0 | DONE | 2026-03-06 | Light/Standard/Deep levels; maintenanceLevel field in STATE.json; ongoing-mode framing; feature re-entry guidance |
| 8 | docs/verification/revision-meta-prompts/08-phase-numbering-consistency.md | Apply Phase N naming consistency across workflow assets | 0 | DONE | 2026-03-06 | 15 meta-prompt + 14 prompt file renames; ~30 files updated; Phase 7b documented in LIFECYCLE.md |
| 9 | docs/verification/revision-meta-prompts/09-step0-artifact-necessity-audit.md | Audit Step 0 artifacts for unique purpose and path validity | 0 | PENDING |  |  |
| 10 | docs/verification/revision-meta-prompts/10-workflow-linting-observability.md | Define non-destructive linting and callout process | 8 | PENDING |  |  |
| 11 | docs/verification/revision-meta-prompts/11-governance-clarity-and-impact.md | Produce governance explainer and impact matrix | 0 | PENDING |  |  |
| 12 | docs/verification/revision-meta-prompts/12-review-bot-phase.md | Add non-blocking objective review-bot phase goals | 8 | PENDING |  |  |
| 13 | docs/verification/revision-meta-prompts/13-phase-x-releases.md | Define context-aware release phase goals | 8 | PENDING |  |  |
| 14 | docs/verification/revision-meta-prompts/14-agent-rules-framework.md | Define AGENTS rule framework for this and other projects | 5 | PENDING |  |  |
| 15 | docs/verification/revision-meta-prompts/15-cross-project-feedback-loop.md | Define reliable cross-project improvement intake process | 0 | PENDING |  |  |
| 16 | docs/verification/revision-meta-prompts/16-workflow-idea-command.md | Define /workflow-idea intake capability goals | 15 | PENDING |  |  |
| 17 | docs/verification/revision-meta-prompts/17-context-sensitive-advisory-guidance.md | Define always-on advisory context-sensitive guidance | 1,6 | PENDING |  |  |
| 18 | docs/verification/revision-meta-prompts/18-generated-surface-clutter-mitigation.md | Reduce generated-project clutter while preserving traceability | 9 | PENDING |  |  |
| 19 | docs/verification/revision-meta-prompts/19-cross-review-suggestion-tone.md | Make late-phase environment suggestions minimal and optional | 12 | PENDING |  |  |
| 999 | docs/verification/revision-meta-prompts/phase-x-completeness-audit.md | Validate full coverage and coherence of all revision outputs | 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19 | PENDING |  | Terminal validation |

## Update Rules
1. Keep one row per executable meta-prompt.
2. Do not delete historical rows.
3. Use `BLOCKED` with a short reason in `Notes` when dependencies cannot be resolved.
4. Add new rows in execution order as prompt files are created.
