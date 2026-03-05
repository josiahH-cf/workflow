# Phase 7: Tool Configurations

**Status:** not-started
**Depends on:** Phase 1 (AGENTS.md decomposition must be complete)
**Parallelizable with:** Phases 3, 4, 5, 6

## Objective

Create `.aiignore` for file exclusion from AI agents, enhance `.codex/config.toml` with better sandbox config, update `.github/copilot-instructions.md` with session bootstrap, and update `CLAUDE.md` with references to the new modular workflow files.

## Rationale

`.aiignore` prevents agents from touching sensitive files (secrets, governance policy, generated files). Enhanced Codex config improves unattended execution reliability. Better Copilot/Claude instructions ensure agents start every session grounded in project reality.

## Context Files to Read First

- `template/.codex/config.toml` — Current Codex config (will be enhanced)
- `template/CLAUDE.md` — Claude adapter (will be updated with new references)
- `template/workflow/ORCHESTRATOR.md` — (from Phase 2) Session bootstrap contract
- `template/AGENTS.md` — Restructured TOC hub (from Phase 1)
- `building-agents-examples.md` — Search for ".aiignore", "session bootstrap", "deterministic"

**For `.github/copilot-instructions.md`:** check if it exists at the repo root level (not template level). It may be at `/home/josiah/workflow/.github/copilot-instructions.md` (root level for this scaffold repo). The **template** version for consumer projects should be at `template/.github/copilot-instructions.md`. Check which exists and update accordingly.

## Steps

### Step 1: Create `template/.aiignore`

This file tells all AI agents which files to exclude from their context and editing scope. It follows `.gitignore` syntax.

```
# =============================================================================
# .aiignore — Files excluded from AI agent context and editing
# =============================================================================

# Secrets and credentials
.env
.env.*
.env.local
.env.production
config/secrets/
*.pem
*.key
*.p12
*.pfx

# Governance files (require change protocol — see governance/CHANGE_PROTOCOL.md)
governance/

# Orchestrator state (managed by /continue only)
workflow/STATE.json

# Generated and build artifacts
node_modules/
dist/
build/
.next/
__pycache__/
*.pyc
.pytest_cache/
coverage/

# Git internals
.git/

# Worktree isolation directories
.trees/

# IDE and editor files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Lock files (read-only reference, don't modify)
package-lock.json
yarn.lock
pnpm-lock.yaml
poetry.lock
Pipfile.lock
```

### Step 2: Enhance `template/.codex/config.toml`

Update the existing config with better sandbox restrictions and session instructions.

**Add/update the following** (keep existing settings, add new ones):

```toml
#:schema https://developers.openai.com/codex/config-schema.json

# Codex reads AGENTS.md natively. Fallback to CLAUDE.md if absent.
project_doc_fallback_filenames = ["CLAUDE.md"]

# Max bytes from instruction files. Default 32768; raised for larger projects.
project_doc_max_bytes = 65536

# Sandbox: workspace-write allows edits within the project directory.
sandbox_mode = "workspace-write"

# Approval: on-request pauses before commands for interactive use.
# Change to "auto-edit" for fully autonomous execution.
approval_policy = "on-request"

# Model: uncomment to override default.
# model = "gpt-5.3-codex"

[sandbox_workspace_write]
# Enable network for package installs. Set false if dependencies are vendored.
network_access = true

# File exclusion patterns — files Codex should not modify.
# These complement .aiignore and provide Codex-specific enforcement.
exclude_patterns = [
  ".env*",
  "governance/**",
  "workflow/STATE.json",
  "*.pem",
  "*.key",
]
```

**Note:** If `exclude_patterns` is not a supported Codex config key, add it as a comment documenting the intent and reference `.aiignore` instead. Check the Codex config schema.

### Step 3: Update `template/CLAUDE.md`

Add session bootstrap preamble and update references to point to the new modular workflow files from Phase 1.

**Add at the top, after the first line:**
```markdown
## Session Bootstrap

At the start of every session, before any work:
1. Read `AGENTS.md` — project routing and phase navigation
2. Read `workflow/STATE.json` — current project state
3. Read `.specify/constitution.md` — project identity (if it exists)
4. Read the active task file (if `currentTaskFile` is set in state)
5. Read `workflow/ORCHESTRATOR.md` — loop contract for `/continue` sessions

This ensures context is grounded in reality, not memory from previous sessions.
```

**Update any section references** to point to the new modular files:
- References to "Concurrency Rules" in AGENTS.md → `workflow/ROUTING.md` and `workflow/CONCURRENCY.md`
- References to "Branch Naming" → `workflow/ROUTING.md`
- References to "Core Commands" → `workflow/COMMANDS.md`
- References to "Boundaries" → `workflow/BOUNDARIES.md`
- References to "Specification Workflow" → `workflow/SPECS.md`

**Important:** Keep all existing Claude-specific content (Context Discipline, Planning, Testing, Implementation, Scope Discipline, Development Principles, Escalation, Claude-Specific Commands). Only add bootstrap and update cross-references.

### Step 4: Update `.github/copilot-instructions.md`

Find the Copilot instructions file (check both `template/.github/copilot-instructions.md` and root `.github/copilot-instructions.md` — both may need updates).

**Add session bootstrap:**
```markdown
## Session Bootstrap

At the start of every session:
1. Read `AGENTS.md` for project conventions and phase navigation
2. Read `workflow/STATE.json` for current project state
3. If a task is active, read the task file from `/tasks/`

See `workflow/ORCHESTRATOR.md` for the full loop contract.
```

**Add references to new modular files:**
```markdown
## Key References

- Agent routing and branch naming: `workflow/ROUTING.md`
- Build/test/lint commands: `workflow/COMMANDS.md`
- Behavioral boundaries: `workflow/BOUNDARIES.md`
- Specification workflow: `workflow/SPECS.md`
- Concurrency safety: `workflow/CONCURRENCY.md`
- Orchestrator loop: `workflow/ORCHESTRATOR.md`
```

## Verification Checklist

- [ ] `template/.aiignore` exists and covers: `.env*`, `config/secrets/`, `*.pem`, `*.key`, `governance/`, `workflow/STATE.json`, `node_modules/`, `dist/`, `.git/`, `.trees/`
- [ ] `template/.codex/config.toml` has original settings intact plus enhancements (exclude patterns or comments)
- [ ] `template/CLAUDE.md` has Session Bootstrap section at the top
- [ ] `template/CLAUDE.md` references updated to point to modular workflow files (ROUTING.md, COMMANDS.md, BOUNDARIES.md, SPECS.md)
- [ ] `template/CLAUDE.md` retains all existing Claude-specific content (Context Discipline, commands, etc.)
- [ ] Copilot instructions updated with session bootstrap and key references
- [ ] `.aiignore` does not exclude files agents legitimately need (specs, tasks, source code, tests)
- [ ] No sensitive file types are missing from `.aiignore` (check for common credential file extensions)

## Completion

When all verification checks pass, update this file:
- Change `**Status:** not-started` to `**Status:** done`
- Add completion timestamp
