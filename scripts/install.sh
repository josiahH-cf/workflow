#!/usr/bin/env bash
set -euo pipefail

# Install the Agent Workflow Scaffold into a target project.
#
# Usage:
#   ./scripts/install.sh [OPTIONS] <target-directory>
#
# Options:
#   --minimal                Install template only (no prompts or meta-prompts)
#   --with-github-templates  Include GitHub Issue templates (.github/ISSUE_TEMPLATE/)
#   --with-github-agents     Include GitHub Copilot agent files (.github/agents/)
#   --with-codex             Include OpenAI Codex files (.codex/)
#   --prompts-dir DIR        Override Copilot prompts destination (default: <target>/.github/prompts)
#   --force                  Overwrite existing files without prompting
#   --dry-run                Show what would be copied without doing it
#   -h, --help               Show this help message

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$REPO_ROOT/template"
PROMPTS_DIR="$REPO_ROOT/prompts"

MINIMAL=false
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
        --minimal)      MINIMAL=true; shift ;;
        --with-prompts) shift ;;  # no-op, prompts are default now
        --with-meta-prompts) shift ;;  # no-op, meta-prompts are default now
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

# Copy Copilot prompts into .github/prompts/ (default unless --minimal)
# VS Code discovers .prompt.md files from .github/prompts/ in the workspace.
if [[ "$MINIMAL" != true ]]; then
    if [[ -z "$PROMPTS_DEST" ]]; then
        PROMPTS_DEST="$TARGET/.github/prompts"
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

# Copy meta-prompts (default unless --minimal)
if [[ "$MINIMAL" != true ]]; then
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

# Post-install validation
echo ""
missing=0
for f in AGENTS.md CLAUDE.md workflow/STATE.json workflow/LIFECYCLE.md; do
    if [[ "$DRY_RUN" != true ]] && [[ ! -f "$TARGET/$f" ]]; then
        echo "WARNING: Missing $f"
        missing=$((missing + 1))
    fi
done
if [[ "$missing" -eq 0 && "$DRY_RUN" != true ]]; then
    echo "All critical files verified."
fi

# Platform-specific next steps
echo ""
echo "✓ Scaffold installed to $TARGET"
echo ""
echo "Next steps:"
echo "  cd $TARGET"
echo ""
echo "  Copilot (VS Code):  Type /compass in Copilot Chat"
echo "  Claude Code:         Run /compass"
echo "  Codex:               Reference meta-prompts/02-compass.md"
echo ""
echo "Then: /define-features → /scaffold → /fine-tune → /continue"

# Mention platform flags if none were passed
PLATFORM_FLAGS=()
[[ "$WITH_GITHUB_TEMPLATES" != true ]] && PLATFORM_FLAGS+=("--with-github-templates")
[[ "$WITH_GITHUB_AGENTS" != true ]] && PLATFORM_FLAGS+=("--with-github-agents")
[[ "$WITH_CODEX" != true ]] && PLATFORM_FLAGS+=("--with-codex")
if [[ ${#PLATFORM_FLAGS[@]} -gt 0 ]]; then
    echo ""
    echo "Optional: Re-run with ${PLATFORM_FLAGS[*]} for full platform support."
fi
