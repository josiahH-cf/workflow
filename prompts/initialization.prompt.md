---
mode: agent
description: "Initialize project scaffold — place files, configure conventions, start Compass"
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
---
<!-- role: derived | canonical-source: meta-prompts/minor/01-scaffold-import.md -->

# Initialize Project Scaffold

> **Note:** This is the Copilot equivalent of `meta-prompts/initialization.md`. For full step-by-step instructions with all options, read that file. This prompt runs the same workflow interactively.

A scaffold zip archive has been placed in this project directory. Work through the following steps:

## Step 1 — Locate and Extract

Find the scaffold zip (`scaffold-template.zip`, `scaffold-metaprompts.zip`, `scaffold-full.zip`, or custom name). Extract to a temporary location and inspect contents:
- Contains `AGENTS.md` → template content present
- Contains `prompts/` with `.prompt.md` files → Copilot prompt files present
- Contains both → full variant

Report: "Detected ZIP variant: [template-only / metaprompts-only / full]. Proceeding to check for conflicts."

## Step 2 — Place Template Files

For each template file, check for conflicts. If a conflict exists, show a diff and ask: replace, keep existing, or skip? After placing all files, delete the zip and commit: "Initialize project scaffolding".

If the ZIP includes Copilot prompt files (`.prompt.md`), ask if the user wants them installed to the VS Code user prompts directory. Detect the correct path based on OS/editor.

## Step 3 — Customize AGENTS.md

Walk through each `[PROJECT-SPECIFIC]` placeholder in `AGENTS.md`:
- Project name and one-line description
- Build commands: Install, Build, Test (all), Test (single), Lint, Format, Type-check
- Key directories and their responsibilities
- Naming conventions (functions, files)

Present completed AGENTS.md for review. Iterate until confirmed. Commit: "Customize AGENTS.md for this project"

## Step 4 — Configure CI and Settings

- Set `INSTALL_CMD`, `BUILD_CMD`, `LINT_CMD`, `TEST_CMD` in `.github/workflows/copilot-setup-steps.yml`
- Review `.claude/settings.json` permissions and hooks
- Ask about the test command for the session-end reminder hook
- Offer YOLO mode options (see `meta-prompts/initialization.md` STEP 4 for full options)
- Configure `.codex/config.toml` if using Codex

## Step 5 — Verify

Confirm: all expected directories exist, `AGENTS.md` has no remaining placeholders, `.gitignore` includes scaffold entries, all template files are in place.

## Step 6 — Start Compass

If `.specify/constitution.md` is not populated, start the Compass interview to establish project identity. Run the `/compass` prompt or load `compass.prompt.md`.

After Compass completes: "Constitution established. Run `/continue` to advance through remaining phases automatically."
