# RS-009 Step 0 Artifact Necessity Audit

## Goal
Establish whether initialization/update/prompt-sync artifacts are each necessary, uniquely purposed, and operationally reachable.

## In Scope
- Necessity and uniqueness checks for Step 0 assets.
- Usage-path clarity expectations.
- Declutter goal where overlap exists.
- Template directory file assessment and merge behavior audit.

## Out of Scope
- Immediate deletion strategy.
- Replacing current setup architecture.

## Observable Outcomes
- Each Step 0 artifact has a unique justified role.
- Redundancy candidates are explicitly identified.
- Template file merge classifications (auto-replace / protect / conditional) are validated for correctness.

## Dependencies
- None.

## Linked Meta-Prompt
- `docs/verification/revision-meta-prompts/09-step0-artifact-necessity-audit.md`

---

## Artifact Inventory

### Category A: Meta-Prompts (Canonical Sources)

| # | Artifact | Path | Purpose |
|---|----------|------|---------|
| A1 | Initialization meta-prompt | `meta-prompts/admin/initialization.md` | Canonical source for Phase 1 agent instructions. Defines 6-step ZIP-based scaffold placement, conflict resolution, convention customization, config setup, verification, and auto-Compass trigger. |
| A2 | Update meta-prompt | `meta-prompts/admin/update.md` | Canonical source for scaffold version updates. Defines 7-step process: inventory, classify (auto-replace/protect/conditional), show changes, apply updates, sync prompts, review protected files, verify. |
| A3 | Prompt-sync meta-prompt | `meta-prompts/admin/prompt-sync.md` | Canonical source for prompt derivation rules. Defines 5-step process: inventory parity, diff validation, regenerate (script-first), validate, report. |

### Category B: Derived Command Files

| # | Artifact | Path | Derived From | Purpose |
|---|----------|------|-------------|---------|
| B1 | Init Copilot prompt | `prompts/initialization.prompt.md` | A1 | VS Code slash command `/initialization` — derived copy of A1 with Copilot frontmatter and input substitutions. |
| B2 | Init Claude command | `template/.claude/commands/initialization.md` | A1 | Claude Code slash command `/initialization` — derived copy of A1 operational block. |

### Category C: Scripts (Automation)

| # | Artifact | Path | Purpose |
|---|----------|------|---------|
| C1 | install.sh | `scripts/install.sh` | Non-interactive CLI installer. Copies template/ and prompts/ into a target directory. Handles `--minimal`, `--force`, `--dry-run`, platform opt-in flags (`--with-github-templates`, `--with-github-agents`, `--with-codex`). |
| C2 | sync-prompts.sh | `scripts/sync-prompts.sh` | Regenerates derived Claude commands and Copilot prompts from canonical meta-prompt sources. Supports `--check` (CI drift detection) and `--dry-run`. |
| C3 | validate-scaffold.sh | `scripts/validate-scaffold.sh` | Validates template internal consistency: required files, cross-references, command parity, placeholder presence, constitution sections, YAML validity, no deprecated frontmatter, no hardcoded tool whitelists. |
| C4 | test-scripts.sh | `scripts/test-scripts.sh` | Thin wrapper that runs `bats tests/scripts` for all script test suites. |

### Category D: Template Files (Placed Into Target Projects)

| # | Artifact | Path | Merge Behavior | Purpose |
|---|----------|------|---------------|---------|
| D1 | AGENTS.md | `template/AGENTS.md` | **Protect** — customized per-project by Compass (Phase 2) | Routing hub for all coding agents. TOC with phase commands, gates, and reference index. |
| D2 | CLAUDE.md | `template/CLAUDE.md` | **Auto-replace** — not customized per-project | Session bootstrap rules for Claude Code. Reads AGENTS.md, STATE.json, constitution. |
| D3 | CLAUDE.local.md | `template/CLAUDE.local.md` | **Conditional** — auto-replace if still default stub, protect if customized | Personal preference overrides (gitignored). |
| D4 | .gitignore | `template/.gitignore` | **Additive** — entries appended, never replaced | Ignores CLAUDE.local.md, .claude/plans/, .trees/, .vscode/, .claude/settings.local.json. |
| D5 | .aiignore | `template/.aiignore` | **Auto-replace** — static exclusion rules | AI agent context exclusions for secrets, governance, build artifacts, lock files. |
| D6 | constitution.md | `template/.specify/constitution.md` | **Protect** — written by Compass, never auto-overwritten | Project identity template with theme sections; becomes read-only after Phase 2. |
| D7 | spec-template.md | `template/.specify/spec-template.md` | **Auto-replace** — not customized per-project | Blank spec template copied for each new feature. |
| D8 | AC template | `template/.specify/acceptance-criteria-template.md` | **Auto-replace** — reference format document | EARS + GWT acceptance criteria format reference. |
| D9 | settings.json | `template/.claude/settings.json` | **Protect** — customized tool permissions and hooks | Claude tool permissions, PostToolUse/Stop hooks. |
| D10 | settings.local.json | `template/.claude/settings.local.json` | **Protect** — personal, gitignored | Local Claude override for YOLO mode etc. |
| D11 | Workflow control-plane files | `template/workflow/*.md` | **Mixed** — COMMANDS.md is Protect; LIFECYCLE, PLAYBOOK, FILE_CONTRACTS, FAILURE_ROUTING, ROUTING, ORCHESTRATOR, CONCURRENCY, BOUNDARIES are Auto-replace | Workflow execution reference documents. |
| D12 | STATE.json | `template/workflow/STATE.json` | **Protect** — managed by /continue orchestrator only | Orchestration state tracking phase, feature, task. |
| D13 | Governance files | `template/governance/*.md` | **Auto-replace** — static policy docs | CHANGE_PROTOCOL, POLICY_TESTS, REGISTRY. |
| D14 | Template dirs | `template/specs/`, `template/tasks/`, `template/decisions/` | **Auto-replace** — blank _TEMPLATE.md files | Blank templates for features, tasks, decisions. |
| D15 | GitHub configs | `template/.github/` | **Mixed** — see update meta-prompt classification | PR template, review rubric, issue templates, agents, CI workflows. |
| D16 | Codex files | `template/.codex/` | **Mixed** — config.toml is Protect; AGENTS.md and PLANS.md are Auto-replace | Codex adapter files. |
| D17 | Scripts | `template/scripts/*.sh` | **Auto-replace** — static operational scripts | clash-check.sh, policy-check.sh, setup-worktree.sh. |

---

## Usage-Path Analysis

### How Each Artifact Is Invoked

| Artifact | Trigger | Actor | When |
|----------|---------|-------|------|
| A1 (init meta-prompt) | Paste into agent session / ZIP placed in project | Human | Project bootstrap (once) |
| A2 (update meta-prompt) | Paste into agent session / new ZIP placed | Human | Scaffold version update |
| A3 (prompt-sync meta-prompt) | Paste into agent session | Human / maintainer | After meta-prompt edits |
| B1 (init Copilot prompt) | `/initialization` in VS Code Copilot Chat | Human via VS Code | Project bootstrap |
| B2 (init Claude command) | `/initialization` in Claude Code | Human via Claude Code | Project bootstrap |
| C1 (install.sh) | `./scripts/install.sh <target-dir>` | Human / CI | Non-interactive install |
| C2 (sync-prompts.sh) | `./scripts/sync-prompts.sh [--check]` | Human / CI | After meta-prompt edits |
| C3 (validate-scaffold.sh) | `./scripts/validate-scaffold.sh` | Human / CI | Scaffold health check |
| C4 (test-scripts.sh) | `./scripts/test-scripts.sh` | Human / CI | Regression testing |

### Flow Diagram

```
New project:
  Human → A1/B1/B2 (agent-guided init with interview)
  Human → C1 (script-based install, no interview)

Scaffold update:
  Human → A2 (agent-guided update with diff/protect)

Meta-prompt edit:
  Maintainer → C2 (regenerate derived files)
  Maintainer → A3 (agent-guided sync when scripts unavailable)

Validation:
  CI / Maintainer → C3 (scaffold health) → C4 (bats tests)
```

---

## Overlap and Redundancy Analysis

### Overlap 1: Initialization — Agent vs Script

**A1/B1/B2** (agent init) and **C1** (install.sh) both place template files into a target project.

| Dimension | Agent Init (A1+B1+B2) | Script Install (C1) |
|-----------|----------------------|---------------------|
| Conflict resolution | Interactive per-file with merge options | `--force` or skip |
| Convention setup | Interview-driven (COMMANDS.md, constitution) | None — places files as-is |
| Config customization | Walks through settings.json, copilot-setup-steps, YOLO mode | None |
| Compass auto-trigger | Yes (Phase 2 auto-initiated) | No |
| ZIP variant detection | Yes (template / metaprompts / full) | N/A (copies from repo dirs) |
| Use case | End-user project bootstrap | Automation / CI / batch setup |

**Assessment: NOT redundant.** C1 fills a different niche (non-interactive, scriptable). Agent init provides the full guided experience. They serve complementary personas.

### Overlap 2: Prompt Sync — Agent vs Script

**A3** (prompt-sync meta-prompt) and **C2** (sync-prompts.sh) both regenerate derived command files.

| Dimension | Agent Sync (A3) | Script Sync (C2) |
|-----------|----------------|-------------------|
| Manual edit detection | Yes — flags and asks before overwriting | No — always overwrites generated files |
| Parity validation | Cross-platform map check | Associative arrays with explicit mapping |
| Input substitutions | Documented in prose | Implemented in `apply_input_substitutions()` |
| Preferred path | Fallback when scripts unavailable | Primary path (A3 explicitly says "script-first") |

**Assessment: NOT redundant.** A3 explicitly defers to C2 ("Canonical maintainer path is script-based sync"). A3 exists as fallback for environments where shell execution is unavailable (e.g., Codex task submission, web-based agents). Both are necessary.

### Overlap 3: Derived Init Commands — B1 vs B2

**B1** (Copilot prompt) and **B2** (Claude command) are platform-specific derivations of the same source (A1).

**Assessment: NOT redundant.** Different platforms require different file formats (Copilot needs YAML frontmatter + input substitutions; Claude needs plain markdown without frontmatter). Both are generated by C2 and cannot be merged.

---

## Necessity Assessment

| # | Artifact | Verdict | Rationale |
|---|----------|---------|-----------|
| A1 | Init meta-prompt | **NECESSARY** | Canonical source for agent-guided project bootstrap. No other artifact captures the interview-driven setup flow. |
| A2 | Update meta-prompt | **NECESSARY** | Unique artifact for scaffold version updates with protect/auto-replace classification. No script equivalent exists for update flow. |
| A3 | Prompt-sync meta-prompt | **NECESSARY** | Fallback for environments without shell access. Explicitly secondary to C2 but needed for agent-only workflows. |
| B1 | Init Copilot prompt | **NECESSARY** | Platform-specific derived output. Required for VS Code Copilot slash command discovery. |
| B2 | Init Claude command | **NECESSARY** | Platform-specific derived output. Required for Claude Code slash command discovery. |
| C1 | install.sh | **NECESSARY** | Non-interactive install path. Enables CI, batch setup, and scripted workflows. Complements A1 without duplicating its interview logic. |
| C2 | sync-prompts.sh | **NECESSARY** | Primary prompt derivation engine. Referenced by A3 as canonical path. CI-compatible with `--check`. |
| C3 | validate-scaffold.sh | **NECESSARY** | Only artifact that validates template internal consistency. 8 distinct check categories. |
| C4 | test-scripts.sh | **NECESSARY** | Bats test runner. Required for regression testing of C1, C2, C3. |
| D1–D17 | Template files | **NECESSARY** | Each template file serves a documented role in FILE_CONTRACTS.md. Merge behaviors are well-classified. |

---

## Template Merge Behavior Audit

### Classification Consistency Check

The update meta-prompt (A2) defines three categories: Auto-replace, Protect, Conditional. Cross-checking against FILE_CONTRACTS.md and install.sh behavior:

| Template File | A2 Classification | FILE_CONTRACTS Owner | install.sh Behavior | Consistent? |
|--------------|-------------------|---------------------|---------------------|-------------|
| AGENTS.md | Protect | Compass (Phase 2) | copy_file (skip if exists, force overwrites) | **YES** — both recognize this is project-customized |
| CLAUDE.md | Auto-replace | Scaffold template | copy_file | **YES** — not customized per-project |
| CLAUDE.local.md | Conditional (auto-replace if default) | N/A (gitignored) | copy_file | **MINOR GAP** — install.sh doesn't detect "still default" |
| workflow/COMMANDS.md | Protect | Phase 1 init / Phase 4 finalize | copy_file | **YES** — both recognize customization |
| workflow/LIFECYCLE.md | Auto-replace | Scaffold template | copy_file | **YES** |
| workflow/PLAYBOOK.md | Auto-replace | Scaffold template | copy_file | **YES** |
| workflow/FILE_CONTRACTS.md | Auto-replace | Scaffold template | copy_file | **YES** |
| workflow/STATE.json | N/A (not in A2 auto-replace list) | Orchestrator (/continue) | copy_file | **NOTE** — install.sh places it; A2 doesn't classify it. STATE.json is placed once at init and managed by orchestrator after. Effectively Protect. |
| .specify/constitution.md | Protect | Compass interview | copy_file | **YES** |
| .claude/settings.json | Protect | Developer customized | copy_file | **YES** |
| governance/*.md | Auto-replace | Scaffold template | copy_file | **YES** |
| .github/workflows/*.yml | Mixed | Mixed | copy_file | **YES** — copilot-setup-steps is Protect, others Auto-replace |
| .gitignore | Additive (append) | N/A | copy_file (not additive) | **GAP** — install.sh does whole-file copy, A2 does additive append |

### Gaps Identified

1. **install.sh .gitignore handling** — install.sh copies the .gitignore wholesale. The update meta-prompt (A2) correctly treats .gitignore as additive (append-only). Since install.sh runs on fresh projects (no existing .gitignore expected), this is acceptable for init but would be destructive if re-run. Mitigated by the `--force` gate and the fact that updates use A2 instead.

2. **install.sh CLAUDE.local.md detection** — install.sh doesn't distinguish "still default stub" from "customized" for CLAUDE.local.md. Acceptable because install.sh targets fresh projects where the file won't exist yet. The update path (A2) handles this correctly.

3. **STATE.json not explicitly classified in A2** — STATE.json appears in neither Auto-replace nor Protect in the update meta-prompt. It should be listed under Protect since it's managed by the orchestrator after init. Currently implicitly protected because it's absent from Auto-replace.

### Recommendations (flag only, no action)

- **R1:** Consider adding `workflow/STATE.json` to A2's Protect list explicitly to prevent future ambiguity.
- **R2:** Consider adding a note to install.sh that .gitignore handling is whole-file copy by design (fresh target only), vs the update path's additive behavior.

---

## Consolidation Candidates

**None identified.** Every Step 0 artifact has a documented unique purpose, a distinct invocation path, and a distinct actor/context. The agent-guided vs script-automated split is intentional and well-documented. Derived files (B1, B2) are platform-format requirements, not duplications.

The template merge behavior is internally consistent with two minor documentation gaps (R1, R2) that do not affect correctness.
