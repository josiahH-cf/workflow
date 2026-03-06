# Agentic Test Log — Summary Template

> **Purpose:** Human-facing summary of the agentic test run. Synthesized from `experiment-log.md` after copying it back from the test project.
>
> **How to use:** After the test completes, copy `~/hello-verify/experiment-log.md` to this directory. Then fill in this template by parsing the log entries.

---

## Test Metadata

| Field | Value |
|-------|-------|
| **Date** | |
| **Executor** | |
| **Primary tool** | Copilot / Claude Code / Codex |
| **Tools used** | |
| **Test project path** | `~/hello-verify/` |
| **Workflow repo commit** | |
| **Total duration** | |
| **Sessions used** | |
| **Final STATE.json phase** | |

---

## Severity Summary

| Severity | Count | Key Themes |
|----------|-------|------------|
| `info` | | |
| `warning` | | |
| `error` | | |
| `critical` | | |
| **Total entries** | | |

---

## Per-Phase Scoring

Score each criterion as PASS (1) or FAIL (0). See [`agentic_test_plan.md`](agentic_test_plan.md) §7 for criteria definitions.

| Phase | Entered | Inputs | Outputs | Handoff | Transition | Logged | Score | Notes |
|-------|:-------:|:------:|:-------:|:-------:|:----------:|:------:|:-----:|-------|
| 1. Scaffold | | | | | | | /6 | |
| 2. Compass | | | | | | | /6 | |
| 3. Define Features | | | | | | | /6 | |
| 4. Scaffold Project | | | | | | | /6 | |
| 5. Fine-tune | | | | | | | /6 | |
| 6. Code | | | | | | | /6 | |
| 6.5 Bug Injection | | | | | | | /6 | |
| 7. Bug Track | | | | | | | /6 | |
| 7b. Review & Ship | | | | | | | /6 | |
| 8. Maintain | | | | | | | /6 | |
| **Total** | | | | | | | **/60** | |

### Score Interpretation

| Score | Verdict |
|-------|---------|
| 54–60 (90%+) | **PASS** — Workflow works as designed |
| 42–53 (70–89%) | **PASS WITH ISSUES** — Works but has friction |
| 30–41 (50–69%) | **CONDITIONAL** — Significant fixes needed |
| 0–29 (<50%) | **FAIL** — Major revision required |

---

## Phase-by-Phase Detail

### Phase 1 — Scaffold Import

| Dimension | Value |
|-----------|-------|
| **Timestamp** | |
| **Tool** | |
| **Files read** | |
| **Files written** | |
| **Commands run** | |
| **Decisions** | |
| **Loops/retries** | |
| **Files skipped** | |
| **Issues** | |

---

### Phase 2 — Compass

| Dimension | Value |
|-----------|-------|
| **Timestamp** | |
| **Tool** | |
| **Files read** | |
| **Files written** | |
| **Commands run** | |
| **Decisions** | |
| **Loops/retries** | |
| **Files skipped** | |
| **Issues** | |

---

### Phase 3 — Define Features

| Dimension | Value |
|-----------|-------|
| **Timestamp** | |
| **Tool** | |
| **Files read** | |
| **Files written** | |
| **Commands run** | |
| **Decisions** | |
| **Loops/retries** | |
| **Files skipped** | |
| **Issues** | |

---

### Phase 4 — Scaffold Project

| Dimension | Value |
|-----------|-------|
| **Timestamp** | |
| **Tool** | |
| **Files read** | |
| **Files written** | |
| **Commands run** | |
| **Decisions** | |
| **Loops/retries** | |
| **Files skipped** | |
| **Issues** | |

---

### Phase 5 — Fine-Tune Plan

| Dimension | Value |
|-----------|-------|
| **Timestamp** | |
| **Tool** | |
| **Files read** | |
| **Files written** | |
| **Commands run** | |
| **Decisions** | |
| **Loops/retries** | |
| **Files skipped** | |
| **Issues** | |

---

### Phase 6 — Code (TDD)

| Dimension | Value |
|-----------|-------|
| **Timestamp** | |
| **Tool** | |
| **Files read** | |
| **Files written** | |
| **Commands run** | |
| **Decisions** | |
| **Loops/retries** | |
| **Files skipped** | |
| **Issues** | |

---

### Phase 6.5 — Bug Injection

| Dimension | Value |
|-----------|-------|
| **Timestamp** | |
| **Tool** | Manual (human) |
| **Bug introduced** | |
| **Detection method** | |
| **Agent detected?** | Yes / No |

---

### Phase 7 — Bug Track

| Dimension | Value |
|-----------|-------|
| **Timestamp** | |
| **Tool** | |
| **Files read** | |
| **Files written** | |
| **Commands run** | |
| **Bug ID** | |
| **Root cause identified?** | Yes / No |
| **Fix correct?** | Yes / No |
| **Loops/retries** | |
| **Issues** | |

---

### Phase 7b — Review & Ship

| Dimension | Value |
|-----------|-------|
| **Timestamp** | |
| **Tool** | |
| **Files read** | |
| **Files written** | |
| **ACs verified** | AC-1: / AC-2: / AC-3: / AC-4: |
| **Review result** | PASS / FAIL |
| **Cross-review done?** | Yes / No |
| **PR created?** | Yes / No |
| **Issues** | |

---

### Phase 8 — Maintain

| Dimension | Value |
|-----------|-------|
| **Timestamp** | |
| **Tool** | |
| **Files read** | |
| **Files written** | |
| **Commands run** | |
| **README generated?** | Yes / No |
| **Compliance check** | PASS / FAIL / Skipped |
| **Issues** | |

---

## Instruction Clarity Analysis

Extract all `warning`, `error`, and `critical` entries where **Instruction clarity** was not "clear":

| # | Phase | File/Section | Clarity Rating | Issue Description | Proposed Fix |
|---|-------|-------------|----------------|-------------------|-------------|
| 1 | | | | | |
| 2 | | | | | |
| 3 | | | | | |
| 4 | | | | | |
| 5 | | | | | |

---

## Tool Handoff Analysis

Record every instance where work transferred between tools:

| # | From Tool | To Tool | Phase | What Was Handed Off | Context Loss? | Notes |
|---|-----------|---------|-------|--------------------|--------------:|-------|
| 1 | | | | | Yes / No | |
| 2 | | | | | Yes / No | |
| 3 | | | | | Yes / No | |

---

## `/continue` Transition Analysis

Record every `/continue` invocation and whether it correctly detected state:

| # | Invocation | STATE.json Before | Detected Phase | Correct? | Action Taken | Notes |
|---|-----------|-------------------|----------------|----------|-------------|-------|
| 1 | | | | Yes / No | | |
| 2 | | | | Yes / No | | |
| 3 | | | | Yes / No | | |
| 4 | | | | Yes / No | | |
| 5 | | | | Yes / No | | |

---

## Final Outcome

| Question | Answer |
|----------|--------|
| **Did the workflow reach the end state (`done`)?** | Yes / No |
| **Was `hello.exe` produced?** | Yes / No |
| **Is `hello.exe` a valid Windows PE executable?** | Yes / No |
| **Does `hello.exe` print "Hello, world!"?** | Yes / No / Not tested |
| **Was the injected bug detected and fixed?** | Yes / No |
| **Were all phases entered in correct order?** | Yes / No |
| **Aggregate score** | /60 |
| **Verdict** | PASS / PASS WITH ISSUES / CONDITIONAL / FAIL |
| **Confidence (1–5)** | |
| **Critical blockers found** | |
| **Top 3 issues** | 1. <br> 2. <br> 3. |
| **Recommended next action** | |
