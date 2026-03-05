#!/usr/bin/env bash
set -euo pipefail

# Setup a git worktree for parallel agent work.
# Usage: scripts/setup-worktree.sh <model> <type> <description>
# Example: scripts/setup-worktree.sh claude feat auth-flow
#
# Creates: .trees/<model>-<type>-<description>/
# Branch: <model>/<type>-<description>

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <model> <type> <description>"
  echo "  model:       claude | copilot | codex"
  echo "  type:        feat | bug | refactor | chore | docs"
  echo "  description: 2-4 word kebab-case summary"
  echo ""
  echo "Example: $0 claude feat auth-flow"
  exit 1
fi

MODEL="$1"
TYPE="$2"
DESC="$3"

# Validate model
if [[ ! "$MODEL" =~ ^(claude|copilot|codex)$ ]]; then
  echo "Error: model must be claude, copilot, or codex (got: $MODEL)"
  exit 1
fi

# Validate type
if [[ ! "$TYPE" =~ ^(feat|bug|refactor|chore|docs)$ ]]; then
  echo "Error: type must be feat, bug, refactor, chore, or docs (got: $TYPE)"
  exit 1
fi

BRANCH="${MODEL}/${TYPE}-${DESC}"
WORKTREE_DIR=".trees/${MODEL}-${TYPE}-${DESC}"

# Check if worktree already exists
if [[ -d "$WORKTREE_DIR" ]]; then
  echo "Error: worktree already exists at $WORKTREE_DIR"
  exit 1
fi

# Create the worktree directory parent
mkdir -p .trees

# Get the current branch as base
BASE_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Create worktree with new branch
echo "Creating worktree: $WORKTREE_DIR"
echo "Branch: $BRANCH (from $BASE_BRANCH)"
git worktree add -b "$BRANCH" "$WORKTREE_DIR" "$BASE_BRANCH"

# Copy local config files that aren't tracked
for config_file in .claude/settings.local.json .vscode/settings.json; do
  if [[ -f "$config_file" ]]; then
    target_dir="$WORKTREE_DIR/$(dirname "$config_file")"
    mkdir -p "$target_dir"
    cp "$config_file" "$WORKTREE_DIR/$config_file"
    echo "Copied: $config_file"
  fi
done

echo ""
echo "Worktree ready:"
echo "  Directory: $WORKTREE_DIR"
echo "  Branch:    $BRANCH"
echo "  Base:      $BASE_BRANCH"
echo ""
echo "To work in this worktree: cd $WORKTREE_DIR"
echo "To remove when done: git worktree remove $WORKTREE_DIR"
