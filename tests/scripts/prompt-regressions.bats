#!/usr/bin/env bats

load ./helpers.bash

setup() {
  setup_repo_copy
}

teardown() {
  teardown_repo_copy
}

@test "initialization artifacts route fresh, existing, and scaffolded repos" {
  local file

  for file in \
    "$WORKDIR/meta-prompts/admin/initialization.md" \
    "$WORKDIR/prompts/initialization.prompt.md" \
    "$WORKDIR/template/.claude/commands/initialization.md"
  do
    grep -F ".workflow-bootstrap/install-context.json" "$file"
    grep -F "Fresh initialization mode" "$file"
    grep -F "Existing-project injection mode" "$file"
    grep -F "Scaffold-update mode" "$file"
    grep -F '.github/prompts/*.prompt.md' "$file"
  done
}

@test "update prompt is framed as update-workflow command with batched protected review" {
  local file="$WORKDIR/meta-prompts/admin/update.md"

  grep -F "/update-workflow" "$file"
  grep -F "/initialization" "$file"
  grep -F "STEP 6  -  REVIEW PROTECTED FILES IN ONE BATCH" "$file"
  grep -F "By default they will remain untouched" "$file"
}

@test "update-workflow command is discoverable in command maps" {
  grep -F "/update-workflow" "$WORKDIR/template/AGENTS.md"
  grep -F "/update-workflow" "$WORKDIR/template/CLAUDE.md"
  grep -F "/update-workflow" "$WORKDIR/README.md"
  [ -f "$WORKDIR/template/.claude/commands/update-workflow.md" ]
  [ -f "$WORKDIR/prompts/update-workflow.prompt.md" ]
}

@test "initialization delegates to update-workflow in scaffold-update mode" {
  local file="$WORKDIR/meta-prompts/admin/initialization.md"
  grep -F "/update-workflow" "$file"
  grep -F "Delegate to" "$file"
}

@test "review artifacts use the uppercase PR template path" {
  local file

  for file in \
    "$WORKDIR/meta-prompts/phase-7d-review-and-ship.md" \
    "$WORKDIR/prompts/phase-7d-review-session.prompt.md"
  do
    grep -F "/.github/PULL_REQUEST_TEMPLATE.md" "$file"
    if grep -Fq "pull_request_template.md" "$file"; then
      echo "lowercase PR template path still present in $file"
      return 1
    fi
  done
}

@test "primary docs point Phase 1 to initialization" {
  grep -F "/initialization" "$WORKDIR/README.md"
  grep -F "After install, always run \`/initialization\`" "$WORKDIR/README.md"
  grep -F "install → /initialization → /compass" "$WORKDIR/docs/quickstart-first-success.md"
  grep -F "/initialization" "$WORKDIR/template/AGENTS.md"
}

@test "prompt-sync command map covers all sync-prompts commands" {
  local meta="$WORKDIR/meta-prompts/admin/prompt-sync.md"
  local script="$WORKDIR/scripts/sync-prompts.sh"

  # Extract command names from COMMAND_TO_META in sync-prompts.sh
  local cmds
  cmds=$(grep -oP '\["[a-z-]+"\]=' "$script" | head -18 | grep -oP '[a-z-]+' | sort -u)

  for cmd in $cmds; do
    grep -qF "$cmd" "$meta" || {
      echo "Command '$cmd' missing from prompt-sync.md command map"
      return 1
    }
  done
}

@test "CLAUDE.md lists all slash commands from AGENTS.md" {
  local claude="$WORKDIR/template/CLAUDE.md"

  for cmd in initialization update-workflow compass compass-edit define-features \
             scaffold fine-tune implement build-session test review-bot bug bugfix \
             review-session cross-review maintain operationalize continue; do
    grep -qF "/$cmd" "$claude" || {
      echo "Command '/$cmd' missing from CLAUDE.md"
      return 1
    }
  done
}
