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

  printf "manual drift\n" >> "$WORKDIR/template/.claude/commands/compass.md"
  printf "manual drift\n" >> "$WORKDIR/prompts/phase-2-compass.prompt.md"

  run bash "$WORKDIR/scripts/sync-prompts.sh" --check

  [ "$status" -eq 1 ]
  assert_output_contains "[drift] $WORKDIR/template/.claude/commands/compass.md"
  assert_output_contains "[drift] $WORKDIR/prompts/phase-2-compass.prompt.md"
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
  printf "manual drift\n" >> "$WORKDIR/prompts/phase-9-continue.prompt.md"

  run bash "$WORKDIR/scripts/sync-prompts.sh" --check

  [ "$status" -eq 1 ]
  assert_output_contains "[drift] $WORKDIR/template/.claude/commands/continue.md"
  assert_output_contains "[drift] $WORKDIR/prompts/phase-9-continue.prompt.md"
}

@test "build-session meta-prompt exists" {
  [ -f "$WORKDIR/meta-prompts/phase-6b-build-session.md" ]
}

@test "sync-prompts.sh generates build-session prompt" {
  run bash "$WORKDIR/scripts/sync-prompts.sh"
  [ "$status" -eq 0 ]

  [ -f "$WORKDIR/prompts/phase-6b-build-session.prompt.md" ]
  [ -f "$WORKDIR/template/.claude/commands/build-session.md" ]
}

@test "sync-prompts.sh generates prompts with agent frontmatter" {
  run bash "$WORKDIR/scripts/sync-prompts.sh"
  [ "$status" -eq 0 ]

  run grep -n "^agent: agent$" "$WORKDIR/prompts/phase-3-define-features.prompt.md"
  [ "$status" -eq 0 ]

  run grep -n "^mode:" "$WORKDIR/prompts/phase-3-define-features.prompt.md"
  [ "$status" -eq 1 ]
}

@test "sync-prompts.sh fails if a prompt uses deprecated mode frontmatter" {
  run bash "$WORKDIR/scripts/sync-prompts.sh"
  [ "$status" -eq 0 ]

  perl -0pi -e 's/^agent: agent$/mode: agent/m' "$WORKDIR/prompts/phase-3-define-features.prompt.md"

  run bash "$WORKDIR/scripts/sync-prompts.sh" --check

  [ "$status" -eq 1 ]
  assert_output_contains "Deprecated prompt mode header found: $WORKDIR/prompts/phase-3-define-features.prompt.md"
}
