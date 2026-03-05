# Phase 9: Documentation & Finalization

**Status:** not-started
**Depends on:** Phases 1–8 (all changes must be complete)

## Objective

Update all user-facing documentation to reflect the new architecture, update examples, perform final cross-reference validation, and clean up the remediation plan files.

## Rationale

All structural changes are complete. Documentation must reflect the new reality for both human users and agents reading the files. This is also the final validation pass to ensure nothing was missed and all cross-references resolve.

## Context Files to Read First

- `README.md` — Main project README (major update needed)
- `docs/quickstart-first-success.md` — Quickstart guide (update with new paths)
- `docs/reference/principles.md` — Engineering principles (add new principles)
- `TROUBLESHOOTING.md` — Issue resolution (add new troubleshooting entries)
- `examples/sample-project/` — Example project (may need updates from Phase 5)
- `template/governance/REGISTRY.md` — Final registry audit
- `template/` — Review the complete new structure

## Steps

### Step 1: Update `README.md`

**Update the scaffold layout diagram** to include all new files:
```
project/
├── AGENTS.md                        ← TOC hub (routing, phases, quick reference)
├── CLAUDE.md                        ← Claude adapter (session rules, commands)
├── .aiignore                        ← Files excluded from AI agents
├── .specify/
│   ├── constitution.md              ← Project identity (Compass output)
│   ├── spec-template.md             ← Feature spec template (EARS/GWT)
│   └── acceptance-criteria-template.md
├── specs/                           ← Per-feature specs
├── tasks/                           ← Per-feature task breakdowns
├── decisions/                       ← Architecture decision records
├── bugs/
│   └── LOG.md                       ← Bug tracking log
├── workflow/
│   ├── LIFECYCLE.md                 ← Phase definitions
│   ├── PLAYBOOK.md                  ← Phase execution gates
│   ├── FILE_CONTRACTS.md            ← Artifact schemas
│   ├── FAILURE_ROUTING.md           ← Error recovery
│   ├── STATE.json                   ← Orchestrator state
│   ├── ORCHESTRATOR.md              ← Autonomous loop contract
│   ├── ROUTING.md                   ← Agent routing, branches, concurrency
│   ├── COMMANDS.md                  ← Build/test/lint commands
│   ├── BOUNDARIES.md                ← ALWAYS/ASK/NEVER rules
│   ├── SPECS.md                     ← Specification workflow + EARS guide
│   └── CONCURRENCY.md              ← Multi-agent safety
├── governance/
│   ├── CHANGE_PROTOCOL.md
│   ├── POLICY_TESTS.md
│   └── REGISTRY.md
├── scripts/
│   ├── policy-check.sh
│   ├── setup-worktree.sh            ← Enhanced with --list, --cleanup
│   └── clash-check.sh               ← Pre-write conflict detection
├── .github/
│   ├── copilot-instructions.md
│   ├── REVIEW_RUBRIC.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── ISSUE_TEMPLATE/
│   │   ├── feature.yml
│   │   ├── bug.yml
│   │   └── agent-task.yml
│   ├── agents/
│   │   ├── reviewer.agent.md
│   │   └── implementer.agent.md
│   └── workflows/
│       ├── copilot-setup-steps.yml
│       ├── copilot-agent.yml
│       ├── claude-review.yml
│       ├── autofix.yml
│       └── agentic-triage.yml
└── .codex/
    ├── AGENTS.md
    ├── PLANS.md
    └── config.toml
```

**Update "How It Works" section** to describe the autonomous loop:
- Mention `workflow/ORCHESTRATOR.md` as the loop contract
- Describe the enhanced `/continue` that loops automatically
- Reference `meta-prompts/major/00-full-build.md` as the single-invocation entry point

**Add "CI Workflows" section:**
- Describe the 5 CI workflows and their triggers
- Note that all require `ANTHROPIC_API_KEY` secret for Claude-based workflows
- Emphasize human approval requirement before merge

**Update "Deliverables" section** to include:
- `.aiignore` configured for the project
- CI workflows installed and configured
- Issue and PR templates in place
- Agent definition files available

**Update migration notes** for existing users:
- Running `install.sh` will add new files without overwriting existing scaffold files (if --force is not used)
- Existing AGENTS.md content has been split into sub-files; users should run `install.sh` to get the new structure

### Step 2: Update `docs/quickstart-first-success.md`

**Add "Full Autonomous Build" path:**
```markdown
### Path C: Full Autonomous Build (most autonomous)

1. Install: `./scripts/install.sh /path/to/your/project`
2. Run: Open `meta-prompts/major/00-full-build.md` in your agent
3. The agent will interview you (Compass), then autonomously:
   - Define features from your answers
   - Plan the architecture
   - Create task breakdowns
   - Write tests, implement code, review, and ship
4. You intervene only when the agent stops for: interview questions, merge approval, or blocking issues
5. Run `/maintain` when all features are shipped
```

**Update troubleshooting section** to reference new files.

### Step 3: Update `docs/reference/principles.md`

**Add new principles:**

```markdown
## Concurrency Safety
- If two agents need to modify the same file, the task split is wrong
- Use vertical slice decomposition: each agent owns an entire feature slice
- Run `scripts/clash-check.sh` before starting parallel work
- Short integration cycles: merge every few hours, not days
- See `workflow/CONCURRENCY.md` for full reference

## Acceptance Criteria Notation
- Use GIVEN/WHEN/THEN (GWT) format for all acceptance criteria
- Each criterion must be independently verifiable by an automated test
- The GIVEN is the test setup, WHEN is the action, THEN is the assertion
- See `workflow/SPECS.md` for the full EARS notation guide

## Autonomous Loop Discipline
- The orchestrator (`/continue`) loops automatically through phases
- Session bootstrap: always read AGENTS.md + STATE.json + constitution before first action
- Max 10 phase transitions per session (safety valve)
- When stopped, report state + blocker + resume command clearly
- See `workflow/ORCHESTRATOR.md` for the loop contract
```

### Step 4: Update `TROUBLESHOOTING.md`

**Add new entries:**

```markdown
## CI Workflow Failures

**Claude review not triggering:**
- Verify `ANTHROPIC_API_KEY` secret is set in repository settings
- Check that the workflow file exists at `.github/workflows/claude-review.yml`
- Ensure the comment contains `@claude` (case-sensitive)

**Autofix creating too many PRs:**
- The autofix workflow has a max 3 turns limit per invocation
- Check concurrency groups — only one autofix should run per branch
- If cost is a concern, disable the workflow and use manual `/bugfix` instead

**Copilot not picking up issues:**
- Verify the issue is assigned to `copilot` (not just mentioned)
- Check that `copilot-setup-steps.yml` exists and runs successfully
- Review Copilot Coding Agent settings in repository settings

## Worktree Conflicts

**clash-check.sh reports conflicts:**
- Two agents are modifying overlapping files
- Options: (1) rebase one branch, (2) reassign tasks to a single agent, (3) define interface contracts
- Run `scripts/setup-worktree.sh --list` to see all active worktrees
- See `workflow/CONCURRENCY.md` for decomposition strategies

**Worktrees consuming too much disk:**
- Run `scripts/setup-worktree.sh --cleanup` to remove merged worktrees
- Each worktree is a full copy; a 2GB repo can consume 10GB+ with multiple worktrees

## Autonomous Loop Issues

**`/continue` stops unexpectedly:**
- Check `workflow/STATE.json` for the current phase and any error state
- The loop stops at: human input needed, blocking bugs, missing artifacts, test failures after 2 attempts
- Resume with `/continue` — it will pick up from the saved state

**Loop seems stuck in a phase:**
- Max 10 transitions per session — if hit, restart with a fresh `/continue`
- Check the phase gate in `workflow/PLAYBOOK.md` — the gate condition may not be satisfied
- Verify the active task file exists and has incomplete tasks
```

### Step 5: Update `examples/sample-project/`

**If Phase 5 rewrote the example spec, verify it's correct.**

**Add a sample STATE.json** showing mid-build state:
Create `examples/sample-project/workflow/STATE.json`:
```json
{
  "schemaVersion": 1,
  "projectPhase": "7-test",
  "currentFeatureId": "001-task-crud",
  "currentTaskFile": "tasks/001-task-crud.md",
  "testMode": "post",
  "updatedAt": "2026-03-05T12:00:00Z"
}
```

**Add a sample bug log** (if not already present):
Create `examples/sample-project/bugs/LOG.md`:
```markdown
# Bug Log

## BUG-001: SQLite path not created on first run

- **Description:** `taskflow add` fails with FileNotFoundError if `~/.taskflow/` doesn't exist
- **Location:** `src/taskflow/repository.py:15`
- **Phase found:** 7-test (post-implementation testing)
- **Severity:** blocking
- **Expected:** Directory created automatically on first use
- **Actual:** FileNotFoundError raised
- **Status:** fixed (T-1 updated to create directory)
- **Fix:** Added `Path(db_path).parent.mkdir(parents=True, exist_ok=True)` before connection
```

### Step 6: Final Cross-Reference Audit

Run all validation tools and verify everything is consistent:

```bash
# 1. Validate scaffold structure
./scripts/validate-scaffold.sh

# 2. Run all BATS tests
./scripts/test-scripts.sh

# 3. Check prompt sync
./scripts/sync-prompts.sh --check

# 4. Check for placeholder residue (only expected ones should remain)
grep -r '\[PROJECT-SPECIFIC\]' template/ | grep -v _TEMPLATE | grep -v COMMANDS.md | grep -v AGENTS.md

# 5. Verify REGISTRY.md accounts for all files
# Compare files in template/ with entries in REGISTRY.md

# 6. Check all markdown links resolve
# For each .md file in template/, verify all [text](path) links point to existing files
```

**Registry audit:** Read `template/governance/REGISTRY.md` and verify every file listed exists. Also verify every file in `template/` is listed somewhere in the registry (no orphans).

### Step 7: Delete Remediation Plan Files

**This is the final step. Only execute after ALL verification passes.**

Delete the entire `docs/remediation/` directory:
```bash
rm -rf docs/remediation/
```

This removes:
- `docs/remediation/README.md`
- `docs/remediation/meta-prompt.md`
- `docs/remediation/phase-01.md` through `phase-09.md`

These files were execution artifacts for the remediation process and are no longer needed. The changes they specified are now part of the project.

**If any phase is not yet `done`, DO NOT delete the files.** Report which phases are incomplete and stop.

## Verification Checklist

- [ ] `README.md` has updated scaffold layout showing all new files
- [ ] `README.md` describes autonomous loop and CI workflows
- [ ] `README.md` has updated migration notes
- [ ] `docs/quickstart-first-success.md` has Path C (Full Autonomous Build)
- [ ] `docs/reference/principles.md` has concurrency, EARS, and loop discipline principles
- [ ] `TROUBLESHOOTING.md` has CI workflow, worktree conflict, and loop troubleshooting entries
- [ ] `examples/sample-project/workflow/STATE.json` exists with mid-build state example
- [ ] `examples/sample-project/bugs/LOG.md` exists with sample bug entry
- [ ] `./scripts/validate-scaffold.sh` passes all checks
- [ ] `./scripts/test-scripts.sh` — all BATS tests pass
- [ ] `./scripts/sync-prompts.sh --check` — no drift detected
- [ ] `grep -r '\[PROJECT-SPECIFIC\]' template/` returns only expected placeholders (AGENTS.md overview, COMMANDS.md commands/conventions)
- [ ] Every file in `template/governance/REGISTRY.md` exists
- [ ] No orphan files in `template/` (every file referenced somewhere)
- [ ] All phase-01 through phase-08 files show `**Status:** done`
- [ ] `docs/remediation/` directory has been deleted

## Completion

When ALL verification checks pass (including deletion):
- The remediation is complete
- No status update needed (the file itself will be deleted)
