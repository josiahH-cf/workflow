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
