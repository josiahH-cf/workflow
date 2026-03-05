<!-- role: canonical-source -->
<!-- phase: 7 -->
<!-- description: Run tests against ACs, log bugs, verify behavior -->
# Phase 7 — Test & Mark Changes

**Objective:** Verify implementation against acceptance criteria, log failures as bugs, and confirm behavior matches spec.

**Trigger:** Phase 6 complete (implementation exists on feature branch).

**Entry commands:**
- Claude: `/test`
- Copilot: `test.prompt.md`

---

## What Happens

### Pre-Implementation (Test Writing)
1. Read spec ACs and existing test patterns
2. Write at least one test per AC using EARS/GWT format
3. Tests must fail before implementation exists
4. Include UI/visual tests where applicable
5. Commit failing tests

### Post-Implementation (Verification)
1. Run full test suite
2. Compare results against each AC — mark pass/fail
3. Log failures as bugs via `/bug`
4. If behavior deviated from spec but tests pass, update spec notes
5. Verify no regressions

## Gate

- All acceptance criteria verified (pass or documented failure)
- Bug log reviewed — no blocking bugs remain
- No regressions in existing tests

## Output

- Test results mapped to ACs
- Bug log entries for any failures
- Updated spec if behavior deviated

## See Also

- Bug logging: `/bug` command
- Bug fixing: `/bugfix` command
- v1 equivalent: Phase 3 (Test) + Phase 5 (Review) — v2 combines test verification with bug logging
