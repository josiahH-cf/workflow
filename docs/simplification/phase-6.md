# Phase 6: Cleanup

> **Status**: NOT STARTED
> **Prereqs**: Phase 5 complete (all verification passes)
> **Outcome**: All simplification artifacts removed. Repository is clean.

## Objective

Delete all temporary simplification artifacts. The work is done.

---

## Step 1: Delete Simplification Docs

```bash
rm -rf docs/simplification/
```

---

## Step 2: Delete Orchestrator Meta-Prompt

```bash
rm meta-prompts/simplify.md
```

---

## Step 3: Verify No Stale References

```bash
# No references to simplification docs
grep -ri "simplification\|simplify\.md" README.md docs/ meta-prompts/ template/ scripts/ prompts/ --include="*.md" --include="*.sh"
```

Must return zero hits.

---

## Step 4: Run Sync and Tests

```bash
# Ensure sync doesn't reference simplify.md
scripts/sync-prompts.sh --check

# Full test suite
scripts/test-scripts.sh
```

---

## Step 5: Final Commit

```bash
git add -A
git commit -m "chore: remove simplification working docs

All 7 phases complete. Cleanup artifacts:
- docs/simplification/ (phase tracker + 7 phase docs)
- meta-prompts/simplify.md (orchestrator)
"
```

---

## Acceptance Criteria

- [ ] `docs/simplification/` does not exist
- [ ] `meta-prompts/simplify.md` does not exist
- [ ] No references to `simplification` or `simplify.md` in any active file
- [ ] `sync-prompts.sh --check` passes
- [ ] All test scripts pass
- [ ] Repository is clean — no temporary/working artifacts remain
- [ ] Final commit made with descriptive message

## Post-Completion

The simplification is done. The repository should now have:
- Flat `meta-prompts/` directory with ~17 files
- `prompts/` with ~15 Copilot slash commands
- `template/.claude/commands/` with ~15 Claude commands
- Lean template install (≤ 60 files by default)
- README ≤ 100 lines with golden path + platform routing
- New Mermaid workflow diagram
- `workflow-example` repo linked as reference
- Zero legacy commands, zero version language
- All governance files intact
- All tests passing
