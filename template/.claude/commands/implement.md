<!-- role: derived | canonical-source: meta-prompts/minor/06-code.md -->
You are implementing one task from a fine-tuned feature spec. TDD: tests exist first — make them pass.

Read the task file at: $ARGUMENTS
Read `.specify/constitution.md` — verify the task traces to a constitution capability.
Read `/AGENTS.md` (Boundaries, Core Commands, Code Conventions, Specification Workflow).
Read `/workflow/PLAYBOOK.md` and `/workflow/FILE_CONTRACTS.md`.

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
- Do not add functionality beyond what this task specifies. No bonus features, no preemptive refactors.
- Do not change files outside the scope listed in this task's "Files" field.
- **Update the spec before any unplanned decision.** If implementation requires something not in the spec, write it to `/decisions/[NNNN]-[slug].md` AND update the spec's notes section before proceeding.
- Bugs discovered during implementation: run `/bug` to log them. Do not silently work around bugs.

## After Implementation

1. Run the full test suite — not just this task's tests.
2. If unrelated tests break, fix the regression without modifying those tests.
3. Commit on the assigned branch (see task's Branch field — format: `model/type-short-description`).
4. Commit message references the task: `Implement [task name] for [feature-id]-[slug] — T-N`.
5. Update the task file: mark this task `[x] Complete`. Update Status counts.
6. Append to Session Log: date, what was completed, any blockers or decisions.

## Next Step

- If MORE tasks remain "Not started" → state: "Task N complete. M remaining. Run `/implement` again with the same task file."
- If ALL tasks complete → state: "All tasks complete. Next: `/test` for verification, then review."
