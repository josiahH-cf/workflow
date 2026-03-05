#!/usr/bin/env bash
set -euo pipefail

# Sync derived prompt files from canonical meta-prompt sources.
#
# Usage:
#   ./scripts/sync-prompts.sh [--dry-run] [--check]
#
# Options:
#   --dry-run   Show what would change without modifying files
#   --check     Exit with code 1 if any derived file is out of sync (CI mode)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

META_MINOR="$REPO_ROOT/meta-prompts/minor"
META_MAJOR="$REPO_ROOT/meta-prompts/major"
CLAUDE_CMDS="$REPO_ROOT/template/.claude/commands"
COPILOT_PROMPTS="$REPO_ROOT/prompts"

DRY_RUN=false
CHECK_MODE=false
DRIFT_COUNT=0
SYNC_COUNT=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --check)   CHECK_MODE=true; DRY_RUN=true; shift ;;
        -h|--help) sed -n '3,9p' "$0" | sed 's/^# \?//'; exit 0 ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

# Mapping: command-name -> meta-prompt-file (relative to meta-prompts/)
# Commands without a meta-prompt are canonical themselves and skipped.
declare -A COMMAND_TO_META=(
    # V2 phases
    ["compass"]="minor/02-compass.md"
    ["define-features"]="minor/03-define-features.md"
    ["scaffold"]="minor/04-scaffold-project.md"
    ["fine-tune"]="minor/05-fine-tune-plan.md"
    ["implement"]="minor/06-code.md"
    ["test"]="minor/07-test.md"
    ["maintain"]="minor/08-maintain.md"
    # V1 phases
    ["ideate"]="minor/0-ideate.md"
    ["scope"]="minor/1-scope.md"
    ["plan"]="minor/2-plan.md"
    ["execplan"]="minor/2b-execplan.md"
    ["review"]="minor/5-review.md"
    ["cross-review"]="minor/5b-cross-review.md"
    ["pr-create"]="minor/6-pr-create.md"
    ["merge"]="minor/7-merge.md"
    ["fix-prompt"]="minor/fix-prompt.md"
    # Major sessions
    ["plan-session"]="major/01-plan.md"
    ["build-session"]="major/02-build.md"
    ["review-session"]="major/03-review-and-ship.md"
)

# Extract the operational content from a meta-prompt.
# For minor meta-prompts: content inside the fenced ```text ... ``` block.
# For major meta-prompts: content inside the fenced ```text ... ``` block.
# Falls back to full file content (minus front-matter comments) if no fenced block.
extract_operational_block() {
    local file="$1"
    local in_block=false
    local content=""

    while IFS= read -r line; do
        if [[ "$in_block" == true ]]; then
            if [[ "$line" == '```' ]]; then
                echo "$content"
                return 0
            fi
            content+="$line"$'\n'
        elif [[ "$line" == '```text' || "$line" == '```' ]] && [[ "$in_block" == false ]]; then
            # Check if this is the start of the operational block
            in_block=true
        fi
    done < "$file"

    # No fenced block found — return file content minus comment headers
    grep -v '^<!--' "$file" | sed '/^$/N;/^\n$/d'
}

# Extract description from meta-prompt comment
extract_description() {
    local file="$1"
    grep -oP '(?<=<!-- description: ).*(?= -->)' "$file" 2>/dev/null || echo "Workflow command"
}

# Generate the Claude command file content
generate_claude_cmd() {
    local cmd_name="$1"
    local meta_file="$2"
    local meta_rel="${meta_file#$REPO_ROOT/}"

    echo "<!-- role: derived | canonical-source: $meta_rel -->"
    echo "<!-- generated-from-metaprompt -->"
    extract_operational_block "$meta_file"
}

# Generate the Copilot prompt file content
generate_copilot_prompt() {
    local cmd_name="$1"
    local meta_file="$2"
    local meta_rel="${meta_file#$REPO_ROOT/}"
    local description
    description="$(extract_description "$meta_file")"

    # Determine tools needed
    local tools="read_file"
    case "$cmd_name" in
        implement|build-session|bugfix|scaffold|test)
            tools="read_file\n  - create_file\n  - replace_string_in_file\n  - run_in_terminal"
            ;;
        review|cross-review|review-session|scope|plan|ideate|continue|compass|define-features|fine-tune|maintain)
            tools="read_file\n  - create_file\n  - replace_string_in_file\n  - run_in_terminal"
            ;;
        *)
            tools="read_file\n  - create_file\n  - replace_string_in_file\n  - run_in_terminal"
            ;;
    esac

    echo "---"
    echo "mode: agent"
    echo "description: '$description'"
    echo "tools:"
    echo -e "  - $tools"
    echo "---"
    echo "<!-- role: derived | canonical-source: $meta_rel -->"
    echo "<!-- generated-from-metaprompt -->"

    # Add file references for Copilot
    echo ""
    local op_content
    op_content="$(extract_operational_block "$meta_file")"

    # Add AGENTS.md reference if mentioned in content
    if echo "$op_content" | grep -q "AGENTS.md"; then
        echo "[AGENTS.md](../template/AGENTS.md)"
    fi

    # Add workflow references for execution/review commands
    case "$cmd_name" in
        implement|build-session|test|review|cross-review|review-session|continue|maintain)
            echo "[workflow/PLAYBOOK.md](../template/workflow/PLAYBOOK.md)"
            echo "[workflow/FILE_CONTRACTS.md](../template/workflow/FILE_CONTRACTS.md)"
            ;;
    esac

    case "$cmd_name" in
        implement|build-session|bugfix)
            echo "[workflow/FAILURE_ROUTING.md](../template/workflow/FAILURE_ROUTING.md)"
            ;;
    esac

    echo ""

    # Apply input substitutions
    echo "$op_content" | sed \
        -e 's/\$ARGUMENTS/${input:filePath:Provide the path to the spec or task file}/g' \
        -e 's/\$SPEC_PATH/${input:specPath:Path to the spec file}/g' \
        -e 's/\$TASKS_PATH/${input:tasksPath:Path to the task file}/g' \
        -e 's/\$TARGET_BRANCH/${input:targetBranch:Target branch name (e.g., main)}/g'
}

# Check if a file would change
check_drift() {
    local target="$1"
    local new_content="$2"

    if [[ ! -f "$target" ]]; then
        echo "  [new] $target"
        ((DRIFT_COUNT++))
        return
    fi

    local current
    current="$(cat "$target")"
    if [[ "$current" != "$new_content" ]]; then
        echo "  [drift] $target"
        ((DRIFT_COUNT++))
    else
        echo "  [ok] $target"
    fi
}

# Write or report on a file
sync_file() {
    local target="$1"
    local content="$2"

    if [[ "$DRY_RUN" == true ]]; then
        check_drift "$target" "$content"
    else
        mkdir -p "$(dirname "$target")"
        echo "$content" > "$target"
        echo "  [sync] $target"
        ((SYNC_COUNT++))
    fi
}

echo "Syncing derived prompt files from canonical meta-prompts..."
echo ""

for cmd_name in "${!COMMAND_TO_META[@]}"; do
    meta_rel="${COMMAND_TO_META[$cmd_name]}"
    meta_file="$REPO_ROOT/meta-prompts/$meta_rel"

    if [[ ! -f "$meta_file" ]]; then
        echo "  [warn] Meta-prompt not found: $meta_rel (skipping $cmd_name)"
        continue
    fi

    # Generate and sync Claude command
    claude_content="$(generate_claude_cmd "$cmd_name" "$meta_file")"
    sync_file "$CLAUDE_CMDS/$cmd_name.md" "$claude_content"

    # Generate and sync Copilot prompt
    copilot_content="$(generate_copilot_prompt "$cmd_name" "$meta_file")"
    sync_file "$COPILOT_PROMPTS/$cmd_name.prompt.md" "$copilot_content"
done

echo ""
if [[ "$CHECK_MODE" == true ]]; then
    if [[ $DRIFT_COUNT -gt 0 ]]; then
        echo "FAIL: $DRIFT_COUNT file(s) out of sync. Run ./scripts/sync-prompts.sh to fix."
        exit 1
    else
        echo "OK: All derived prompt files are in sync."
    fi
elif [[ "$DRY_RUN" == true ]]; then
    echo "Dry run complete. $DRIFT_COUNT file(s) would change."
else
    echo "Synced $SYNC_COUNT file(s)."
fi
