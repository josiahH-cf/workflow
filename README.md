# Agent Workflow Scaffold

Drop-in scaffold for agent-driven development with Claude, Copilot, and Codex.

## What this gives you

- `AGENTS.md` as the canonical routing file
- Workflow + governance docs for execution and policy
- Templates for specs, tasks, and decisions
- Tool adapters for Claude, Copilot, and Codex
- CI and PR templates for validation

## Quick start

1. Download a release ZIP (`scaffold-template.zip`, `scaffold-metaprompts.zip`, or `scaffold-full.zip`).
2. Place it in your project root.
3. Open an AI coding session at the project root.
4. Run [`meta-prompts/initialization.md`](meta-prompts/initialization.md) for setup.
5. Run [`meta-prompts/update.md`](meta-prompts/update.md) for updates.
6. Confirm prompt installation, then type `/` in chat.

## ZIP choices

| ZIP | Includes |
| --- | --- |
| `scaffold-template.zip` | Template scaffold (`AGENTS.md`, `.claude/`, `.github/`, `.codex/`, and templates) |
| `scaffold-metaprompts.zip` | Copilot `.prompt.md` command files |
| `scaffold-full.zip` | Template scaffold + Copilot prompt files |

## Scaffold layout

```text
/template/
  AGENTS.md                          # Canonical entrypoint and policy routing
  /workflow/
    LIFECYCLE.md                     # Lifecycle index
    PLAYBOOK.md                      # Phase execution contract
    FILE_CONTRACTS.md                # Artifact ownership + validation rules
    FAILURE_ROUTING.md               # Retry/escalation paths
  /governance/
    CHANGE_PROTOCOL.md               # Safe instruction-change process
    POLICY_TESTS.md                  # Policy checks mapped to validation
    REGISTRY.md                      # Canonical policy file registry
  /specs/_TEMPLATE.md                # Feature spec template
  /tasks/_TEMPLATE.md                # Task plan + evidence template
  /decisions/_TEMPLATE.md            # Decision record template
  /CLAUDE.md                         # Claude adapter
  /.github/copilot-instructions.md   # Copilot adapter
  /.codex/config.toml                # Codex runtime config
```

Other scaffold files include `.claude/commands/`, issue/PR templates, and workflow YAML under `.github/`.

## Command installation paths

- Linux: `~/.config/Code/User/prompts/`
- macOS: `~/Library/Application Support/Code/User/prompts/`
- Windows: `%APPDATA%/Code/User/prompts/`
- WSL2 + Windows VS Code: `/mnt/c/Users/[WindowsUser]/AppData/Roaming/Code/User/prompts/`
- VS Code Insiders: use `Code - Insiders` in the path
- Cursor: use `Cursor` in the path

## Maintainers

Use [`meta-prompts/prompt-sync.md`](meta-prompts/prompt-sync.md) to keep meta-prompts, Claude commands, and Copilot prompts aligned.
