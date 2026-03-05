#!/usr/bin/env bash
set -euo pipefail

# Install the Agent Workflow Scaffold into a target project.
#
# Usage:
#   ./scripts/install.sh [OPTIONS] <target-directory>
#
# Options:
#   --with-prompts    Also copy Copilot .prompt.md files to the target
#   --prompts-dir DIR Override the Copilot prompts destination (default: auto-detect)
#   --force           Overwrite existing files without prompting
#   --dry-run         Show what would be copied without doing it
#   -h, --help        Show this help message

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$REPO_ROOT/template"
PROMPTS_DIR="$REPO_ROOT/prompts"

WITH_PROMPTS=false
PROMPTS_DEST=""
FORCE=false
DRY_RUN=false
TARGET=""

usage() {
    sed -n '3,12p' "$0" | sed 's/^# \?//'
    exit 0
}

detect_prompts_dir() {
    case "$(uname -s)" in
        Linux*)
            if [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/version 2>/dev/null; then
                # WSL2 — try to find Windows VS Code prompts dir
                local win_user
                win_user=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r' || true)
                if [[ -n "$win_user" ]]; then
                    echo "/mnt/c/Users/$win_user/AppData/Roaming/Code/User/prompts"
                    return
                fi
            fi
            echo "${XDG_CONFIG_HOME:-$HOME/.config}/Code/User/prompts"
            ;;
        Darwin*)
            echo "$HOME/Library/Application Support/Code/User/prompts"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "$APPDATA/Code/User/prompts"
            ;;
        *)
            echo "$HOME/.config/Code/User/prompts"
            ;;
    esac
}

copy_file() {
    local src="$1" dest="$2"
    if [[ "$DRY_RUN" == true ]]; then
        echo "  [dry-run] $src -> $dest"
        return
    fi
    if [[ -f "$dest" && "$FORCE" != true ]]; then
        echo "  [skip] $dest (exists, use --force to overwrite)"
        return
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "  [copy] $dest"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --with-prompts) WITH_PROMPTS=true; shift ;;
        --prompts-dir)  PROMPTS_DEST="$2"; shift 2 ;;
        --force)        FORCE=true; shift ;;
        --dry-run)      DRY_RUN=true; shift ;;
        -h|--help)      usage ;;
        -*)             echo "Unknown option: $1" >&2; exit 1 ;;
        *)              TARGET="$1"; shift ;;
    esac
done

if [[ -z "$TARGET" ]]; then
    echo "Error: target directory required." >&2
    echo "Usage: $0 [OPTIONS] <target-directory>" >&2
    exit 1
fi

# Resolve target to absolute path
TARGET="$(cd "$TARGET" 2>/dev/null && pwd || mkdir -p "$TARGET" && cd "$TARGET" && pwd)"

echo "Installing scaffold into: $TARGET"
echo ""

# Copy template files, preserving directory structure
file_count=0
while IFS= read -r -d '' src; do
    rel="${src#$TEMPLATE_DIR/}"
    copy_file "$src" "$TARGET/$rel"
    ((file_count++))
done < <(find "$TEMPLATE_DIR" -type f -print0)

echo ""
echo "Copied $file_count template files."

# Copy Copilot prompts if requested
if [[ "$WITH_PROMPTS" == true ]]; then
    if [[ -z "$PROMPTS_DEST" ]]; then
        PROMPTS_DEST="$(detect_prompts_dir)"
    fi
    echo ""
    echo "Installing Copilot prompts to: $PROMPTS_DEST"
    echo ""
    prompt_count=0
    for src in "$PROMPTS_DIR"/*.prompt.md; do
        [[ -f "$src" ]] || continue
        copy_file "$src" "$PROMPTS_DEST/$(basename "$src")"
        ((prompt_count++))
    done
    echo ""
    echo "Copied $prompt_count prompt files."
fi

echo ""
echo "Done. Next steps:"
echo "  1. cd $TARGET"
echo "  2. Open an AI session and run the initialization meta-prompt"
echo "  3. Or use /continue (Claude) to start the Compass interview"
