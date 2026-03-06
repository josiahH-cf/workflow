# Phase 2 Validation Note — Tool Call Flexibility (RS-002)

**Completed**: 2026-03-06
**Scope**: Full audit of all workflow artifacts for overly restrictive permissions, guards, and tool constraints.
**Guiding filter**: Does it GATE the model → remove. Does it GUIDE toward better outcomes → keep (soften if phrased as prohibition).

## Constraint Classification & Actions

| File | Constraint | Classification | Action |
|------|-----------|---------------|--------|
| `template/.claude/settings.json` | `permissions.deny` list (8 entries: rm -rf, force-push, checkout main, chmod 777, curl\|bash, wget\|bash) | GATE | **Removed** — model is trusted |
| `template/.claude/settings.json` | `PreToolUse` hook blocking .env, .git/, constitution.md edits | GATE | **Removed** — .env protection redundant with BOUNDARIES Avoid rule |
| `template/.claude/settings.json` | `PostToolUse` prettier hook | GUIDE | **Kept** — formatting aid |
| `template/.claude/settings.json` | `Stop` hook test reminder | GUIDE | **Kept** — helpful reminder |
| `template/workflow/BOUNDARIES.md` | ALWAYS section (5 hard mandates) | GUIDE | **Softened** — renamed to "Best Practices", kept all 5 as recommendations |
| `template/workflow/BOUNDARIES.md` | ASK FIRST section (5 approval gates) | GATE | **Converted** — renamed to "Recommended Review Points", kept as advisory awareness |
| `template/workflow/BOUNDARIES.md` | NEVER: "Commit secrets or .env files" | GUIDE | **Kept** — secrets protection |
| `template/workflow/BOUNDARIES.md` | NEVER: "Modify files outside assigned scope" | GUIDE | **Kept** — useful scoping practice |
| `template/workflow/BOUNDARIES.md` | NEVER: "Auto-merge without human approval" | GATE | **Removed** — gates autonomy |
| `template/workflow/BOUNDARIES.md` | NEVER: "Skip tests" | GUIDE | **Kept** — test-pass enforcement |
| `template/workflow/BOUNDARIES.md` | NEVER: "Decisions not traceable to spec" | GUIDE | **Kept** — traceability best practice |
| `template/workflow/BOUNDARIES.md` | Governance Blockage Recovery section | GATE | **Removed** — no hard blocks = no recovery needed |
| `template/.github/agents/planner.agent.md` | "never writes code" (description + body + rules) | GATE | **Reframed** — capability language: "specializes in planning; delegates implementation" |
| `template/.github/agents/reviewer.agent.md` | "Do not suggest refactors outside PR scope" | GATE | **Reframed** — "Focus review on the PR scope" |
| `template/.github/agents/implementer.agent.md` | "Do not modify files outside task scope" | GATE | **Softened** — "Stay within task scope when possible" |
| `prompts/initialization.prompt.md` | YOLO guardrails block (bypassPermissions prohibition, local-only constraint) | GATE | **Removed** |
| `meta-prompts/admin/initialization.md` | Same YOLO guardrails block | GATE | **Removed** |
| `template/.claude/commands/initialization.md` | Same YOLO guardrails block | GATE | **Removed** |
| `meta-prompts/admin/update.md` | bypassPermissions verification step | GATE | **Removed** |
| `prompts/initialization.prompt.md` | Step 5 bypassPermissions check | GATE | **Removed** |
| `meta-prompts/admin/initialization.md` | Step 5 bypassPermissions check | GATE | **Removed** |
| `template/.claude/commands/initialization.md` | Step 5 bypassPermissions check | GATE | **Removed** |
| `prompts/compass-edit.prompt.md` | "Never modify constitution silently" | GATE | **Reframed** — "Log changes with rationale for traceability" |
| `template/.claude/commands/compass-edit.md` | Same prohibition | GATE | **Reframed** — same |
| `scripts/sync-prompts.sh` | `check_for_hardcoded_tool_whitelists()` function + call | GATE | **Removed** — prevents tools from being specified when beneficial |
| `scripts/validate-scaffold.sh` | Check 4b: hardcoded tool whitelist validation | GATE | **Removed** |
| `tests/scripts/sync-prompts.bats` | "fails if template agent hardcodes tools" test | GATE | **Removed** |
| `tests/scripts/validate-scaffold.bats` | "fails on hardcoded tool whitelists" test | GATE | **Removed** |
| `meta-prompts/admin/prompt-sync.md` | STEP 4 line: "do not hardcode tool whitelists" | GATE | **Removed** |
| `docs/verification/archive_after_run/human_review_checklist.md` | Whitelist audit line | GATE | **Removed** |
| `TROUBLESHOOTING.md` | Reference to settings.json hook blocking edits | GATE | **Updated** — references best-practice scope guidance instead |

## Files Modified

| File | Change Summary |
|------|---------------|
| `template/.claude/settings.json` | Removed `deny` list and `PreToolUse` hooks |
| `template/workflow/BOUNDARIES.md` | Advisory tone; removed auto-merge gate and governance recovery |
| `template/.github/agents/planner.agent.md` | Capability framing; removed "never writes code" |
| `template/.github/agents/reviewer.agent.md` | Softened "Do not suggest" to "Focus on" |
| `template/.github/agents/implementer.agent.md` | Softened scope restriction to guidance |
| `prompts/initialization.prompt.md` | Removed YOLO guardrails + bypassPermissions check |
| `meta-prompts/admin/initialization.md` | Same |
| `template/.claude/commands/initialization.md` | Same |
| `meta-prompts/admin/update.md` | Removed bypassPermissions verification step |
| `prompts/compass-edit.prompt.md` | Reframed constitution constraint to traceability |
| `template/.claude/commands/compass-edit.md` | Same |
| `scripts/sync-prompts.sh` | Removed whitelist detection function + call |
| `scripts/validate-scaffold.sh` | Removed Check 4b |
| `tests/scripts/sync-prompts.bats` | Removed whitelist test |
| `tests/scripts/validate-scaffold.bats` | Removed whitelist test |
| `meta-prompts/admin/prompt-sync.md` | Removed whitelist validation line |
| `docs/verification/archive_after_run/human_review_checklist.md` | Removed whitelist audit line |
| `TROUBLESHOOTING.md` | Updated hook reference to scope guidance |

## What Was Preserved

- **Best practices**: spec-reading, test-before-commit, branch naming, AC evidence, constitution alignment
- **Awareness points**: dependency additions, CI changes, constitution edits, AGENTS.md changes, architecture decisions
- **Core protections**: secrets/`.env` avoidance, test-skip avoidance, file scope awareness, decision traceability
- **Agent specialization**: planning focus (planner), QA rigor (reviewer), TDD process (implementer) — all expressed as capabilities, not prohibitions
- **Formatting and tooling**: prettier hook, test reminder, permissions allow list
