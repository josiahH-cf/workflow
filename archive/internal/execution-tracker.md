# V2 Workflow Execution Tracker

## Status Overview

| Phase | Title | Status | Started | Completed | Notes |
|-------|-------|--------|---------|-----------|-------|
| A | Foundation (AGENTS.md, CLAUDE.md, adapters, .specify/) | DONE | 2026-03-04 | 2026-03-04 | All verification passed |
| B | Planning Commands (compass, define-features, scaffold, fine-tune) | DONE | 2026-03-04 | 2026-03-04 | All verification passed |
| C | Execution Commands (implement, test, bug, maintain, continue) | DONE | 2026-03-04 | 2026-03-04 | All verification passed |
| D | Infrastructure (review rubric, hooks, CI, agents) | DONE | 2026-03-04 | 2026-03-04 | All verification passed |
| E | Alignment (meta-prompts, workflow/ files, worktree, sync) | DONE | 2026-03-04 | 2026-03-04 | All verification passed |
| F | Validation & QA (link audit, 11 QA checks, README) | DONE | 2026-03-04 | 2026-03-04 | All 11 QA checks passed |

## Current Phase: COMPLETE

## Baseline Deltas

The implementation plan assumed AGENTS.md, CLAUDE.md, and `.specify/` did NOT exist. Actual state:

- `template/AGENTS.md` — EXISTS (v1 routing hub, being replaced)
- `template/CLAUDE.md` — EXISTS (v1 session rules, being replaced)
- `template/.specify/` — DOES NOT EXIST (matches plan assumption)
- `template/.codex/AGENTS.md` — DOES NOT EXIST (plan's assumption correct; `.codex/config.toml` and `PLANS.md` exist)
- `template/.claude/commands/` — 14 v1 commands exist (plan assumed fewer)
- `template/.claude/settings.json` — EXISTS (v1 permissions, will be replaced in Phase D)
- `template/.claude/settings.local.json` — EXISTS (gitignored YOLO mode, preserved)
- `template/.github/agents/reviewer.md` — EXISTS (v1 reviewer, template gets new reviewer.agent.md in Phase D)

Strategy: Replace AGENTS.md, CLAUDE.md, settings.json, implement.md, test.md with v2 content. Preserve all other v1 files.

## Phase A Log

- 2026-03-04: Baseline check complete. Deltas documented above.
- 2026-03-04: Replaced AGENTS.md with v2 routing hub (207 lines, 10 sections + Reference Index)
- 2026-03-04: Replaced CLAUDE.md with v2 adapter (4 AGENTS.md references, 9+ command listings)
- 2026-03-04: Prepended AGENTS.md linkage to copilot-instructions.md
- 2026-03-04: Created .codex/AGENTS.md adapter
- 2026-03-04: Created .specify/ with 3 templates (constitution, spec-template, ac-template)
- 2026-03-04: All verification passed. Phase A = DONE.

## Phase B Log

- 2026-03-04: Created 5 Claude commands: compass.md, compass-edit.md, define-features.md, scaffold.md, fine-tune.md
- 2026-03-04: Created 4 Copilot prompts: compass, define-features, scaffold, fine-tune
- 2026-03-04: All verification passed (adaptive keyword, no-code check, routing matrix ref, YAML frontmatter). Phase B = DONE.

## Phase C Log

- 2026-03-04: Replaced implement.md with v2 (TDD, constitution alignment, update-spec-before-unplanned)
- 2026-03-04: Replaced test.md with v2 (failures as bugs, EARS/GWT, UI tests)
- 2026-03-04: Created bug.md (41 lines, lightweight logging)
- 2026-03-04: Created bugfix.md (reproduce→diagnose→fix→verify→PR)
- 2026-03-04: Created maintain.md (two modes: initial setup + ongoing)
- 2026-03-04: Created continue.md (orchestration brain: state read, phase detection, auto-advance, stop gates)
- 2026-03-04: Replaced implement.prompt.md and test.prompt.md with v2
- 2026-03-04: Created bug.prompt.md and maintain.prompt.md
- 2026-03-04: All verification passed. Phase C = DONE.

## Phase D Log

- 2026-03-04: Created REVIEW_RUBRIC.md (6 scored categories: Correctness, Test Coverage, Security, Performance, Style, Documentation)
- 2026-03-04: Extended pull_request_template.md (5 new sections: Spec Reference, AC Evidence, Model & Branch, Review Checklist, Bug Log; all original content preserved)
- 2026-03-04: Created planner.agent.md (planning specialist, never writes code)
- 2026-03-04: Created reviewer.agent.md (references spec and rubric, structured output format)
- 2026-03-04: Replaced settings.json (valid JSON, PostToolUse with 15s timeout, PreToolUse blocks .env/.git/AGENTS.md/CLAUDE.md/constitution.md, Stop hook)
- 2026-03-04: Extended copilot-setup-steps.yml (added spec-existence validation step)
- 2026-03-04: Created autofix.yml (workflow_run trigger on failure, concurrency per branch, PR creation)
- 2026-03-04: All verification passed. Phase D = DONE.

## Phase E Log

- 2026-03-04: Updated initialization.md — added v2 workflow note, STEP 6 auto-initiate Compass
- 2026-03-04: Updated update.md — added v2 awareness, expanded auto-replace and protect lists
- 2026-03-04: Created 8 minor meta-prompts (01-scaffold-import through 08-maintain)
- 2026-03-04: Updated 3 major meta-prompts with v2 context blocks and constitution references
- 2026-03-04: Updated LIFECYCLE.md — added project-level phases table (8 phases + Bug Track)
- 2026-03-04: Updated PLAYBOOK.md — added project-level phase gates, constitution reference
- 2026-03-04: Updated FILE_CONTRACTS.md — added constitution.md and bugs/LOG.md contracts
- 2026-03-04: Updated FAILURE_ROUTING.md — added 5 new v2 failure types
- 2026-03-04: Updated REGISTRY.md — added all new canonical files, adapter, agent, CI/CD entries
- 2026-03-04: Created setup-worktree.sh (executable, model/type-description naming)
- 2026-03-04: Updated prompt-sync.md — added v2 cross-platform command map (20+ entries), diff validation
- 2026-03-04: All verification passed. Phase E = DONE.

## Phase F Log

- 2026-03-04: Link graph audit — all 22+ AGENTS.md file references resolve. PASS.
- 2026-03-04: Adapter linkage — 3 adapters verified (CLAUDE.md 4 refs, copilot-instructions 3 refs, .codex/AGENTS.md 5 refs). PASS.
- 2026-03-04: Command-prompt parity — 8 paired commands, 3 Claude-only. PASS.
- 2026-03-04: Phase coverage — 8 phases + Bug Track all have command, prompt, AGENTS.md reference, meta-prompt. PASS.
- 2026-03-04: Updated README.md — added 8-phase workflow description, routing explanation, updated scaffold layout.
- 2026-03-04: QA-1 through QA-11 — all PASS (49 files verified, 11 sections, spec integrity, hooks, CI, cross-refs, orphan check, content quality).
- 2026-03-04: QA report written to v2-project-docs/qa-report.md.
- 2026-03-04: All verification passed. Phase F = DONE.

## Final Summary

V2 8-phase agentic workflow implementation is **complete**. ~45 files created or modified across 6 build phases (A–F). All 11 QA checks pass. The workflow is ready for use — run `initialization.md` in a target project to begin.

## Decisions

1. **Replace strategy** — v1 AGENTS.md, CLAUDE.md replaced wholesale with v2 content
2. **V1 delivery commands preserved** — review.md, pr-create.md, merge.md, etc. untouched
3. **`.specify/` supplements `specs/`** — both coexist
4. **`.codex/AGENTS.md` created as new adapter** — existing config.toml and PLANS.md untouched
