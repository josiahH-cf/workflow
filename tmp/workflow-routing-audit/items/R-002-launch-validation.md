# R-002: Launch-Level Validation At Phase Ends

## Problem

Current testing guidance is strong for code-level tests but does not consistently enforce app-launch behavior checks.

## Goal

At key gates, validate both:
- code/test outcomes
- runtime launch/smoke behavior (when inferable)

## Constraint

Inference should come from each target project's tooling files (`package.json`, `Makefile`, `justfile`, etc.), not hardcoded per-project configuration.

## Expected Behavior

1. Infer likely run/smoke commands from repository evidence.
2. Execute launch-level checks near end-of-phase validation.
3. Capture evidence in review/test outputs.
4. If inference fails, proceed with explicit caveat and next-step guidance.

## Candidate Files

- `meta-prompts/phase-7-test.md`
- `meta-prompts/phase-7a-review-bot.md`
- `meta-prompts/phase-10-continue.md`
- `template/workflow/PLAYBOOK.md`

## Acceptance Criteria

- Launch-level check requirement is documented for relevant phases.
- Inference-first behavior is defined and consistent.
- Failure/cannot-infer branches are explicit.
- Review outputs include launch check evidence when executed.

## Validation

- Simulate project with inferable run command: launch check runs.
- Simulate project with no clear run command: caveat path emitted.
- Ensure no conflict with existing `/test pre` and `/test post` semantics.

## Implementation Notes

### Status: Complete

### Design Decisions

- **Inference-first**: The launch check infers run commands from `package.json` scripts, `Makefile`/`justfile` targets, `Procfile`, `Dockerfile`, `pyproject.toml`, `Cargo.toml`, or `workflow/COMMANDS.md` Run entry. No hardcoded project-specific configuration.
- **Non-blocking skip**: When no run command can be inferred (e.g., libraries), the check records `[LAUNCH CHECK] Skipped` and proceeds. This is explicitly not a failure.
- **Launch failure = blocking bug**: If the inferred command crashes (non-zero exit, timeout), it's logged as a blocking bug via `/bug` with `severity: blocking`.
- **Scoped to post-mode only**: `/test pre` is unaffected. Launch check is step 6 in post-implementation mode.
- **Review bot includes launch check**: The bot runs the same inference/execute/skip flow and includes the result in its summary. `SKIPPED` does not count as a FAIL for auto-merge decisions.
- **Consistent skip message**: Both phase-7-test.md and phase-7a-review-bot.md use identical wording: `[LAUNCH CHECK] Skipped — no inferable run command. Manual smoke test recommended.`

### Files Changed

- `meta-prompts/phase-7-test.md` — Added step 6 (launch/smoke check with inference, execute, skip, and failure paths) to post-implementation mode. Updated gate and output sections.
- `meta-prompts/phase-7a-review-bot.md` — Added launch/smoke check step between test/lint execution and summary. Updated summary template with `Launch check: PASS/FAIL/SKIPPED`. Updated STEP 3 decision logic to accept SKIPPED.
- `meta-prompts/phase-10-continue.md` — Updated `7-test` + `testMode=post` dispatch row to reference launch check.
- `template/workflow/PLAYBOOK.md` — Updated project-level Test gate, feature-level Test (post) gate, and Bot Review gate to include launch check evidence.
- `prompts/phase-7-test.prompt.md` — Regenerated via `sync-prompts.sh`.
- `prompts/phase-7a-review-bot.prompt.md` — Regenerated via `sync-prompts.sh`.
- `prompts/phase-10-continue.prompt.md` — Regenerated via `sync-prompts.sh`.
- `template/.claude/commands/test.md` — Regenerated.
- `template/.claude/commands/review-bot.md` — Regenerated.
- `template/.claude/commands/continue.md` — Regenerated.

### Validation Evidence

- `./scripts/sync-prompts.sh --check` → **OK: All derived prompt files are in sync.**
- `./scripts/test-scripts.sh` → **32/32 tests pass, 0 failures.**
- **Trace 1 (inferable run command):** `/test post` step 6a infers from tooling files → step 6b executes and captures evidence → review bot runs same flow → summary includes `Launch check: PASS`. Gates accept PASS. **PASS.**
- **Trace 2 (no inferable run command):** `/test post` step 6c records skip message and proceeds → review bot records identical skip, not a FAIL → gates accept SKIPPED. **PASS.**
- **Trace 3 (no conflict with pre-mode):** Launch check exists only in post-implementation mode (step 6). Pre-mode steps 1–5 are unchanged. No launch references in pre-mode gates. **PASS.**
