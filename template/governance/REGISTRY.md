# Canonical Policy Registry

This registry defines the authority and ownership of scaffold policy files.

## Canonical Files

| File | Authority | Owner |
|---|---|---|
| `/AGENTS.md` | Entrypoint and precedence (v2: 10 sections including routing matrix) | Human maintainer |
| `/workflow/LIFECYCLE.md` | Lifecycle index (project-level + feature-level phases) | Human maintainer |
| `/workflow/PLAYBOOK.md` | Phase execution contract (project + feature gates) | Human maintainer |
| `/workflow/FILE_CONTRACTS.md` | Artifact schema and linkage | Human maintainer |
| `/workflow/FAILURE_ROUTING.md` | Failure matrix and escalation | Human maintainer |
| `/governance/CHANGE_PROTOCOL.md` | Policy mutation rules | Human maintainer |
| `/governance/POLICY_TESTS.md` | Validation requirements | Human maintainer |
| `/.specify/constitution.md` | Project identity (from Compass interview) | Compass / Human (via `/compass-edit`) |
| `/.specify/spec-template.md` | Feature spec template | Human maintainer |
| `/.specify/acceptance-criteria-template.md` | AC format reference (EARS + GWT) | Human maintainer |
| `/.github/REVIEW_RUBRIC.md` | Review scoring rubric (6 categories) | Human maintainer |
| `/.github/pull_request_template.md` | PR template (extended with v2 sections) | Human maintainer |
| `/bugs/LOG.md` | Bug tracking log | Any agent (via `/bug`) |

## Adapter Files (Non-Canonical)

- `/CLAUDE.md` — Claude adapter (imports AGENTS.md)
- `/.github/copilot-instructions.md` — Copilot adapter (links to AGENTS.md)
- `/.codex/config.toml` — Codex configuration
- `/.codex/AGENTS.md` — Codex adapter (references ../AGENTS.md)

Adapters may add tool-specific mechanics but must not redefine canonical workflow policy.

## Agent Definition Files

- `/.github/agents/planner.agent.md` — Planning specialist (never writes code)
- `/.github/agents/reviewer.agent.md` — Review specialist (scores against rubric)
- `/.github/agents/reviewer.md` — Legacy v1 reviewer (preserved)

## CI/CD Files

- `/.github/workflows/copilot-setup-steps.yml` — CI validation + spec-existence check
- `/.github/workflows/autofix.yml` — Autofix on CI failure (workflow_run trigger)
