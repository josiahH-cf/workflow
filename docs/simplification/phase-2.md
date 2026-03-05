# Phase 2: Trim Template + Merge Workflow Docs + Delete Archive

> **Status**: COMPLETE
> **Prereqs**: Phase 1 complete
> **Outcome**: Archive deleted. Diagram deleted. Platform files are opt-in. SPECS.md merged into FILE_CONTRACTS.md. Default install is leaner.

## Objective

Reduce what ships to the user's project. Merge overlapping workflow docs. Remove dead artifacts.

---

## Step 1: Delete archive/

The `archive/` directory contains historical implementation artifacts marked "non-canonical." Git history preserves everything.

```bash
rm -rf archive/
```

Verify no docs reference `archive/`:
```bash
grep -ri "archive" README.md docs/ meta-prompts/ template/ --include="*.md" \
  | grep -v "docs/simplification/"
```
Update any references found.

---

## Step 2: Delete workflow-diagram.svg

```bash
rm workflow-diagram.svg
```

Remove any references to it in README.md or docs. New diagram will be created in Phase 5.

```bash
grep -ri "workflow-diagram" README.md docs/ template/ --include="*.md"
```
Remove all hits.

---

## Step 3: Implement Generate-on-Demand for Platform-Specific Template Files

These files are useful but NOT needed by every user on day one. Move them to opt-in install flags.

### 3a. Add flags to `scripts/install.sh`

Add these new flags (alongside existing `--with-prompts`, `--with-meta-prompts`):

| Flag | Files Included | When to Use |
|------|---------------|-------------|
| `--with-github-templates` | `template/.github/ISSUE_TEMPLATE/` (5 files) | Using GitHub Issues |
| `--with-github-agents` | `template/.github/agents/` (3 files) | Using GitHub Copilot Agents |
| `--with-codex` | `template/.codex/` (3 files) | Using OpenAI Codex |

### 3b. Modify install.sh copy logic

The default install should **skip** these directories unless the corresponding flag is passed. Modify the `rsync` or `cp` logic to exclude:
- `.github/ISSUE_TEMPLATE/`
- `.github/agents/`
- `.codex/`

Unless the respective flag is provided.

### 3c. Update install.sh help text
Add the new flags to the `--help` output with clear descriptions.

### 3d. Update post-install message
If platform flags were not passed, mention them:
```
Optional: Re-run with --with-github-templates --with-github-agents --with-codex for full platform support.
```

---

## Step 4: Merge Overlapping Workflow Docs

### 4a. Merge SPECS.md → FILE_CONTRACTS.md

Read both files:
- `template/workflow/SPECS.md` — contains spec-writing workflow, EARS/GWT format guidance
- `template/workflow/FILE_CONTRACTS.md` — contains artifact schemas for all file types

Merge strategy:
1. Move SPECS.md content into a new `## Specification Writing` section in FILE_CONTRACTS.md
2. Preserve all EARS/GWT format guidance
3. Ensure no duplicate content
4. Delete `template/workflow/SPECS.md`

```bash
rm template/workflow/SPECS.md
```

### 4b. Evaluate ORCHESTRATOR.md vs PLAYBOOK.md overlap

Read both files and identify:
- Phase-gate definitions that appear in both
- Content unique to each

**Expected outcome**: Keep both files but deduplicate. PLAYBOOK owns gate definitions, ORCHESTRATOR owns the dispatch table and loop contract. Move any gate definitions from ORCHESTRATOR into PLAYBOOK and reference them.

If the overlap is minimal (< 20 lines), leave as-is and note "evaluated, no merge needed."

---

## Step 5: Update Tests

### 5a. Update `validate-scaffold.sh`
The required file list will have changed:
- `SPECS.md` no longer exists → remove from expected files
- Platform-specific files may not be in default install → adjust expectations

### 5b. Update test expectations
- `tests/scripts/validate-scaffold.bats` — update required file list
- `tests/scripts/install.bats` — update expected file counts for default install

### 5c. Run all tests
```bash
scripts/test-scripts.sh
```

---

## Verification Commands

```bash
# Archive deleted
[ -d archive ] && echo "FAIL" || echo "PASS: archive/ deleted"

# Diagram deleted
[ -f workflow-diagram.svg ] && echo "FAIL" || echo "PASS: diagram deleted"

# SPECS.md merged
[ -f template/workflow/SPECS.md ] && echo "FAIL" || echo "PASS: SPECS.md merged"

# FILE_CONTRACTS.md has spec content
grep -qi "specification\|EARS\|GWT" template/workflow/FILE_CONTRACTS.md && echo "PASS: spec content merged" || echo "FAIL"

# No references to deleted files
grep -ri "SPECS\.md" template/workflow/ --include="*.md" | grep -v FILE_CONTRACTS && echo "FAIL: stale SPECS.md ref" || echo "PASS"
grep -ri "workflow-diagram" README.md docs/ template/ --include="*.md" && echo "FAIL: stale diagram ref" || echo "PASS"
grep -ri "archive/" README.md docs/ meta-prompts/ template/ --include="*.md" | grep -v "docs/simplification/" && echo "FAIL: stale archive ref" || echo "PASS"

# Default install file count
# Run install to temp dir and count
TMPDIR=$(mktemp -d)
scripts/install.sh "$TMPDIR" 2>/dev/null
FILE_COUNT=$(find "$TMPDIR" -type f | wc -l)
echo "Default install: $FILE_COUNT files"
[ "$FILE_COUNT" -le 60 ] && echo "PASS: ≤ 60 files" || echo "NEEDS REVIEW: > 60 files"
rm -rf "$TMPDIR"

# All tests pass
scripts/test-scripts.sh
```

---

## Acceptance Criteria

- [ ] `archive/` directory does not exist
- [ ] `workflow-diagram.svg` does not exist
- [ ] No references to `archive/`, `workflow-diagram`, or `SPECS.md` in active docs
- [ ] `template/workflow/SPECS.md` does not exist (content merged into FILE_CONTRACTS.md)
- [ ] `template/workflow/FILE_CONTRACTS.md` contains specification writing guidance (EARS/GWT)
- [ ] `install.sh` supports `--with-github-templates`, `--with-github-agents`, `--with-codex` flags
- [ ] Default install (no flags) produces ≤ 60 files in target project
- [ ] Platform-specific files only included when corresponding flag is passed
- [ ] All test scripts pass (with updated expectations)
- [ ] ORCHESTRATOR.md / PLAYBOOK.md overlap evaluated (merged or documented as acceptable)

## Files Summary

- **Deleted**: ~9 files (archive/ contents) + `workflow-diagram.svg` + `SPECS.md` = ~11
- **Modified**: `install.sh` (flags), `FILE_CONTRACTS.md` (merged content), test files (expectations)
