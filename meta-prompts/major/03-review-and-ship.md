# Feature Lifecycle — Meta-Prompts

Three session-oriented meta-prompts covering the full lifecycle. Each is designed for sustained deep work — batch issue creation, iterative development, or bulk review — rather than one-phase-at-a-time invocations.

**Standing rules for all sessions:**
- Follow the project conventions in `AGENTS.md` throughout.
- Every artifact produced (spec, task file, test, implementation, review report) is committed or written to its canonical location before moving on.
- Fresh context means: no prior conversation carried forward. When indicated, end the current session and begin a new one.

---

## Meta-Prompt 3 — Review & Ship

**Covers:** Phase 5 (Review), Phase 5b (Cross-Review), Phase 6 (PR Create), and preparation for Phase 7 (Human Review)

**Purpose:** Review completed feature branches in bulk. For each branch, verify against the spec, produce a structured report, and — if it passes — create the pull request. This session can process multiple completed features sequentially. Ideally, the reviewing agent is different from the one that built the feature.

**Session inputs:** One or more feature names that are labeled `status:implemented`. Provide them one at a time or as a list.

---

```
You are reviewing completed feature branches and preparing them for merge. You will process one feature at a time through review, and if it passes, create its pull request.

For each feature, work through the following:

PHASE 5 — REVIEW
Read the spec at /specs/[feature-name].md, the task file at /tasks/[feature-name].md, and the full diff of the feature branch against the target branch.

Evaluate every item below. For each, report PASS or FAIL with specific evidence.

Acceptance criteria coverage — for each criterion in the spec:
- Does a test exist that verifies this criterion?
- Does the implementation satisfy the criterion?
- Report: PASS with test location, or FAIL with what is missing.

Code quality:
- No existing tests were modified to accommodate the new code.
- No files outside the spec's Affected Areas were changed.
- No hardcoded values, secrets, or environment-specific strings.
- No functions over 50 lines.
- No dead code or unused imports.
- Error handling is explicit, not silent.
- Naming is consistent with existing codebase conventions.

Produce a summary:
- Total criteria: [N], Passed: [N], Failed: [N]
- Code quality issues: [list or "None"]

If ALL checks pass:
- State: "Review PASSED for [feature-name]."
- Proceed to Phase 6 below.

If ANY check fails:
- List each failure with the specific fix needed.
- State: "Review FAILED for [feature-name]. These issues must be addressed in a Build session before this feature can proceed."
- Do not create a PR. Move to the next feature if there are more to review.

PHASE 5b — CROSS-REVIEW (when applicable)
If you are a different agent or model than the one that built AND initially reviewed this feature, your Phase 5 evaluation above serves as the cross-review. State this explicitly in the report.

If you are the same agent that built the feature, note: "Self-reviewed only. Cross-review by a different agent is recommended before merge."

PHASE 6 — PR CREATE (only for features that passed review)
Read the PR template at /.github/pull_request_template.md if it exists.
Read the full diff of the feature branch against the target branch.

Produce the pull request:
- Title: concise imperative summary
- What: one sentence
- Why: link to /specs/[feature-name].md
- Changes: logical changes grouped by area
- Testing checklist: check each box honestly — if any cannot be checked, leave it unchecked and explain
- Non-code checklist: same — honest checks only
- Verification: how a reviewer can verify beyond reading the diff
- Rollback: special steps or "Standard revert."
- If the diff exceeds 300 lines, state this and recommend splitting before opening.

Open the PR against the target branch.
State: "PR created for [feature-name]. Ready for human review (Phase 7)."

After completing review (and PR if applicable) for one feature:
- Ask: "Would you like to review another feature, or is this review session complete?"

If another feature: ask for the next feature name and repeat from Phase 5.
If complete: produce a session summary:
  - Features reviewed
  - Status of each: PR created / failed review (with reason)
  - Any features needing a Build session to address failures

State: "All features that passed review have open PRs. Remaining items need Build sessions to address review failures. Human review (Phase 7) can proceed on the open PRs — estimated 10 minutes per PR using the non-code checklist."
```

**Output per feature:** A PASS/FAIL review report and, if passed, an open pull request.

**Output at session end:** A summary of all features reviewed and their disposition.

**Phase 7 — Human Review (not a meta-prompt):**
Phase 7 is human-driven. The PR's non-code checklist is designed for a reviewer who does not need to read code. The checklist covers: scope match against spec, diff size, file scope, secrets, test evidence, commit messages, cross-review status, and rollback path. Estimated time: 10 minutes per PR. On approval: merge, delete the branch, label the issue `status:done`.

---

## Session Flow Summary

```
PLAN (interactive, batch)
  Phase 0: Ideate → Issue            ↺ repeat per idea
  Phase 1: Scope  → Spec               ↰ split back to Phase 0 if criteria > 7
  Phase 2: Plan   → Tasks / ExecPlan   ↰ split back to Phase 1 if tasks > 5
  → "Plan another?" loop

BUILD (autonomous, one feature per session)
  Phase 3: Test   → Committed failing tests
  Phase 4: Implement → Committed code   ↺ repeat per task
  → Resume in fresh session if context constrained

REVIEW & SHIP (batch)
  Phase 5/5b: Review → PASS/FAIL report   ↰ fail sends back to Build
  Phase 6: PR Create (on pass)
  → "Review another?" loop

HUMAN (Phase 7)
  Merge via non-code checklist → Done
```

**File connections:**
```
/specs/[name].md        produced by: Plan     consumed by: Build, Review & Ship
/tasks/[name].md        produced by: Plan     consumed by: Build, Review & Ship
/decisions/[NNNN].md    produced by: Build    consumed by: future sessions
ExecPlan                produced by: Plan     consumed by: Build (long-run only)
PR                      produced by: Review   consumed by: Human
```
