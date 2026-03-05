setup_repo_copy() {
  REPO_SRC="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  WORKDIR="$(mktemp -d)"

  cp -R "$REPO_SRC/scripts" "$WORKDIR/"
  cp -R "$REPO_SRC/template" "$WORKDIR/"
  cp -R "$REPO_SRC/prompts" "$WORKDIR/"
  cp -R "$REPO_SRC/meta-prompts" "$WORKDIR/"
}

teardown_repo_copy() {
  if [[ -n "${WORKDIR:-}" && -d "$WORKDIR" ]]; then
    rm -rf "$WORKDIR"
  fi
}

assert_output_contains() {
  local needle="$1"
  if [[ "$output" != *"$needle"* ]]; then
    echo "Expected output to contain: $needle"
    echo "Actual output:"
    echo "$output"
    return 1
  fi
}
