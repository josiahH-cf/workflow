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
META_PROMPTS_DIR="$REPO_ROOT/meta-prompts"
STAGING_DIR_NAME=".workflow-bootstrap"
STAGING_SOURCE_DIR_NAME="scaffold"
INSTALL_CONTEXT_FILE_NAME="install-context.json"

MINIMAL=false
WITH_GITHUB_TEMPLATES=false
WITH_GITHUB_AGENTS=false
WITH_CODEX=false
PROMPTS_DEST=""
FORCE=false
DRY_RUN=false
END_OF_OPTIONS=false
TARGET=""
POSITIONAL_ARGS=()
PARSED_OPTION_ARGS=()
KNOWN_OPTION_SEGMENTS=(
    "--minimal"
    "--with-prompts"
    "--with-meta-prompts"
    "--with-github-templates"
    "--with-github-agents"
    "--with-codex"
    "--prompts-dir"
    "--force"
    "--dry-run"
    "-h"
    "--help"
)

usage() {
    sed -n '3,19p' "$0" | sed 's/^# \?//'
    exit 0
}

render_command() {
    local rendered=()
    local arg quoted

    for arg in "$@"; do
        printf -v quoted '%q' "$arg"
        rendered+=("$quoted")
    done

    local IFS=' '
    echo "${rendered[*]}"
}

is_known_option_segment() {
    local candidate="$1"
    local segment

    for segment in "${KNOWN_OPTION_SEGMENTS[@]}"; do
        if [[ "$candidate" == "$segment" ]]; then
            return 0
        fi
    done

    return 1
}

find_suspicious_target_segment() {
    local target="$1"
    local path_segments=()
    local path_segment

    IFS='/' read -r -a path_segments <<< "$target"
    for path_segment in "${path_segments[@]}"; do
        [[ -z "$path_segment" ]] && continue
        if is_known_option_segment "$path_segment"; then
            echo "$path_segment"
            return 0
        fi
    done

    return 1
}

error_suspicious_target() {
    local target="$1"
    local segment="$2"
    local literal_dir_command=("$0" "${PARSED_OPTION_ARGS[@]}" -- "$target")

    echo "Error: target path '$target' contains option-like segment '$segment'." >&2
    echo "This usually means a missing space before the flag." >&2

    if [[ "$(basename -- "$target")" == "$segment" ]]; then
        local parent_target
        local suggested_command

        parent_target="$(dirname -- "$target")"
        suggested_command=("$0" "${PARSED_OPTION_ARGS[@]}" "$segment")
        if [[ "$parent_target" == "." && "$target" == "$segment" ]]; then
            suggested_command+=("<target-directory>")
        else
            suggested_command+=("$parent_target")
        fi

        echo "Did you mean:" >&2
        echo "  $(render_command "${suggested_command[@]}")" >&2
    fi

    echo "If you intentionally want a directory named '$segment', pass the target after '--':" >&2
    echo "  $(render_command "${literal_dir_command[@]}")" >&2
    exit 1
}

copy_file() {
    local src="$1" dest="$2"
    if [[ "$DRY_RUN" == true ]]; then
        return
    fi
    if [[ -f "$dest" && "$FORCE" != true ]]; then
        return
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
}

copy_file_force() {
    local src="$1" dest="$2"
    if [[ "$DRY_RUN" == true ]]; then
        return
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
}

target_is_effectively_empty() {
    local entry

    if [[ ! -d "$TARGET" ]]; then
        return 0
    fi

    while IFS= read -r -d '' entry; do
        case "$(basename "$entry")" in
            .git) continue ;;
            *) return 1 ;;
        esac
    done < <(find "$TARGET" -mindepth 1 -maxdepth 1 -print0)

    return 0
}

target_has_scaffold_markers() {
    [[ -f "$TARGET/workflow/LIFECYCLE.md" ]] \
        || [[ -f "$TARGET/workflow/STATE.json" ]] \
        || [[ -f "$TARGET/.claude/commands/initialization.md" ]] \
        || [[ -f "$TARGET/.specify/spec-template.md" ]] \
        || [[ -f "$TARGET/meta-prompts/admin/initialization.md" ]]
}

ensure_staging_ignored() {
    local gitignore="$TARGET/.gitignore"

    if [[ "$DRY_RUN" == true ]]; then
        return
    fi

    if [[ -f "$gitignore" ]] && grep -Fqx "$STAGING_DIR_NAME/" "$gitignore"; then
        return
    fi

    if [[ -f "$gitignore" ]] && [[ -s "$gitignore" ]]; then
        printf '\n%s\n' "$STAGING_DIR_NAME/" >> "$gitignore"
    else
        printf '%s\n' "$STAGING_DIR_NAME/" >> "$gitignore"
    fi
}

write_install_context() {
    local mode="$1"
    local staged_source_rel="$2"
    local context_dir="$TARGET/$STAGING_DIR_NAME"
    local prompt_dest_value="null"
    local staged_source_value="null"

    if [[ "$DRY_RUN" == true ]]; then
        return
    fi

    mkdir -p "$context_dir"

    if [[ -n "$PROMPTS_DEST" ]]; then
        printf -v prompt_dest_value '"%s"' "$PROMPTS_DEST"
    fi
    if [[ -n "$staged_source_rel" ]]; then
        printf -v staged_source_value '"%s"' "$staged_source_rel"
    fi

    cat > "$context_dir/$INSTALL_CONTEXT_FILE_NAME" <<EOF
{
  "mode": "$mode",
  "target": "$TARGET",
  "stagedSource": $staged_source_value,
  "promptDestination": $prompt_dest_value,
  "minimal": $MINIMAL,
  "withGithubTemplates": $WITH_GITHUB_TEMPLATES,
  "withGithubAgents": $WITH_GITHUB_AGENTS,
  "withCodex": $WITH_CODEX,
  "nextStep": "/initialization"
}
EOF
}

copy_template_tree() {
    local destination_root="$1"
    local count=0
    local src rel

    while IFS= read -r -d '' src; do
        rel="${src#$TEMPLATE_DIR/}"
        copy_file "$src" "$destination_root/$rel"
        count=$((count + 1))
    done < <(find "$TEMPLATE_DIR" -type f "${EXCLUDE_ARGS[@]}" -print0)

    echo "$count"
}

copy_prompt_tree() {
    local destination_root="$1"
    local count=0
    local src
    local prompt_destination="$destination_root/.github/prompts"

    if [[ "$MINIMAL" == true ]]; then
        echo "0"
        return
    fi

    if [[ "${MODE:-}" == "direct-copy" && -n "$PROMPTS_DEST" ]]; then
        prompt_destination="$PROMPTS_DEST"
    fi

    for src in "$PROMPTS_DIR"/*.prompt.md; do
        [[ -f "$src" ]] || continue
        copy_file "$src" "$prompt_destination/$(basename "$src")"
        count=$((count + 1))
    done

    echo "$count"
}

copy_meta_prompt_tree() {
    local destination_root="$1"
    local count=0
    local src rel

    if [[ "$MINIMAL" == true ]]; then
        echo "0"
        return
    fi

    while IFS= read -r -d '' src; do
        rel="${src#$META_PROMPTS_DIR/}"
        copy_file "$src" "$destination_root/meta-prompts/$rel"
        count=$((count + 1))
    done < <(find "$META_PROMPTS_DIR" -type f -print0)

    echo "$count"
}

phase1_prompt_destination() {
    if [[ -n "$PROMPTS_DEST" ]]; then
        echo "$PROMPTS_DEST"
    else
        echo "$TARGET/.github/prompts"
    fi
}

refresh_phase1_entrypoints() {
    local count=0
    local prompt_destination

    # Keep the public /initialization entrypoints current in the project root
    # so staged installs route through the latest Phase 1 router immediately.
    copy_file_force \
        "$TEMPLATE_DIR/.claude/commands/initialization.md" \
        "$TARGET/.claude/commands/initialization.md"
    count=$((count + 1))

    if [[ "$MINIMAL" != true ]]; then
        prompt_destination="$(phase1_prompt_destination)"
        copy_file_force \
            "$PROMPTS_DIR/initialization.prompt.md" \
            "$prompt_destination/initialization.prompt.md"
        copy_file_force \
            "$META_PROMPTS_DIR/admin/initialization.md" \
            "$TARGET/meta-prompts/admin/initialization.md"
        count=$((count + 2))
    fi

    echo "$count"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    if [[ "$END_OF_OPTIONS" == true ]]; then
        POSITIONAL_ARGS+=("$1")
        shift
        continue
    fi

    case "$1" in
        --)
            END_OF_OPTIONS=true
            shift
            ;;
        --minimal)
            MINIMAL=true
            PARSED_OPTION_ARGS+=("$1")
            shift
            ;;
        --with-prompts)
            PARSED_OPTION_ARGS+=("$1")
            shift
            ;;  # no-op, prompts are default now
        --with-meta-prompts)
            PARSED_OPTION_ARGS+=("$1")
            shift
            ;;  # no-op, meta-prompts are default now
        --with-github-templates)
            WITH_GITHUB_TEMPLATES=true
            PARSED_OPTION_ARGS+=("$1")
            shift
            ;;
        --with-github-agents)
            WITH_GITHUB_AGENTS=true
            PARSED_OPTION_ARGS+=("$1")
            shift
            ;;
        --with-codex)
            WITH_CODEX=true
            PARSED_OPTION_ARGS+=("$1")
            shift
            ;;
        --prompts-dir)
            if [[ $# -lt 2 || "$2" == "--" ]]; then
                echo "Error: --prompts-dir requires a directory argument." >&2
                exit 1
            fi
            PROMPTS_DEST="$2"
            PARSED_OPTION_ARGS+=("$1" "$2")
            shift 2
            ;;
        --force)
            FORCE=true
            PARSED_OPTION_ARGS+=("$1")
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            PARSED_OPTION_ARGS+=("$1")
            shift
            ;;
        -h|--help)
            usage
            ;;
        -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

if [[ "${#POSITIONAL_ARGS[@]}" -eq 0 ]]; then
    echo "Error: target directory required." >&2
    echo "Usage: $0 [OPTIONS] <target-directory>" >&2
    exit 1
fi

if [[ "${#POSITIONAL_ARGS[@]}" -gt 1 ]]; then
    echo "Error: exactly one target directory required; got ${#POSITIONAL_ARGS[@]}: $(render_command "${POSITIONAL_ARGS[@]}")" >&2
    exit 1
fi

TARGET="${POSITIONAL_ARGS[0]}"

if [[ "$END_OF_OPTIONS" != true ]]; then
    if suspicious_segment="$(find_suspicious_target_segment "$TARGET")"; then
        error_suspicious_target "$TARGET" "$suspicious_segment"
    fi
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

MODE="direct-copy"
SUMMARY_VERB="copied"
SUMMARY_DETAIL="Scaffold files copied into the project root."
DESTINATION_ROOT="$TARGET"
STAGED_SOURCE_REL=""
if target_has_scaffold_markers; then
    MODE="staged-update"
    SUMMARY_VERB="staged"
    SUMMARY_DETAIL="Existing scaffold detected. A fresh scaffold payload was staged and the root /initialization entrypoints were refreshed."
elif ! target_is_effectively_empty; then
    MODE="staged-existing"
    SUMMARY_VERB="staged"
    SUMMARY_DETAIL="Existing project detected. A scaffold payload was staged and the root /initialization entrypoints were refreshed."
fi

if [[ "$MODE" != "direct-copy" ]]; then
    DESTINATION_ROOT="$TARGET/$STAGING_DIR_NAME/$STAGING_SOURCE_DIR_NAME"
    STAGED_SOURCE_REL="$STAGING_DIR_NAME/$STAGING_SOURCE_DIR_NAME"
    ensure_staging_ignored
    if [[ "$DRY_RUN" != true ]]; then
        rm -rf "$DESTINATION_ROOT"
    fi
fi

if [[ "$MODE" == "direct-copy" && -z "$PROMPTS_DEST" ]]; then
    PROMPTS_DEST="$TARGET/.github/prompts"
fi

template_count="$(copy_template_tree "$DESTINATION_ROOT")"
prompt_count="$(copy_prompt_tree "$DESTINATION_ROOT")"
meta_count="$(copy_meta_prompt_tree "$DESTINATION_ROOT")"
entrypoint_count="0"
if [[ "$MODE" != "direct-copy" ]]; then
    entrypoint_count="$(refresh_phase1_entrypoints)"
fi
write_install_context "$MODE" "$STAGED_SOURCE_REL"

echo "Summary:"
echo "  Mode: $MODE"
echo "  Template files $SUMMARY_VERB: $template_count"
if [[ "$MINIMAL" != true ]]; then
    echo "  Prompt files $SUMMARY_VERB: $prompt_count"
    echo "  Meta-prompts $SUMMARY_VERB: $meta_count"
fi
if [[ "$MODE" != "direct-copy" ]]; then
    echo "  Staging directory: $TARGET/$STAGING_DIR_NAME"
    echo "  Root /initialization entrypoints refreshed: $entrypoint_count"
fi

echo ""
echo "$SUMMARY_DETAIL"
echo ""
echo "Next step:"
echo "  cd $TARGET"
echo "  Run /initialization"
