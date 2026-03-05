<!-- role: canonical-source -->
Fix a logged bug following the reproduce → diagnose → fix → verify → PR loop.

Read the bug entry: $ARGUMENTS (path to bug log or bug ID like BUG-NNN)
Read `/AGENTS.md` (Boundaries, Bug Tracking, Branch Naming).
Read `.specify/constitution.md` — verify the fix aligns with project principles.

## Step 1: Reproduce

- Write a failing test that demonstrates the bug's "Expected vs Actual" behavior.
- The test must fail before the fix and pass after.
- If the bug cannot be reproduced, document why and close as "cannot reproduce."

## Step 2: Diagnose

- Read the code at the bug's Location field.
- Identify the root cause — not just the symptom.
- If the root cause spans multiple files or suggests a design issue, log a `/bug` for the deeper problem and fix the immediate symptom only.

## Step 3: Fix

- Fix the root cause. Minimal change — do not refactor surrounding code.
- Do not introduce new functionality beyond what restores correct behavior.
- If the fix requires a decision not covered by the spec, write to `/decisions/[NNNN]-[slug].md`.

## Step 4: Verify

- Run the failing test — it must now pass.
- Run the full test suite — no regressions.
- If regressions appear, fix them without modifying unrelated tests.

## Step 5: Ship

- Branch: `model/bug-short-description` (per AGENTS.md branch naming).
- Commit message: `Fix BUG-NNN: [short description]`.
- Update the bug log entry: set Status to `fixed`, add fix date and commit ref.
- Create PR with bug reference and test evidence.

State: "BUG-NNN fixed. Test added. PR ready."
