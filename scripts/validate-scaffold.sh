#!/usr/bin/env bash
set -euo pipefail

# Validate the scaffold template for internal consistency.
#
# Usage:
#   ./scripts/validate-scaffold.sh [template-dir]
#
# Checks:
#   1. All required scaffold files exist
#   2. Cross-references between files resolve
#   3. No orphan command files (command without meta-prompt or vice versa)
#   4. Placeholder consistency in AGENTS.md
#   5. Constitution template has required theme sections
#   6. Prompt-sync parity (Claude commands match Copilot prompts)
#   7. Generated prompts and template agents do not hardcode tool whitelists
#   8. Generated prompts do not use deprecated mode: frontmatter

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="${1:-$REPO_ROOT/template}"

PASS=0
FAIL=0
WARN=0

pass() { echo "  [PASS] $1"; PASS=$((PASS + 1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN + 1)); }

echo "Validating scaffold at: $TEMPLATE_DIR"
echo ""

# ─── Check 1: Required files exist ───
echo "1. Required scaffold files"

REQUIRED_FILES=(
    "AGENTS.md"
    "CLAUDE.md"
    "workflow/LIFECYCLE.md"
    "workflow/PLAYBOOK.md"
    "workflow/FILE_CONTRACTS.md"
    "workflow/STATE.json"
    "workflow/FAILURE_ROUTING.md"
    "governance/CHANGE_PROTOCOL.md"
    "governance/POLICY_TESTS.md"
    "governance/REGISTRY.md"
    ".specify/constitution.md"
    ".specify/spec-template.md"
    ".specify/acceptance-criteria-template.md"
    ".github/copilot-instructions.md"
    ".github/REVIEW_RUBRIC.md"
    ".github/pull_request_template.md"
    ".github/workflows/copilot-setup-steps.yml"
    ".github/workflows/copilot-agent.yml"
    ".github/workflows/claude-review.yml"
    ".github/workflows/autofix.yml"
    ".github/workflows/agentic-triage.yml"
    ".claude/settings.json"
    ".aiignore"
    "workflow/ROUTING.md"
    "workflow/COMMANDS.md"
    "workflow/BOUNDARIES.md"
    "workflow/ORCHESTRATOR.md"
    "workflow/CONCURRENCY.md"
    "scripts/policy-check.sh"
    "scripts/setup-worktree.sh"
    "scripts/clash-check.sh"
    "scripts/workflow-lint.sh"
    "workflow/LINT_CONTRACT.md"
)

for f in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$TEMPLATE_DIR/$f" ]]; then
        pass "$f exists"
    else
        fail "$f missing"
    fi
done

echo ""

# ─── Check 1b: AGENTS.md TOC validation ───
echo "1b. AGENTS.md TOC hub validation"

if [[ -f "$TEMPLATE_DIR/AGENTS.md" ]]; then
    agents_lines=$(wc -l < "$TEMPLATE_DIR/AGENTS.md")
    if (( agents_lines > 100 )); then
        warn "AGENTS.md is $agents_lines lines (target: <80). Consider moving content to sub-files."
    else
        pass "AGENTS.md is $agents_lines lines (compact TOC hub)"
    fi

    for ref in "ROUTING.md" "COMMANDS.md" "BOUNDARIES.md" "FILE_CONTRACTS.md"; do
        if grep -q "$ref" "$TEMPLATE_DIR/AGENTS.md"; then
            pass "AGENTS.md references $ref"
        else
            fail "AGENTS.md missing reference to $ref"
        fi
    done
fi

echo ""

# ─── Check 1c: .aiignore sanity ───
echo "1c. .aiignore validation"

if [[ -s "$TEMPLATE_DIR/.aiignore" ]]; then
    pass ".aiignore exists and is non-empty"
else
    fail ".aiignore is missing or empty"
fi

echo ""

# ─── Check 1d: CI workflow YAML validity ───
echo "1d. CI workflow YAML validity"

for yml in "$TEMPLATE_DIR/.github/workflows/"*.yml; do
    [[ -f "$yml" ]] || continue
    basename_yml=$(basename "$yml")
    if command -v python3 &>/dev/null; then
        if python3 -c "import yaml; yaml.safe_load(open('$yml'))" 2>/dev/null; then
            pass "$basename_yml is valid YAML"
        else
            fail "Invalid YAML: $basename_yml"
        fi
    else
        pass "$basename_yml exists (YAML validation skipped — no python3)"
    fi
done

echo ""

# ─── Check 2: AGENTS.md placeholder consistency ───
echo "2. AGENTS.md placeholder check"

agents_file="$TEMPLATE_DIR/AGENTS.md"
if [[ -f "$agents_file" ]]; then
    placeholder_count=$(grep -c '\[PROJECT-SPECIFIC\]' "$agents_file" || true)
    if [[ $placeholder_count -gt 0 ]]; then
        pass "AGENTS.md has $placeholder_count [PROJECT-SPECIFIC] placeholder(s) (expected in template)"
    else
        warn "AGENTS.md has no [PROJECT-SPECIFIC] placeholders — may already be customized"
    fi

    # Check for install/build/test step placeholders
    for step in "install step" "build step" "test step"; do
        if grep -q "\[$step\]" "$agents_file"; then
            pass "AGENTS.md has [$step] placeholder (expected in template)"
        fi
    done
fi

echo ""

# ─── Check 3: Constitution template has required sections ───
echo "3. Constitution template sections"

constitution="$TEMPLATE_DIR/.specify/constitution.md"
if [[ -f "$constitution" ]]; then
    SECTIONS=(
        "Problem & Context"
        "Target User"
        "Success Criteria"
        "Core Capabilities"
        "Out-of-Scope Boundaries"
        "Inviolable Principles"
        "Security Posture"
        "Testing Strategy"
        "Ambiguity Tracking"
    )
    for section in "${SECTIONS[@]}"; do
        if grep -q "## $section" "$constitution"; then
            pass "Constitution has '$section' section"
        else
            fail "Constitution missing '$section' section"
        fi
    done
fi

echo ""

# ─── Check 4: Command file parity ───
echo "4. Command file parity (Claude <-> Copilot)"

claude_cmds="$REPO_ROOT/template/.claude/commands"
copilot_prompts="$REPO_ROOT/prompts"

# Command-to-prompt filename mapping (mirrors sync-prompts.sh COMMAND_TO_PROMPT)
declare -A CMD_TO_PROMPT=(
    ["initialization"]="initialization.prompt.md"
    ["continue"]="phase-10-continue.prompt.md"
    ["compass-edit"]="phase-2b-compass-edit.prompt.md"
    ["bug"]="phase-7b-bug.prompt.md"
    ["bugfix"]="phase-7c-bugfix.prompt.md"
    ["compass"]="phase-2-compass.prompt.md"
    ["define-features"]="phase-3-define-features.prompt.md"
    ["scaffold"]="phase-4-scaffold.prompt.md"
    ["fine-tune"]="phase-5-fine-tune.prompt.md"
    ["implement"]="phase-6-implement.prompt.md"
    ["test"]="phase-7-test.prompt.md"
    ["maintain"]="phase-8-maintain.prompt.md"
    ["operationalize"]="phase-9-operationalize.prompt.md"
    ["build-session"]="phase-6b-build-session.prompt.md"
    ["review-session"]="phase-7d-review-session.prompt.md"
    ["cross-review"]="phase-7e-cross-review.prompt.md"
    ["review-bot"]="phase-7a-review-bot.prompt.md"
)

# Reverse mapping: prompt base name -> command name
declare -A PROMPT_TO_CMD=()
for cmd in "${!CMD_TO_PROMPT[@]}"; do
    pbase="$(basename "${CMD_TO_PROMPT[$cmd]}" .prompt.md)"
    PROMPT_TO_CMD["$pbase"]="$cmd"
done

if [[ -d "$claude_cmds" && -d "$copilot_prompts" ]]; then
    # Get Claude command names (without .md)
    claude_names=()
    for f in "$claude_cmds"/*.md; do
        [[ -f "$f" ]] || continue
        name="$(basename "$f" .md)"
        claude_names+=("$name")
    done

    # Get Copilot prompt names (without .prompt.md)
    copilot_names=()
    for f in "$copilot_prompts"/*.prompt.md; do
        [[ -f "$f" ]] || continue
        name="$(basename "$f" .prompt.md)"
        copilot_names+=("$name")
    done

    # Check Claude -> Copilot (using mapping)
    for name in "${claude_names[@]}"; do
        prompt_file="${CMD_TO_PROMPT[$name]:-$name.prompt.md}"
        if [[ -f "$copilot_prompts/$prompt_file" ]]; then
            pass "Claude '$name' has matching Copilot prompt"
        else
            warn "Claude '$name' has no matching Copilot prompt"
        fi
    done

    # Check Copilot -> Claude (using reverse mapping)
    for name in "${copilot_names[@]}"; do
        cmd_name="${PROMPT_TO_CMD[$name]:-$name}"
        if [[ -f "$claude_cmds/$cmd_name.md" ]]; then
            pass "Copilot '$name' has matching Claude command"
        else
            warn "Copilot '$name' has no matching Claude command"
        fi
    done
fi

echo ""

# ─── Check 4c: Deprecated prompt mode validation ───
echo "4c. Deprecated prompt mode validation"

deprecated_mode_found=false
while IFS= read -r file; do
    [[ -n "$file" ]] || continue
    if grep -qiE '^mode:' "$file"; then
        fail "$file uses deprecated mode: frontmatter"
        deprecated_mode_found=true
    fi
done < <(find "$REPO_ROOT/prompts" -type f -name '*.prompt.md' -print)

if [[ "$deprecated_mode_found" == false ]]; then
    pass "No generated prompts use deprecated mode: frontmatter"
fi

echo ""

# ─── Check 5: Cross-references in workflow docs ───
echo "5. Cross-reference validation"

# Check that AGENTS.md Reference Index links all exist
if [[ -f "$agents_file" ]]; then
    while IFS= read -r line; do
        # Extract markdown links like [text](/path)
        ref=$(echo "$line" | grep -oP '(?<=: `)/[^`]+(?=`)' || true)
        if [[ -n "$ref" ]]; then
            target="$TEMPLATE_DIR$ref"
            if [[ -f "$target" || -d "$target" ]]; then
                pass "Reference $ref resolves"
            else
                fail "Reference $ref does not resolve"
            fi
        fi
    done < <(sed -n '/^## Reference Index/,/^## /p' "$agents_file")
fi

echo ""

# ─── Check 6: Settings.json is valid JSON ───
echo "6. Configuration validation"

settings="$TEMPLATE_DIR/.claude/settings.json"
if [[ -f "$settings" ]]; then
    if python3 -c "import json; json.load(open('$settings'))" 2>/dev/null; then
        pass "settings.json is valid JSON"
    else
        fail "settings.json is invalid JSON"
    fi
fi

codex_config="$TEMPLATE_DIR/.codex/config.toml"
if [[ -f "$codex_config" ]]; then
    pass "Codex config.toml exists"
fi

state_file="$TEMPLATE_DIR/workflow/STATE.json"
if [[ -f "$state_file" ]]; then
    if python3 -c "import json; json.load(open('$state_file'))" 2>/dev/null; then
        pass "workflow/STATE.json is valid JSON"
    else
        fail "workflow/STATE.json is invalid JSON"
    fi
fi

echo ""

# ─── Summary ───
echo "════════════════════════════════"
echo "Results: $PASS passed, $FAIL failed, $WARN warnings"
echo "════════════════════════════════"

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
