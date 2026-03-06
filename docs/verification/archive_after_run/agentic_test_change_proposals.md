# Agentic Test - Change Proposals

> **Purpose:** Convert verification findings into actionable changes in this repo, then copy validated outputs to `~/hello-verify` for dry-run testing.

## Verification Maintenance Sub-Process (Parallel)

This sub-process lives in `docs/verification/` and runs in parallel with the normal workflow phases.

1. Read findings from `~/hello-verify/experiment-log.md` and extract `warning`, `error`, `critical` entries.
2. Create or update a local findings bundle in this repo under `experiment_findings/phaseN_name/`.
3. Create CP entries in this document grouped by target file.
4. Implement generic/local fixes in this repo first.
5. Copy selected outputs to `~/hello-verify`.
6. Run dry-run checks in `~/hello-verify` and record pass/fail.

## Findings Folder Convention

Every findings bundle should follow the same structure.

```text
experiment_findings/
	phaseN_name/
		README.md
		01-issue-summary.md
		02-phased-remediation-plan.md
		03-file-impact-matrix.md
		04-copy-manifest.md
```

Required naming rule:
- Folder name format: `phaseN_slug` where `N` is the workflow phase number and `slug` is short lowercase kebab or snake style.

## Copy-Forward Contract (`workflow` -> `hello-verify`)

Default target repo path: `~/hello-verify`

Directionality rules:
1. Reverse copy from `hello-verify` into `workflow` is allowed only for evidence artifacts (`experiment-log.md` and optional derived summaries).
2. Core workflow/project files must be fixed in `workflow` first, then applied forward to `hello-verify`.
3. Never import these from `hello-verify` into `workflow`: `.specify/constitution.md`, `specs/`, `tasks/`, `AGENTS.md`, `workflow/STATE.json`, source code, or build files.

### Findings bundle copy

```bash
rsync -av --dry-run \
	/home/josiah/workflow/experiment_findings/ \
	/home/josiah/hello-verify/experiment_findings/
rsync -av \
	/home/josiah/workflow/experiment_findings/ \
	/home/josiah/hello-verify/experiment_findings/
```

### Workflow file copy-forward

When a CP modifies a template or prompt file, the fix must also be applied to the corresponding file in `~/hello-verify`. File mapping:

| Source (workflow repo) | Destination (hello-verify) | Copy strategy |
|---|---|---|
| `template/workflow/*.md` | `~/hello-verify/workflow/*.md` | Overwrite |
| `template/governance/*.md` | `~/hello-verify/governance/*.md` | Overwrite |
| `prompts/*.prompt.md` | `~/hello-verify/.github/prompts/*.prompt.md` | Overwrite |
| `meta-prompts/admin/*.md` | `~/hello-verify/meta-prompts/admin/*.md` | Overwrite |
| `template/.specify/constitution.md` | `~/hello-verify/.specify/constitution.md` | **Comment-only patch** — the hello-verify version contains project-specific content; only update the HTML comment header, never overwrite the body |

Copy commands (per-file, after CP implementation):

```bash
# Workflow files (safe overwrite)
cp /home/josiah/workflow/template/workflow/PLAYBOOK.md    /home/josiah/hello-verify/workflow/PLAYBOOK.md
cp /home/josiah/workflow/template/workflow/BOUNDARIES.md  /home/josiah/hello-verify/workflow/BOUNDARIES.md

# Prompts (safe overwrite)
cp /home/josiah/workflow/prompts/define-features.prompt.md /home/josiah/hello-verify/.github/prompts/define-features.prompt.md

# Meta-prompts (safe overwrite)
cp /home/josiah/workflow/meta-prompts/admin/prompt-sync.md /home/josiah/hello-verify/meta-prompts/admin/prompt-sync.md

# Constitution — comment-only patch (sed replaces only the first-line HTML comment)
sed -i '1s|^<!-- .*-->$|<!-- This file is generated during Phase 2 (Compass). During Phase 2, this is the primary write target — Compass directly populates all sections. After Phase 2 completes, this file is read-only. Post-Compass edits require /compass-edit or equivalent. -->|' /home/josiah/hello-verify/.specify/constitution.md
```

Pre-copy checks:
1. Confirm local changes are committed or intentionally staged.
2. Confirm CP entries reference evidence lines in `~/hello-verify/experiment-log.md`.
3. Confirm each copied file appears in `04-copy-manifest.md`.

Post-copy checks:
1. Run `bash /home/josiah/workflow/scripts/validate-scaffold.sh /home/josiah/hello-verify`.
2. Verify copied files exist in `~/hello-verify/experiment_findings/phaseN_name/`.
3. Verify workflow files match (diff source vs. destination for each overwritten file).
4. Append a result entry to `~/hello-verify/experiment-log.md`.

---

## Proposal Format

```markdown
### CP-[NNN]: [Short title]

| Field | Value |
|-------|-------|
| **Target file** | `[repo-relative path in workflow repo]` |
| **Section/line** | [which section or line range] |
| **Category** | [see categories below] |
| **Severity** | info / warning / error / critical |
| **Evidence** | [experiment-log.md entry reference or quote] |
| **Status** | proposed / in-progress / implemented / validated |

**What to change:**
[Describe the specific edit - what to add, remove, rewrite, or move]

**Why:**
[What went wrong or was confusing, with evidence from the test run]

**Expected improvement:**
[What the change fixes - clearer instructions, correct behavior, unblocked path]

**How to validate:**
[How to verify the fix works - re-run phase, check output, run test]
```

---

## Categories

Derived from [`template/workflow/FAILURE_ROUTING.md`](../../template/workflow/FAILURE_ROUTING.md):

| Category | Description | Typical Target Files |
|----------|-------------|---------------------|
| `instruction-clarity` | Ambiguous, missing, or confusing instructions | meta-prompts/, prompts/, docs/ |
| `instruction-conflict` | Two files say contradictory things | AGENTS.md, workflow/*.md, CLAUDE.md |
| `missing-step` | A required action is not documented | meta-prompts/, PLAYBOOK.md, LIFECYCLE.md |
| `wrong-gate` | Phase gate criteria do not match actual behavior | PLAYBOOK.md, ORCHESTRATOR.md |
| `broken-reference` | File link points to nonexistent or renamed file | AGENTS.md, REGISTRY.md |
| `toolchain-gap` | Tool-specific instructions missing or wrong | prompts/*.prompt.md, CLAUDE.md, .codex/ |
| `state-corruption` | STATE.json not updated correctly or schema wrong | STATE.json, ORCHESTRATOR.md |
| `parity-drift` | Claude command and Copilot prompt out of sync | sync-prompts.sh, prompts/, .claude/commands/ |
| `bug-path-gap` | Bug/bugfix flow has missing steps or unclear routing | 07b-bug.md, 07c-bugfix.md, BOUNDARIES.md |
| `scope-violation` | Agent modified files outside assigned scope | BOUNDARIES.md, AGENTS.md |

---

## Proposals

### Workflow Repo Fixes

### CP-001: Clarify scaffold validator invocation path

| Field | Value |
|-------|-------|
| **Target file** | `docs/verification/agentic_test_runbook.md` |
| **Section/line** | `Phase 1 - Scaffold Import` actions |
| **Category** | `instruction-clarity` |
| **Severity** | error |
| **Evidence** | `~/hello-verify/experiment-log.md:26` (`./validate-scaffold.sh` exit 127) |
| **Status** | implemented |

**What to change:**
Use explicit script path (`scripts/validate-scaffold.sh` or absolute path), not root-relative `./validate-scaffold.sh`.

**Why:**
The failure entry shows the agent attempted root-relative execution and could not find the script.

**Expected improvement:**
Phase 1 validation is deterministic and avoids false setup failures.

**How to validate:**
Run `bash /home/josiah/workflow/scripts/validate-scaffold.sh /home/josiah/hello-verify` and confirm pass.

---

### CP-002: Enforce non-intent completion gate for Define Features

| Field | Value |
|-------|-------|
| **Target file** | `workflow/PLAYBOOK.md` and `prompts/define-features.prompt.md` |
| **Section/line** | Define Features gate and completion requirements |
| **Category** | `missing-step` |
| **Severity** | error |
| **Evidence** | `~/hello-verify/experiment-log.md:102` (phase acknowledged, required spec outputs missing) |
| **Status** | implemented |

**What to change:**
Require explicit artifact evidence before phase completion: at least one `specs/*.md`, capability coverage map, and orphan-feature decision.

**Why:**
The phase was marked as acted on while required files were not produced.

**Expected improvement:**
Prevents plan-only responses from being treated as completed phase execution.

**How to validate:**
Re-run phase 3 and confirm completion is blocked until files and coverage map are present.

---

### CP-003: Resolve Compass constitution write contradiction

| Field | Value |
|-------|-------|
| **Target file** | `template/.specify/constitution.md` and `template/workflow/BOUNDARIES.md` |
| **Section/line** | Constitution edit policy and allowed write paths |
| **Category** | `instruction-conflict` |
| **Severity** | error |
| **Evidence** | `~/hello-verify/experiment-log.md:187` (Compass required writes blocked by policy wording) |
| **Status** | implemented |

**What to change:**
State clearly that phase-2 Compass population is an allowed write operation; restrict only out-of-band edits to `/compass-edit`.

**Why:**
Current language can be interpreted as read-only during the exact phase that must write the file.

**Expected improvement:**
Removes governance ambiguity and reduces Compass stalls.

**How to validate:**
Run Compass from a fresh scaffold and verify `.specify/constitution.md` updates without policy conflict.

---

### CP-004: Add governance blockage recovery path to BOUNDARIES.md

| Field | Value |
|-------|-------|
| **Target file** | `template/workflow/BOUNDARIES.md` |
| **Section/line** | After NEVER section |
| **Category** | `missing-step` |
| **Severity** | error |
| **Evidence** | `~/hello-verify/experiment-log.md` entry `[2-compass] 2026-03-05T14:16:39` — "Assistant became blocked from applying in-workspace edits during constitution-phase follow-up, causing stoppage" |
| **Status** | implemented |

**What to change:**
Add a "Governance Blockage Recovery" subsection after NEVER with a log → retry → escalate pattern: (1) Log failure in experiment-log.md or bug log, (2) Retry once after confirming the write is within phase scope, (3) If still blocked, continue with remaining phase actions and flag the blocked write for human resolution.

**Why:**
When governance enforcement blocked a phase-required write, the agent had no documented recovery path and progress halted entirely. The failure required manual intervention in a new chat session.

**Expected improvement:**
Agents encountering governance/tooling blockage during an allowed-phase write have a deterministic recovery path instead of stalling indefinitely.

**How to validate:**
Confirm BOUNDARIES.md contains the recovery subsection. Re-run Compass from a fresh scaffold; if a write is temporarily blocked, the agent should follow the recovery pattern instead of stopping.

---

### CP-005: Add tool-ID compatibility validation to prompt-sync

| Field | Value |
|-------|-------|
| **Target file** | `meta-prompts/admin/prompt-sync.md` |
| **Section/line** | Validation steps |
| **Category** | `toolchain-gap` |
| **Severity** | warning |
| **Evidence** | `~/hello-verify/experiment-log.md` entry `[3-define-features] 2026-03-05T14:38:27` — "Require interview-capable tooling for interview phases and validate runtime tool-id compatibility" |
| **Status** | implemented |

**What to change:**
Add a validation step: when regenerating prompts, verify that interview-dependent phases (Compass, Define Features) include fallback instructions for tools that lack interactive interview capability.

**Why:**
Phase 2 (Compass) and Phase 3 (Define Features) depend on interactive interviews. Prompt regeneration can reintroduce tool contract mismatches if it doesn't verify interview capability in the target tool.

**Expected improvement:**
Prompt-sync regeneration flags missing interview fallback instructions, preventing tool-specific gaps from being reintroduced.

**How to validate:**
Run prompt-sync regeneration and confirm the output flags any interview-dependent prompt that lacks a non-interactive fallback.

---

## Summary

| Category | Count | Highest Severity |
|----------|-------|-----------------|
| `instruction-clarity` | 1 | error |
| `instruction-conflict` | 1 | error |
| `missing-step` | 2 | error |
| `wrong-gate` | 0 | - |
| `broken-reference` | 0 | - |
| `toolchain-gap` | 1 | warning |
| `state-corruption` | 0 | - |
| `parity-drift` | 0 | - |
| `bug-path-gap` | 0 | - |
| `scope-violation` | 0 | - |
| **Total proposals** | **5** | **error** |

---

## Next Steps

1. [x] Prioritize by severity (critical -> error -> warning)
2. [x] Group proposals by target file family
3. [x] Implement remaining proposed fixes (CP-002, CP-003, CP-004, CP-005)
4. [x] Re-run dry-run validation in `~/hello-verify`
5. [ ] Update each CP status to `validated` after rerun evidence is captured
