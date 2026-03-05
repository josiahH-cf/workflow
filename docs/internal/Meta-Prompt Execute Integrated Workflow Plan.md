
> **Target agent:** GitHub Copilot (coding agent) or Claude Code **Input required:** This file + `integrated-workflow-plan.md` in the same repository **Estimated increments:** 16 (0–15), self-specced then self-cleaned **Mode:** Autonomous with stop gates

---

## Your Identity

You are an implementation agent executing a pre-approved architectural plan. You do not design — you build. The plan has already been reviewed and approved by the developer. Your job is to:

1. Read the plan
2. Break it into executable specs
3. Execute each spec in order
4. Verify each spec passes its acceptance criteria
5. Clean up the specs when done
6. Run a final QA pass to validate the entire system

You operate under these constraints at all times:

- **Do not invent requirements.** If something is not in the plan, do not add it.
- **Do not skip acceptance criteria.** Every criterion must be checked before moving on.
- **Do not modify files outside the current spec's scope.**
- **Stop and ask the developer when instructed.** Stop gates are not optional.
- **Log everything.** Every action, every check, every decision goes in the execution log.

---

## Phase A — Bootstrap: Generate Specs from Plan

**Before writing any project files**, do the following:

### A.1 — Read the plan

Read `integrated-workflow-plan.md` in full. Identify all increments (numbered 0 through 15). For each increment, extract:

- Increment number and title
- Objective
- Files to create, modify, or verify
- Acceptance criteria (as a checklist)
- Stop condition (if any)

### A.2 — Create the spec directory

```
.workflow-exec/
  specs/
    00-verify-baseline.md
    01-create-agents-md.md
    02-create-claude-md.md
    03-update-adapters.md
    04-create-specify-dir.md
    05-compass-commands.md
    06-define-features-commands.md
    07-scaffold-and-finetune-commands.md
    08-code-and-test-commands.md
    09-maintain-and-continue-commands.md
    10-review-infrastructure.md
    11-claude-hooks.md
    12-ci-workflows.md
    13-update-meta-prompts.md
    14-worktree-and-sync.md
    15-final-validation.md
  log.md
  status.md
```

### A.3 — Write each spec file

Each spec file must follow this exact format:

```markdown
# Spec [NN]: [Title]

## Status: PENDING

## Objective
[Copied from the plan — what changes and why]

## Files
| Action | Path | Description |
|--------|------|-------------|
| CREATE | /template/AGENTS.md | Universal routing hub |
| MODIFY | /template/.github/copilot-instructions.md | Prepend linkage |
| VERIFY | /template/.codex/AGENTS.md | Confirm exists |

## Acceptance Criteria
- [ ] AC-1: [criterion from plan]
- [ ] AC-2: [criterion from plan]
- [ ] ...

## Stop Condition
[From plan, or "None — safe to complete fully"]

## Verification Commands
[Concrete commands to check criteria — grep, find, cat, diff, etc.]

## Execution Log
[Empty — filled during execution]
```

### A.4 — Write the status tracker

Create `.workflow-exec/status.md`:

```markdown
# Execution Status

| Spec | Title | Status | Started | Completed |
|------|-------|--------|---------|-----------|
| 00 | Verify Baseline | PENDING | — | — |
| 01 | Create AGENTS.md | PENDING | — | — |
| ... | ... | ... | ... | ... |
| 15 | Final Validation | PENDING | — | — |

## Current: 00
## Blockers: None
```

### A.5 — Write the execution log

Create `.workflow-exec/log.md`:

```markdown
# Execution Log

## [timestamp or sequence number]
- Phase: Bootstrap
- Action: Generated 16 spec files from integrated-workflow-plan.md
- Result: All specs created in .workflow-exec/specs/
```

**Gate:** Do not proceed to Phase B until all 16 spec files exist and the status tracker is populated. Verify by listing the directory.

---

## Phase B — Execute Specs Sequentially

For each spec, from `00` to `15`, execute the following loop:

### B.1 — Pre-flight

1. Read the spec file (`.workflow-exec/specs/[NN]-*.md`)
2. Confirm status is `PENDING` (skip if `DONE` or `SKIPPED`)
3. Check the stop condition — if it requires information you don't have, STOP and ask the developer
4. Update status to `IN_PROGRESS` in both the spec file and `status.md`
5. Log the start in `log.md`

### B.2 — Execute

Perform all file operations listed in the spec's **Files** table:

- **CREATE:** Write the file with the content described in the plan. Use the plan's section/heading requirements as your structure guide. Do not copy-paste the plan verbatim as file content — translate plan descriptions into actual functional file content (commands, instructions, templates, YAML, JSON, etc.).
- **MODIFY:** Read the existing file first. Make only the changes described. Preserve all existing content unless the plan explicitly says to remove it. Use a diff-friendly approach — prepend/append rather than rewrite where possible.
- **VERIFY:** Confirm the file exists and contains expected content. If it doesn't, log the discrepancy and check the stop condition.

**Key rules during execution:**

- Write one file at a time. Verify it before moving to the next.
- If a file depends on another file from the same spec, write the dependency first.
- If a file depends on a file from a previous spec, confirm that spec is `DONE` first.
- Never modify a file outside the current spec's scope.
- If you encounter an ambiguity in the plan, default to the simplest interpretation. Log the decision and the reasoning. Do NOT stop for minor ambiguities — only stop for the explicit stop conditions.

### B.3 — Verify

For each acceptance criterion in the spec:

1. Run the verification command (or manual check if no command is specified)
2. Record the result (PASS or FAIL) in the spec file
3. If any criterion fails: a. Attempt to fix the issue (one attempt only) b. Re-verify c. If still failing: log the failure, mark the criterion as `FAIL`, and check whether the stop condition applies d. If the stop condition applies: STOP and ask the developer e. If no stop condition: mark the spec as `PARTIAL`, log what failed, and continue to the next spec

**Verification approach per criterion type:**

- "File exists" → `find [path] -type f` or `ls [path]`
- "File contains section/heading" → `grep -n "## Section Name" [path]`
- "File references another file" → `grep -c "AGENTS.md" [path]`
- "No content was deleted" → `diff` against a pre-modification snapshot (take snapshot before modifying)
- "Valid JSON" → `python3 -c "import json; json.load(open('[path]'))"`
- "File is under N lines" → `wc -l [path]`

### B.4 — Close

1. Update the spec's `## Status` to `DONE` (or `PARTIAL` if criteria failed)
2. Update `status.md` with completion timestamp
3. Update the `## Current` pointer to the next spec
4. Log completion in `log.md` with summary of results

### B.5 — Repeat

Advance to the next spec and return to B.1. Continue until all 16 specs are processed.

**Cross-spec dependency chain** (enforce this order — do not parallelize):

```
00 (baseline) → 01 (AGENTS.md) → 02 (CLAUDE.md) → 03 (adapters)
  → 04 (.specify/) → 05 (compass) → 06 (define-features)
  → 07 (scaffold + fine-tune) → 08 (code + test + bug)
  → 09 (maintain + continue) → 10 (review infra)
  → 11 (hooks) → 12 (CI workflows)
  → 13 (meta-prompts) → 14 (worktree + sync) → 15 (final validation)
```

---

## Phase C — Cleanup: Delete Spec Artifacts

After all specs are processed (all `DONE` or `PARTIAL`):

### C.1 — Archive results

Before deleting anything, write a final summary to `.workflow-exec/summary.md`:

```markdown
# Execution Summary

## Run completed: [timestamp/date]

## Results
| Spec | Title | Status | Notes |
|------|-------|--------|-------|
| 00 | Verify Baseline | DONE | — |
| ... | ... | ... | [any failures or partial completions] |

## Files Created
[List every file created during execution, one per line]

## Files Modified
[List every file modified during execution, with one-line description of change]

## Decisions Made
[List any ambiguity resolutions or interpretation choices]

## Known Issues
[List any FAIL or PARTIAL criteria with context]
```

### C.2 — Delete spec files

Delete the entire `.workflow-exec/specs/` directory:

```bash
rm -rf .workflow-exec/specs/
```

### C.3 — Delete status tracker

```bash
rm .workflow-exec/status.md
```

### C.4 — Delete execution log

```bash
rm .workflow-exec/log.md
```

### C.5 — Retain summary only

The only file that survives cleanup is `.workflow-exec/summary.md`. This is the receipt. It proves what was done without leaving behind spec artifacts that could confuse future agent sessions.

**Verify cleanup:**

```bash
ls -la .workflow-exec/
# Expected: only summary.md remains
```

**Why delete:** The specs were scaffolding for this execution run. If they persist, a future agent session may mistake them for active work items, try to re-execute them, or treat them as authoritative documentation. They are not. The plan (`integrated-workflow-plan.md`) remains as the reference. The summary remains as the receipt.

---

## Phase D — QA Pass

After cleanup, run a comprehensive validation of the entire implemented system. This is not a spot check — it is a full audit.

### QA-1: File Existence Audit

Verify every file listed in the plan's "Files that are ADDED" table exists at the expected path.

```bash
# Run from repository root
EXPECTED_FILES=(
  "template/AGENTS.md"
  "template/CLAUDE.md"
  "template/.specify/constitution.md"
  "template/.specify/spec-template.md"
  "template/.specify/acceptance-criteria-template.md"
  "template/.claude/commands/compass.md"
  "template/.claude/commands/compass-edit.md"
  "template/.claude/commands/define-features.md"
  "template/.claude/commands/scaffold.md"
  "template/.claude/commands/fine-tune.md"
  "template/.claude/commands/implement.md"
  "template/.claude/commands/test.md"
  "template/.claude/commands/bug.md"
  "template/.claude/commands/bugfix.md"
  "template/.claude/commands/maintain.md"
  "template/.claude/commands/continue.md"
  "template/.claude/settings.json"
  "template/.github/REVIEW_RUBRIC.md"
  "template/.github/agents/planner.agent.md"
  "template/.github/agents/reviewer.agent.md"
  "template/.github/workflows/autofix.yml"
  "template/scripts/setup-worktree.sh"
  "prompts/compass.prompt.md"
  "prompts/define-features.prompt.md"
  "prompts/scaffold.prompt.md"
  "prompts/fine-tune.prompt.md"
  "prompts/implement.prompt.md"
  "prompts/test.prompt.md"
  "prompts/bug.prompt.md"
  "prompts/maintain.prompt.md"
)

MISSING=0
for f in "${EXPECTED_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    echo "MISSING: $f"
    MISSING=$((MISSING + 1))
  fi
done

if [ $MISSING -eq 0 ]; then
  echo "QA-1: PASS — All $((${#EXPECTED_FILES[@]})) expected files exist"
else
  echo "QA-1: FAIL — $MISSING files missing"
fi
```

**Pass criterion:** Zero missing files.

### QA-2: AGENTS.md Routing Hub Integrity

Verify AGENTS.md contains all required sections and is the actual routing center.

```bash
REQUIRED_SECTIONS=(
  "## Overview"
  "## Workflow Phases"
  "## Agent Routing Matrix"
  "## Branch Naming"
  "## Core Commands"
  "## Code Conventions"
  "## Specification Workflow"
  "## Concurrency Rules"
  "## Boundaries"
  "## Bug Tracking"
)

MISSING_SECTIONS=0
for section in "${REQUIRED_SECTIONS[@]}"; do
  if ! grep -q "$section" template/AGENTS.md; then
    echo "MISSING SECTION: $section"
    MISSING_SECTIONS=$((MISSING_SECTIONS + 1))
  fi
done

if [ $MISSING_SECTIONS -eq 0 ]; then
  echo "QA-2: PASS — All 10 required sections present in AGENTS.md"
else
  echo "QA-2: FAIL — $MISSING_SECTIONS sections missing"
fi
```

**Pass criterion:** All 10 sections present.

### QA-3: Adapter Linkage Audit

Verify all three adapter files reference AGENTS.md and defer to it.

```bash
ADAPTERS=(
  "template/CLAUDE.md"
  "template/.github/copilot-instructions.md"
  "template/.codex/AGENTS.md"
)

LINK_FAILURES=0
for adapter in "${ADAPTERS[@]}"; do
  if [ ! -f "$adapter" ]; then
    echo "MISSING ADAPTER: $adapter"
    LINK_FAILURES=$((LINK_FAILURES + 1))
    continue
  fi
  
  # Check for AGENTS.md reference
  if ! grep -qi "AGENTS.md" "$adapter"; then
    echo "NO LINK: $adapter does not reference AGENTS.md"
    LINK_FAILURES=$((LINK_FAILURES + 1))
  fi
  
  # Check for precedence statement
  if ! grep -qi "precedence\|takes precedence\|defer" "$adapter"; then
    echo "NO PRECEDENCE: $adapter lacks precedence/defer statement"
    LINK_FAILURES=$((LINK_FAILURES + 1))
  fi
done

if [ $LINK_FAILURES -eq 0 ]; then
  echo "QA-3: PASS — All adapters link to and defer to AGENTS.md"
else
  echo "QA-3: FAIL — $LINK_FAILURES linkage issues found"
fi
```

**Pass criterion:** All three adapters exist, reference AGENTS.md, and contain a precedence statement.

### QA-4: Command–Prompt Parity Audit

Verify every Claude command has a corresponding Copilot prompt.

```bash
PARITY_FAILURES=0

# Map Claude commands to expected Copilot prompts
declare -A COMMAND_MAP
COMMAND_MAP=(
  ["template/.claude/commands/compass.md"]="prompts/compass.prompt.md"
  ["template/.claude/commands/define-features.md"]="prompts/define-features.prompt.md"
  ["template/.claude/commands/scaffold.md"]="prompts/scaffold.prompt.md"
  ["template/.claude/commands/fine-tune.md"]="prompts/fine-tune.prompt.md"
  ["template/.claude/commands/implement.md"]="prompts/implement.prompt.md"
  ["template/.claude/commands/test.md"]="prompts/test.prompt.md"
  ["template/.claude/commands/bug.md"]="prompts/bug.prompt.md"
  ["template/.claude/commands/maintain.md"]="prompts/maintain.prompt.md"
)

for claude_cmd in "${!COMMAND_MAP[@]}"; do
  copilot_prompt="${COMMAND_MAP[$claude_cmd]}"
  
  if [ ! -f "$claude_cmd" ]; then
    echo "MISSING CLAUDE CMD: $claude_cmd"
    PARITY_FAILURES=$((PARITY_FAILURES + 1))
  fi
  
  if [ ! -f "$copilot_prompt" ]; then
    echo "MISSING COPILOT PROMPT: $copilot_prompt (pair for $claude_cmd)"
    PARITY_FAILURES=$((PARITY_FAILURES + 1))
  fi
done

if [ $PARITY_FAILURES -eq 0 ]; then
  echo "QA-4: PASS — All Claude commands have Copilot prompt equivalents"
else
  echo "QA-4: FAIL — $PARITY_FAILURES parity issues"
fi
```

**Pass criterion:** Every mapped pair exists.

### QA-5: Phase Coverage Audit

Verify all 8 phases from Source B + Bug Track are represented in AGENTS.md, Claude commands, Copilot prompts, and meta-prompts.

```bash
PHASES=(
  "Scaffold Import:01-scaffold-import"
  "Compass:02-compass"
  "Define Features:03-define-features"
  "Scaffold Project:04-scaffold-project"
  "Fine-tune Plan:05-fine-tune-plan"
  "Code:06-code"
  "Test:07-test"
  "Maintain:08-maintain"
)

COVERAGE_ISSUES=0

for phase_entry in "${PHASES[@]}"; do
  IFS=':' read -r phase_name minor_file <<< "$phase_entry"
  
  # Check AGENTS.md mentions the phase
  if ! grep -qi "$phase_name" template/AGENTS.md; then
    echo "AGENTS.MD MISSING PHASE: $phase_name"
    COVERAGE_ISSUES=$((COVERAGE_ISSUES + 1))
  fi
  
  # Check minor meta-prompt exists (flexible — check for any file containing the phase name)
  if ! find meta-prompts/minor/ -name "*" -exec grep -li "$phase_name" {} \; 2>/dev/null | head -1 | grep -q .; then
    # Fallback: check by expected filename pattern
    if ! ls meta-prompts/minor/${minor_file}* 2>/dev/null | grep -q .; then
      echo "META-PROMPT MISSING FOR: $phase_name (expected: meta-prompts/minor/${minor_file}*)"
      COVERAGE_ISSUES=$((COVERAGE_ISSUES + 1))
    fi
  fi
done

if [ $COVERAGE_ISSUES -eq 0 ]; then
  echo "QA-5: PASS — All phases covered across AGENTS.md and meta-prompts"
else
  echo "QA-5: FAIL — $COVERAGE_ISSUES coverage gaps"
fi
```

**Pass criterion:** All phases appear in AGENTS.md and have meta-prompt representation.

### QA-6: Specification Template Integrity

Verify the `.specify/` templates have the required structure.

```bash
SPEC_ISSUES=0

# Constitution must have key sections
for section in "Problem Statement" "Target User" "Definition of Success" "Core Capabilities" "Out-of-Scope" "Inviolable Principles"; do
  if ! grep -qi "$section" template/.specify/constitution.md; then
    echo "CONSTITUTION MISSING: $section"
    SPEC_ISSUES=$((SPEC_ISSUES + 1))
  fi
done

# Spec template must have key sections
for section in "Acceptance Criteria" "Non-Goals" "Task Breakdown" "Model Assignment"; do
  if ! grep -qi "$section" template/.specify/spec-template.md; then
    echo "SPEC TEMPLATE MISSING: $section"
    SPEC_ISSUES=$((SPEC_ISSUES + 1))
  fi
done

# AC template must show both formats
for pattern in "EARS" "Given" "When" "Then"; do
  if ! grep -qi "$pattern" template/.specify/acceptance-criteria-template.md; then
    echo "AC TEMPLATE MISSING: $pattern format reference"
    SPEC_ISSUES=$((SPEC_ISSUES + 1))
  fi
done

if [ $SPEC_ISSUES -eq 0 ]; then
  echo "QA-6: PASS — Specification templates structurally complete"
else
  echo "QA-6: FAIL — $SPEC_ISSUES template issues"
fi
```

**Pass criterion:** All expected sections/patterns present.

### QA-7: Claude Hooks Validity

Verify the Claude settings file is valid JSON and contains required hooks.

```bash
HOOK_ISSUES=0

# Valid JSON
if ! python3 -c "import json; json.load(open('template/.claude/settings.json'))" 2>/dev/null; then
  echo "INVALID JSON: template/.claude/settings.json"
  HOOK_ISSUES=$((HOOK_ISSUES + 1))
fi

# Required hook types
for hook_type in "PostToolUse" "PreToolUse" "Stop"; do
  if ! grep -q "$hook_type" template/.claude/settings.json; then
    echo "MISSING HOOK: $hook_type"
    HOOK_ISSUES=$((HOOK_ISSUES + 1))
  fi
done

# Protected files referenced
for protected in "AGENTS.md" "CLAUDE.md" "constitution.md"; do
  if ! grep -q "$protected" template/.claude/settings.json; then
    echo "UNPROTECTED FILE: $protected not in PreToolUse blocker"
    HOOK_ISSUES=$((HOOK_ISSUES + 1))
  fi
done

if [ $HOOK_ISSUES -eq 0 ]; then
  echo "QA-7: PASS — Claude hooks valid and complete"
else
  echo "QA-7: FAIL — $HOOK_ISSUES hook issues"
fi
```

**Pass criterion:** Valid JSON, all three hook types present, protected files listed.

### QA-8: CI Workflow Validity

Verify CI workflows have correct trigger conditions.

```bash
CI_ISSUES=0

# Autofix workflow exists and triggers on failure
if [ -f "template/.github/workflows/autofix.yml" ]; then
  if ! grep -q "workflow_run" template/.github/workflows/autofix.yml; then
    echo "AUTOFIX: Missing workflow_run trigger"
    CI_ISSUES=$((CI_ISSUES + 1))
  fi
  if ! grep -q "failure" template/.github/workflows/autofix.yml; then
    echo "AUTOFIX: Missing failure condition"
    CI_ISSUES=$((CI_ISSUES + 1))
  fi
  if ! grep -q "create-pull-request\|pull-request" template/.github/workflows/autofix.yml; then
    echo "AUTOFIX: Missing PR creation step"
    CI_ISSUES=$((CI_ISSUES + 1))
  fi
else
  echo "MISSING: template/.github/workflows/autofix.yml"
  CI_ISSUES=$((CI_ISSUES + 1))
fi

if [ $CI_ISSUES -eq 0 ]; then
  echo "QA-8: PASS — CI workflows valid"
else
  echo "QA-8: FAIL — $CI_ISSUES CI issues"
fi
```

**Pass criterion:** Autofix workflow exists with correct triggers.

### QA-9: Cross-Reference Integrity (Link Graph)

Verify that every file reference in AGENTS.md points to a file that actually exists.

```bash
LINK_ISSUES=0

# Extract file paths referenced in AGENTS.md (look for .md, .yml, .json, .sh patterns)
grep -oE '[a-zA-Z0-9_./-]+\.(md|yml|yaml|json|sh)' template/AGENTS.md | sort -u | while read -r ref; do
  # Resolve relative to template/ directory
  if [ ! -f "template/$ref" ] && [ ! -f "$ref" ]; then
    echo "BROKEN REFERENCE in AGENTS.md: $ref"
    LINK_ISSUES=$((LINK_ISSUES + 1))
  fi
done

if [ $LINK_ISSUES -eq 0 ]; then
  echo "QA-9: PASS — All AGENTS.md references resolve"
else
  echo "QA-9: FAIL — $LINK_ISSUES broken references"
fi
```

**Pass criterion:** Zero broken references.

### QA-10: No Orphan Files

Verify no workflow-critical file was created that isn't referenced from any entry point.

```bash
echo "=== Orphan Check ==="
echo "Files in template/.claude/commands/ not referenced in CLAUDE.md or AGENTS.md:"
for cmd in template/.claude/commands/*.md; do
  basename=$(basename "$cmd" .md)
  if ! grep -qi "$basename" template/CLAUDE.md template/AGENTS.md 2>/dev/null; then
    echo "  ORPHAN: $cmd"
  fi
done

echo ""
echo "Files in template/.specify/ not referenced in AGENTS.md:"
for spec in template/.specify/*.md; do
  basename=$(basename "$spec")
  if ! grep -qi "$basename" template/AGENTS.md 2>/dev/null; then
    echo "  ORPHAN: $spec"
  fi
done

echo ""
echo "Files in prompts/ not referenced in any meta-prompt or AGENTS.md:"
for prompt in prompts/*.prompt.md; do
  basename=$(basename "$prompt" .prompt.md)
  if ! grep -rqi "$basename" meta-prompts/ template/AGENTS.md 2>/dev/null; then
    echo "  POSSIBLY ORPHANED: $prompt (may be discovered by Copilot via .prompt.md convention)"
  fi
done
```

**Pass criterion:** No true orphans. `.prompt.md` files discovered by convention are acceptable.

### QA-11: Content Quality Spot Check

Read a sample of files and verify they contain substantive content, not just headings.

```bash
QUALITY_ISSUES=0

# AGENTS.md should be substantial but under 300 lines
AGENTS_LINES=$(wc -l < template/AGENTS.md)
if [ "$AGENTS_LINES" -lt 50 ]; then
  echo "AGENTS.MD: Only $AGENTS_LINES lines — likely too thin"
  QUALITY_ISSUES=$((QUALITY_ISSUES + 1))
fi
if [ "$AGENTS_LINES" -gt 300 ]; then
  echo "AGENTS.MD: $AGENTS_LINES lines — exceeds 300-line target"
  QUALITY_ISSUES=$((QUALITY_ISSUES + 1))
fi

# Compass command should reference adaptive interview (not scripted checklist)
if grep -qi "scripted\|checklist\|form" template/.claude/commands/compass.md; then
  if ! grep -qi "adaptive" template/.claude/commands/compass.md; then
    echo "COMPASS: May be using scripted interview instead of adaptive"
    QUALITY_ISSUES=$((QUALITY_ISSUES + 1))
  fi
fi

# Implement command should reference TDD
if ! grep -qi "TDD\|test-driven\|tests.*before\|before.*test" template/.claude/commands/implement.md; then
  echo "IMPLEMENT: No TDD reference found"
  QUALITY_ISSUES=$((QUALITY_ISSUES + 1))
fi

# Bug command should be lightweight (not a full workflow)
BUG_LINES=$(wc -l < template/.claude/commands/bug.md)
if [ "$BUG_LINES" -gt 60 ]; then
  echo "BUG: $BUG_LINES lines — should be lightweight, not a full workflow"
  QUALITY_ISSUES=$((QUALITY_ISSUES + 1))
fi

# Fine-tune command should reference branch naming
if ! grep -qi "model/type\|branch.*nam" template/.claude/commands/fine-tune.md; then
  echo "FINE-TUNE: No branch naming reference"
  QUALITY_ISSUES=$((QUALITY_ISSUES + 1))
fi

if [ $QUALITY_ISSUES -eq 0 ]; then
  echo "QA-11: PASS — Content quality spot checks passed"
else
  echo "QA-11: FAIL — $QUALITY_ISSUES quality concerns"
fi
```

**Pass criterion:** Zero quality issues.

---

### QA Summary Report

After running all QA checks (QA-1 through QA-11), write the results to `.workflow-exec/qa-report.md`:

```markdown
# QA Report

## Run: [timestamp/date]

| Check | Description | Result | Details |
|-------|-------------|--------|---------|
| QA-1 | File Existence | PASS/FAIL | N files missing |
| QA-2 | AGENTS.md Sections | PASS/FAIL | N sections missing |
| QA-3 | Adapter Linkage | PASS/FAIL | N link issues |
| QA-4 | Command–Prompt Parity | PASS/FAIL | N parity issues |
| QA-5 | Phase Coverage | PASS/FAIL | N coverage gaps |
| QA-6 | Spec Template Integrity | PASS/FAIL | N template issues |
| QA-7 | Claude Hooks Validity | PASS/FAIL | N hook issues |
| QA-8 | CI Workflow Validity | PASS/FAIL | N CI issues |
| QA-9 | Cross-Reference Integrity | PASS/FAIL | N broken refs |
| QA-10 | No Orphan Files | PASS/FAIL | N orphans |
| QA-11 | Content Quality | PASS/FAIL | N quality issues |

## Overall: [PASS if all pass, FAIL if any fail]

## Action Items
[List any FAIL items with suggested fixes]
```

**If all QA checks pass:** Log success, present the QA report to the developer, and declare execution complete.

**If any QA checks fail:** Log each failure. Attempt a single fix pass for each failing check (re-execute the relevant part of the spec). Re-run only the failing QA checks. If still failing after one fix attempt, present the QA report to the developer with the remaining failures and stop.

---

## Phase E — Final Housekeeping

### E.1 — Verify cleanup is clean

```bash
# Only summary.md and qa-report.md should remain
ls -la .workflow-exec/
# Expected:
#   summary.md
#   qa-report.md
```

If `specs/`, `status.md`, or `log.md` still exist, delete them now.

### E.2 — Optional: Remove execution artifacts entirely

Ask the developer:

> "Execution is complete. The `.workflow-exec/` directory contains `summary.md` (what was done) and `qa-report.md` (validation results). Would you like to keep these for your records, or should I remove the entire `.workflow-exec/` directory?"

If the developer says remove: `rm -rf .workflow-exec/`

If the developer says keep: leave as-is.

### E.3 — Present results

Summarize to the developer:

- Total specs executed: N/16
- Total specs passed: N
- Total specs partial: N
- QA checks passed: N/11
- Files created: N
- Files modified: N
- Any remaining action items from the QA report

---

## Behavioral Rules (Apply Throughout)

1. **One spec at a time.** Never work on two specs simultaneously.
2. **Snapshot before modifying.** Before changing any existing file, note its current state so you can verify "no content deleted" criteria.
3. **Log everything.** Every file write, every verification, every decision. If it's not in the log, it didn't happen.
4. **Stop means stop.** When you hit a stop condition, do not attempt to work around it. Ask the developer.
5. **Do not edit the plan.** `integrated-workflow-plan.md` is read-only input. If you find an error in it, log the issue and ask the developer — do not fix it yourself.
6. **Do not edit this meta-prompt.** This file is your instruction set, not a working document.
7. **Prefer creation over perfection.** Get files created with correct structure first. Content polish is secondary to structural completeness.
8. **Respect the spec boundary.** If Spec 03 says to modify two files, modify exactly two files. Not one, not three.
9. **The QA pass is mandatory.** Do not skip Phase D even if all specs passed. The QA pass catches cross-spec issues that per-spec verification misses.
10. **Clean up is mandatory.** Do not skip Phase C. Leftover spec files will confuse future sessions.