# Phase 8: Scripts & Test Harness Update

**Status:** not-started
**Depends on:** Phases 1–7 (all structural changes must be complete)

## Objective

Update all installation, synchronization, validation, and policy scripts to handle the new modular file structure. Add and update BATS tests to cover new functionality.

## Rationale

The template structure has changed significantly across Phases 1–7. Scripts must create/copy/validate the new files or they'll break on next install. Tests must verify the new structure passes validation.

## Context Files to Read First

- `scripts/install.sh` — Installation script (must add new files)
- `scripts/sync-prompts.sh` — Prompt sync (must add `00-full-build.md` mapping)
- `scripts/validate-scaffold.sh` — Validation (must add new checks)
- `template/scripts/policy-check.sh` — Policy validation (must add new files)
- `tests/scripts/` — All existing test files (must be updated)
- All new files created in Phases 1–7 (review the `template/` directory)

## Steps

### Step 1: Update `scripts/install.sh`

Add new template files to the copy list. The install script copies files from the workflow repo's `template/` directory into the target project.

**New files to add to the copy operation:**

From Phase 1 (AGENTS.md decomposition):
- `template/workflow/ROUTING.md`
- `template/workflow/COMMANDS.md`
- `template/workflow/BOUNDARIES.md`
- `template/workflow/SPECS.md`

From Phase 2 (Autonomous loop):
- `template/workflow/ORCHESTRATOR.md`

From Phase 3 (CI workflows):
- `template/.github/workflows/copilot-setup-steps.yml`
- `template/.github/workflows/copilot-agent.yml`
- `template/.github/workflows/claude-review.yml`
- `template/.github/workflows/autofix.yml`
- `template/.github/workflows/agentic-triage.yml`

From Phase 4 (Issue/PR templates):
- `template/.github/ISSUE_TEMPLATE/feature.yml`
- `template/.github/ISSUE_TEMPLATE/bug.yml`
- `template/.github/ISSUE_TEMPLATE/agent-task.yml`
- `template/.github/PULL_REQUEST_TEMPLATE.md`
- `template/.github/agents/reviewer.agent.md`
- `template/.github/agents/implementer.agent.md`

From Phase 6 (Concurrency):
- `template/workflow/CONCURRENCY.md`
- `template/scripts/clash-check.sh`

From Phase 7 (Tool configs):
- `template/.aiignore`

**Directory creation:** Ensure the install script creates these directories in the target project before copying:
- `.github/ISSUE_TEMPLATE/`
- `.github/agents/`
- `.github/workflows/`

**Approach:** Find where the install script copies template files (likely a loop or series of `cp` commands) and add the new files to that list. Ensure new directories are created with `mkdir -p` before copying into them.

### Step 2: Update `scripts/sync-prompts.sh`

The sync script maintains parity between meta-prompts and derived prompt files.

**Add `00-full-build.md` to the command mapping:**

Find the command-to-meta mapping table in the script and add:
```
full-build → meta-prompts/major/00-full-build.md
```

**Verify `continue` sync:**

The enhanced `09-continue.md` (from Phase 2) needs to sync correctly to `prompts/continue.prompt.md`. Verify the extraction logic handles the new session bootstrap and outer loop sections.

### Step 3: Update `scripts/validate-scaffold.sh`

Add validation checks for the new file structure.

**Check 1 update — Required files:**

Add to the required files list:
```
workflow/ROUTING.md
workflow/COMMANDS.md
workflow/BOUNDARIES.md
workflow/SPECS.md
workflow/ORCHESTRATOR.md
workflow/CONCURRENCY.md
.aiignore
.github/PULL_REQUEST_TEMPLATE.md
.github/ISSUE_TEMPLATE/feature.yml
.github/ISSUE_TEMPLATE/bug.yml
.github/ISSUE_TEMPLATE/agent-task.yml
.github/agents/reviewer.agent.md
.github/agents/implementer.agent.md
.github/workflows/copilot-setup-steps.yml
.github/workflows/copilot-agent.yml
.github/workflows/claude-review.yml
.github/workflows/autofix.yml
.github/workflows/agentic-triage.yml
scripts/clash-check.sh
```

**New check — AGENTS.md TOC validation:**

```bash
# Check: AGENTS.md is a compact TOC hub
agents_lines=$(wc -l < "$TEMPLATE_DIR/AGENTS.md")
if (( agents_lines > 100 )); then
  warn "AGENTS.md is $agents_lines lines (target: <80). Consider moving content to sub-files."
fi

# Check: AGENTS.md contains links to modular files
for ref in "ROUTING.md" "COMMANDS.md" "BOUNDARIES.md" "SPECS.md"; do
  if ! grep -q "$ref" "$TEMPLATE_DIR/AGENTS.md"; then
    fail "AGENTS.md missing reference to $ref"
  fi
done
```

**New check — .aiignore sanity:**
```bash
# Check: .aiignore exists and is non-empty
if [[ ! -s "$TEMPLATE_DIR/.aiignore" ]]; then
  fail ".aiignore is missing or empty"
fi
```

**New check — CI workflow YAML validity:**
```bash
# Check: All workflow YAML files are valid
for yml in "$TEMPLATE_DIR/.github/workflows/"*.yml; do
  [[ -f "$yml" ]] || continue
  # Basic YAML validity check (requires python3 or yq)
  if command -v python3 &>/dev/null; then
    python3 -c "import yaml; yaml.safe_load(open('$yml'))" 2>/dev/null || \
      fail "Invalid YAML: $(basename "$yml")"
  fi
done
```

### Step 4: Update `template/scripts/policy-check.sh`

Add new canonical files to the existence check.

**Find the required files list** in the policy-check script and add:
```
workflow/ROUTING.md
workflow/COMMANDS.md
workflow/BOUNDARIES.md
workflow/SPECS.md
workflow/ORCHESTRATOR.md
workflow/CONCURRENCY.md
```

**Add link resolution validation:**
```bash
# Validate that AGENTS.md links resolve to existing files
while IFS= read -r link; do
  # Extract relative path from markdown links
  target=$(echo "$link" | sed -n 's/.*](\([^)]*\)).*/\1/p')
  if [[ -n "$target" && ! -f "$target" && ! -f "$ROOT/$target" ]]; then
    fail "AGENTS.md contains broken link: $target"
  fi
done < <(grep -oE '\[[^]]*\]\([^)]*\)' "$ROOT/AGENTS.md" 2>/dev/null || true)
```

### Step 5: Update `tests/scripts/install.bats`

Add tests for new file installation.

```bash
@test "install copies new workflow files" {
  run bash scripts/install.sh "$TARGET"
  assert_success
  # Phase 1 files
  [[ -f "$TARGET/workflow/ROUTING.md" ]]
  [[ -f "$TARGET/workflow/COMMANDS.md" ]]
  [[ -f "$TARGET/workflow/BOUNDARIES.md" ]]
  [[ -f "$TARGET/workflow/SPECS.md" ]]
  # Phase 2 files
  [[ -f "$TARGET/workflow/ORCHESTRATOR.md" ]]
  # Phase 4 files
  [[ -f "$TARGET/.github/ISSUE_TEMPLATE/feature.yml" ]]
  [[ -f "$TARGET/.github/PULL_REQUEST_TEMPLATE.md" ]]
  [[ -f "$TARGET/.github/agents/reviewer.agent.md" ]]
  # Phase 6 files
  [[ -f "$TARGET/workflow/CONCURRENCY.md" ]]
  [[ -f "$TARGET/scripts/clash-check.sh" ]]
  # Phase 7 files
  [[ -f "$TARGET/.aiignore" ]]
}
```

### Step 6: Update `tests/scripts/validate-scaffold.bats`

Add tests for new validation checks.

```bash
@test "validate detects missing ROUTING.md" {
  rm -f "$TARGET/workflow/ROUTING.md"
  run bash scripts/validate-scaffold.sh "$TARGET"
  assert_failure
}

@test "validate checks AGENTS.md references" {
  run bash scripts/validate-scaffold.sh "$TARGET"
  assert_success
  # Should pass when all references exist
}
```

### Step 7: Update `tests/scripts/sync-prompts.bats`

Add test for `00-full-build.md` sync.

```bash
@test "full-build meta-prompt exists" {
  [[ -f "meta-prompts/major/00-full-build.md" ]]
}
```

### Step 8: Create `tests/scripts/clash-check.bats`

New test file for the conflict detection script.

```bash
#!/usr/bin/env bats

load helpers

setup() {
  setup_repo_copy
}

teardown() {
  teardown_repo_copy
}

@test "clash-check runs without error when no worktrees" {
  cd "$REPO_COPY"
  git init
  run bash scripts/clash-check.sh
  assert_success
  assert_output_contains "No worktrees found"
}

@test "clash-check supports --json flag" {
  cd "$REPO_COPY"
  git init
  run bash scripts/clash-check.sh --json
  assert_success
}
```

## Verification Checklist

- [ ] `scripts/install.sh` copies all new files (ROUTING.md, COMMANDS.md, BOUNDARIES.md, SPECS.md, ORCHESTRATOR.md, CONCURRENCY.md, .aiignore, issue templates, PR template, agent files, CI workflows, clash-check.sh)
- [ ] `scripts/install.sh` creates necessary directories (`.github/ISSUE_TEMPLATE/`, `.github/agents/`, `.github/workflows/`)
- [ ] `scripts/sync-prompts.sh` includes `00-full-build.md` in command mapping
- [ ] `scripts/validate-scaffold.sh` checks for all new required files
- [ ] `scripts/validate-scaffold.sh` validates AGENTS.md line count and link presence
- [ ] `scripts/validate-scaffold.sh` checks .aiignore existence
- [ ] `template/scripts/policy-check.sh` validates new canonical files exist
- [ ] `tests/scripts/install.bats` tests new file installation
- [ ] `tests/scripts/validate-scaffold.bats` tests new validation checks
- [ ] `tests/scripts/sync-prompts.bats` tests full-build meta-prompt
- [ ] `tests/scripts/clash-check.bats` exists with basic tests
- [ ] Running `./scripts/install.sh --dry-run /tmp/test-target` shows all new files
- [ ] Running `./scripts/validate-scaffold.sh` passes with the new template structure
- [ ] Running `./scripts/test-scripts.sh` — all BATS tests pass
- [ ] Running `./scripts/sync-prompts.sh --check` shows no drift

## Completion

When all verification checks pass, update this file:
- Change `**Status:** not-started` to `**Status:** done`
- Add completion timestamp
