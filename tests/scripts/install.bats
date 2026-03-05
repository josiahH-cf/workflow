#!/usr/bin/env bats

load ./helpers.bash

setup() {
  setup_repo_copy
}

teardown() {
  teardown_repo_copy
}

@test "install.sh --dry-run processes all template files" {
  # Default install excludes platform-specific directories
  expected_count="$(find "$WORKDIR/template" -type f \
    -not -path "$WORKDIR/template/.github/ISSUE_TEMPLATE/*" \
    -not -path "$WORKDIR/template/.github/agents/*" \
    -not -path "$WORKDIR/template/.codex/*" \
    | wc -l | tr -d ' ')"

  run bash "$WORKDIR/scripts/install.sh" --dry-run "$WORKDIR/target"

  [ "$status" -eq 0 ]
  assert_output_contains "Copied $expected_count template files."
}

@test "install.sh copies template, prompts, and meta-prompts when requested" {
  run bash "$WORKDIR/scripts/install.sh" --with-prompts --prompts-dir "$WORKDIR/prompt-dst" --with-meta-prompts "$WORKDIR/target"

  [ "$status" -eq 0 ]
  [ -f "$WORKDIR/target/AGENTS.md" ]
  [ -f "$WORKDIR/target/meta-prompts/initialization.md" ]
  [ -f "$WORKDIR/prompt-dst/compass.prompt.md" ]
}

@test "install.sh errors when target path is a file" {
  touch "$WORKDIR/not-a-dir"

  run bash "$WORKDIR/scripts/install.sh" --dry-run "$WORKDIR/not-a-dir"

  [ "$status" -eq 1 ]
  assert_output_contains "target exists but is not a directory"
}

@test "install.sh copies new workflow and template files" {
  run bash "$WORKDIR/scripts/install.sh" "$WORKDIR/target"
  [ "$status" -eq 0 ]

  # Phase 1 files
  [ -f "$WORKDIR/target/workflow/ROUTING.md" ]
  [ -f "$WORKDIR/target/workflow/COMMANDS.md" ]
  [ -f "$WORKDIR/target/workflow/BOUNDARIES.md" ]
  # Phase 2 files
  [ -f "$WORKDIR/target/workflow/ORCHESTRATOR.md" ]
  # Core files
  [ -f "$WORKDIR/target/.github/PULL_REQUEST_TEMPLATE.md" ]
  [ -f "$WORKDIR/target/workflow/CONCURRENCY.md" ]
  [ -f "$WORKDIR/target/scripts/clash-check.sh" ]
  [ -f "$WORKDIR/target/.aiignore" ]
  # Platform-specific files excluded by default
  [ ! -f "$WORKDIR/target/.github/ISSUE_TEMPLATE/feature.yml" ]
  [ ! -f "$WORKDIR/target/.github/agents/reviewer.agent.md" ]
  [ ! -f "$WORKDIR/target/.codex/AGENTS.md" ]
}

@test "install.sh includes platform files with opt-in flags" {
  run bash "$WORKDIR/scripts/install.sh" --with-github-templates --with-github-agents --with-codex "$WORKDIR/target"
  [ "$status" -eq 0 ]

  [ -f "$WORKDIR/target/.github/ISSUE_TEMPLATE/feature.yml" ]
  [ -f "$WORKDIR/target/.github/agents/reviewer.agent.md" ]
  [ -f "$WORKDIR/target/.github/agents/implementer.agent.md" ]
  [ -f "$WORKDIR/target/.codex/AGENTS.md" ]
}
