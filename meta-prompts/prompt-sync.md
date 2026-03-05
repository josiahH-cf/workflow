# Prompt Sync  -  Meta-Prompt

Paste this into a coding agent session at the root of this repository whenever prompt files need to be synchronized.

---

```text
You are maintaining prompt artifacts for this repository.

Your job is to keep these three sources consistent:
- Meta-prompts: /meta-prompts/*.md
- Claude command files: /template/.claude/commands/*.md
- Copilot prompt files: /prompts/*.prompt.md

Canonical maintainer path is script-based sync (`./scripts/sync-prompts.sh`). If script execution is unavailable, you may apply the same logic manually by editing files.

STEP 1  -  INVENTORY
1. List all slash-command names from meta-prompts by reading:
   - <!-- slash-command: ... --> or <!-- phase: ... -->
   - <!-- description: ... -->
2. List command files in:
   - /template/.claude/commands/
   - /prompts/
3. Confirm parity using the cross-platform command mapping:

   Cross-Platform Command Map:
   | Phase | Claude Command | Copilot Prompt | Meta-Prompt |
   |-------|---------------|----------------|-------------|
   | 1 | initialization.md | initialization.prompt.md | initialization.md |
   | 2 | compass.md | compass.prompt.md | 02-compass.md |
   | 2 | compass-edit.md | compass-edit.prompt.md | 02b-compass-edit.md |
   | 3 | define-features.md | define-features.prompt.md | 03-define-features.md |
   | 4 | scaffold.md | scaffold.prompt.md | 04-scaffold-project.md |
   | 5 | fine-tune.md | fine-tune.prompt.md | 05-fine-tune-plan.md |
   | 6 | implement.md | implement.prompt.md | 06-code.md |
   | 6 | build-session.md | build-session.prompt.md | 06b-build-session.md |
   | 7 | test.md | test.prompt.md | 07-test.md |
   | 7 | bug.md | bug.prompt.md | 07b-bug.md |
   | 7 | bugfix.md | bugfix.prompt.md | 07c-bugfix.md |
   | 7 | review-session.md | review-session.prompt.md | 07d-review-and-ship.md |
   | 7 | cross-review.md | cross-review.prompt.md | 07e-cross-review.md |
   | 8 | maintain.md | maintain.prompt.md | 08-maintain.md |
   | Orchestrator | continue.md | continue.prompt.md | 09-continue.md |

4. Report parity:
   - Every command with a Copilot equivalent has both files present.
   - All commands now have Copilot prompt equivalents.
   - No orphan generated outputs without a source.

STEP 2  -  DIFF VALIDATION
Before regenerating, for each file that will be updated:
1. Read the current file content.
2. Compare with what the meta-prompt would generate.
3. If the current file has been manually edited (no <!-- generated-from-metaprompt --> marker OR content diverges significantly from meta-prompt), flag it:
   - "MANUAL EDIT DETECTED: [file] — last synced content differs from current. Overwrite? (yes/skip)"
4. Only overwrite files that are confirmed as auto-generated or explicitly approved.

STEP 3  -  REGENERATE (SCRIPT-FIRST)
Run `./scripts/sync-prompts.sh` to regenerate derived files. If script execution is unavailable, regenerate manually using the rules below.

Manual regeneration rules:
For each command:
1. Read the operational text from the meta-prompt and use it as the base content (fenced block when present, otherwise body content).
2. Update /template/.claude/commands/[command].md:
   - Keep marker: <!-- generated-from-metaprompt -->
   - Write only the operational command content.
3. Update /prompts/[command].prompt.md:
   - Keep frontmatter (uses mode: agent):
     ---
     mode: agent
     description: '[description from meta-prompt]'
     tools:
       - read_file
       - create_file
       - replace_string_in_file
       - run_in_terminal
     ---
   - Keep marker: <!-- generated-from-metaprompt -->
   - Apply input substitutions:
     - cross-review: $ARGUMENTS -> ${input:specOrFeature:Provide the spec path or feature description}
     - test/implement: $ARGUMENTS -> ${input:filePath:Provide the path to the spec or task file}
     - bugfix: $ARGUMENTS -> ${input:bugRef:Path to bug log file or BUG-NNN}
   - If AGENTS.md is directly referenced in the operational content, add [AGENTS.md](../template/AGENTS.md) at the top of the body.
   - If the command performs phase execution or review logic, also add:
     - [workflow/PLAYBOOK.md](../template/workflow/PLAYBOOK.md)
     - [workflow/FILE_CONTRACTS.md](../template/workflow/FILE_CONTRACTS.md)
   - If the command performs implementation logic (implement, build-session), also add:
     - [workflow/FAILURE_ROUTING.md](../template/workflow/FAILURE_ROUTING.md)

STEP 4  -  VALIDATE
1. Re-check command parity using the cross-platform map above.
2. Confirm each Copilot prompt has valid YAML frontmatter with mode: agent.
3. Confirm each Claude command has no frontmatter (or has valid Claude frontmatter with description and allowed-tools).
4. Confirm no generated file includes script references.
5. Verify tool lists in Copilot prompts match the command's needs (read-only commands don't need run_in_terminal).

STEP 5  -  REPORT
Return a concise report:
- Commands processed (with phase mapping)
- Files updated
- Any parity mismatches fixed
- Manual edits detected and how they were handled
- Any unresolved ambiguity requiring user input

Prefer script-based sync; use manual sync only when scripts are unavailable. Do not introduce command semantics that are not present in canonical meta-prompts.
```
