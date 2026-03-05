# Phase 6: Multi-Agent Concurrency & Drift Detection

**Status:** not-started
**Depends on:** Phase 1 (AGENTS.md decomposition must be complete)
**Parallelizable with:** Phases 3, 4, 5, 7

## Objective

Add pre-write conflict detection, worktree safety enhancements (inventory, cleanup, port isolation), and a comprehensive concurrency reference document to prevent parallel agent work from silently conflicting.

## Rationale

Best practices warn that "two parallel agents create ~1.5× integration work; eight create ~5×." The project has `template/scripts/setup-worktree.sh` but no conflict prevention or drift detection. Agentic drift — "gradual, invisible divergence when parallel autonomous agents encode different assumptions" — is described as the hardest unsolved problem in multi-agent work.

## Context Files to Read First

- `template/scripts/setup-worktree.sh` — Current worktree script (will be enhanced)
- `template/workflow/ROUTING.md` — (from Phase 1) Contains concurrency rules (will be updated)
- `template/AGENTS.md` — Quick Reference table (will add CONCURRENCY.md)
- `building-agents-examples.md` — Search for "worktree", "Clash", "agentic drift", "vertical slice", "interface-contract"

## Steps

### Step 1: Enhance `template/scripts/setup-worktree.sh`

Add new capabilities to the existing script. **Keep all existing functionality intact** — these are additions.

#### 1a. Add `--list` flag

When invoked as `setup-worktree.sh --list`, output an inventory of all active worktrees:
```
Active Worktrees:
  claude-feat-auth-flow    branch: claude/feat-auth-flow    age: 2h    status: clean
  copilot-feat-dashboard   branch: copilot/feat-dashboard   age: 45m   status: 3 modified files
```

Implementation:
```bash
if [[ "${1:-}" == "--list" ]]; then
  echo "Active Worktrees:"
  if [[ -d ".trees" ]]; then
    for dir in .trees/*/; do
      [[ -d "$dir" ]] || continue
      name=$(basename "$dir")
      branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
      # Age calculation from directory creation time
      age_seconds=$(( $(date +%s) - $(stat -c %Y "$dir" 2>/dev/null || stat -f %m "$dir" 2>/dev/null) ))
      if (( age_seconds < 3600 )); then
        age="$((age_seconds / 60))m"
      else
        age="$((age_seconds / 3600))h"
      fi
      # Modified files count
      modified=$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
      if [[ "$modified" == "0" ]]; then
        status="clean"
      else
        status="$modified modified files"
      fi
      printf "  %-30s branch: %-30s age: %-6s status: %s\n" "$name" "$branch" "$age" "$status"
    done
  else
    echo "  (no worktrees)"
  fi
  exit 0
fi
```

#### 1b. Add `--cleanup` flag

When invoked as `setup-worktree.sh --cleanup`, remove worktrees whose branches have been merged to the base branch:
```bash
if [[ "${1:-}" == "--cleanup" ]]; then
  if [[ ! -d ".trees" ]]; then
    echo "No worktrees to clean up."
    exit 0
  fi
  base_branch=$(git rev-parse --abbrev-ref HEAD)
  merged_branches=$(git branch --merged "$base_branch" | sed 's/^[ *]*//')
  cleaned=0
  for dir in .trees/*/; do
    [[ -d "$dir" ]] || continue
    branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || continue)
    if echo "$merged_branches" | grep -qx "$branch"; then
      echo "Removing merged worktree: $(basename "$dir") (branch: $branch)"
      git worktree remove "$dir" --force
      ((cleaned++))
    fi
  done
  echo "Cleaned up $cleaned worktree(s)."
  exit 0
fi
```

#### 1c. Add disk space check before creation

Before `git worktree add`, check available disk space:
```bash
# Check disk space (warn if < 2GB available)
available_kb=$(df -k . | awk 'NR==2 {print $4}')
if (( available_kb < 2097152 )); then
  echo "Warning: Less than 2GB disk space available ($(( available_kb / 1024 ))MB)."
  echo "Worktrees consume significant space. Proceed? (y/N)"
  read -r confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || exit 1
fi
```

#### 1d. Add pre-creation conflict scan

Before creating a worktree, scan existing worktrees for modified files that overlap:
```bash
# Check for file overlap with existing worktrees
if [[ -d ".trees" ]]; then
  for existing_dir in .trees/*/; do
    [[ -d "$existing_dir" ]] || continue
    existing_modified=$(git -C "$existing_dir" diff --name-only 2>/dev/null)
    if [[ -n "$existing_modified" ]]; then
      echo "Note: Worktree $(basename "$existing_dir") has modified files:"
      echo "$existing_modified" | head -5
      echo "Ensure your new task doesn't overlap these files."
    fi
  done
fi
```

### Step 2: Create `template/scripts/clash-check.sh`

Pre-write conflict detection script that simulates three-way merges between all active worktrees.

```bash
#!/usr/bin/env bash
set -euo pipefail

# Clash Check — Pre-write conflict detection for parallel worktrees.
# Simulates three-way merges between all active worktrees to detect conflicts
# before they happen.
#
# Usage: scripts/clash-check.sh [--json]
# Exit code: 0 if no conflicts, 1 if conflicts detected.
#
# Uses `clash` CLI if available, otherwise falls back to git merge-tree simulation.

JSON_OUTPUT=false
if [[ "${1:-}" == "--json" ]]; then
  JSON_OUTPUT=true
fi

# Check if clash CLI is available
if command -v clash &>/dev/null; then
  if $JSON_OUTPUT; then
    clash status --json
  else
    clash status
  fi
  exit $?
fi

# Fallback: git merge-tree simulation
BASE_BRANCH=$(git rev-parse --abbrev-ref HEAD)
BASE_COMMIT=$(git rev-parse HEAD)

conflicts_found=0
conflict_details=()

if [[ ! -d ".trees" ]]; then
  echo "No worktrees found. No conflicts possible."
  exit 0
fi

# Collect all worktree branches
branches=()
for dir in .trees/*/; do
  [[ -d "$dir" ]] || continue
  branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || continue)
  branches+=("$branch")
done

if (( ${#branches[@]} < 2 )); then
  echo "Fewer than 2 active worktrees. No cross-worktree conflicts possible."
  exit 0
fi

# Pairwise conflict check using git merge-tree
for (( i=0; i<${#branches[@]}; i++ )); do
  for (( j=i+1; j<${#branches[@]}; j++ )); do
    branch_a="${branches[$i]}"
    branch_b="${branches[$j]}"

    # Find merge base
    merge_base=$(git merge-base "$branch_a" "$branch_b" 2>/dev/null || echo "$BASE_COMMIT")

    # Simulate merge
    merge_result=$(git merge-tree "$merge_base" "$branch_a" "$branch_b" 2>/dev/null || true)

    if echo "$merge_result" | grep -q "^<<<<<<<"; then
      conflicts_found=1
      conflict_details+=("CONFLICT: $branch_a ↔ $branch_b")
      if ! $JSON_OUTPUT; then
        echo "⚠ CONFLICT detected: $branch_a ↔ $branch_b"
        echo "$merge_result" | grep -A2 "^<<<<<<<"  | head -10
        echo ""
      fi
    fi
  done
done

if $JSON_OUTPUT; then
  echo "{"
  echo "  \"conflicts_found\": $conflicts_found,"
  echo "  \"details\": ["
  for (( k=0; k<${#conflict_details[@]}; k++ )); do
    comma=""
    if (( k < ${#conflict_details[@]} - 1 )); then comma=","; fi
    echo "    \"${conflict_details[$k]}\"$comma"
  done
  echo "  ]"
  echo "}"
fi

if (( conflicts_found )); then
  if ! $JSON_OUTPUT; then
    echo "Conflicts detected. Consider:"
    echo "  1. Rebase one branch onto the other"
    echo "  2. Reassign overlapping tasks to a single agent"
    echo "  3. Define interface contracts to decouple the work"
  fi
  exit 1
else
  if ! $JSON_OUTPUT; then
    echo "No conflicts detected across ${#branches[@]} worktrees."
  fi
  exit 0
fi
```

### Step 3: Create `template/workflow/CONCURRENCY.md`

Comprehensive concurrency safety reference.

```markdown
# Concurrency Safety

Rules and strategies for running multiple agents on the same codebase simultaneously.

## Core Rule

> If two agents need to modify the same file, the split is wrong.

Redesign the task decomposition until each agent has exclusive file ownership.

## Worktree Isolation

Every agent gets an isolated worktree via `scripts/setup-worktree.sh <model> <type> <description>`.

- Directory: `.trees/<model>-<type>-<description>/`
- Branch: `<model>/<type>-<description>`
- Max parallel agents: 3 (configurable in this file)
- Inventory: `scripts/setup-worktree.sh --list`
- Cleanup: `scripts/setup-worktree.sh --cleanup`
- Conflict check: `scripts/clash-check.sh`

## Task Decomposition Strategies

### Strategy 1: Vertical Slice (Preferred)

Each agent builds an entire feature slice (route → controller → validation → tests).
- ✅ No file overlap
- ✅ Each agent is self-contained
- ❌ Requires careful interface design up front

### Strategy 2: Interface Contract

Define API contracts and data types FIRST, then agents code against agreed interfaces independently.
- ✅ Enables true parallel work
- ✅ Single source of truth (types/schemas)
- ❌ Requires freeze on interfaces early

### Strategy 3: Dependency-Graph

Group files by import relationships; assign each group to one agent.
- ✅ Respects natural code boundaries
- ❌ Complex for highly interconnected codebases

### Strategy 4: Role-Based Routing

Use the Agent Routing Matrix in `workflow/ROUTING.md`:
- Claude: complex reasoning, refactoring, bug diagnosis
- Copilot: UI work, documentation, boilerplate
- Codex: batch operations, migrations, CI/CD

## Drift Detection

**Agentic drift**: gradual, invisible divergence when parallel agents encode different assumptions in code that merges cleanly but contains contradictory logic.

### Prevention
- Short integration cycles: merge every few hours, not days
- Pre-write conflict check: `scripts/clash-check.sh` before starting work
- Interface contracts: define types/schemas before implementation
- Vertical slices: minimize shared file surface area

### Detection
- Post-merge, run full test suite (catches behavioral conflicts)
- Review merged code for contradictory patterns
- Track which agents modified which files across branches

## Safety Limits

| Limit | Value | Rationale |
|-------|-------|-----------|
| Max parallel agents | 3 | Integration tax is nonlinear |
| Max worktree age | 24h | Stale worktrees drift |
| Conflict check frequency | Before each commit | Catches overlaps early |
| Integration cycle | Every 4-8 hours | Prevents drift accumulation |

## Runtime Isolation

Worktrees share the host machine. Prevent resource conflicts:

- **Ports**: Allocate unique dev server port per worktree (e.g., base_port + worktree_index)
- **Databases**: Use separate database files per worktree (e.g., `.trees/<name>/dev.db`)
- **Docker**: Use unique container names per worktree
- **Temp files**: Use worktree-specific temp directories
```

### Step 4: Update `template/AGENTS.md` Quick Reference

Add CONCURRENCY.md to the Quick Reference table (from Phase 1):

```markdown
| Concurrency safety, drift detection | `workflow/CONCURRENCY.md` |
```

### Step 5: Update `template/workflow/ROUTING.md`

Add a concurrency-aware section at the end:

```markdown
## Concurrency-Aware Task Assignment

When assigning tasks for parallel execution:

1. Verify no file overlap between tasks (check `Files:` fields in task files)
2. If overlap exists, reassign to a single agent or redesign the split
3. Run `scripts/clash-check.sh` after worktree creation to detect existing conflicts
4. See `workflow/CONCURRENCY.md` for full concurrency safety reference
```

### Step 6: Update `template/governance/REGISTRY.md`

Add new canonical files:
```markdown
| `/workflow/CONCURRENCY.md` | Concurrency safety, drift detection, decomposition strategies | Human maintainer |
```

And in scripts section (if one exists, or add):
```markdown
- `/scripts/clash-check.sh` — Pre-write conflict detection between worktrees
```

## Verification Checklist

- [ ] `template/scripts/setup-worktree.sh` supports `--list` flag showing active worktrees with branch, age, status
- [ ] `template/scripts/setup-worktree.sh` supports `--cleanup` flag removing only merged worktrees
- [ ] `template/scripts/setup-worktree.sh` checks disk space before creation
- [ ] `template/scripts/setup-worktree.sh` scans for file overlap with existing worktrees
- [ ] `template/scripts/clash-check.sh` exists with `--json` flag support
- [ ] `template/scripts/clash-check.sh` uses `clash` CLI if available, falls back to `git merge-tree`
- [ ] `template/scripts/clash-check.sh` exits 1 on conflicts, 0 on clean
- [ ] `template/workflow/CONCURRENCY.md` exists with core rule, strategies, drift detection, safety limits
- [ ] `template/AGENTS.md` Quick Reference includes CONCURRENCY.md
- [ ] `template/workflow/ROUTING.md` has concurrency-aware task assignment section
- [ ] `template/governance/REGISTRY.md` lists CONCURRENCY.md and clash-check.sh
- [ ] All existing `setup-worktree.sh` functionality still works (create worktree with 3 args)

## Completion

When all verification checks pass, update this file:
- Change `**Status:** not-started` to `**Status:** done`
- Add completion timestamp
