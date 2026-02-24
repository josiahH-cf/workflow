# Feature Lifecycle — Meta-Prompts

Three session-oriented meta-prompts covering the full lifecycle. Each is designed for sustained deep work — batch issue creation, iterative development, or bulk review — rather than one-phase-at-a-time invocations.

**Standing rules for all sessions:**
- Follow the project conventions in `AGENTS.md` throughout.
- Every artifact produced (spec, task file, test, implementation, review report) is committed or written to its canonical location before moving on.
- Fresh context means: no prior conversation carried forward. When indicated, end the current session and begin a new one.

---

## Meta-Prompt 1 — Plan

**Covers:** Phase 0 (Ideate), Phase 1 (Scope), Phase 2 (Plan), Phase 2b (ExecPlan if applicable)

**Purpose:** Turn raw ideas into fully planned, ready-to-build issues — in batch. This session is interactive. You will work through one idea at a time, completing all planning phases for each before moving to the next.

**Session inputs:** One or more ideas, described in plain language. Provide them one at a time when prompted.

---

```
You are running a planning session. The goal is to take raw ideas and produce fully planned features — each with a filed issue, a locked spec, and an ordered task file — ready for an agent to pick up and build.

You will process one idea at a time through three phases. Do not skip phases. Do not write code or tests.

For each idea, work through the following in order:

PHASE 0 — IDEATE
Ask: "Describe the feature or idea you'd like to plan."
When the idea is provided:
1. Determine if this is a single feature or a batch of related features.
   - Single feature: produce one issue.
   - Batch or epic: decompose into independently actionable issues. Each must stand alone. If issues depend on each other, state the dependency explicitly in the Notes section of the dependent issue.
2. For each issue, produce:
   - Title (concise, imperative)
   - Idea (1–3 sentences: what and why)
   - Desired Outcome (what should be true when done)
   - Sizing Guess (S / M / L / XL — if XL, note it should be split further during scoping)
   - Notes (context, dependencies on other issues if any)
   - Labels: type:feature or type:bug, status:idea, size:[S/M/L/XL]
3. Present the issue(s) for review. Ask: "Does this capture the intent? Adjust anything before I scope it?"
   Wait for confirmation before proceeding.

PHASE 1 — SCOPE
For each confirmed issue:
1. Explore the codebase to understand what files, patterns, dependencies, and constraints are relevant.
2. Produce a spec at /specs/[feature-name].md containing:
   - Description (2–3 sentences)
   - Acceptance Criteria (3–7 testable statements as checkboxes — each verifiable by an automated test)
   - Affected Areas (files, modules, directories)
   - Constraints (performance, compatibility, security — or "None")
   - Out of Scope (explicitly excluded)
   - Dependencies (or "None")
   - Notes (or "None")
3. Validate:
   - If criteria exceed 7, stop. Recommend how to split the feature into smaller issues. Present the split for approval, then restart Phase 0 for each sub-feature.
   - Every criterion must be concrete and testable — not vague ("works correctly") or procedural ("run the tests").
4. Present the spec for review. Ask: "Spec ready. Review the acceptance criteria — are these correct and complete?"
   Wait for confirmation before proceeding.

PHASE 2 — PLAN
For each confirmed spec:
1. Decompose into 2–5 implementation tasks, ordered by dependency.
2. For each task, provide:
   - Name
   - Files it will create or modify
   - Done state (one sentence)
   - Which acceptance criteria it covers
   - Status: Not started
3. Write to /tasks/[feature-name].md including:
   - Link to the spec
   - Status summary (total, complete, remaining)
   - Task list
   - Test Strategy (map each criterion to the task that tests it — every criterion appears exactly once)
   - Empty Session Log
4. Validate:
   - Maximum 5 tasks. If more are needed, recommend splitting the spec and loop back to Phase 1.
   - If any task touches more than 8 files, split that task. If the total would exceed 5, recommend splitting the spec instead.
   - Every acceptance criterion must be covered by at least one task.
5. If this feature involves milestones or long-running execution, also produce an ExecPlan alongside the task file following the structure in /.codex/PLANS.md.
6. Present the task file for review. Ask: "Tasks planned. Does this decomposition look right?"
   Wait for confirmation.

After completing all three phases for one idea:
- Confirm: "Issue, spec, and tasks are complete for [feature-name]. Label the issue status:planned."
- Then ask: "Would you like to plan another feature, or is this planning session complete?"

If another feature: return to Phase 0 and ask for the next idea.
If complete: summarize all features planned in this session with their file paths:
  - Issues created
  - Specs: /specs/[name].md
  - Tasks: /tasks/[name].md
  - ExecPlans (if any)
State: "All planned features are ready for the Build phase."
```

**Output per idea:** A filed issue, `/specs/[feature-name].md`, `/tasks/[feature-name].md`, and optionally an ExecPlan.

**Output at session end:** A summary table of all planned features and their artifacts.

**Next:** Hand off to the Build meta-prompt. Each planned issue can be built independently in a separate session.

---

## Meta-Prompt 2 — Build

**Covers:** Phase 3 (Test), Phase 4 (Implement — looped per task)

**Purpose:** Take a single planned issue and build it end-to-end: write failing tests for all acceptance criteria, then implement one task at a time until all tasks pass. Each task is a commit. This session is autonomous — the agent works through the task file without further input unless a decision or blocker arises.

**Session inputs:** The path to one task file (e.g., `/tasks/[feature-name].md`).

---

```
You are building a planned feature. The task file for this session is provided. Read it now, along with the linked spec.

Work through two phases in order. Commit at every checkpoint described below.

PHASE 3 — TEST
1. Read the spec's acceptance criteria.
2. Read existing test files in the relevant area to match the project's test style, naming, and structure.
3. For each acceptance criterion, write at least one test that:
   - Asserts the expected behavior described in the criterion.
   - Will fail because the feature does not exist yet.
   - Uses a descriptive name stating the expected behavior.
4. Do not write any implementation code — not even stubs or helpers that implement feature logic.
5. Run the full test suite. Confirm: new tests fail, all existing tests pass.
6. Commit the test files with a message referencing the spec.

PHASE 4 — IMPLEMENT (repeat for each task)
For each task in the task file, in order:
1. Orient before writing:
   - Identify the next task marked "Not started."
   - Read the test file(s) covering this task's criteria.
   - Read the source files this task will modify.
   - Confirm you understand what the tests expect before writing.
2. Implement only this one task.
   - Make the failing tests for this task pass.
   - Follow existing code patterns.
   - Do not modify any existing tests. If a test seems wrong, the implementation is wrong.
   - Do not add functionality beyond what this task specifies.
   - Do not change files outside this task's listed scope.
3. If you encounter a non-obvious decision, write it to /decisions/[NNNN]-[slug].md before proceeding.
4. Run the full test suite. If unrelated tests break, fix the regression without modifying those tests.
5. Commit with a message referencing the task.
6. Update the task file: mark this task complete, update the status counts, append to the Session Log.
7. If more tasks remain: continue to the next task within this session if context allows. If context is becoming constrained, stop and note which task is next — a fresh session should pick up from that point.

When all tasks are complete:
- Confirm the full test suite passes.
- State: "All tasks complete for [feature-name]. Label the issue status:implemented. This feature is ready for the Review phase."
```

**Output:** Committed failing tests, committed implementation (one commit per task), updated task file with all tasks marked complete.

**Context note:** If the feature has many tasks and context becomes constrained, it is correct to stop mid-feature and resume in a fresh session pointing at the same task file. The task file's status tracking ensures continuity.

**Next:** Hand off to the Review & Ship meta-prompt.

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
