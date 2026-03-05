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
#   5. Constitution template has all 8 sections
#   6. Prompt-sync parity (Claude commands match Copilot prompts)

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
    ".github/agents/planner.agent.md"
    ".github/agents/reviewer.agent.md"
    ".github/workflows/copilot-setup-steps.yml"
    ".github/workflows/autofix.yml"
    ".claude/settings.json"
    ".codex/AGENTS.md"
    "scripts/policy-check.sh"
    "scripts/setup-worktree.sh"
)

for f in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$TEMPLATE_DIR/$f" ]]; then
        pass "$f exists"
    else
        fail "$f missing"
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

# ─── Check 3: Constitution template has all 8 sections ───
echo "3. Constitution template sections"

constitution="$TEMPLATE_DIR/.specify/constitution.md"
if [[ -f "$constitution" ]]; then
    SECTIONS=(
        "Problem Statement"
        "Target User"
        "Definition of Success"
        "Core Capabilities"
        "Out-of-Scope Boundaries"
        "Inviolable Principles"
        "Security Requirements"
        "Testing Requirements"
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

    # Check Claude -> Copilot
    for name in "${claude_names[@]}"; do
        if [[ -f "$copilot_prompts/$name.prompt.md" ]]; then
            pass "Claude '$name' has matching Copilot prompt"
        else
            warn "Claude '$name' has no matching Copilot prompt"
        fi
    done

    # Check Copilot -> Claude
    for name in "${copilot_names[@]}"; do
        if [[ -f "$claude_cmds/$name.md" ]]; then
            pass "Copilot '$name' has matching Claude command"
        else
            warn "Copilot '$name' has no matching Claude command"
        fi
    done
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
