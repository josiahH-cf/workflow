# Analyze Test Findings — Meta-Prompt

Paste this into a coding agent session **in the `~/workflow/` directory** after the hello-verify test run is complete and `experiment-log.md` has been copied back.

> **Prerequisites:**
> - Test run is finished (STATE.json shows `"done"` or the test was stopped early).
> - `experiment-log.md` has been copied: `cp ~/hello-verify/experiment-log.md ~/workflow/docs/verification/experiment-log.md`
> - The following template files exist in `docs/verification/`:
>   - [`agentic_test_log_template.md`](agentic_test_log_template.md) — summary template to fill
>   - [`agentic_test_change_proposals.md`](agentic_test_change_proposals.md) — change proposal template to fill
>   - [`agentic_test_plan.md`](agentic_test_plan.md) — scoring criteria reference

---

```text
You are the analysis agent for an Agent Workflow verification test. A separate
agent just completed a full workflow run (Phases 1–8 + Bug Track) to build
a "hello-verify" Windows executable from C using mingw-w64. That agent
self-logged every action to experiment-log.md per the experiment observer
contract. Your job: parse the log, score the run, and produce actionable
change proposals for the workflow repo.

You will fill in two existing template files. Do not create new files.
Do not modify experiment-log.md — it is read-only evidence.

---

STEP 1 — LOAD CONTEXT

Read these files in order:
1. docs/verification/experiment-log.md          — the raw log (primary input)
2. docs/verification/agentic_test_plan.md       — scoring criteria (§7)
3. docs/verification/agentic_test_log_template.md   — template to fill (output 1)
4. docs/verification/agentic_test_change_proposals.md — template to fill (output 2)
5. docs/verification/experiment_observer.md     — observer contract (reference)
6. docs/verification/agentic_test_runbook.md    — phase expectations (reference)

After reading all six files, report:
  "Loaded [N] experiment-log entries across [M] phases.
   Severity breakdown: [X] info, [Y] warning, [Z] error, [W] critical."

---

STEP 2 — PARSE THE EXPERIMENT LOG

Extract every entry from experiment-log.md. For each entry, capture:
  - Phase name
  - Timestamp
  - Severity (info / warning / error / critical)
  - Tool used
  - Action description
  - Files read (list)
  - Files written (list)
  - Commands run (with exit codes)
  - Decision made (if any)
  - Failure description (if any)
  - Instruction clarity rating and details
  - Retry count and trigger
  - Files skipped (list)
  - Proposed workflow fix (if any)

Build an internal index of all entries grouped by phase and by severity.

---

STEP 3 — SCORE PER-PHASE

For each phase (1 through 8, plus 6.5 Bug Injection and 7 Bug Track),
evaluate six criteria from agentic_test_plan.md §7. Score each as
PASS (1) or FAIL (0):

  1. Entered — Did the agent enter this phase?
  2. Inputs — Did it read the correct input files?
  3. Outputs — Did it produce the required output artifacts?
  4. Handoff — Did the tool adapter / session bootstrap work?
  5. Transition — Did STATE.json advance correctly?
  6. Logged — Did the agent log this phase to experiment-log.md?

Calculate per-phase scores (/6) and aggregate total (/60).

Determine the verdict:
  54–60 (90%+)  → PASS
  42–53 (70–89%) → PASS WITH ISSUES
  30–41 (50–69%) → CONDITIONAL
  0–29  (<50%)   → FAIL

---

STEP 4 — FILL THE LOG TEMPLATE

Open docs/verification/agentic_test_log_template.md and fill in every section:

4a. Test Metadata — date, executor, tools, duration, sessions, final phase.

4b. Severity Summary — count entries per severity level, note key themes.

4c. Per-Phase Scoring — fill the scoring table from Step 3.

4d. Phase-by-Phase Detail — for each phase, fill:
  Timestamp, Tool, Files read, Files written, Commands run, Decisions,
  Loops/retries, Files skipped, Issues.
  Pull all values directly from experiment-log.md entries for that phase.

4e. Instruction Clarity Analysis — extract all entries where instruction
  clarity was NOT "clear" (i.e., ambiguous, contradictory, missing).
  Fill the table with: phase, file/section, clarity rating, issue, proposed fix.

4f. Tool Handoff Analysis — extract all tool handoff entries.
  Fill the table with: from-tool, to-tool, phase, what was handed off,
  whether context was lost.

4g. /continue Transition Analysis — extract all entries involving /continue
  or STATE.json transitions. Fill: invocation, state before, detected phase,
  whether detection was correct, action taken.

4h. Final Outcome — answer every question:
  Did pipeline reach "done"? Was hello.exe produced? Valid PE? Correct output?
  Bug detected and fixed? Phases in order? Aggregate score? Verdict?
  Confidence (1–5)? Critical blockers? Top 3 issues? Recommended next action?

Save the filled template.

---

STEP 5 — GENERATE CHANGE PROPOSALS

Open docs/verification/agentic_test_change_proposals.md.

5a. Extract all "Proposed workflow fix" entries from experiment-log.md where
  severity is warning, error, or critical.

5b. For each proposed fix, create a CP-NNN entry using the template format:
  - CP number (sequential: CP-001, CP-002, ...)
  - Short title
  - Target file (repo-relative path in ~/workflow/)
  - Section/line
  - Category (from the 10 categories in the template: instruction-clarity,
    instruction-conflict, missing-step, wrong-gate, broken-reference,
    toolchain-gap, state-corruption, parity-drift, bug-path-gap, scope-violation)
  - Severity (from the experiment-log entry)
  - Evidence (quote or reference the experiment-log entry)
  - What to change (specific edit)
  - Why (what went wrong, with evidence)
  - Expected improvement
  - How to validate (re-run phase, check output, etc.)

5c. If the experiment log also contains info-level entries with proposed fixes
  that represent genuine improvements (not just "N/A"), include those as
  lower-priority proposals after the warning+ entries.

5d. De-duplicate: if multiple entries propose the same fix to the same file,
  merge them into one proposal with combined evidence.

5e. Fill the Summary table: count proposals per category and note highest
  severity in each.

5f. Fill the Next Steps checklist at the bottom.

Save the filled proposals file.

---

STEP 6 — CROSS-CHECK AND REPORT

Before finishing, cross-check:
  - Every warning/error/critical entry in experiment-log.md has a corresponding
    CP-NNN proposal (or an explicit note why no change is needed).
  - The per-phase scores in the log template are consistent with the detail tables.
  - The aggregate score matches the sum of per-phase scores.
  - The verdict matches the score interpretation table.

Report any inconsistencies you find and fix them.

---

STEP 7 — FINAL SUMMARY

Print a brief summary to the chat:

  ## Verification Test Results

  **Aggregate score:** [N]/60 — [VERDICT]
  **Entries:** [total] ([info] info, [warning] warning, [error] error, [critical] critical)
  **Change proposals:** [N] (highest severity: [level])

  **Top issues:**
  1. [one-line description]
  2. [one-line description]
  3. [one-line description]

  **Files updated:**
  - docs/verification/agentic_test_log_template.md (filled)
  - docs/verification/agentic_test_change_proposals.md (filled)

  **Recommended next action:** [one sentence]

Then tell the human:
"Analysis complete. Review the two filled templates, then commit:
  cd ~/workflow
  git add docs/verification/
  git commit -m 'docs: add agentic test results from hello-verify run'"

---

RULES:

1. Do not modify experiment-log.md. It is append-only evidence from the test run.
2. Do not create new files. Fill the two existing templates in place.
3. Use exact quotes from experiment-log.md as evidence in change proposals.
4. If the experiment log is incomplete (e.g., test was stopped early), score
   un-entered phases as 0/6 and note "phase not reached" in the detail table.
5. Be precise about file paths: use repo-relative paths from ~/workflow/ for
   target files in change proposals (e.g., template/workflow/PLAYBOOK.md).
6. If the experiment log has no warning+ entries, report that as a positive
   outcome and create zero change proposals. Do not invent issues.
7. Assign categories strictly from the 10-category list. If an issue doesn't
   fit cleanly, choose the closest match and note the ambiguity.
```
