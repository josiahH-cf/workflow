#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if ! command -v bats >/dev/null 2>&1; then
  echo "Error: bats is required but not installed." >&2
  echo "Install bats and rerun: bats tests/scripts" >&2
  exit 1
fi

cd "$REPO_ROOT"
bats tests/scripts
