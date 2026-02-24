# Feature Lifecycle — Meta-Prompt System

Each prompt below is a standalone, reusable command. Copy the prompt for the phase you need, replace the `[placeholders]`, and invoke it in any LLM agent. Every phase's output is designed to be consumed directly by the next phase's input with no additional interpretation.

**How to use this document:**
- Start at Phase 0 and work forward.
- Each prompt states when to start a fresh context window.
- Branching prompts (2b, 5b) are used only when their trigger condition is met.
- `$ARGUMENTS` means: replace with the actual value when invoking.

---

## Phase 0 — Ideate

**Objective:** Turn a raw idea into one or more structured GitHub Issues that an agent can pick up.

**Trigger:** You have an idea, a user request, a bug report, or a batch of related features.

**Required input:** The idea, described in your own words. No files needed.

**Context window:** Any. This is typically human-driven, but an agent can assist with decomposition.

---

```
You are helping structure a raw idea into actionable GitHub Issues.

The idea is: $ARGUMENTS

Do the following:

1. Determine whether this is a single feature or a batch of related features.
   - If it is a single feature, produce ONE issue.
   - If it is a batch or epic, decompose it into independently actionable issues. Each issue must stand alone — no implicit ordering. If issues depend on each other, state the dependency explicitly in the dependent issue's Notes section.

2. For each issue, produce the following and nothing else:

   ---
   **Title:** [concise imperative title]

   **Idea:** [1–3 sentences: what and why]

   **Desired Outcome:** [What should be true when this is done]

   **Sizing Guess:** [S / M / L / XL — if XL, note that it should be split further during scoping]

   **Notes:** [Context, links, prior art, dependencies on other issues if any]

   **Labels:** type:feature (or type:bug), status:idea, size:[S/M/L/XL]
   ---

3. If you produced multiple issues, list them in a suggested scoping order (dependency-first).

Do not write code. Do not create specs. Do not scope the feature. The sole output of this phase is one or more issue bodies ready to be filed.
```

**Output:** One or more issue bodies, each labeled `status:idea`.

**Next phase:** Phase 1 (Scope). Invoke once per issue, in a fresh context window per issue.

---

## Phase 1 — Scope

**Objective:** Explore the codebase and produce a locked spec with testable acceptance criteria.

**Trigger:** A GitHub Issue exists with label `status:idea`.

**Required input:** The issue body (or URL) and access to the codebase.

**Context window:** Fresh. One scope session per issue.

---

```
You are scoping a new feature. Do not write code. Do not create implementation files.

The feature is: $ARGUMENTS

Read the project's conventions file (AGENTS.md) before starting.

Explore the codebase to understand:
1. What files, modules, and areas are relevant to this feature.
2. What existing patterns and conventions apply to this area.
3. What dependencies, constraints, or risks exist.

Then produce a spec file at /specs/[feature-name].md with exactly this structure:

---
# Feature: [name]

## Description
[2–3 sentences: what this does and why]

## Acceptance Criteria
[3–7 testable statements. Each must be verifiable by an automated test. Write them as checkboxes.]

## Affected Areas
[Files, modules, or directories this will touch]

## Constraints
[Performance targets, backward compatibility, security requirements — or "None"]

## Out of Scope
[What is explicitly excluded to prevent scope creep]

## Dependencies
[Other features, services, or data this depends on — or "None"]

## Notes
[Non-obvious details the implementer should know — or "None"]
---

Rules:
- Acceptance criteria must be between 3 and 7. No more.
- If you cannot get below 8 criteria, this feature is too large. Instead of writing the spec, recommend how to split it into smaller features and stop. Each sub-feature will need its own Phase 0 issue and its own Phase 1 scope session.
- Every criterion must be a concrete, testable statement — not vague ("works correctly") or procedural ("run the tests").
- Do not include implementation details in the criteria. Describe what, not how.
- The spec file is the only output. Do not produce task files, test files, or code.

After writing the spec, state: "Spec complete. Label the issue status:scoped. Next phase: Plan."
```

**Output:** `/specs/[feature-name].md` — a locked spec file.

**Branch — Split:** If criteria exceed 7, this phase produces a split recommendation instead of a spec. Go back to Phase 0 to create separate issues, then scope each independently.

**Next phase:** Phase 2 (Plan). Start in a fresh context window.

---

## Phase 2 — Plan

**Objective:** Decompose a locked spec into 2–5 ordered implementation tasks.

**Trigger:** A spec file exists at `/specs/[feature-name].md`. Issue is labeled `status:scoped`.

**Required input:** The path to the spec file.

**Context window:** Fresh. Do not carry scope context into planning.

---

```
You are planning implementation tasks. Do not write code. Do not write tests.

Read the spec at: $ARGUMENTS
Read the project's conventions file (AGENTS.md) for relevant patterns.

Decompose the spec into 2–5 implementation tasks, ordered by dependency (tasks that others depend on come first).

For each task, provide:
- **Name:** [short descriptive name]
- **Files:** [specific files this task will create or modify]
- **Done when:** [one sentence describing the verifiable end state]
- **Criteria covered:** [which acceptance criteria from the spec this task addresses]
- **Status:** [ ] Not started

Write the output to /tasks/[feature-name].md with this structure:

---
# Tasks: [feature-name]

**Spec:** /specs/[feature-name].md

## Status
- Total: [N]
- Complete: 0
- Remaining: [N]

## Task List

### Task 1: [name]
- **Files:** [list]
- **Done when:** [one sentence]
- **Criteria covered:** [which from spec]
- **Status:** [ ] Not started

[repeat for each task]

## Test Strategy
[Map each acceptance criterion to the task that will test it. Every criterion must appear exactly once.]

## Session Log
[empty — will be filled during implementation]
---

Rules:
- Maximum 5 tasks. If you need more, the spec should have been split during Phase 1. Do not proceed — recommend splitting and stop.
- If any single task touches more than 8 files, split that task into smaller tasks. The total must still not exceed 5. If it would, recommend splitting the spec instead.
- Every acceptance criterion must be covered by at least one task. No orphaned criteria.
- Tasks must be completable independently in sequence — no circular dependencies.
- Do not write code, tests, or modify any source files.

After writing the task file, state: "Plan complete. Label the issue status:planned. Next phase: Test (Phase 3)."

If this feature will use a long-running execution plan (milestone-based, multi-step), also state: "This feature is a candidate for an ExecPlan. Run Phase 2b before proceeding to Phase 3."
```

**Output:** `/tasks/[feature-name].md` — an ordered task file.

**Branch — ExecPlan:** If the feature is a candidate for milestone-based long-run execution, proceed to Phase 2b before Phase 3.

**Branch — Split:** If tasks exceed 5 or any task exceeds 8 files and cannot be condensed, go back to Phase 1 to split the spec.

**Next phase:** Phase 3 (Test), or Phase 2b (ExecPlan) first if flagged. Start Phase 3 in a fresh context window.

---

## Phase 2b — ExecPlan (Long-Run Variant)

**Objective:** Convert a task plan into a milestone-based execution plan for long-running agent sessions.

**Trigger:** Phase 2 flagged this feature as an ExecPlan candidate.

**Required input:** Paths to both the spec and task file.

**Context window:** Same session as Phase 2 is acceptable, or fresh.

---

```
You are creating a milestone-based execution plan for a long-running implementation session.

Read the spec at: $SPEC_PATH
Read the task file at: $TASKS_PATH
Read the project's conventions file (AGENTS.md).

Produce an ExecPlan that restructures the tasks into milestones. Each milestone must leave all tests passing when complete.

Write the output following this structure:

---
# ExecPlan: [feature-name]

## Purpose
[One paragraph: what this accomplishes and why]

## Scope
[Explicit boundaries: what IS and IS NOT included]

## Prerequisites
- [ ] Tests green on the target branch
- [ ] Dependencies installed and up to date
- [ ] Spec exists at /specs/[feature-name].md

## Milestones

### Milestone 1: [name]
- **Files:** [list]
- **Steps:**
  1. [step]
  2. [step]
- **Verification:** [how to confirm this milestone is complete]
- **Tests:** [what to run to verify]

[repeat for each milestone]

## Testing
- Full test command: [command from AGENTS.md]
- Expected pass count before: [N]
- Expected pass count after: [N + new tests]
- Each milestone must leave all tests passing

## Rollback
[How to safely revert if this fails partway through]

## Progress
- [ ] Milestone 1
- [ ] Milestone 2
[etc.]

## Decision Log
[empty — fill during implementation if non-obvious choices arise]

## Surprises
[empty — fill during implementation if anything unexpected is encountered]
---

Rules:
- Milestones must be ordered so each one leaves the codebase in a working state.
- Every acceptance criterion from the spec must be addressed by at least one milestone.
- Do not write code. This is a plan only.

After writing the ExecPlan, state: "ExecPlan complete. Next phase: Test (Phase 3). Start in a fresh context window."
```

**Output:** An ExecPlan document (stored alongside the task file or in the project's plan location).

**Next phase:** Phase 3 (Test). Start in a fresh context window.

---

## Phase 3 — Test

**Objective:** Write and commit failing tests — one per acceptance criterion — before any implementation code exists.

**Trigger:** A task file exists at `/tasks/[feature-name].md`. Issue is labeled `status:planned`.

**Required input:** The path to the task file.

**Context window:** Fresh. Do not carry planning context into test writing.

---

```
You are writing tests for a feature that does not exist yet. Do not write implementation code.

Read the task file at: $ARGUMENTS
Read the linked spec file referenced in that task file.
Read the project's conventions file (AGENTS.md) for testing patterns.
Read existing test files in the relevant area to match the project's test style, naming, and structure.

For each acceptance criterion in the spec, write at least one test that:
- Asserts the expected behavior described in the criterion.
- Will FAIL right now because the feature has not been implemented.
- Uses a descriptive name that states the expected behavior in plain language.

Rules:
- Every acceptance criterion must have at least one corresponding test. No criterion left untested.
- Tests must fail. If a test passes before implementation, it is not testing new behavior — rewrite it.
- Do not write any implementation code. Not even stubs, helpers, or fixtures that implement feature logic.
- Follow the existing test patterns in this codebase exactly. Match file location, naming, imports, and structure.
- All pre-existing tests must still pass. Your new tests are the only ones that should fail.

After writing tests:
1. Run the full test suite.
2. Confirm: new tests fail, all existing tests pass.
3. Commit the test files with a message referencing the spec (example: "Add failing tests for [feature-name] per /specs/[feature-name].md").

After committing, state: "Failing tests committed. Label the issue status:tests-written. Next phase: Implement (Phase 4). Start in a fresh context window. Run one session per task."
```

**Output:** Committed failing test files. All existing tests still pass. New tests fail.

**Next phase:** Phase 4 (Implement). **Start in a fresh context window.** Implementation is done one task per session.

---

## Phase 4 — Implement

**Objective:** Make failing tests pass by implementing exactly one task. Commit when that task's tests pass.

**Trigger:** Failing tests are committed. Task file has at least one task with status "Not started."

**Required input:** The path to the task file.

**Context window:** Fresh for each task. One task per session. Do not batch tasks.

---

```
You are implementing one task from a planned feature. Only one.

Read the task file at: $ARGUMENTS
Read the project's conventions file (AGENTS.md).

Orient before writing:
1. Identify the next task in the task file that is marked "Not started."
2. Read the test file(s) that cover this task's acceptance criteria.
3. Read the source files this task will modify.
4. Confirm you understand what the tests expect before writing any code.

Implement ONLY this one task. Not the next one. Not a partial start on another.

Rules:
- Make the failing tests for this task pass.
- Follow existing code patterns. Read the surrounding code before writing.
- Do not modify any existing tests. If a test seems wrong, the implementation is wrong — not the test.
- Do not add functionality beyond what this task specifies. No bonus features, no preemptive refactors.
- Do not change files outside the scope listed in this task's "Files" field.
- If you encounter a non-obvious decision, write it to /decisions/[NNNN]-[slug].md before proceeding. Use the next available number.

After implementation:
1. Run the full test suite — not just this task's tests.
2. If unrelated tests break, fix the regression without modifying those tests.
3. Commit with a message referencing the task (example: "Implement [task name] for [feature-name] — task 2/4").
4. Update the task file: mark this task's status as [x] Complete. Update the Status counts (Complete, Remaining).
5. Append to the Session Log: date, what was completed, any blockers or decisions made.

After committing, check the task file:

- If MORE tasks remain with status "Not started":
  State: "Task [N] complete. [M] tasks remaining. End this session. Start a fresh context window and run Phase 4 again with the same task file path."

- If ALL tasks are now complete:
  State: "All tasks complete. Label the issue status:implemented. Next phase: Review (Phase 5). Start in a fresh context window. For best results, use a different agent or model for review."
```

**Output:** Committed implementation code for one task. Task file updated. Tests passing.

**Loop:** Repeat Phase 4 in a fresh context window for each remaining task.

**Next phase (when all tasks done):** Phase 5 (Review). **Start in a fresh context window. Use a different agent or model than the one that implemented.**

---

## Phase 5 — Review (Self-Verify)

**Objective:** Verify the implementation against the spec. Produce a PASS/FAIL report per acceptance criterion.

**Trigger:** All tasks are marked complete in the task file. Issue is labeled `status:implemented`.

**Required input:** The path to the spec file.

**Context window:** Fresh. Ideally a different agent or model than the implementer. If the same agent must self-verify, still use a fresh context window with no implementation history.

---

```
You are reviewing a completed feature branch. You did not write this code. Approach it with fresh eyes.

Read the spec at: $ARGUMENTS
Read the project's conventions file (AGENTS.md).
Read the full diff of the current branch against the target branch.
Read the task file linked from the spec's feature name at /tasks/[feature-name].md.

Evaluate every item below. For each, report PASS or FAIL with specific evidence.

**Acceptance criteria coverage:**
For each criterion in the spec:
- Does a test exist that specifically verifies this criterion?
- PASS: [criterion] — test at [file:line] verifies this.
- FAIL: [criterion] — no test found, or test does not verify the stated behavior.

**Code quality checks:**
1. No existing tests were modified to accommodate the new code.
   - PASS/FAIL + evidence.
2. No files outside the spec's "Affected Areas" were changed.
   - PASS/FAIL + list any out-of-scope files.
3. No hardcoded values, secrets, or environment-specific strings.
   - PASS/FAIL + locations if found.
4. No functions over 50 lines.
   - PASS/FAIL + function names and line counts if found.
5. No dead code or unused imports.
   - PASS/FAIL + locations if found.
6. Error handling is explicit, not silent (no bare catches, no swallowed errors).
   - PASS/FAIL + locations if found.
7. Naming is consistent with existing codebase conventions.
   - PASS/FAIL + inconsistencies if found.

**Summary:**
- Total criteria: [N]
- Passed: [N]
- Failed: [N]

If ALL checks pass:
  State: "Review PASSED. Branch is ready for cross-review. Next: Phase 5b (Cross-Review) in a fresh context window with a DIFFERENT agent or model. If cross-review is not available, proceed to Phase 6 (PR Create)."

If ANY check fails:
  List each failure with the specific fix needed.
  State: "Review FAILED. Return to Phase 4 (Implement) in a fresh context window to address the failures listed above. Do not proceed to PR."
```

**Output:** A PASS/FAIL report per acceptance criterion and code quality check.

**Branch — FAIL:** Go back to Phase 4 in a fresh context window to fix specific failures.

**Next phase (on PASS):** Phase 5b (Cross-Review) if a different agent is available. Otherwise, Phase 6 (PR Create).

---

## Phase 5b — Cross-Review

**Objective:** Independent verification by a different agent or model than both the implementer and the self-reviewer.

**Trigger:** Phase 5 passed. A different agent or model is available.

**Required input:** The path to the spec file.

**Context window:** Fresh. MUST be a different agent or model than the one that implemented OR self-reviewed. This is the critical constraint of this phase.

---

```
You are performing an independent review of a completed feature branch. You did not implement this code and you did not perform the initial review. Your judgment is independent.

Read the spec at: $ARGUMENTS
Read the project's conventions file (AGENTS.md).
Read the full diff of the current branch against the target branch.

Perform the same evaluation as a standard review:

**For each acceptance criterion in the spec:**
- Does a test exist that verifies this criterion?
- Does the implementation actually satisfy the criterion (not just the test)?
- PASS: [criterion] — [evidence]
- FAIL: [criterion] — [what is wrong and where]

**Code quality (flag any issues found):**
- Functions over 50 lines
- Missing error handling
- Hardcoded secrets or environment-specific values
- Files changed outside the declared scope
- Dead code or unused imports
- Naming inconsistencies with the existing codebase
- Tests that were modified rather than implementation being fixed

**Your independent assessment:**
- APPROVE: All criteria met, code quality acceptable. Ready for PR.
- REQUEST CHANGES: [list specific changes needed]

If APPROVE:
  State: "Cross-review passed. Label the issue status:reviewed. Next phase: PR Create (Phase 6)."

If REQUEST CHANGES:
  State: "Cross-review found issues. Return to Phase 4 (Implement) in a fresh context window to address the items listed above."
```

**Output:** An independent APPROVE or REQUEST CHANGES report.

**Branch — REQUEST CHANGES:** Go back to Phase 4 in a fresh context window.

**Next phase (on APPROVE):** Phase 6 (PR Create).

---

## Phase 6 — PR Create

**Objective:** Open a pull request with a complete description linking to the spec, summarizing changes, and including both code and non-code checklists.

**Trigger:** Review (and cross-review if applicable) passed. Issue is labeled `status:reviewed`.

**Required input:** The spec file path and the target branch name.

**Context window:** Can continue from review, or fresh. Either is fine.

---

```
You are creating a pull request for a completed, reviewed feature branch.

Read the spec at: $SPEC_PATH
Read the full diff of the current branch against the target branch: $TARGET_BRANCH
Read the project's PR template at /.github/pull_request_template.md if it exists.

Produce the PR with this structure:

---
**Title:** [concise imperative summary of the change]

## What
[One sentence: what this PR does]

## Why
Spec: /specs/[feature-name].md

## Changes
[List the logical changes, grouped by area. Keep it scannable.]

## Testing
- [x] All acceptance criteria from the spec have corresponding tests
- [x] All tests pass locally
- [x] No existing tests were modified to accommodate new behavior
- [x] Linting and formatting checks pass

## Non-Code Checks
- [x] Spec acceptance criteria are all addressed
- [x] Diff is under 300 lines
- [x] No files changed outside the declared scope
- [x] Commit messages reference the spec or task file
- [x] No TODOs or placeholder text in the diff
- [x] No new dependencies added without justification
- [x] Rollback path is documented below

## Verification
[How a reviewer can verify beyond reading the diff — specific steps or commands]

## Rollback
[Special steps beyond git revert, or "Standard revert." if none]
---

Rules:
- If the diff exceeds 300 lines, state this clearly and recommend splitting before opening the PR.
- Check every box honestly. If any box cannot be checked, do not check it — leave it unchecked and explain why.
- The PR description must be understandable by a non-developer reviewer using the non-code checklist.
- Open the PR against the target branch using the project's standard method.

After creating the PR, state: "PR opened. Next phase: Human review and merge (Phase 7). A human reviewer should use the non-code checklist — no code reading required, approximately 10 minutes."
```

**Output:** An open pull request with a complete, honest description and checklists.

**Next phase:** Phase 7 (Human Review & Merge). This is a human-driven phase.

---

## Phase 7 — Human Review & Merge

**Objective:** Non-code review by a human, followed by merge and cleanup.

**Trigger:** A PR is open and all automated checks pass.

**Required input:** The open PR.

**Context window:** Not applicable — this is a human checklist. An agent can assist if asked, but the decision to merge is human.

---

```
You are assisting a human reviewer with a non-code review of a pull request. The human does not need to read code. Walk them through this checklist:

A. SCOPE CHECK (2 minutes)
   Open the spec file linked in the PR. Count the acceptance criteria. Compare to the PR's Testing section — every criterion should be checked. If any are missing, send it back.

B. SIZE CHECK (30 seconds)
   Look at the diff size. If over 300 lines, ask the team to split it. Large PRs hide bugs.

C. FILE SCOPE CHECK (2 minutes)
   Compare "Affected Areas" in the spec to the files changed in the PR. If files outside the declared scope changed, ask why. Undeclared changes are the most common source of regressions.

D. NO SECRETS CHECK (1 minute)
   Search the diff for anything that looks like a key, token, password, or URL with credentials. Even a partial match is worth questioning.

E. TEST EVIDENCE CHECK (2 minutes)
   Look at the CI status. Green means all tests passed. Check the test count — it should be higher than before. If the count is the same or lower, something is wrong.

F. COMMIT MESSAGE CHECK (1 minute)
   Each commit should reference the spec or task file. Commits that say "fix" or "update" with no context mean the agent did not follow the rules.

G. CROSS-REVIEW CHECK (1 minute)
   The PR should have a review from a different agent than the one that wrote it. If the same agent implemented and reviewed, request a cross-review before approving.

H. ROLLBACK CHECK (30 seconds)
   The PR should state how to undo the change. "Standard revert" is fine for most changes. If the feature touches databases, APIs, or configuration, ask for more detail.

Total: approximately 10 minutes, no code reading required.

If all checks pass: Approve, merge, delete the branch, label the issue status:done.
If any check fails: Request changes and state which check failed.
```

**Output:** Merged code, deleted branch, issue labeled `status:done`.

---

## Quick Reference — Phase Chain & Context Rules

```
Phase 0: Ideate          → Issue body                    [any context]
Phase 1: Scope           → /specs/[name].md              [FRESH context, one per issue]
Phase 2: Plan            → /tasks/[name].md              [FRESH context]
Phase 2b: ExecPlan       → ExecPlan document             [same or fresh]
Phase 3: Test            → committed failing tests       [FRESH context]
Phase 4: Implement       → committed code (one task)     [FRESH context, one per task, REPEAT]
Phase 5: Review          → PASS/FAIL report              [FRESH context, different agent preferred]
Phase 5b: Cross-Review   → APPROVE/REQUEST CHANGES       [FRESH context, DIFFERENT agent required]
Phase 6: PR Create       → open PR                       [fresh or continue]
Phase 7: Merge           → merged, branch deleted        [human]
```

**Branching triggers:**
- Phase 0 → batch: produces multiple issues, each enters Phase 1 independently.
- Phase 1 → split: criteria > 7, go back to Phase 0 to decompose.
- Phase 2 → split: tasks > 5 or any task > 8 files, go back to Phase 1.
- Phase 2 → ExecPlan: long-run flagged, insert Phase 2b before Phase 3.
- Phase 4 → loop: repeat in fresh context for each task until all are done.
- Phase 5 → fail: return to Phase 4 to fix.
- Phase 5b → request changes: return to Phase 4 to fix.
- Phase 7 → changes requested: return to Phase 5.

**File connections:**
```
/specs/[name].md        produced by: Phase 1    consumed by: 2, 3 (via tasks), 4 (via tasks), 5, 5b, 6
/tasks/[name].md        produced by: Phase 2    consumed by: 3, 4, 5 (via spec link)
/decisions/[NNNN].md    produced by: Phase 4    consumed by: future sessions
ExecPlan                produced by: Phase 2b   consumed by: Phase 4 (long-run only)
PR                      produced by: Phase 6    consumed by: Phase 7
```
