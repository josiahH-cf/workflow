# Prompt Sync  -  Meta-Prompt

Paste this into a coding agent session at the root of this repository whenever prompt files need to be synchronized.

---

```text
You are maintaining prompt artifacts for this repository.

Your job is to keep these three sources consistent:
- Meta-prompts: /meta-prompts/major/*.md and /meta-prompts/minor/*.md
- Claude command files: /template/.claude/commands/*.md
- Copilot prompt files: /prompts/*.prompt.md

This repository is prompt-first. Do not use shell scripts. Do all work through file reads/edits.

STEP 1  -  INVENTORY
1. List all slash-command names from meta-prompts by reading:
   - <!-- slash-command: ... --> or <!-- phase: ... -->
   - <!-- description: ... -->
2. List command files in:
   - /template/.claude/commands/
   - /prompts/
3. Confirm parity using the v2 cross-platform command mapping:

   V2 Cross-Platform Command Map:
   | Phase | Claude Command | Copilot Prompt | Meta-Prompt (minor) |
   |-------|---------------|----------------|-------------------|
   | 2 | compass.md | compass.prompt.md | 02-compass.md |
   | 2 | compass-edit.md | compass-edit.prompt.md | — |
   | 3 | define-features.md | define-features.prompt.md | 03-define-features.md |
   | 4 | scaffold.md | scaffold.prompt.md | 04-scaffold-project.md |
   | 5 | fine-tune.md | fine-tune.prompt.md | 05-fine-tune-plan.md |
   | 6 | implement.md | implement.prompt.md | 06-code.md |
   | 7 | test.md | test.prompt.md | 07-test.md |
   | 8 | maintain.md | maintain.prompt.md | 08-maintain.md |
   | — | bug.md | bug.prompt.md | — |
   | — | bugfix.md | bugfix.prompt.md | — |
   | — | continue.md | continue.prompt.md | — |
   | V1 | review.md | review.prompt.md | — |
   | V1 | cross-review.md | cross-review.prompt.md | — |
   | V1 | pr-create.md | pr-create.prompt.md | — |
   | V1 | merge.md | merge.prompt.md | — |
   | V1 | ideate.md | ideate.prompt.md | 0-ideate.md |
   | V1 | scope.md | scope.prompt.md | 1-scope.md |
   | V1 | plan.md | plan.prompt.md | 2-plan.md |
   | V1 | execplan.md | execplan.prompt.md | 2b-execplan.md |
   | V1 | fix-prompt.md | fix-prompt.prompt.md | fix-prompt.md |

4. Report parity:
   - Every command with a Copilot equivalent has both files present.
   - All v2 commands now have Copilot prompt equivalents.
   - No orphan generated outputs without a source.

STEP 2  -  DIFF VALIDATION
Before regenerating, for each file that will be updated:
1. Read the current file content.
2. Compare with what the meta-prompt would generate.
3. If the current file has been manually edited (no <!-- generated-from-metaprompt --> marker OR content diverges significantly from meta-prompt), flag it:
   - "MANUAL EDIT DETECTED: [file] — last synced content differs from current. Overwrite? (yes/skip)"
4. Only overwrite files that are confirmed as auto-generated or explicitly approved.

STEP 3  -  REGENERATE BY EDITING FILES
For each command:
1. Read the operational fenced block from the meta-prompt and use it as the base content.
2. Update /template/.claude/commands/[command].md:
   - Keep marker: <!-- generated-from-metaprompt -->
   - Write only the operational command content.
3. Update /prompts/[command].prompt.md:
   - Keep frontmatter (v2 uses mode: agent instead of agent: 'agent'):
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
     - ideate: $ARGUMENTS -> ${input:idea:Describe the feature idea}
     - scope/review/cross-review: $ARGUMENTS -> ${input:specOrFeature:Provide the spec path or feature description}
     - plan/test/implement: $ARGUMENTS -> ${input:filePath:Provide the path to the spec or task file}
     - execplan: $SPEC_PATH -> ${input:specPath:Path to the spec file}
                 $TASKS_PATH -> ${input:tasksPath:Path to the task file}
     - pr-create: $SPEC_PATH -> ${input:specPath:Path to the spec file}
                  $TARGET_BRANCH -> ${input:targetBranch:Target branch name (e.g., main)}
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

Do not run shell scripts. Do not introduce script-based workflow text.
```
