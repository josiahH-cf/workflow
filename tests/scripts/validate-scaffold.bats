#!/usr/bin/env bats

load ./helpers.bash

setup() {
  setup_repo_copy
}

teardown() {
  teardown_repo_copy
}

@test "validate-scaffold.sh passes on healthy scaffold" {
  run bash "$WORKDIR/scripts/sync-prompts.sh"
  [ "$status" -eq 0 ]

  run bash "$WORKDIR/scripts/validate-scaffold.sh" "$WORKDIR/template"
  [ "$status" -eq 0 ]
  assert_output_contains "Results:"
}

@test "validate-scaffold.sh fails when required file is missing" {
  rm -f "$WORKDIR/template/AGENTS.md"

  run bash "$WORKDIR/scripts/validate-scaffold.sh" "$WORKDIR/template"
  [ "$status" -eq 1 ]
  assert_output_contains "AGENTS.md missing"
}
