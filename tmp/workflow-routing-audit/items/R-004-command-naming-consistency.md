# R-004: Command Naming And Reference Consistency

## Problem

Some internal canonical references and filenames are inconsistent (for example, implement/review-session map to older meta-prompt filenames), which can create drift in scripts/tests/docs.

## Goal

Normalize internal references comprehensively while keeping user-facing slash commands unchanged.

## Expected Behavior

1. Preserve command names users run (`/implement`, `/review-session`, etc.).
2. Normalize source mappings and references across scripts/tests/docs.
3. Keep prompt generation and regression checks stable.

## Candidate Files

- `scripts/sync-prompts.sh`
- `meta-prompts/admin/prompt-sync.md`
- `tests/scripts/prompt-regressions.bats`
- `prompts/*.prompt.md`
- `template/.claude/commands/*.md`

## Acceptance Criteria

- No user-facing command regressions.
- Mapping docs/scripts/tests agree on canonical paths.
- `sync-prompts --check` remains green after changes.

## Validation

- Run `./scripts/sync-prompts.sh --check`.
- Run prompt regression tests.
- Verify command map in docs remains accurate.

## Implementation Notes

### Findings

1. **prompt-sync.md command map was missing 2 of 18 entries:** `review-bot` (Phase 7a) and `update-workflow` (Admin) were absent from the Cross-Platform Command Map table, while `sync-prompts.sh` correctly mapped all 18 commands.
2. **CLAUDE.md command listing was missing 3 commands:** `/build-session` (Phase 6 session mode), `/review-bot` (Phase 7a default merge path), and `/operationalize` (Phase 9) — all present in AGENTS.md but absent from the Claude-specific reference.
3. **No regression test existed** to catch command map / listing drift between the script, prompt-sync doc, and CLAUDE.md.

### Changes Made

- `meta-prompts/admin/prompt-sync.md` — Added `review-bot` and `update-workflow` rows to Cross-Platform Command Map.
- `template/CLAUDE.md` — Added `/build-session`, `/review-bot`, `/operationalize`; updated section heading "Phase 8+" → "Phases 8–9+".
- `tests/scripts/prompt-regressions.bats` — Added 2 new tests: (a) prompt-sync map covers all sync-prompts commands, (b) CLAUDE.md lists all slash commands from AGENTS.md.

### Decisions

- User-facing slash command names unchanged (per R-004 constraint).
- Meta-prompt filenames left as-is (e.g., `phase-6-code.md` for `/implement`) — the mapping arrays in `sync-prompts.sh` are the canonical bridge between descriptive filenames and command names.
- No derived files (Claude commands, Copilot prompts) required regeneration — changes were to reference docs and tests only.

### Evidence

- `./scripts/sync-prompts.sh --check`: **OK** — all 36 derived files in sync.
- `bats tests/scripts/prompt-regressions.bats`: **8/8 pass** (including 2 new tests).
- `bats tests/scripts/*.bats`: **36/36 pass** — full suite green.

## Status

Complete.
