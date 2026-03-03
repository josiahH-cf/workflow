# Canonical Policy Registry

This registry defines the authority and ownership of scaffold policy files.

## Canonical Files

| File | Authority | Owner |
|---|---|---|
| `/AGENTS.md` | Entrypoint and precedence | Human maintainer |
| `/workflow/LIFECYCLE.md` | Lifecycle index | Human maintainer |
| `/workflow/PLAYBOOK.md` | Phase execution contract | Human maintainer |
| `/workflow/FILE_CONTRACTS.md` | Artifact schema and linkage | Human maintainer |
| `/workflow/FAILURE_ROUTING.md` | Failure matrix and escalation | Human maintainer |
| `/governance/CHANGE_PROTOCOL.md` | Policy mutation rules | Human maintainer |
| `/governance/POLICY_TESTS.md` | Validation requirements | Human maintainer |

## Adapter Files (Non-Canonical)

- `/CLAUDE.md`
- `/.github/copilot-instructions.md`
- `/.codex/config.toml`

Adapters may add tool-specific mechanics but must not redefine canonical workflow policy.
