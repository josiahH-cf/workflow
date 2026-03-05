<!-- role: derived | canonical-source: meta-prompts/minor/06-code.md -->
<!-- generated-from-metaprompt -->
# Phase 6 — Code

**Objective:** Implement features following TDD from fine-tuned specs and task files. Tests exist first — make them pass.

**Trigger:** Phase 5 complete (`/tasks/[feature-id]-[slug].md` exists with ordered tasks, model assignment, and branches).

**Entry commands:**
- Claude: `/implement`
- Copilot: `implement.prompt.md`

---

## What Happens

1. Confirm `/test pre` has created failing tests for this feature
2. Orient: read task file, failing tests, source files
3. Verify constitution alignment before implementing
4. Implement one task at a time — make failing tests pass
5. Follow existing code patterns
6. Log bugs via `/bug` — don't silently work around them
7. Update spec before any unplanned decision
8. Commit per task on the assigned branch

## Gate

- Pre-implementation tests exist for every AC (from `/test pre`)
- All tasks in current feature's task file marked Complete
- Full test suite passes
- No unresolved blocking bugs

## Output

- Passing code on feature branch
- Updated task file with completion status
- Decision records for any unplanned decisions
- Bug log entries for any discovered bugs

## Rules

- TDD — tests exist before implementation
- One task per commit
- Do not modify existing tests
- Do not add functionality beyond spec
- Update spec before unplanned decisions

## See Also

- Bug logging: `/bug` command
- v1 equivalent: Phase 4 (Implement) — v2 adds constitution alignment check and bug-logging requirement
