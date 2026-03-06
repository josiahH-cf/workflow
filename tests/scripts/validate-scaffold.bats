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

@test "validate-scaffold.sh detects missing ROUTING.md" {
  rm -f "$WORKDIR/template/workflow/ROUTING.md"

  run bash "$WORKDIR/scripts/validate-scaffold.sh" "$WORKDIR/template"
  [ "$status" -eq 1 ]
  assert_output_contains "workflow/ROUTING.md missing"
}

@test "validate-scaffold.sh checks AGENTS.md references" {
  run bash "$WORKDIR/scripts/sync-prompts.sh"
  [ "$status" -eq 0 ]

  run bash "$WORKDIR/scripts/validate-scaffold.sh" "$WORKDIR/template"
  [ "$status" -eq 0 ]
  assert_output_contains "AGENTS.md references ROUTING.md"
}

@test "validate-scaffold.sh fails on hardcoded tool whitelists" {
  run bash "$WORKDIR/scripts/sync-prompts.sh"
  [ "$status" -eq 0 ]

  perl -0pi -e 's/description: Feature implementation specialist following TDD\n/description: Feature implementation specialist following TDD\ntools: [read_file, write_file]\n/' "$WORKDIR/template/.github/agents/implementer.agent.md"

  run bash "$WORKDIR/scripts/validate-scaffold.sh" "$WORKDIR/template"
  [ "$status" -eq 1 ]
  assert_output_contains "$WORKDIR/template/.github/agents/implementer.agent.md hardcodes a tool whitelist"
}

@test "validate-scaffold.sh fails on deprecated prompt mode frontmatter" {
  run bash "$WORKDIR/scripts/sync-prompts.sh"
  [ "$status" -eq 0 ]

  perl -0pi -e 's/^agent: agent$/mode: agent/m' "$WORKDIR/prompts/define-features.prompt.md"

  run bash "$WORKDIR/scripts/validate-scaffold.sh" "$WORKDIR/template"
  [ "$status" -eq 1 ]
  assert_output_contains "$WORKDIR/prompts/define-features.prompt.md uses deprecated mode: frontmatter"
}
