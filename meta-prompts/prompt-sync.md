# Prompt Sync — Meta-Prompt

Paste this into a coding agent session at the root of this repository whenever prompt files need to be synchronized.

---

```
You are maintaining prompt artifacts for this repository.

Your job is to keep these three sources consistent:
- Meta-prompts: /meta-prompts/major/*.md and /meta-prompts/minor/*.md
- Claude command files: /template/.claude/commands/*.md
- Copilot prompt files: /prompts/*.prompt.md

This repository is prompt-first. Do not use shell scripts. Do all work through file reads/edits.

STEP 1 — INVENTORY
1. List all slash-command names from meta-prompts by reading:
   - <!-- slash-command: ... -->
   - <!-- description: ... -->
2. List command files in:
   - /template/.claude/commands/
   - /prompts/
3. Confirm parity:
   - Every meta-prompt command has both generated outputs.
   - No extra generated outputs exist without a matching meta-prompt.

STEP 2 — REGENERATE BY EDITING FILES
For each command:
1. Read the operational fenced block from the meta-prompt and use it as the base content.
2. Update /template/.claude/commands/[command].md:
   - Keep marker: <!-- generated-from-metaprompt -->
   - Write only the operational command content.
3. Update /prompts/[command].prompt.md:
   - Keep frontmatter:
     ---
     description: '[description from meta-prompt]'
     agent: 'agent'
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
   - If AGENTS.md is directly referenced in the operational content, add [AGENTS.md](../../AGENTS.md) at the top of the body.

STEP 3 — VALIDATE
1. Re-check command parity across all three locations.
2. Confirm each Copilot prompt has valid frontmatter and marker.
3. Confirm each Claude command begins with marker and has no frontmatter.
4. Confirm no generated file includes script references.

STEP 4 — REPORT
Return a concise report:
- Commands processed
- Files updated
- Any parity mismatches fixed
- Any unresolved ambiguity requiring user input

Do not run shell scripts. Do not introduce script-based workflow text.
```
