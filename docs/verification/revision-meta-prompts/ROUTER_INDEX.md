# Router Index

Use this file as the single source of truth for loop routing.

## Status Values
- `PENDING`
- `IN_PROGRESS`
- `DONE`
- `BLOCKED`
- `ARCHIVED`

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
| 9 | docs/verification/revision-meta-prompts/09-step0-artifact-necessity-audit.md | Audit Step 0 artifacts for unique purpose and path validity | 0 | DONE | 2026-03-06 | All 17 artifact groups assessed NECESSARY; 0 consolidation candidates; 2 minor documentation recommendations (R1: STATE.json in update Protect list, R2: install.sh .gitignore note); template merge behavior validated with 2 acceptable gaps |
| 10 | docs/verification/revision-meta-prompts/10-workflow-linting-observability.md | Define non-destructive linting and callout process | 8 | DONE | 2026-03-06 | LINT_CONTRACT.md + workflow-lint.sh created; wired into FILE_CONTRACTS, COMMANDS, PLAYBOOK, POLICY_TESTS, REGISTRY; validate-scaffold updated |
| 11 | docs/verification/revision-meta-prompts/11-governance-clarity-and-impact.md | Produce governance explainer and impact matrix | 0 | DONE | 2026-03-06 | Explainer + impact matrix in docs/verification/; 14 POLICY_TESTS rules classified (13 hard, 1 advisory) |
| 12 | docs/verification/revision-meta-prompts/12-review-bot-phase.md | Add non-blocking objective review-bot phase goals | 8 | DONE | 2026-03-06 | Phase 7a: automated full-rubric review + auto commit/push/merge (default path); findings file on FAIL for /continue re-entry; new meta-prompt, prompt, agent file, + updates to LIFECYCLE, AGENTS, PLAYBOOK, FILE_CONTRACTS, ROUTING, ORCHESTRATOR, FAILURE_ROUTING, COMMANDS |
| 13 | docs/verification/revision-meta-prompts/13-phase-x-releases.md | Define interview-driven automation config phase (Phase 9 — Operationalize) | 8 | DONE | 2026-03-06 | Reworked from release planning to interview-driven Phase 9: Operationalize; meta-prompt + prompt + Claude command + release-publish.yml + maintenance-config.yml template; /continue renumbered to phase-10; LIFECYCLE, AGENTS, PLAYBOOK, ORCHESTRATOR, sync-prompts, validate-scaffold updated |
| 14 | docs/verification/revision-meta-prompts/14-agent-rules-framework.md | Remove hardcoded agent-to-task bindings; enable dynamic multi-agent `/continue` coordination | 5 | DONE | 2026-03-06 | Advisory-only routing matrix; claim-based multi-agent coordination; model-neutral branch naming and worktree setup; STATE.json v2 with activeClaims; 20+ files updated across template, prompts, meta-prompts |
| 15 | docs/verification/archive_after_run/archived-meta-prompts/15-cross-project-feedback-loop.md | Define reliable cross-project improvement intake process | 0 | ARCHIVED | 2026-03-06 | No longer needed; archived |
| 16 | docs/verification/archive_after_run/archived-meta-prompts/16-workflow-idea-command.md | Define /workflow-idea intake capability goals | 15 | ARCHIVED | 2026-03-06 | No longer needed; archived with #15 |
| 17 | docs/verification/revision-meta-prompts/17-context-sensitive-advisory-guidance.md | Define always-on advisory context-sensitive guidance | 1,6 | DONE | 2026-03-06 | advisoryProfile field in STATE.json; 3-tier advisory model (Inform/Suggest/Recommend) in ORCHESTRATOR + ROUTING; auto-detected in Compass, periodic callout in /continue outer loop; lighter-touch approach — rules in ORCHESTRATOR/ROUTING, not per-prompt rewrites |
| 18 | docs/verification/revision-meta-prompts/18-generated-surface-clutter-mitigation.md | Reduce generated-project clutter while preserving traceability | 9 | ARCHIVED | 2026-03-06 | Skipped; strategy documented but not implemented |
| 19 | docs/verification/archive_after_run/archived-meta-prompts/19-cross-review-suggestion-tone.md | Make late-phase environment suggestions minimal and optional | 12 | ARCHIVED | 2026-03-06 | No longer needed; archived |
| 20 | docs/verification/revision-meta-prompts/20-workflow-diagram-update.md | Update workflow diagram to reflect all lifecycle changes | 12,13 | DONE | 2026-03-06 | Full Mermaid rewrite: Phase 7a PASS/FAIL branching, Phase 7b dashed fallback, Phase 9 Operationalize, Project Setup subgraph, findings re-entry path, feature cycling diamond |
| 21 | docs/verification/revision-meta-prompts/21-QA and Deletion.md | Final QA: completeness audit + simplification analysis + cleanup + system verification (absorbs #999) | 17,20 | PENDING |  |  |
| 999 | docs/verification/revision-meta-prompts/phase-x-completeness-audit.md | Validate full coverage and coherence of all revision outputs | — | ARCHIVED | 2026-03-06 | Absorbed into #21; completeness audit is now Pass 1 of Phase 21 |

## Update Rules
1. Keep one row per executable meta-prompt.
2. Do not delete historical rows.
3. Use `BLOCKED` with a short reason in `Notes` when dependencies cannot be resolved.
4. Add new rows in execution order as prompt files are created.
