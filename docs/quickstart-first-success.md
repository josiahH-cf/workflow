# Quickstart: 5 Commands to First Feature

The fastest path to a complete feature cycle with the scaffold.

```
install → /compass → /define-features → /scaffold → /fine-tune → /continue
                                                          ↕
                                                    /bug (concurrent)
```

## 1) Install Scaffold

From the scaffold repo root:

```bash
./scripts/install.sh /path/to/your/project
```

This installs the template, Copilot prompts, and meta-prompts by default.
For template only: `./scripts/install.sh --minimal /path/to/your/project`

## 2) Define Your Project (Compass)

```bash
cd /path/to/your/project
```

In your AI tool, run `/compass`. The agent conducts a dynamic discovery interview about your project — starting broad and narrowing based on your answers — and produces `.specify/constitution.md`.

Done means:
- `.specify/constitution.md` has no `[PROJECT-SPECIFIC]` placeholders.

## 3) Define One Feature

Run `/define-features` and create exactly one feature spec.

Done means:
- `specs/[feature-id]-[slug].md` exists.

## 4) Plan Architecture + Tasks

Run `/scaffold`, then `/fine-tune`.

Done means:
- `workflow/COMMANDS.md` Core Commands and Code Conventions are filled.
- `tasks/[feature-id]-[slug].md` exists and maps ACs to tasks.

## 5) Build, Test, Review, Ship

Run `/continue`.

Expected flow:
1. Tests written (failing — TDD)
2. Implementation (task-by-task)
3. Test verification (AC pass)
4. Review + ship

`/continue` loops automatically through these steps and pauses at stop gates.

## 6) Maintain

Run `/maintain` to generate/update docs and compliance artifacts.

## Troubleshooting

- If `/continue` loops, check `workflow/STATE.json` and `tasks/*.md`.
- If prompts drift, run `./scripts/sync-prompts.sh` in the scaffold repo.
- If setup checks fail, run `./scripts/validate-scaffold.sh` in the scaffold repo.
- See [workflow/FAILURE_ROUTING.md](../template/workflow/FAILURE_ROUTING.md) for the full failure response matrix.
- See [TROUBLESHOOTING.md](../TROUBLESHOOTING.md) for CI workflow, worktree, and loop issues.
