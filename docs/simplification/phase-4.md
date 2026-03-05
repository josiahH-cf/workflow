# Phase 4: Extract Sample Project to `workflow-example` Repo

> **Status**: NOT STARTED
> **Prereqs**: Phase 3 complete
> **Outcome**: `examples/` moved to `workflow-example` GitHub repo. Main repo links to it.

## Objective

Move `examples/sample-project/` to its own GitHub repository (`workflow-example`). Link from README. Reduce main repo size.

---

## Step 1: Create `workflow-example` Repository

### 1a. Create repo via GitHub API

Create the repository under the same GitHub org/user as the main workflow repo.

```bash
# Using GitHub CLI (gh)
gh repo create workflow-example \
  --public \
  --description "Reference example for the workflow scaffold — a completed TaskFlow CLI project" \
  --clone
```

If `gh` CLI is not available, use the GitHub API:
```bash
curl -X POST https://api.github.com/user/repos \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "workflow-example",
    "description": "Reference example for the workflow scaffold — a completed TaskFlow CLI project",
    "private": false,
    "auto_init": false
  }'
```

### Manual fallback
If API creation fails:
1. Create `workflow-example` manually on GitHub
2. Clone it locally
3. Continue from Step 2

---

## Step 2: Populate the Repository

### 2a. Copy sample project contents

```bash
cd workflow-example/

# Copy all contents from the sample project
cp -r /path/to/workflow/examples/sample-project/* .
cp -r /path/to/workflow/examples/sample-project/.* . 2>/dev/null  # hidden files

# Verify key files
ls -la .specify/constitution.md specs/ tasks/ decisions/ bugs/ workflow/
```

### 2b. Create README.md for the new repo

Create a README that explains what this is:

```markdown
# Workflow Example — TaskFlow CLI

This is a **completed reference example** for the [Workflow Scaffold](link-to-main-repo).

It shows what a project looks like after running through the full workflow:
constitution defined, features specified, tasks planned, decisions recorded.

## What's Included

| Artifact | Purpose |
|----------|---------|
| `.specify/constitution.md` | Project identity, goals, boundaries |
| `specs/001-task-crud.md` | Feature specification with acceptance criteria |
| `tasks/001-task-crud.md` | Task breakdown with model assignments |
| `decisions/0001-sqlite-storage.md` | Architecture decision record |

## The Project: TaskFlow

A fictional Python CLI task manager using SQLite and Click.
Used to demonstrate the workflow scaffold's artifact chain.

## Getting Started with the Scaffold

See the [main workflow repository](link-to-main-repo) for installation and usage.
```

### 2c. Commit and push

```bash
cd workflow-example/
git add -A
git commit -m "feat: initial population from workflow scaffold example"
git push origin main
```

---

## Step 3: Update Main Repo

### 3a. Delete examples/ directory

```bash
rm -rf examples/
```

### 3b. Update README.md

Replace any reference to `examples/sample-project/` with a link to the new repo:

```markdown
## Reference Example

See [workflow-example](https://github.com/ORG/workflow-example) for a completed sample project showing all artifacts.
```

### 3c. Find and update all references to examples/

```bash
grep -ri "examples\|sample.project" README.md docs/ meta-prompts/ template/ --include="*.md" \
  | grep -v "docs/simplification/"
```

Update every hit to reference the new repo URL.

---

## Verification Commands

```bash
# examples/ deleted from main repo
[ -d examples ] && echo "FAIL" || echo "PASS: examples/ deleted"

# No references to examples/ or sample-project
grep -ri "examples/\|sample.project" README.md docs/ meta-prompts/ template/ --include="*.md" \
  | grep -v "docs/simplification/" \
  | grep -v "workflow-example" \
  && echo "FAIL: stale references" || echo "PASS"

# README links to workflow-example
grep -q "workflow-example" README.md && echo "PASS: README links to new repo" || echo "FAIL"

# Verify remote repo exists (requires network)
gh repo view workflow-example --json name 2>/dev/null && echo "PASS: repo exists" || echo "NEEDS VERIFICATION: check GitHub manually"
```

---

## Acceptance Criteria

- [ ] `workflow-example` repository created on GitHub
- [ ] Repository contains: constitution, specs, tasks, decisions, bugs, workflow artifacts
- [ ] Repository has README linking back to main workflow repo
- [ ] `examples/` directory deleted from main repo
- [ ] README.md links to `workflow-example` repository
- [ ] No stale references to `examples/` or `sample-project` in main repo docs
- [ ] All test scripts pass

## Files Summary

- **Deleted from main repo**: `examples/` directory (~6 items)
- **Modified**: `README.md`, any docs that referenced `examples/sample-project/`
- **Created externally**: `workflow-example` GitHub repository
