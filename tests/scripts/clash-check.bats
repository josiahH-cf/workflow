#!/usr/bin/env bats

load ./helpers.bash

setup() {
  setup_repo_copy
}

teardown() {
  teardown_repo_copy
}

@test "clash-check.sh runs without error when no worktrees" {
  cd "$WORKDIR"
  git init -q
  git config user.email "test@test.com"
  git config user.name "Test"
  git commit --allow-empty -m "init" -q
  run bash "$WORKDIR/template/scripts/clash-check.sh"
  [ "$status" -eq 0 ]
}

@test "clash-check.sh supports --json flag" {
  cd "$WORKDIR"
  git init -q
  git config user.email "test@test.com"
  git config user.name "Test"
  git commit --allow-empty -m "init" -q
  run bash "$WORKDIR/template/scripts/clash-check.sh" --json
  [ "$status" -eq 0 ]
}
