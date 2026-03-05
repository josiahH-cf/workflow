# Quickstart: First Success (15-Minute Path)

This is the fastest path to complete one feature cycle with the scaffold.

## 1) Install Scaffold

From this repo root:

```bash
./scripts/install.sh --with-meta-prompts /path/to/your/project
```

If you also use Copilot prompts:

```bash
./scripts/install.sh --with-meta-prompts --with-prompts /path/to/your/project
```

## 2) Initialize Identity (Compass)

In your target project root:
- If `meta-prompts/initialization.md` exists, run it.
- Otherwise run `/compass` directly.

Done means:
- `.specify/constitution.md` has no `[PROJECT-SPECIFIC]` placeholders.

## 3) Define One Feature

Run `/define-features` and create exactly one feature spec.

Done means:
- `specs/[feature-id]-[slug].md` exists.

## 4) Scaffold + Fine-Tune

Run `/scaffold`, then `/fine-tune`.

Done means:
- AGENTS Core Commands and Code Conventions are filled.
- `tasks/[feature-id]-[slug].md` exists and maps ACs to tasks.

## 5) Build Deterministically

Run `/continue`.

Expected flow:
1. `/test pre` (failing tests)
2. `/implement` (task-by-task)
3. `/test post` (AC verification)
4. `/review` + `/cross-review` + `/pr-create` + `/merge`

## 6) Maintain

Run `/maintain` to generate/update docs and compliance artifacts.

## Troubleshooting

- If `/continue` loops, check `workflow/STATE.json` and `tasks/*.md`.
- If prompts drift, run `./scripts/sync-prompts.sh` in this repo.
- If setup checks fail, run `./scripts/validate-scaffold.sh` in this repo.
