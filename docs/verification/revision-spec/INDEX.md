# Revision Spec Index

Purpose: map every finding to a standalone goal spec and linked execution meta-prompt.

## Coverage Map

| Spec ID | Spec File | Meta-Prompt | Source Findings Coverage |
|---|---|---|---|
| RS-001 | docs/verification/revision-spec/RS-001-command-flow-unification.md | docs/verification/revision-meta-prompts/01-command-flow-unification.md | /implement vs /continue difference; bug supersedence; next TODO logic |
| RS-002 | docs/verification/revision-spec/RS-002-tool-call-flexibility.md | docs/verification/revision-meta-prompts/02-tool-call-flexibility.md | Global tool-call troubleshooting and limitation removal goal |
| RS-003 | docs/verification/revision-spec/RS-003-compass-dynamic-discovery.md | docs/verification/revision-meta-prompts/03-compass-dynamic-discovery.md | Step 2 general-to-specific Compass flow; question/style structure; broad-to-narrow behavior |
| RS-004 | docs/verification/revision-spec/RS-004-define-features-interview-and-test-planning.md | docs/verification/revision-meta-prompts/04-define-features-interview-and-test-planning.md | Step 3 interview style gap; test planning/location expectations |
| RS-005 | docs/verification/revision-spec/RS-005-scaffold-agents-ownership.md | docs/verification/revision-meta-prompts/05-scaffold-agents-ownership.md | Step 4 AGENTS ownership boundary and consistency |
| RS-006 | docs/verification/revision-spec/RS-006-fine-tune-stability-routing-and-roadmap.md | docs/verification/revision-meta-prompts/06-fine-tune-stability-routing-and-roadmap.md | Step 5 hang risk; model routing suggestions; live roadmap behavior |
| RS-007 | docs/verification/revision-spec/RS-007-maintain-levels-and-project-status.md | docs/verification/revision-meta-prompts/07-maintain-levels-and-project-status.md | Step 8 maintenance levels and status semantics |
| RS-008 | docs/verification/revision-spec/RS-008-phase-numbering-consistency.md | docs/verification/revision-meta-prompts/08-phase-numbering-consistency.md | Add Phase N naming across workflow artifacts |
| RS-009 | docs/verification/revision-spec/RS-009-step0-artifact-necessity-audit.md | docs/verification/revision-meta-prompts/09-step0-artifact-necessity-audit.md | Step 0 initialization/update/prompt-sync necessity and declutter |
| RS-010 | docs/verification/revision-spec/RS-010-workflow-linting-observability.md | docs/verification/revision-meta-prompts/10-workflow-linting-observability.md | Internal linting process, orphan checks, >120 lines, newline and clarity callouts |
| RS-011 | docs/verification/revision-spec/RS-011-governance-clarity-and-impact.md | docs/verification/revision-meta-prompts/11-governance-clarity-and-impact.md | Governance explanation and constraints impact clarity |
| RS-012 | docs/verification/revision-spec/RS-012-review-bot-phase.md | docs/verification/revision-meta-prompts/12-review-bot-phase.md | Add non-blocking review bot phase with objective reporting |
| RS-013 | docs/verification/revision-spec/RS-013-phase-x-releases.md | docs/verification/revision-meta-prompts/13-phase-x-releases.md | Add release phase goals with context-aware release choices |
| RS-014 | docs/verification/revision-spec/RS-014-agent-rules-framework.md | docs/verification/revision-meta-prompts/14-agent-rules-framework.md | THIS-project and OTHER-project AGENTS rule processes |
| RS-015 | docs/verification/revision-spec/RS-015-cross-project-feedback-loop.md | docs/verification/revision-meta-prompts/15-cross-project-feedback-loop.md | Cross-project improvement intake process |
| RS-016 | docs/verification/revision-spec/RS-016-workflow-idea-command.md | docs/verification/revision-meta-prompts/16-workflow-idea-command.md | Dedicated /workflow-idea goal spec |
| RS-017 | docs/verification/revision-spec/RS-017-context-sensitive-advisory-guidance.md | docs/verification/revision-meta-prompts/17-context-sensitive-advisory-guidance.md | Always-on advisory context-sensitive guidance behavior |
| RS-018 | docs/verification/revision-spec/RS-018-generated-surface-clutter-mitigation.md | docs/verification/revision-meta-prompts/18-generated-surface-clutter-mitigation.md | Cleaner generated project surface and clutter mitigation |
| RS-019 | docs/verification/revision-spec/RS-019-cross-review-suggestion-tone.md | docs/verification/revision-meta-prompts/19-cross-review-suggestion-tone.md | Minimal optional new-window/terminal suggestions in late phases |
| RS-020 | docs/verification/revision-spec/RS-020-workflow-diagram-update.md | docs/verification/revision-meta-prompts/20-workflow-diagram-update.md | Update workflow diagram to reflect Phase 7a (Review Bot), auto-merge, findings re-entry |

## Final Audit Link
- Completeness meta-prompt: `docs/verification/revision-meta-prompts/phase-x-completeness-audit.md`
- Router source of truth: `docs/verification/revision-meta-prompts/ROUTER_INDEX.md`
