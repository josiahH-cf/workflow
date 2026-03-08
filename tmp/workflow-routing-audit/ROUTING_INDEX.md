# Routing Index

Single source of truth for issue routing and implementation sequencing.

| ID | Theme | Status | Primary Files | Tracker |
|---|---|---|---|---|
| R-001 | `/continue` FAST router decision forks | Complete | `meta-prompts/phase-10-continue.md`, `template/workflow/ORCHESTRATOR.md`, `template/workflow/LIFECYCLE.md`, `template/workflow/PLAYBOOK.md` | `tmp/workflow-routing-audit/items/R-001-fast-router.md` |
| R-002 | Launch-level phase-end validation | Complete | `meta-prompts/phase-7-test.md`, `meta-prompts/phase-7a-review-bot.md`, `meta-prompts/phase-10-continue.md`, `template/workflow/PLAYBOOK.md` | `tmp/workflow-routing-audit/items/R-002-launch-validation.md` |
| R-003 | `/update-workflow` command and upstream diffing | Complete | `meta-prompts/admin/update.md`, `meta-prompts/admin/initialization.md`, `template/AGENTS.md`, `scripts/sync-prompts.sh` | `tmp/workflow-routing-audit/items/R-003-update-workflow-command.md` |
| R-004 | Command naming/reference consistency | Complete | `scripts/sync-prompts.sh`, `meta-prompts/admin/prompt-sync.md`, `tests/scripts/prompt-regressions.bats`, `prompts/*.prompt.md`, `template/.claude/commands/*.md` | `tmp/workflow-routing-audit/items/R-004-command-naming-consistency.md` |
| R-005 | Git worktree lifecycle and conflict-first rules | Open | `template/workflow/CONCURRENCY.md`, `template/scripts/setup-worktree.sh`, `template/workflow/ROUTING.md`, `template/workflow/FAILURE_ROUTING.md`, `template/workflow/ORCHESTRATOR.md` | `tmp/workflow-routing-audit/items/R-005-worktree-lifecycle-rules.md` |
| R-006 | Fork activation level — user-configured fork sensitivity | Open | `meta-prompts/phase-2-compass.md`, `meta-prompts/admin/initialization.md`, `meta-prompts/phase-10-continue.md`, `template/workflow/ORCHESTRATOR.md`, `template/workflow/STATE.json` | `tmp/workflow-routing-audit/items/R-006-fork-activation-level.md` |

## Deferred

| ID | Theme | Status | Notes |
|---|---|---|---|
| D-001 | Reviewer topology (`review-bot` vs manual reviewer path) | Deferred | Intentionally excluded until desired behavior is finalized |
