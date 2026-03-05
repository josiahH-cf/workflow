#!/usr/bin/env bash
set -euo pipefail

# Install the Agent Workflow Scaffold into a target project.
#
# Usage:
#   ./scripts/install.sh [OPTIONS] <target-directory>
#
# Options:
#   --with-prompts           Also copy Copilot .prompt.md files to the target
#   --with-meta-prompts      Also copy meta-prompts/ into the target project root
#   --with-github-templates  Include GitHub Issue templates (.github/ISSUE_TEMPLATE/)
#   --with-github-agents     Include GitHub Copilot agent files (.github/agents/)
#   --with-codex             Include OpenAI Codex files (.codex/)
#   --prompts-dir DIR        Override the Copilot prompts destination (default: auto-detect)
#   --force                  Overwrite existing files without prompting
#   --dry-run                Show what would be copied without doing it
#   -h, --help               Show this help message

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$REPO_ROOT/template"
PROMPTS_DIR="$REPO_ROOT/prompts"

WITH_PROMPTS=false
WITH_META_PROMPTS=false
WITH_GITHUB_TEMPLATES=false
WITH_GITHUB_AGENTS=false
WITH_CODEX=false
PROMPTS_DEST=""
FORCE=false
DRY_RUN=false
TARGET=""

usage() {
    sed -n '3,19p' "$0" | sed 's/^# \?//'
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
        --with-meta-prompts) WITH_META_PROMPTS=true; shift ;;
        --with-github-templates) WITH_GITHUB_TEMPLATES=true; shift ;;
        --with-github-agents) WITH_GITHUB_AGENTS=true; shift ;;
        --with-codex) WITH_CODEX=true; shift ;;
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

# Resolve target to absolute path without shell-chain side effects
if [[ -e "$TARGET" && ! -d "$TARGET" ]]; then
    echo "Error: target exists but is not a directory: $TARGET" >&2
    exit 1
fi

if [[ -d "$TARGET" ]]; then
    TARGET="$(cd "$TARGET" && pwd)"
else
    mkdir -p "$TARGET"
    TARGET="$(cd "$TARGET" && pwd)"
fi

echo "Installing scaffold into: $TARGET"
echo ""

# Build exclusion list for platform-specific directories
EXCLUDE_ARGS=()
if [[ "$WITH_GITHUB_TEMPLATES" != true ]]; then
    EXCLUDE_ARGS+=(-not -path "$TEMPLATE_DIR/.github/ISSUE_TEMPLATE/*")
fi
if [[ "$WITH_GITHUB_AGENTS" != true ]]; then
    EXCLUDE_ARGS+=(-not -path "$TEMPLATE_DIR/.github/agents/*")
fi
if [[ "$WITH_CODEX" != true ]]; then
    EXCLUDE_ARGS+=(-not -path "$TEMPLATE_DIR/.codex/*")
fi

# Copy template files, preserving directory structure
file_count=0
while IFS= read -r -d '' src; do
    rel="${src#$TEMPLATE_DIR/}"
    copy_file "$src" "$TARGET/$rel"
    file_count=$((file_count + 1))
done < <(find "$TEMPLATE_DIR" -type f "${EXCLUDE_ARGS[@]}" -print0)

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
        prompt_count=$((prompt_count + 1))
    done
    echo ""
    echo "Copied $prompt_count prompt files."
fi

# Copy meta-prompts if requested
if [[ "$WITH_META_PROMPTS" == true ]]; then
    META_PROMPTS_DIR="$REPO_ROOT/meta-prompts"
    echo ""
    echo "Installing meta-prompts to: $TARGET/meta-prompts"
    echo ""
    meta_count=0
    while IFS= read -r -d '' src; do
        rel="${src#$META_PROMPTS_DIR/}"
        copy_file "$src" "$TARGET/meta-prompts/$rel"
        meta_count=$((meta_count + 1))
    done < <(find "$META_PROMPTS_DIR" -type f -print0)
    echo ""
    echo "Copied $meta_count meta-prompt files."
fi

echo ""
echo "Done. Next steps:"
echo "  1. cd $TARGET"
HAS_META_PROMPTS=false
if [[ "$WITH_META_PROMPTS" == true ]] || [[ -f "$TARGET/meta-prompts/initialization.md" ]]; then
    HAS_META_PROMPTS=true
fi

if [[ "$HAS_META_PROMPTS" == true ]]; then
    echo "  2. Open an AI session and run meta-prompts/initialization.md"
    echo "  3. Or use /compass, then /continue"
else
    echo "  2. Open an AI session and run /compass to create constitution.md"
    echo "  3. Then run /continue to auto-advance phases"
fi

# Mention platform flags if none were passed
PLATFORM_FLAGS=()
[[ "$WITH_GITHUB_TEMPLATES" != true ]] && PLATFORM_FLAGS+=("--with-github-templates")
[[ "$WITH_GITHUB_AGENTS" != true ]] && PLATFORM_FLAGS+=("--with-github-agents")
[[ "$WITH_CODEX" != true ]] && PLATFORM_FLAGS+=("--with-codex")
if [[ ${#PLATFORM_FLAGS[@]} -gt 0 ]]; then
    echo ""
    echo "Optional: Re-run with ${PLATFORM_FLAGS[*]} for full platform support."
fi
