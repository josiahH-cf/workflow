#!/usr/bin/env bats

load ./helpers.bash

setup() {
  setup_repo_copy
}

teardown() {
  teardown_repo_copy
}

@test "install.sh --dry-run processes all template files" {
  expected_count="$(find "$WORKDIR/template" -type f | wc -l | tr -d ' ')"

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
  [ -f "$WORKDIR/target/workflow/SPECS.md" ]
  # Phase 2 files
  [ -f "$WORKDIR/target/workflow/ORCHESTRATOR.md" ]
  # Phase 4 files
  [ -f "$WORKDIR/target/.github/ISSUE_TEMPLATE/feature.yml" ]
  [ -f "$WORKDIR/target/.github/PULL_REQUEST_TEMPLATE.md" ]
  [ -f "$WORKDIR/target/.github/agents/reviewer.agent.md" ]
  [ -f "$WORKDIR/target/.github/agents/implementer.agent.md" ]
  # Phase 6 files
  [ -f "$WORKDIR/target/workflow/CONCURRENCY.md" ]
  [ -f "$WORKDIR/target/scripts/clash-check.sh" ]
  # Phase 7 files
  [ -f "$WORKDIR/target/.aiignore" ]
}
