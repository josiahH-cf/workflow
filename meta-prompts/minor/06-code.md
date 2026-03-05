<!-- role: canonical-source -->
<!-- phase: 6 -->
<!-- description: TDD implementation — make failing tests pass, one task at a time -->
# Phase 6 — Code

**Objective:** Implement features following TDD from fine-tuned specs. Tests exist first — make them pass.

**Trigger:** Phase 5 complete (fine-tuned specs with ACs, model assignments, branches exist).

**Entry commands:**
- Claude: `/implement`
- Copilot: `implement.prompt.md`

---

## What Happens

1. Orient: read task file, failing tests, source files
2. Verify constitution alignment before implementing
3. Implement one task at a time — make failing tests pass
4. Follow existing code patterns
5. Log bugs via `/bug` — don't silently work around them
6. Update spec before any unplanned decision
7. Commit per task on the assigned branch

## Gate

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
