# Agent Workflow Scaffold

Prompt-first scaffolding for AI-assisted development in VS Code or Cursor.

## Core Model

Users should be able to:
1. Download a scaffold ZIP release
2. Place it in a project root
3. Run a workflow prompt in an AI chat session
4. Let the agent perform setup/update work

No shell scripts are required.

## ZIP Variants

| ZIP | Contents | Use When |
|-----|----------|----------|
| `scaffold-template.zip` | Template files only (`AGENTS.md`, `.claude/`, `.github/`, `.codex/`, templates) | You want project scaffolding and Claude slash commands |
| `scaffold-metaprompts.zip` | Copilot `.prompt.md` files only | Your project already has scaffolding and you only want Copilot `/` commands |
| `scaffold-full.zip` | Template files + Copilot `.prompt.md` files | You want both scaffold and Copilot slash commands |

## Quick Start (Outside User)

1. Download the ZIP variant you want from Releases.
2. Place the ZIP in your project root.
3. Open VS Code or Cursor and start an AI coding session at the project root.
4. Paste and run:
   - [`meta-prompts/initialization.md`](meta-prompts/initialization.md) for first-time setup
   - [`meta-prompts/update.md`](meta-prompts/update.md) for updates to an already initialized project
5. Confirm prompt installation when asked. The agent will copy `.prompt.md` files into your editor prompts directory.
6. Type `/` in chat to confirm slash commands are available.

## Prompt Installation Targets

The initialization/update prompts use these target directories:
- Linux: `~/.config/Code/User/prompts/`
- macOS: `~/Library/Application Support/Code/User/prompts/`
- Windows: `%APPDATA%/Code/User/prompts/`
- WSL2 with Windows VS Code: `/mnt/c/Users/[WindowsUser]/AppData/Roaming/Code/User/prompts/`
- VS Code Insiders: replace `Code` with `Code - Insiders`
- Cursor: replace `Code` with `Cursor`

## Commands

### Claude Code

Claude commands are included in scaffold template files under `.claude/commands/`.

### GitHub Copilot

Copilot commands are `.prompt.md` files under `prompts/`. Initialization/update prompts install them into the editor user prompts directory.

### Codex

Codex does not use slash commands. Use `AGENTS.md` + the meta-prompts directly.

## Maintainer Workflow (Prompt-Only)

Use [`meta-prompts/prompt-sync.md`](meta-prompts/prompt-sync.md) to synchronize:
- `meta-prompts/major/*.md` + `meta-prompts/minor/*.md`
- `template/.claude/commands/*.md`
- `prompts/*.prompt.md`

This keeps prompt artifacts aligned without scripts.

## Repository Structure

```
/template/                          — Distributable scaffolding
  .claude/commands/                 — Claude slash commands
  .github/                          — Copilot instructions, PR template, CI, issue templates
  .codex/                           — Codex configuration and ExecPlan template
/prompts/                           — Copilot .prompt.md command files
/meta-prompts/
  initialization.md                 — First-time setup prompt
  update.md                         — Update prompt
  prompt-sync.md                    — Maintainer prompt sync workflow
  major/                            — Consolidated session prompts
  minor/                            — Per-phase prompts
/.github/workflows/
  release-template.yml              — Release workflow producing ZIP variants
/workflow-diagram.svg               — Workflow lifecycle diagram
/Principles for Development Using the Workflow.md
/LICENSE
/README.md
```
