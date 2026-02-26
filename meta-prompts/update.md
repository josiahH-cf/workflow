# Project Update — Meta-Prompt

Paste this into a coding agent session at the root of a project that was **previously initialized** with the scaffold. A new version of the scaffold ZIP has been placed in the project directory. This meta-prompt will update the project's scaffolding while preserving your customizations.

Works with any of the three ZIP variants: `scaffold-template.zip`, `scaffold-metaprompts.zip`, or `scaffold-full.zip`.

---

```
You are updating an existing project's development scaffolding. This project was previously initialized with a scaffold ZIP — its files are already in place and have been customized. A new version of the scaffold ZIP has been placed in this project directory. Find it.

Work through the following steps in order.

---

STEP 1 — LOCATE, DETECT VARIANT, AND INVENTORY

Find the scaffold zip file in the project directory. The zip may be named scaffold-template.zip, scaffold-metaprompts.zip, scaffold-full.zip, or a custom name.

Extract its contents to a temporary location so you can inspect them before placing anything.

Determine which variant this is by inspecting the contents:
- If it contains AGENTS.md → template content is present.
- If it contains a prompts/ directory with .prompt.md files → metaprompt slash commands are present.
- If it contains both → this is the full variant.

Report: "Detected ZIP variant: [template-only / metaprompts-only / full]. Contents: [N] files."

---

STEP 2 — CLASSIFY FILES AND BUILD UPDATE PLAN

Classify every file in the ZIP into one of three categories:

**Auto-replace (generated/static — safe to overwrite):**
- `.claude/commands/*.md` — generated slash commands
- `workflow/LIFECYCLE.md` — lifecycle reference
- `specs/_TEMPLATE.md`, `tasks/_TEMPLATE.md`, `decisions/_TEMPLATE.md` — blank templates
- `.github/pull_request_template.md` — PR template
- `.github/ISSUE_TEMPLATE/*.md` — issue templates
- `.github/agents/*.md` — GitHub agent definitions
- `.codex/PLANS.md` — ExecPlan template
- `CLAUDE.md` — Claude config (imports AGENTS.md, not customized per-project)
- `CLAUDE.local.md` — only if it is still the default stub
- `.gitignore` — additive entries (will be appended, not replaced)
- `prompts/*.prompt.md` — generated Copilot prompt files

**Protect (customized per-project — never auto-overwrite):**
- `AGENTS.md` — customized with project-specific conventions
- `.claude/settings.json` — customized tool permissions and hooks
- `.claude/settings.local.json` — local Claude override (personal; gitignored)
- `.vscode/settings.json` — local/editor preference overrides (personal)
- `.github/workflows/copilot-setup-steps.yml` — customized CI steps
- `.codex/config.toml` — customized Codex settings
- `.github/copilot-instructions.md` — may have project-specific additions

**Conditional (may or may not be customized):**
- Any file not in the above lists.

Present the update plan as a table:

| File | Category | Action |
|------|----------|--------|
| [file] | Auto-replace | Will overwrite with new version |
| [file] | Protect | Will skip (customized) |
| [file] | New file | Will add (does not exist yet) |

Ask: "Here is the update plan. Auto-replace files will be overwritten. Protected files will be skipped. New files will be added. Proceed?"

Wait for confirmation before continuing.

---

STEP 3 — SHOW CHANGES FOR AUTO-REPLACE FILES

For each auto-replace file that already exists in the project:
1. Compare the existing version with the new version from the ZIP.
2. If they differ, show a brief summary of what changed:
   - Lines added / removed / modified (counts)
   - Key changes in plain language (e.g., "New /ideate command added", "Review command updated with additional checks")
3. If they are identical, note: "[file] — no changes."

Present all changes as a summary report. Ask: "These are the changes that will be applied. Continue with the update?"

Wait for confirmation.

---

STEP 4 — APPLY UPDATES

**Auto-replace files:**
For each auto-replace file:
- If the file exists and differs: overwrite it with the new version.
- If the file exists and is identical: skip silently.
- If the file does not exist: place it.

**.gitignore (special handling):**
- Do not replace the existing .gitignore.
- Check each entry in the new .gitignore. If an entry is missing from the existing .gitignore, append it.
- Report any entries that were added.

**New files:**
Place any files that exist in the ZIP but not in the project.

**Protected files:**
Skip entirely. Do not touch.

After applying all updates, delete the zip archive and any temporary extraction directory.

Commit all changes: "Update project scaffolding to [version or date]"

---

STEP 5 — UPDATE COPILOT PROMPT FILES

If the ZIP contains a prompts/ directory with .prompt.md files:

Ask: "This update includes new Copilot prompt files. Would you like to update the installed prompt files in your VS Code user prompts directory?"

If yes:
1. Detect the VS Code user prompts directory (same logic as initialization):
   - Linux: ~/.config/Code/User/prompts/
   - macOS: ~/Library/Application Support/Code/User/prompts/
   - Windows: $APPDATA/Code/User/prompts/
   - WSL2 with Windows VS Code: /mnt/c/Users/[WindowsUser]/AppData/Roaming/Code/User/prompts/
   - VS Code Insiders: replace `Code` with `Code - Insiders`
   - Cursor: replace `Code` with `Cursor`
2. If multiple editor prompt directories exist, ask which one to target before copying.
3. Copy all .prompt.md files from the prompts/ directory to the detected target directory, overwriting existing versions.
4. Show what was updated:
   - Files replaced (with change summary if possible)
   - New files added
   - Files unchanged

State: "Copilot prompt files updated. Type / in Copilot chat to verify."

If no: skip and note the files can be updated manually later by copying `.prompt.md` files into the editor prompts directory.

---

STEP 6 — REVIEW PROTECTED FILES

For each protected file that exists in both the ZIP and the project:
1. Compare the existing version with the new version from the ZIP.
2. If they differ, show the differences and explain what is new in the template version versus what is project-specific customization:
   - New sections or fields added to the template
   - Changed defaults or instructions
   - Removed sections
3. Ask: "The template version of [file] has changes. Your customized version will NOT be overwritten. Would you like to:
   a) See a side-by-side comparison to manually merge any new sections
   b) Skip — your current version is fine
   c) Replace with the template version (this will lose your customizations)"

Apply only what is explicitly confirmed.

If no protected files have changes, state: "All protected files are up to date — no action needed."

---

STEP 7 — VERIFY

Report the update results:

1. List all files that were updated (auto-replaced).
2. List all new files that were added.
3. List all protected files that were skipped.
4. List any protected files where the user chose to merge or replace.
5. Confirm Copilot prompt files were updated (if applicable).
6. Confirm Claude commands are in place at .claude/commands/.
7. Confirm no template placeholder values were introduced into customized files.
8. Confirm `.claude/settings.json` does not contain `bypassPermissions` or `allowDangerouslySkipPermissions`.
9. Confirm local preference files (`.claude/settings.local.json`, `.vscode/settings.json`) were not overwritten unless explicitly approved.

State: "Scaffolding update complete. All generated files (slash commands, templates, lifecycle docs) have been updated. Your project customizations (AGENTS.md, tool configs) are preserved."
```

