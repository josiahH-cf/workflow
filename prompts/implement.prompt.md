---
mode: agent
description: "Implement one task using TDD — make failing tests pass, aligned to constitution"
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
---
<!-- role: derived | canonical-source: meta-prompts/minor/06-code.md -->

# Implement — Phase 6: TDD Implementation

Implement one task from a fine-tuned feature spec. TDD: tests exist first — make them pass.

## Setup

Read the task file at: ${input:filePath:Provide the path to the spec or task file}
Read `.specify/constitution.md` — verify the task traces to a constitution capability.
Read `AGENTS.md` (Boundaries, Core Commands, Code Conventions, Specification Workflow).

## Orient Before Writing

1. Identify the next task marked "Not started" in the task file.
2. Read the failing test(s) that cover this task's acceptance criteria.
3. Read the source files this task will modify.
4. Confirm you understand what the tests expect before writing any code.
5. Check `.specify/constitution.md` — does this task align with a stated capability? If not, stop and clarify.

## Rules

- **TDD** — tests already exist and are failing. Your job: make them pass.
- Implement ONLY this one task. Not the next one.
- Follow existing code patterns. Read surrounding code before writing.
- Do not modify existing tests. If a test seems wrong, the implementation is wrong — not the test.
- Do not add functionality beyond what this task specifies.
- Do not change files outside the scope listed in this task's "Files" field.
- **Update the spec before any unplanned decision.** Write to `/decisions/[NNNN]-[slug].md` AND update the spec.
- Bugs discovered during implementation: log them via bug tracking. Do not silently work around bugs.

## After Implementation

1. Run the full test suite — not just this task's tests.
2. If unrelated tests break, fix the regression without modifying those tests.
3. Commit on the assigned branch (format: `model/type-short-description`).
4. Update the task file: mark this task `[x] Complete`. Update Status counts.

## Next Step

- If MORE tasks remain → "Task N complete. M remaining. Run implement again with the same task file."
- If ALL tasks complete → "All tasks complete. Next: test for verification, then review."
