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
  assert_output_contains "Mode: direct-copy"
  assert_output_contains "Template files copied: $expected_count"
  assert_output_contains "Run /initialization"
}

@test "install.sh copies template, prompts, meta-prompts, and install context for fresh targets" {
  run bash "$WORKDIR/scripts/install.sh" "$WORKDIR/target"

  [ "$status" -eq 0 ]
  [ -f "$WORKDIR/target/AGENTS.md" ]
  [ -f "$WORKDIR/target/meta-prompts/admin/initialization.md" ]
  [ -f "$WORKDIR/target/.github/prompts/phase-2-compass.prompt.md" ]
  [ -f "$WORKDIR/target/.workflow-bootstrap/install-context.json" ]
  assert_output_contains "Mode: direct-copy"
  assert_output_contains "Run /initialization"
}

@test "install.sh --with-prompts --with-meta-prompts still works as no-ops" {
  run bash "$WORKDIR/scripts/install.sh" --with-prompts --with-meta-prompts "$WORKDIR/target"

  [ "$status" -eq 0 ]
  [ -f "$WORKDIR/target/AGENTS.md" ]
  [ -f "$WORKDIR/target/meta-prompts/admin/initialization.md" ]
  [ -f "$WORKDIR/target/.github/prompts/phase-2-compass.prompt.md" ]
}

@test "install.sh --minimal skips prompts and meta-prompts" {
  run bash "$WORKDIR/scripts/install.sh" --minimal "$WORKDIR/target"

  [ "$status" -eq 0 ]
  [ -f "$WORKDIR/target/AGENTS.md" ]
  [ ! -d "$WORKDIR/target/meta-prompts" ]
  [ -f "$WORKDIR/target/.workflow-bootstrap/install-context.json" ]
}

@test "install.sh errors when target path is a file" {
  touch "$WORKDIR/not-a-dir"

  run bash "$WORKDIR/scripts/install.sh" --dry-run "$WORKDIR/not-a-dir"

  [ "$status" -eq 1 ]
  assert_output_contains "target exists but is not a directory"
}

@test "install.sh rejects missing prompts-dir value" {
  run bash "$WORKDIR/scripts/install.sh" --prompts-dir

  [ "$status" -eq 1 ]
  assert_output_contains "--prompts-dir requires a directory argument"
}

@test "install.sh rejects multiple target directories" {
  run bash "$WORKDIR/scripts/install.sh" --dry-run "$WORKDIR/target-a" "$WORKDIR/target-b"

  [ "$status" -eq 1 ]
  assert_output_contains "exactly one target directory required"
}

@test "install.sh rejects target paths that accidentally include a flag segment" {
  run bash "$WORKDIR/scripts/install.sh" --dry-run "$WORKDIR/target/--with-github-templates" --with-github-agents

  [ "$status" -eq 1 ]
  assert_output_contains "contains option-like segment '--with-github-templates'"
  assert_output_contains "Did you mean:"
  assert_output_contains "If you intentionally want a directory named '--with-github-templates', pass the target after '--':"
}

@test "install.sh allows intentional flag-like target paths after --" {
  run bash "$WORKDIR/scripts/install.sh" --minimal -- "$WORKDIR/target/--with-github-templates"

  [ "$status" -eq 0 ]
  [ -f "$WORKDIR/target/--with-github-templates/AGENTS.md" ]
}

@test "install.sh copies new workflow and template files" {
  run bash "$WORKDIR/scripts/install.sh" --prompts-dir "$WORKDIR/prompt-dst" "$WORKDIR/target"
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
  [ -f "$WORKDIR/prompt-dst/phase-2-compass.prompt.md" ]
  # Meta-prompts installed by default
  [ -f "$WORKDIR/target/meta-prompts/admin/initialization.md" ]
  # Platform-specific files excluded by default
  [ ! -f "$WORKDIR/target/.github/ISSUE_TEMPLATE/feature.yml" ]
  [ ! -f "$WORKDIR/target/.github/agents/reviewer.agent.md" ]
  [ ! -f "$WORKDIR/target/.codex/AGENTS.md" ]
}

@test "install.sh stages scaffold into non-empty repos" {
  mkdir -p "$WORKDIR/target"
  printf "existing project\n" > "$WORKDIR/target/README.md"

  run bash "$WORKDIR/scripts/install.sh" "$WORKDIR/target"

  [ "$status" -eq 0 ]
  [ ! -f "$WORKDIR/target/AGENTS.md" ]
  [ -f "$WORKDIR/target/.workflow-bootstrap/scaffold/AGENTS.md" ]
  [ -f "$WORKDIR/target/.workflow-bootstrap/scaffold/meta-prompts/admin/initialization.md" ]
  [ -f "$WORKDIR/target/.workflow-bootstrap/install-context.json" ]
  [ -f "$WORKDIR/target/.claude/commands/initialization.md" ]
  [ -f "$WORKDIR/target/.github/prompts/initialization.prompt.md" ]
  [ -f "$WORKDIR/target/meta-prompts/admin/initialization.md" ]
  [ ! -f "$WORKDIR/target/.github/prompts/phase-2-compass.prompt.md" ]
  [ ! -f "$WORKDIR/target/meta-prompts/admin/update.md" ]
  cmp -s "$WORKDIR/template/.claude/commands/initialization.md" "$WORKDIR/target/.claude/commands/initialization.md"
  cmp -s "$WORKDIR/prompts/initialization.prompt.md" "$WORKDIR/target/.github/prompts/initialization.prompt.md"
  cmp -s "$WORKDIR/meta-prompts/admin/initialization.md" "$WORKDIR/target/meta-prompts/admin/initialization.md"
  grep -Fx ".workflow-bootstrap/" "$WORKDIR/target/.gitignore"
  assert_output_contains "Mode: staged-existing"
  assert_output_contains "Root /initialization entrypoints refreshed: 3"
  assert_output_contains "Run /initialization"
}

@test "install.sh includes platform files with opt-in flags" {
  run bash "$WORKDIR/scripts/install.sh" --minimal --with-github-templates --with-github-agents --with-codex "$WORKDIR/target"
  [ "$status" -eq 0 ]

  [ -f "$WORKDIR/target/.github/ISSUE_TEMPLATE/feature.yml" ]
  [ -f "$WORKDIR/target/.github/agents/reviewer.agent.md" ]
  [ -f "$WORKDIR/target/.github/agents/implementer.agent.md" ]
  [ -f "$WORKDIR/target/.codex/AGENTS.md" ]
}

@test "install.sh stages fresh payload for already scaffolded repos" {
  mkdir -p "$WORKDIR/target/workflow" "$WORKDIR/target/.claude/commands" "$WORKDIR/target/.github/prompts" "$WORKDIR/target/meta-prompts/admin"
  printf "existing scaffold\n" > "$WORKDIR/target/workflow/LIFECYCLE.md"
  printf "existing init\n" > "$WORKDIR/target/.claude/commands/initialization.md"
  printf "existing prompt\n" > "$WORKDIR/target/.github/prompts/initialization.prompt.md"
  printf "existing metaprompt\n" > "$WORKDIR/target/meta-prompts/admin/initialization.md"

  run bash "$WORKDIR/scripts/install.sh" "$WORKDIR/target"

  [ "$status" -eq 0 ]
  [ -f "$WORKDIR/target/workflow/LIFECYCLE.md" ]
  [ -f "$WORKDIR/target/.workflow-bootstrap/scaffold/AGENTS.md" ]
  [ -f "$WORKDIR/target/.workflow-bootstrap/install-context.json" ]
  [ "$(cat "$WORKDIR/target/workflow/LIFECYCLE.md")" = "existing scaffold" ]
  [ ! -f "$WORKDIR/target/.github/prompts/phase-2-compass.prompt.md" ]
  [ ! -f "$WORKDIR/target/meta-prompts/admin/update.md" ]
  cmp -s "$WORKDIR/template/.claude/commands/initialization.md" "$WORKDIR/target/.claude/commands/initialization.md"
  cmp -s "$WORKDIR/prompts/initialization.prompt.md" "$WORKDIR/target/.github/prompts/initialization.prompt.md"
  cmp -s "$WORKDIR/meta-prompts/admin/initialization.md" "$WORKDIR/target/meta-prompts/admin/initialization.md"
  assert_output_contains "Mode: staged-update"
  assert_output_contains "Root /initialization entrypoints refreshed: 3"
  assert_output_contains "Run /initialization"
}

@test "install.sh avoids repetitive overwrite chatter in normal output" {
  run bash "$WORKDIR/scripts/install.sh" "$WORKDIR/target"

  [ "$status" -eq 0 ]
  assert_output_not_contains "use --force to overwrite"
  assert_output_not_contains "[copy]"
  assert_output_not_contains "[skip]"
}
