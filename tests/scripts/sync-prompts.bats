#!/usr/bin/env bats

load ./helpers.bash

setup() {
  setup_repo_copy
}

teardown() {
  teardown_repo_copy
}

@test "sync-prompts.sh --check reports all drift before exiting" {
  run bash "$WORKDIR/scripts/sync-prompts.sh"
  [ "$status" -eq 0 ]

  printf "manual drift\n" >> "$WORKDIR/template/.claude/commands/plan.md"
  printf "manual drift\n" >> "$WORKDIR/prompts/plan.prompt.md"

  run bash "$WORKDIR/scripts/sync-prompts.sh" --check

  [ "$status" -eq 1 ]
  assert_output_contains "[drift] $WORKDIR/template/.claude/commands/plan.md"
  assert_output_contains "[drift] $WORKDIR/prompts/plan.prompt.md"
  assert_output_contains "--- diff (current vs generated)"
  assert_output_contains "FAIL: 2 file(s) out of sync"
}

@test "sync-prompts.sh --check passes when already in sync" {
  run bash "$WORKDIR/scripts/sync-prompts.sh"
  [ "$status" -eq 0 ]

  run bash "$WORKDIR/scripts/sync-prompts.sh" --check
  [ "$status" -eq 0 ]
  assert_output_contains "OK: All derived prompt files are in sync."
}

@test "sync-prompts.sh --check covers continue command artifacts" {
  run bash "$WORKDIR/scripts/sync-prompts.sh"
  [ "$status" -eq 0 ]

  printf "manual drift\n" >> "$WORKDIR/template/.claude/commands/continue.md"
  printf "manual drift\n" >> "$WORKDIR/prompts/continue.prompt.md"

  run bash "$WORKDIR/scripts/sync-prompts.sh" --check

  [ "$status" -eq 1 ]
  assert_output_contains "[drift] $WORKDIR/template/.claude/commands/continue.md"
  assert_output_contains "[drift] $WORKDIR/prompts/continue.prompt.md"
}
