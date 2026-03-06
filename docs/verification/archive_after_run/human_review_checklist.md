# Human Review Checklist — Workflow Repository

> **Purpose:** Systematic file-by-file review of the workflow repository, ordered by the sequence a human would follow when onboarding, installing, configuring, running, debugging, and extending the workflow.
>
> **How to use:** Work through each file in order. Check each box when satisfied. Use the Notes area to record issues. Complete the Overall Sign-off at the end.
>
> **Reference companion:** Compare artifacts against [workflow-example](https://github.com/josiahH-cf/workflow-example) for a completed sample project.

---

## 1. Onboarding & Orientation

### 1.1 [README.md](../../README.md)

- [ ] Purpose of the workflow is stated in the first paragraph
- [ ] Installation steps are present and actionable
- [ ] Supported tools (Copilot, Claude Code, Codex) are listed
- [ ] Link to `workflow-example` companion is present and correct
- [ ] Quick-start path is obvious (reader knows what to do next)
- [ ] No stale references to removed files or renamed phases

**Notes:**

---

### 1.2 [docs/quickstart-first-success.md](../../docs/quickstart-first-success.md)

- [ ] Covers the minimal happy path from install to first working output
- [ ] Steps are numbered and imperative (actionable verbs)
- [ ] Prerequisites are stated (OS, tools, git)
- [ ] References correct script paths (`scripts/install.sh`)
- [ ] End state is clearly defined (what "success" looks like)
- [ ] No assumptions about prior workflow knowledge

**Notes:**

---

### 1.3 [docs/reference/principles.md](../../docs/reference/principles.md)

- [ ] Core principles are listed and concise
- [ ] Principles align with behavior described in `AGENTS.md` and `BOUNDARIES.md`
- [ ] No contradictions with other docs
- [ ] Principles are referenced by downstream phases (traceability)

**Notes:**

---

### 1.4 [docs/reference/workflow-diagram.md](../../docs/reference/workflow-diagram.md)

- [ ] Diagram matches the phase order in `workflow/LIFECYCLE.md`
- [ ] All 8 phases + Bug Track are represented
- [ ] `/continue` orchestration loop is shown
- [ ] Per-feature cycle (Phases 6–7) loop is visible
- [ ] Transitions and gates are labeled

**Notes:**

---

## 2. Installation & Setup

### 2.1 [scripts/install.sh](../../scripts/install.sh)

- [ ] Script runs successfully on Linux/WSL (`bash scripts/install.sh <target>`)
- [ ] OS detection logic works for Linux, macOS, Windows/MINGW, WSL
- [ ] Default copies template, prompts, and meta-prompts
- [ ] `--minimal` flag skips prompts and meta-prompts correctly
- [ ] `--with-github-templates`, `--with-github-agents`, `--with-codex` flags work
- [ ] `--dry-run` shows expected file count without copying
- [ ] Post-install validation checks critical files (AGENTS.md, STATE.json, LIFECYCLE.md)
- [ ] Platform-specific next steps printed to stdout
- [ ] Prompts install to `.github/prompts/` by default, or respect `--prompts-dir` when explicitly provided

**Notes:**

---

### 2.2 [scripts/sync-prompts.sh](../../scripts/sync-prompts.sh)

- [ ] Generates Claude commands from meta-prompts correctly
- [ ] Generates Copilot `.prompt.md` files from meta-prompts correctly
- [ ] `--check` mode detects drift (exit code 1 if out of sync)
- [ ] `--dry-run` previews without modifying
- [ ] All 18 commands are mapped (initialization, continue, compass, compass-edit, define-features, scaffold, fine-tune, implement, build-session, test, bug, bugfix, review-session, cross-review, maintain)
- [ ] Generated prompts and template agent definitions do not hardcode tool whitelists or provider-specific tool IDs
- [ ] YAML frontmatter is generated correctly for Copilot prompts (`agent: agent`, no deprecated `mode:`)

**Parity check:** Run `bash scripts/sync-prompts.sh --check` and confirm exit code 0.

**Notes:**

---

### 2.3 [scripts/validate-scaffold.sh](../../scripts/validate-scaffold.sh)

- [ ] Validates all 31 required files exist
- [ ] AGENTS.md references resolve to actual files
- [ ] Constitution template has all 8 required sections
- [ ] Claude command / Copilot prompt parity is checked
- [ ] JSON validity checked for `settings.json` and `STATE.json`
- [ ] Exit code reflects pass (0) / fail (1) correctly
- [ ] Warnings vs failures are distinguished clearly

**Notes:**

---

### 2.4 [scripts/test-scripts.sh](../../scripts/test-scripts.sh)

- [ ] Checks for `bats` dependency before running
- [ ] Runs the full test suite from repo root
- [ ] Exit code propagated from bats

**Notes:**

---

## 3. Template Hub (Canonical Configuration)

### 3.1 [template/AGENTS.md](../../template/AGENTS.md)

- [ ] Overview section has `[PROJECT-SPECIFIC]` placeholder (correct — filled in Phase 2)
- [ ] All 8 phases + Bug Track + Orchestrator are listed with entry commands for all tools
- [ ] Entry commands reference correct file names (e.g., `compass.prompt.md`, `/compass`)
- [ ] Quick Reference table links resolve to actual files in `workflow/` and `governance/`
- [ ] No duplicated routing or contradictory instructions vs `workflow/*.md` files
- [ ] File is under 150 lines (lean enough for agents to read fully)

**Notes:**

---

### 3.2 [template/CLAUDE.md](../../template/CLAUDE.md)

- [ ] Session Bootstrap lists 5 files in correct priority order
- [ ] Context Discipline rules are clear and actionable
- [ ] References `AGENTS.md` as canonical (not standalone)
- [ ] No instructions that contradict `AGENTS.md` or `BOUNDARIES.md`
- [ ] Commands listed match those in AGENTS.md phase entries

**Notes:**

---

### 3.3 [template/CLAUDE.local.md](../../template/CLAUDE.local.md)

- [ ] Clearly marked as personal / gitignored
- [ ] States that project rules belong in AGENTS.md, not here
- [ ] Provides useful examples (verbosity, model preference)

**Notes:**

---

## 4. Workflow Policy Files

### 4.1 [template/workflow/LIFECYCLE.md](../../template/workflow/LIFECYCLE.md)

- [ ] Project-Level Phases table matches AGENTS.md phase list
- [ ] Feature-Level Phases table (5 phases per feature) is clear
- [ ] Phase numbering note (project vs feature) avoids confusion
- [ ] Label conventions are defined and consistent
- [ ] Feature Identity format is specified (`[issue-id]-[slug]`)

**Notes:**

---

### 4.2 [template/workflow/PLAYBOOK.md](../../template/workflow/PLAYBOOK.md)

- [ ] Every phase has defined input, output, and advance gate
- [ ] Gates are testable (not vague — e.g., "no `[PROJECT-SPECIFIC]` placeholders")
- [ ] Rules per phase are actionable
- [ ] Context discipline rules are present
- [ ] No conflicts with LIFECYCLE.md phase descriptions

**Notes:**

---

### 4.3 [template/workflow/ORCHESTRATOR.md](../../template/workflow/ORCHESTRATOR.md)

- [ ] Loop contract is defined: bootstrap → execute → verify gate → advance → repeat
- [ ] Dispatch table maps phase names to commands
- [ ] Max transitions per session defined (10)
- [ ] Stop conditions are listed (interviews, blocking bugs, approvals, context usage)
- [ ] STATE.json schema is referenced

**Notes:**

---

### 4.4 [template/workflow/ROUTING.md](../../template/workflow/ROUTING.md)

- [ ] Agent routing matrix maps tasks to Claude / Copilot / Codex
- [ ] Branch naming convention defined (`model/type-description`)
- [ ] Concurrency rules referenced or summarized
- [ ] No contradictions with CONCURRENCY.md

**Notes:**

---

### 4.5 [template/workflow/COMMANDS.md](../../template/workflow/COMMANDS.md)

- [ ] Build, test, lint, format, type-check command placeholders present
- [ ] States when commands are filled (Phase 4 — Scaffold)
- [ ] Format is machine-parseable (key: value or similar)

**Notes:**

---

### 4.6 [template/workflow/STATE.json](../../template/workflow/STATE.json)

- [ ] Schema includes: `schemaVersion`, `projectPhase`, `currentFeatureId`, `currentTaskFile`, `testMode`, `updatedAt`
- [ ] Valid JSON (parse without errors)
- [ ] Default values are sensible for a new project

**Notes:**

---

### 4.7 [template/workflow/BOUNDARIES.md](../../template/workflow/BOUNDARIES.md)

- [ ] ALWAYS rules are clear and complete
- [ ] ASK FIRST rules cover risky operations (deps, CI, constitution, AGENTS.md)
- [ ] NEVER rules are non-negotiable and correct
- [ ] Bug tracking format is defined with all required fields
- [ ] Severity levels (blocking / non-blocking) have clear handling rules

**Notes:**

---

### 4.8 [template/workflow/FAILURE_ROUTING.md](../../template/workflow/FAILURE_ROUTING.md)

- [ ] All 10 failure types are covered with first/second actions
- [ ] Escalation criteria are specific ("persists after two attempts")
- [ ] Escalation packet format is defined (feature ID, phase, output, what was tried)
- [ ] Stop conditions for autonomous execution are listed

**Notes:**

---

### 4.9 [template/workflow/CONCURRENCY.md](../../template/workflow/CONCURRENCY.md)

- [ ] Max parallel agents defined (3)
- [ ] No-file-overlap rule is stated
- [ ] Decomposition strategies are listed (vertical slice preferred)
- [ ] Drift detection mechanism described
- [ ] Worktree isolation referenced

**Notes:**

---

### 4.10 [template/workflow/FILE_CONTRACTS.md](../../template/workflow/FILE_CONTRACTS.md)

- [ ] Artifact schemas defined for constitution, specs, tasks, decisions, bugs
- [ ] GWT (Given/When/Then) AC format specified with EARS extensions
- [ ] Machine-parseable checkbox format for ACs
- [ ] Linkage rules (spec → task, AC → test) are explicit

**Notes:**

---

## 5. Phase Definitions (Meta-Prompts)

### 5.1 [meta-prompts/admin/initialization.md](../../meta-prompts/admin/initialization.md)

- [ ] Covers scaffold extraction and file placement
- [ ] References correct template directory structure
- [ ] AGENTS.md customization step is included
- [ ] Validates scaffold after placement

**Notes:**

---

### 5.2 [meta-prompts/01-scaffold-import.md](../../meta-prompts/01-scaffold-import.md)

- [ ] Distinct from initialization.md (or explained relationship)
- [ ] Steps are numbered and imperative
- [ ] Output artifacts are named

**Notes:**

---

### 5.3 [meta-prompts/02-compass.md](../../meta-prompts/02-compass.md)

- [ ] 8-section interview structure defined
- [ ] Adaptive questioning approach described
- [ ] Output: `.specify/constitution.md` with all 8 sections
- [ ] Gate: no `[PROJECT-SPECIFIC]` placeholders remaining
- [ ] Compare structure against `workflow-example/.specify/constitution.md`

**Notes:**

---

### 5.4 [meta-prompts/02b-compass-edit.md](../../meta-prompts/02b-compass-edit.md)

- [ ] Requires explicit developer approval
- [ ] Diff review step is included
- [ ] Downstream impact (specs, tasks) is noted

**Notes:**

---

### 5.5 [meta-prompts/03-define-features.md](../../meta-prompts/03-define-features.md)

- [ ] Maps features to constitution capabilities
- [ ] Output: `/specs/[feature-id]-[slug].md` with 3–7 ACs
- [ ] AC format (GWT) is referenced or shown
- [ ] Compare output structure against `workflow-example/specs/001-task-crud.md`

**Notes:**

---

### 5.6 [meta-prompts/04-scaffold-project.md](../../meta-prompts/04-scaffold-project.md)

- [ ] Architecture reasoning covers: folder structure, dependencies, APIs, data models
- [ ] No code generation — planning only
- [ ] Output fills AGENTS.md Code Conventions + Core Commands
- [ ] `[DECISION NEEDED]` handling for unknowns

**Notes:**

---

### 5.7 [meta-prompts/05-fine-tune-plan.md](../../meta-prompts/05-fine-tune-plan.md)

- [ ] Creates `/tasks/[feature-id]-[slug].md` with ordered tasks
- [ ] ACs in GWT format with IDs (AC-1..N)
- [ ] Model assignments (Claude/Copilot/Codex) per task
- [ ] Branch naming per feature
- [ ] Compare against `workflow-example/tasks/001-task-crud.md`

**Notes:**

---

### 5.8 [meta-prompts/06-code.md](../../meta-prompts/06-code.md)

- [ ] TDD workflow: write failing test → implement → verify
- [ ] One task per commit rule stated
- [ ] Match existing code patterns instruction
- [ ] Bug logging via `/bug` referenced

**Notes:**

---

### 5.9 [meta-prompts/06b-build-session.md](../../meta-prompts/06b-build-session.md)

- [ ] Autonomous session mode covering test + implement
- [ ] Session scope and boundaries defined
- [ ] Relationship to 06-code.md is clear

**Notes:**

---

### 5.10 [meta-prompts/07-test.md](../../meta-prompts/07-test.md)

- [ ] Dual mode: `pre` (write failing tests) and `post` (verify ACs)
- [ ] Pre-mode: tests committed before implementation
- [ ] Post-mode: all ACs verified with evidence
- [ ] Bug logging for failures

**Notes:**

---

### 5.11 [meta-prompts/07b-bug.md](../../meta-prompts/07b-bug.md)

- [ ] Bug logging format matches BOUNDARIES.md
- [ ] BUG-NNN ID assignment
- [ ] Append to `bugs/LOG.md`
- [ ] Returns to calling phase after logging
- [ ] Compare against `workflow-example/bugs/LOG.md`

**Notes:**

---

### 5.12 [meta-prompts/07c-bugfix.md](../../meta-prompts/07c-bugfix.md)

- [ ] 5-step flow: reproduce → diagnose → fix → verify → ship
- [ ] Minimal safe change principle
- [ ] Branch naming for bug fixes
- [ ] Decision record if tradeoff needed

**Notes:**

---

### 5.13 [meta-prompts/07d-review-and-ship.md](../../meta-prompts/07d-review-and-ship.md)

- [ ] Criterion-by-criterion evidence review
- [ ] Honest PASS/FAIL (no fake evidence)
- [ ] PR template referenced
- [ ] Review rubric categories covered

**Notes:**

---

### 5.14 [meta-prompts/07e-cross-review.md](../../meta-prompts/07e-cross-review.md)

- [ ] Independent review by different agent/model
- [ ] Scope and purpose distinct from primary review
- [ ] Optional nature clearly stated

**Notes:**

---

### 5.15 [meta-prompts/08-maintain.md](../../meta-prompts/08-maintain.md)

- [ ] Generates README from constitution + specs
- [ ] Generates CONTRIBUTING from AGENTS.md
- [ ] Security baseline check included
- [ ] Compliance audit described

**Notes:**

---

### 5.16 [meta-prompts/09-continue.md](../../meta-prompts/09-continue.md)

- [ ] Reads STATE.json to determine current phase
- [ ] Dispatch table matches AGENTS.md phase commands
- [ ] Max 10 transitions enforced
- [ ] Stop conditions match ORCHESTRATOR.md
- [ ] State persistence after each transition

**Notes:**

---

### 5.17 [meta-prompts/admin/prompt-sync.md](../../meta-prompts/admin/prompt-sync.md)

- [ ] Purpose and usage of sync-prompts.sh explained
- [ ] Relationship between meta-prompts → Claude commands + Copilot prompts

**Notes:**

---

### 5.18 [meta-prompts/admin/update.md](../../meta-prompts/admin/update.md)

- [ ] Update procedure for workflow files described
- [ ] Versioning or migration approach if present

**Notes:**

---

## 6. Prompt Files (Copilot)

For each prompt file, verify it matches its corresponding meta-prompt source. Run `bash scripts/sync-prompts.sh --check` to automate parity validation.

### 6.1–6.15 Prompt file parity

| # | Prompt File | Meta-Prompt Source | Parity | Notes |
|---|-------------|--------------------|--------|-------|
| 1 | [prompts/initialization.prompt.md](../../prompts/initialization.prompt.md) | `meta-prompts/initialization.md` | [ ] | |
| 2 | [prompts/compass.prompt.md](../../prompts/compass.prompt.md) | `meta-prompts/02-compass.md` | [ ] | |
| 3 | [prompts/compass-edit.prompt.md](../../prompts/compass-edit.prompt.md) | `meta-prompts/02b-compass-edit.md` | [ ] | |
| 4 | [prompts/define-features.prompt.md](../../prompts/define-features.prompt.md) | `meta-prompts/03-define-features.md` | [ ] | |
| 5 | [prompts/scaffold.prompt.md](../../prompts/scaffold.prompt.md) | `meta-prompts/04-scaffold-project.md` | [ ] | |
| 6 | [prompts/fine-tune.prompt.md](../../prompts/fine-tune.prompt.md) | `meta-prompts/05-fine-tune-plan.md` | [ ] | |
| 7 | [prompts/implement.prompt.md](../../prompts/implement.prompt.md) | `meta-prompts/06-code.md` | [ ] | |
| 8 | [prompts/build-session.prompt.md](../../prompts/build-session.prompt.md) | `meta-prompts/06b-build-session.md` | [ ] | |
| 9 | [prompts/test.prompt.md](../../prompts/test.prompt.md) | `meta-prompts/07-test.md` | [ ] | |
| 10 | [prompts/bug.prompt.md](../../prompts/bug.prompt.md) | `meta-prompts/07b-bug.md` | [ ] | |
| 11 | [prompts/bugfix.prompt.md](../../prompts/bugfix.prompt.md) | `meta-prompts/07c-bugfix.md` | [ ] | |
| 12 | [prompts/review-session.prompt.md](../../prompts/review-session.prompt.md) | `meta-prompts/07d-review-and-ship.md` | [ ] | |
| 13 | [prompts/cross-review.prompt.md](../../prompts/cross-review.prompt.md) | `meta-prompts/07e-cross-review.md` | [ ] | |
| 14 | [prompts/maintain.prompt.md](../../prompts/maintain.prompt.md) | `meta-prompts/08-maintain.md` | [ ] | |
| 15 | [prompts/continue.prompt.md](../../prompts/continue.prompt.md) | `meta-prompts/09-continue.md` | [ ] | |

**Automated check:** `bash scripts/sync-prompts.sh --check` → exit code 0 = all in sync

**Notes:**

---

## 7. Governance

### 7.1 [template/governance/CHANGE_PROTOCOL.md](../../template/governance/CHANGE_PROTOCOL.md)

- [ ] Policy mutation requires a proposal artifact
- [ ] Proposal format defined (problem → solution → impact → validation)
- [ ] Two-phase review (builder + reviewer + human approval)
- [ ] Merge isolated from feature code

**Notes:**

---

### 7.2 [template/governance/POLICY_TESTS.md](../../template/governance/POLICY_TESTS.md)

- [ ] All 11 validation checks are listed
- [ ] Phase-aware checks (e.g., placeholders allowed until specified phase)
- [ ] Checks are automatable (not subjective)

**Notes:**

---

### 7.3 [template/governance/REGISTRY.md](../../template/governance/REGISTRY.md)

- [ ] All canonical files listed (~15 canonical + ~5 adapter)
- [ ] Authority hierarchy is clear (AGENTS.md is top)
- [ ] Scripts and CI/CD files registered

**Notes:**

---

## 8. Template Scripts

### 8.1 [template/scripts/clash-check.sh](../../template/scripts/clash-check.sh)

- [ ] Detects conflicts between parallel worktrees
- [ ] Falls back to `git merge-tree` when `clash` CLI unavailable
- [ ] `--json` flag produces valid JSON output
- [ ] Suggestions provided when conflicts found

**Notes:**

---

### 8.2 [template/scripts/policy-check.sh](../../template/scripts/policy-check.sh)

- [ ] Phase-aware placeholder rules enforced
- [ ] STATE.json validated (required fields, file references)
- [ ] Spec/task parity checked (every spec has matching task)
- [ ] AC mapping verified (AC- markers present in task files)
- [ ] Exit code reflects pass/fail

**Notes:**

---

### 8.3 [template/scripts/setup-worktree.sh](../../template/scripts/setup-worktree.sh)

- [ ] Creates `.trees/<model>-<type>-<description>/` directory
- [ ] Creates branch with correct naming convention
- [ ] Copies local config files to worktree
- [ ] `--list` shows active worktrees
- [ ] `--cleanup` removes merged worktrees
- [ ] File overlap detection warns about conflicts

**Notes:**

---

## 9. Troubleshooting

### 9.1 [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md)

- [ ] Covers the 10 most common problems
- [ ] Each problem has: root cause + solution
- [ ] Solutions reference specific files/commands
- [ ] Context pollution problem is addressed (fresh session + /continue)
- [ ] CI failure path is documented
- [ ] `/continue` stop diagnosis is covered (STATE.json, phase gates)

**Notes:**

---

## 10. Test Suite

### 10.1 [tests/scripts/helpers.bash](../../tests/scripts/helpers.bash)

- [ ] `setup_repo_copy()` creates isolated temp environment
- [ ] `teardown_repo_copy()` cleans up
- [ ] `assert_output_contains()` works correctly

**Notes:**

---

### 10.2 [tests/scripts/install.bats](../../tests/scripts/install.bats)

- [ ] Tests cover: dry-run, default copy, minimal mode, error on file target, platform flags
- [ ] Tests validate file presence at expected locations
- [ ] Tests verify next-steps output

**Notes:**

---

### 10.3 [tests/scripts/sync-prompts.bats](../../tests/scripts/sync-prompts.bats)

- [ ] Drift detection test works (modify file → `--check` fails)
- [ ] Clean state test passes (`--check` after sync)
- [ ] Build-session meta-prompt existence verified
- [ ] Continue command parity verified

**Notes:**

---

### 10.4 [tests/scripts/validate-scaffold.bats](../../tests/scripts/validate-scaffold.bats)

- [ ] Healthy scaffold passes validation
- [ ] Missing AGENTS.md causes failure
- [ ] Missing ROUTING.md causes failure

**Notes:**

---

### 10.5 [tests/scripts/clash-check.bats](../../tests/scripts/clash-check.bats)

- [ ] Runs without error on repo with no worktrees
- [ ] `--json` flag accepted

**Notes:**

---

## 11. Template Artifacts (Spec/Task/Decision Templates)

### 11.1 [template/specs/_TEMPLATE.md](../../template/specs/_TEMPLATE.md)

- [ ] Template structure matches FILE_CONTRACTS.md spec schema
- [ ] AC format (GWT) is shown
- [ ] Feature ID placeholder present

**Notes:**

---

### 11.2 [template/tasks/_TEMPLATE.md](../../template/tasks/_TEMPLATE.md)

- [ ] Task breakdown structure is shown
- [ ] AC mapping (AC-* → T-*) format present
- [ ] Model/branch assignment fields present
- [ ] Status checkboxes format shown

**Notes:**

---

### 11.3 [template/decisions/_TEMPLATE.md](../../template/decisions/_TEMPLATE.md)

- [ ] Decision record format defined
- [ ] Fields: date, status, context, options, consequences
- [ ] Compare against `workflow-example/decisions/0001-sqlite-storage.md`

**Notes:**

---

## Overall Sign-off

- [ ] **Goal is clear:** A new user can understand what this workflow does and why within 5 minutes of reading
- [ ] **Minimal happy path exists:** README → quickstart → install → compass → define-features → scaffold → fine-tune → implement → test → review → maintain is a documented, followable path
- [ ] **Install is cohesive:** `install.sh` + `validate-scaffold.sh` + `sync-prompts.sh` produce a working scaffold with no manual patches needed
- [ ] **Troubleshooting exists:** Common failure modes are documented with actionable solutions
- [ ] **Docs align with code:** No references to removed files, renamed commands, or deprecated phases
- [ ] **Prompt parity verified:** `sync-prompts.sh --check` returns exit code 0
- [ ] **Cross-references resolve:** Every file link in AGENTS.md, LIFECYCLE.md, and governance files points to an existing file

**Reviewer:** ____________________  
**Date:** ____________________  
**Overall verdict:** PASS / FAIL / PASS WITH NOTES
