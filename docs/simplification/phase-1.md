# Phase 1: Delete Legacy + Flatten Meta-Prompts + Remove Version Language

> **Status**: COMPLETE
> **Prereqs**: Phase 0 complete
> **Outcome**: Legacy commands deleted. meta-prompts/ is flat (no major/minor). Zero "V1"/"V2" language anywhere.

## Objective

Remove the old workflow entirely. Flatten the meta-prompt directory structure (merge major batch content into numbered files). Strip all version-qualified language — what remains is simply "the workflow."

---

## Step 1: Delete Legacy Command Files (8 commands × 3 locations = 24 files)

### 1a. Delete from `meta-prompts/minor/`
```
rm meta-prompts/minor/0-ideate.md
rm meta-prompts/minor/1-scope.md
rm meta-prompts/minor/2-plan.md
rm meta-prompts/minor/2b-execplan.md
rm meta-prompts/minor/5-review.md
rm meta-prompts/minor/6-pr-create.md
rm meta-prompts/minor/7-merge.md
rm meta-prompts/minor/fix-prompt.md
```

### 1b. Delete from `prompts/`
```
rm prompts/ideate.prompt.md
rm prompts/scope.prompt.md
rm prompts/plan.prompt.md
rm prompts/execplan.prompt.md
rm prompts/review.prompt.md
rm prompts/pr-create.prompt.md
rm prompts/merge.prompt.md
rm prompts/fix-prompt.prompt.md
```

### 1c. Delete from `template/.claude/commands/`
```
rm template/.claude/commands/ideate.md
rm template/.claude/commands/scope.md
rm template/.claude/commands/plan.md
rm template/.claude/commands/execplan.md
rm template/.claude/commands/review.md
rm template/.claude/commands/pr-create.md
rm template/.claude/commands/merge.md
rm template/.claude/commands/fix-prompt.md
```

---

## Step 2: Delete Redundant Major Files

### 2a. Delete these major meta-prompts
```
rm meta-prompts/major/00-full-build.md    # redundant with /continue
rm meta-prompts/major/01-plan.md          # legacy batch wrapper
rm meta-prompts/major/README.md           # explains defunct major/minor split
```

### 2b. Delete corresponding prompt/command files
```
rm prompts/plan-session.prompt.md         # corresponds to deleted 01-plan
rm prompts/full-build.prompt.md           # corresponds to deleted 00-full-build
rm template/.claude/commands/plan-session.md
rm template/.claude/commands/full-build.md
```

---

## Step 3: Flatten meta-prompts/ Directory

### 3a. Move surviving minor files to meta-prompts/ root
Move these files from `meta-prompts/minor/` → `meta-prompts/`:
```
mv meta-prompts/minor/01-scaffold-import.md    meta-prompts/01-scaffold-import.md
mv meta-prompts/minor/02-compass.md            meta-prompts/02-compass.md
mv meta-prompts/minor/02b-compass-edit.md      meta-prompts/02b-compass-edit.md
mv meta-prompts/minor/03-define-features.md    meta-prompts/03-define-features.md
mv meta-prompts/minor/04-scaffold-project.md   meta-prompts/04-scaffold-project.md
mv meta-prompts/minor/05-fine-tune-plan.md     meta-prompts/05-fine-tune-plan.md
mv meta-prompts/minor/06-code.md               meta-prompts/06-code.md
mv meta-prompts/minor/07-test.md               meta-prompts/07-test.md
mv meta-prompts/minor/07b-bug.md               meta-prompts/07b-bug.md
mv meta-prompts/minor/07c-bugfix.md            meta-prompts/07c-bugfix.md
mv meta-prompts/minor/08-maintain.md           meta-prompts/08-maintain.md
mv meta-prompts/minor/09-continue.md           meta-prompts/09-continue.md
```

### 3b. Merge major batch files into numbered flat files

**`meta-prompts/major/02-build.md`** → merge into new `meta-prompts/06b-build-session.md`
- Take the batch session content (TDD loop for a single feature: test-first → implement → verify)
- Renumber to fit in the flat 06-series
- Remove any "V2 Workflow Context" header — just "Workflow Context" or remove entirely
- Ensure it references `06-code.md` and `07-test.md` phase logic

**`meta-prompts/major/03-review-and-ship.md`** → merge into new `meta-prompts/07d-review-and-ship.md`
- Take the review + PR creation + ship content
- Renumber to fit in the flat 07-series
- Remove any "V2" headers
- Ensure it references the current review flow (not legacy V1 review/cross-review/pr-create/merge)

**`meta-prompts/minor/5b-cross-review.md`** → move to `meta-prompts/07e-cross-review.md`
- Renumber from 5b to 07e
- Update content for current flow (remove any legacy V1 references)
- Mark as OPTIONAL in the file header

### 3c. Delete now-empty directories
```
rmdir meta-prompts/minor/
rmdir meta-prompts/major/
```

---

## Step 4: Update prompts/ and .claude/commands/ to Match Flat Structure

### 4a. Update existing files that reference old paths
Every file in `prompts/` that has a `<!-- generated-from-metaprompt -->` marker or references `meta-prompts/minor/` or `meta-prompts/major/` paths must be updated to reference the new flat path.

### 4b. Update build-session and review-session prompts
- `prompts/build-session.prompt.md` → update to reference `meta-prompts/06b-build-session.md`
- `prompts/review-session.prompt.md` → update to reference `meta-prompts/07d-review-and-ship.md`
- `prompts/cross-review.prompt.md` → update to reference `meta-prompts/07e-cross-review.md`

### 4c. Update .claude/commands/ equivalents
- `template/.claude/commands/build-session.md` → update references
- `template/.claude/commands/review-session.md` → update references
- `template/.claude/commands/cross-review.md` → update references

---

## Step 5: Remove ALL "V1"/"V2" Version Language

Search and update every file containing version qualifiers. Key targets:

### 5a. Root and docs
- **`README.md`** — Remove "V1 vs V2 commands" section entirely. Replace with single workflow description.
- **`docs/quickstart-first-success.md`** — Remove any V1/V2 references

### 5b. Workflow and governance templates
- **`template/workflow/LIFECYCLE.md`** — Change "Project-Level Phases (V2 Agentic Workflow)" → "Project-Level Phases". Remove legacy feature-level phase definitions (ideate/scope/plan numbered 0-7). Keep ONLY the 8-phase project lifecycle.
- **`template/governance/REGISTRY.md`** — Remove legacy v1 references, v2 routing matrix notes

### 5c. Meta-prompts (now flat)
- **`meta-prompts/initialization.md`** — "V2 Workflow Context" → "Workflow Context" (or remove header)
- **`meta-prompts/update.md`** — Remove "V2 Awareness" block, "v2 customization" notes
- **`meta-prompts/prompt-sync.md`** — Remove V1 rows from cross-platform mapping table. Update all paths from `minor/` and `major/` to flat structure.

### 5d. All surviving prompts/*.prompt.md files
Remove the "v1 equivalent" comparison line from each file:
- `compass.prompt.md` (line ~61)
- `define-features.prompt.md` (line ~50)
- `scaffold.prompt.md` (line ~62)
- `fine-tune.prompt.md` (line ~60)
- `implement.prompt.md` (line ~65)
- `test.prompt.md` (line ~61)
- `maintain.prompt.md` (line ~65)

### 5e. All surviving template/.claude/commands/*.md files
Remove the "v1 equivalent" comparison line from each:
- `compass.md`, `define-features.md`, `scaffold.md`, `fine-tune.md`, `implement.md`, `test.md`, `maintain.md`

---

## Step 6: Verify Fine-Tune Phase Content

Read `meta-prompts/05-fine-tune-plan.md` (after move) and confirm it includes:
- ✅ Model assignments (which tool handles which task: Claude Code / Codex / Copilot)
- ✅ Branch naming conventions (pattern for feature branches per model/task)

If missing, add sections covering:
```markdown
## Model Assignments
Assign each task to the most appropriate tool:
- **Claude Code**: Deep multi-file work, architectural reasoning, complex refactoring
- **Codex**: Well-specified, long-running unattended tasks with clear inputs/outputs
- **Copilot**: In-editor completions, quick fixes, GitHub-native PR workflows

## Branch Naming
Use the pattern: `[model]/[type]-[slug]`
Example: `claude/feat-auth-flow`, `codex/fix-input-validation`
```

---

## Step 7: Update Scripts

### 7a. `scripts/sync-prompts.sh`
- Remove all V1 entries from the `COMMAND_TO_META` associative array
- Update all remaining entries to use flat paths (e.g., `minor/02-compass.md` → `02-compass.md`)
- Add entries for new files: `06b-build-session.md`, `07d-review-and-ship.md`, `07e-cross-review.md`
- Remove entries for deleted files: `plan-session`, `full-build`

### 7b. `meta-prompts/prompt-sync.md`
- Update the cross-platform command mapping table to remove V1 rows
- Update all paths to flat structure
- Add rows for merged files (build-session, review-and-ship, cross-review)

---

## Step 8: Run Tests

```bash
# Run all BATS tests
scripts/test-scripts.sh

# Check prompt parity
scripts/sync-prompts.sh --check
```

If tests fail due to expected file list changes, update the test expectations:
- `tests/scripts/install.bats` — update expected files
- `tests/scripts/sync-prompts.bats` — update expected command mappings
- `tests/scripts/validate-scaffold.bats` — update required file list

---

## Verification Commands

```bash
# Zero legacy command files remain
ls meta-prompts/minor/ 2>/dev/null && echo "FAIL: minor/ still exists" || echo "PASS"
ls meta-prompts/major/ 2>/dev/null && echo "FAIL: major/ still exists" || echo "PASS"

# Zero version language (excluding simplification docs)
grep -ri --include="*.md" --include="*.sh" "v1\|v2\|legacy\|version 1\|version 2" \
  prompts/ meta-prompts/ template/ scripts/ README.md TROUBLESHOOTING.md docs/reference/ docs/quickstart-first-success.md \
  | grep -v "docs/simplification/" \
  | grep -v "/proc/version" \
  && echo "FAIL: version language found" || echo "PASS"

# No legacy command files anywhere
for cmd in ideate scope plan execplan review pr-create merge fix-prompt; do
  find prompts/ meta-prompts/ template/.claude/commands/ -name "*${cmd}*" 2>/dev/null
done | grep . && echo "FAIL: legacy files found" || echo "PASS"

# Meta-prompts is flat
[ -d meta-prompts/minor ] && echo "FAIL" || echo "PASS: minor/ gone"
[ -d meta-prompts/major ] && echo "FAIL" || echo "PASS: major/ gone"

# Cross-review exists
[ -f meta-prompts/07e-cross-review.md ] && echo "PASS: cross-review preserved" || echo "FAIL"

# Fine-tune has model assignments
grep -qi "model assign" meta-prompts/05-fine-tune-plan.md && echo "PASS" || echo "NEEDS CHECK"
grep -qi "branch nam" meta-prompts/05-fine-tune-plan.md && echo "PASS" || echo "NEEDS CHECK"
```

---

## Acceptance Criteria

- [ ] `meta-prompts/major/` directory does not exist
- [ ] `meta-prompts/minor/` directory does not exist
- [ ] All meta-prompts live flat in `meta-prompts/`
- [ ] `grep -ri "v1\|v2\|legacy" ...` returns zero hits (excluding `docs/simplification/` and `/proc/version`)
- [ ] No legacy command file exists in any prompt directory
- [ ] Cross-review preserved as `meta-prompts/07e-cross-review.md`
- [ ] `05-fine-tune-plan.md` includes model assignments + branch naming conventions
- [ ] `prompts/` updated: plan-session and full-build deleted, references updated
- [ ] `template/.claude/commands/` updated: corresponding deletions and reference updates
- [ ] `scripts/sync-prompts.sh --check` passes with updated flat paths
- [ ] All test scripts pass (with updated expectations)

## Files Summary

- **Deleted**: ~32 files (24 legacy commands + 4 major batch + 4 corresponding prompt/command files)
- **Moved**: ~12 files (minor/ → meta-prompts/ root)
- **Created**: 3 files (06b-build-session.md, 07d-review-and-ship.md, 07e-cross-review.md — merged/moved content)
- **Modified**: ~25+ files (version language removal, path updates, script updates)
