# Troubleshooting

Common issues and fixes for the Agent Workflow Scaffold.

## Common Issues

### Agent ignoring workflow rules

**Symptom:** Agent skips tests, doesn't read spec, makes undocumented decisions.

**Cause:** Agent context doesn't include AGENTS.md or workflow files.

**Fix:** Start a fresh session. Ensure AGENTS.md is in the project root. Use `/continue` instead of manual commands — it loads the right context automatically.

**If persistent:** Use `/fix-prompt` to diagnose which instruction the agent is misreading and edit the source meta-prompt.

---

### Wrong phase detected by /continue

**Symptom:** `/continue` starts the wrong phase or loops.

**Cause:** Phase gate artifacts are missing or malformed.

**Fix:** Check exit criteria manually:
- Does `constitution.md` exist and have no `[PROJECT-SPECIFIC]` placeholders?
- Do specs exist in `/specs/`?
- Are tasks marked complete?
- Run through the checklist in `workflow/PLAYBOOK.md`.

---

### Constitution needs changing mid-build

**Symptom:** You realize the constitution is wrong after Phases 3+.

**Cause:** Normal — requirements evolve.

**Fix:**
1. Use `/compass-edit` (Claude) or edit `constitution.md` directly.
2. Check which downstream specs are affected.
3. Update specs and task files to reflect the change.
4. Log a decision record explaining why.

---

### Session context pollution

**Symptom:** Agent behaves inconsistently, references things from a previous phase.

**Cause:** Carrying context between phases instead of starting fresh.

**Fix:** Start a new session. The workflow requires fresh context between phases. Write plans and decisions to files (not chat) so they survive session boundaries. Use `/continue` in the new session — it reads state from files, not conversation history.

---

### Tests pass before implementation

**Symptom:** Tests written in Phase 7 (pre-implementation mode) already pass.

**Cause:** Tests aren't testing new behavior — they're testing existing functionality.

**Fix:** Rewrite tests to assert the specific new behavior from acceptance criteria. A test that passes before implementation is not testing the feature.

---

### CI failures and autofix

**Symptom:** CI fails on push.

**Cause:** Various — missing spec validation, placeholder detection, build/test failure.

**Fix:** The `autofix.yml` workflow will attempt automated repair (requires `ANTHROPIC_API_KEY` secret). If autofix creates a PR, review it carefully before merging. If autofix can't resolve it, check the failing step in `copilot-setup-steps.yml`.

---

### Too many phases / overwhelmed

**Symptom:** The 8 phases feel excessive for a simple project.

**Cause:** The scaffold is designed for multi-feature, multi-agent projects.

**Fix:** Use `/continue` — it handles phase detection and advancement automatically. You only need to interact during Phases 2-5 (interviews and plan approval). Phases 6-8 run autonomously.

---

### Agent creates files outside scope

**Symptom:** Agent modifies files not listed in the task's "Files" field.

**Cause:** Agent didn't read the task file properly.

**Fix:** Claude's `settings.json` includes hooks that block edits to protected files (`.env`, `.git/`, `constitution.md`). For scope enforcement beyond protected files, review the PR using the `REVIEW_RUBRIC.md` "File Scope Check."

## Getting Help

- Check [workflow/FAILURE_ROUTING.md](template/workflow/FAILURE_ROUTING.md) for the full failure response matrix.
- Check [workflow/PLAYBOOK.md](template/workflow/PLAYBOOK.md) for phase gate definitions.
- Open an issue at the scaffold repository for bugs or feature requests.

---

## CI Workflow Failures

**Claude review not triggering:**
- Verify `ANTHROPIC_API_KEY` secret is set in repository settings.
- Check that the workflow file exists at `.github/workflows/claude-review.yml`.
- Ensure the comment contains `@claude` (case-sensitive).

**Autofix creating too many PRs:**
- The autofix workflow has a max 3 turns limit per invocation.
- Check concurrency groups — only one autofix should run per branch.
- If cost is a concern, disable the workflow and use manual `/bugfix` instead.

**Copilot not picking up issues:**
- Verify the issue is assigned to `copilot` (not just mentioned).
- Check that `copilot-setup-steps.yml` exists and runs successfully.
- Review Copilot Coding Agent settings in repository settings.

---

## Worktree Conflicts

**clash-check.sh reports conflicts:**
- Two agents are modifying overlapping files.
- Options: (1) rebase one branch, (2) reassign tasks to a single agent, (3) define interface contracts.
- Run `scripts/setup-worktree.sh --list` to see all active worktrees.
- See `workflow/CONCURRENCY.md` for decomposition strategies.

**Worktrees consuming too much disk:**
- Run `scripts/setup-worktree.sh --cleanup` to remove merged worktrees.
- Each worktree is a full copy; a 2GB repo can consume 10GB+ with multiple worktrees.

---

## Autonomous Loop Issues

**`/continue` stops unexpectedly:**
- Check `workflow/STATE.json` for the current phase and any error state.
- The loop stops at: human input needed, blocking bugs, missing artifacts, test failures after 2 attempts.
- Resume with `/continue` — it will pick up from the saved state.

**Loop seems stuck in a phase:**
- Max 10 transitions per session — if hit, restart with a fresh `/continue`.
- Check the phase gate in `workflow/PLAYBOOK.md` — the gate condition may not be satisfied.
- Verify the active task file exists and has incomplete tasks.
