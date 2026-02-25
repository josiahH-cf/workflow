# Project Initialization — Meta-Prompt

Paste this into a coding agent session at the root of any project where the scaffold zip has been placed.

---

```
You are initializing a project with a standard development scaffolding. A zip archive containing template files has been placed somewhere in this project directory. Find it.

Work through the following steps in order.

---

STEP 1 — LOCATE AND EXTRACT

Find the scaffold zip file in the project directory. Extract its contents to a temporary location so you can inspect them before placing anything.

List every file the zip contains with its intended destination path relative to the project root. Present this list and confirm: "These files will be placed in your project. Proceeding to check for conflicts."

---

STEP 2 — PLACE FILES, RESOLVE CONFLICTS

For each file in the extracted archive:
1. Check whether a file already exists at the target path in the project.
2. If no conflict: place the file silently.
3. If a conflict exists: show a comparison of what differs between the existing file and the template file. Then ask one of the following based on the file type:
   - For additive files (like .gitignore additions): "This file contains additions meant to be appended. Should I append these entries to your existing file, replace it entirely, or skip this file?"
   - For configuration files with placeholder values (like settings.json, config.toml, copilot-setup-steps.yml): "A version of this file already exists. Should I replace it with the template version, keep your existing version, or show a side-by-side so you can decide what to merge?"
   - For all other files: "This file already exists and differs from the template. Replace with template version, keep existing, or skip?"
   Wait for a response before moving to the next file.

After all files are placed:
- Delete the zip archive and any temporary extraction directory.
- Commit all placed files: "Initialize project scaffolding"

---

STEP 3 — CUSTOMIZE PROJECT CONVENTIONS

Open the placed AGENTS.md file. It contains placeholder values that must be filled in for this project. Walk through each placeholder interactively:

**Project section:**
Ask: "What is the project name and a one-line description? What is the primary language or framework?"

**Build section:**
Ask: "What are your project's build steps? I need each of the following — provide the actual values or say 'not applicable' for any that don't apply:"
- Install
- Build
- Test (all)
- Test (single file or case)
- Lint
- Format
- Type-check

**Architecture section:**
Ask: "Describe the key directories in this project and what each one is responsible for. Aim for 5–15 lines mapping directories to responsibilities."

**Conventions section:**
Ask: "What naming conventions does this project use?"
- Functions and variables: (e.g., camelCase, snake_case)
- Files and directories: (e.g., kebab-case, PascalCase)

After receiving answers for each section, update AGENTS.md with the provided values. Present the completed file for review.

Ask: "Does this look correct? Anything to adjust?"
Iterate until confirmed.

Commit: "Customize AGENTS.md for this project"

---

STEP 4 — CUSTOMIZE REMAINING CONFIGURATION

Walk through each of the following files, but only the ones that were placed (skip any that were not placed or were kept as existing versions during conflict resolution):

**.github/workflows/copilot-setup-steps.yml:**
This file contains placeholder setup steps. Using the build steps just provided for AGENTS.md, fill in the actual values for:
- Language runtime setup
- Install step
- Build, lint, and test validation steps
Present the updated file. Ask: "Does this match your CI environment? Adjust anything?"

**.claude/settings.json:**
Review the permissions list. Ask: "These tool permissions will be pre-approved for agent sessions. The current list covers common operations for git, npm, pip, python, node, and file management. Do these match your project's toolchain, or should any be added or removed?"
Also review the hooks section. Ask: "The post-edit hook runs a formatter and the stop hook runs a linter. What are the actual format and lint steps for this project?" (Use the values from AGENTS.md if already provided.)
Update and present for confirmation.

**.codex/config.toml:**
Ask: "Are you using Codex? If yes, review these settings — otherwise I'll leave the defaults and we can move on."
If yes, present the file and ask about model preference and sandbox configuration.
If no, move on.

Commit each file as it is confirmed: "Configure [filename] for this project"

---

STEP 5 — VERIFY

Run a final check:
1. Confirm all expected directories exist: specs/, tasks/, decisions/, workflow/
2. Confirm AGENTS.md has no remaining placeholder brackets (no `[install step]`, `[project name]`, etc.)
3. Confirm .gitignore includes the scaffolding entries (CLAUDE.local.md, .claude/plans/, .trees/)
4. Confirm all template files (specs/_TEMPLATE.md, tasks/_TEMPLATE.md, decisions/_TEMPLATE.md) are in place
5. List any files that still contain placeholder values and ask: "These files still have placeholder values. Would you like to fill them in now, or leave them as templates?"

When everything is verified:
State: "Project scaffolding is in place. All conventions are configured and committed. The project is ready for development."
```
