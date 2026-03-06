# Agentic End-to-End Test Plan

> **Purpose:** Define the objective, architecture, success criteria, and scoring rubric for validating the workflow repo by building a new project from inception to completion.

---

## 1. Objective

Validate that the Agent Workflow system works as designed by executing every phase (1–8 + Bug Track) against a new project, using all three supported tools (Copilot, Claude Code, Codex). Specifically:

- **Execution order:** Phases run in the documented sequence with correct gates
- **Tool handoffs:** Each tool receives the right context and produces the right artifacts
- **`/continue` transitions:** The orchestrator correctly detects state, advances phases, and persists progress
- **Loop/phase behavior:** Per-feature cycles (test → implement → test → review) work correctly
- **Debugging path:** `/bug` and `/bugfix` correctly log, reproduce, diagnose, fix, and verify issues
- **Observability:** The experiment observer captures enough detail to identify what to change

---

## 2. Target Project: Hello World (Windows .exe from WSL)

| Property | Value |
|----------|-------|
| **Name** | `hello-verify` |
| **Language** | C |
| **Toolchain** | `x86_64-w64-mingw32-gcc` (mingw-w64 cross-compiler) |
| **Platform** | Windows x86_64 `.exe`, cross-compiled from WSL/Linux |
| **Output** | `hello.exe` that prints `Hello, world!\n` to stdout and exits 0 |
| **Complexity** | Minimal code, maximum workflow exercise |

**Why Windows cross-compilation?** It forces the agent to reason about:
- Cross-compiler installation (`sudo apt install mingw-w64`)
- Target triple selection (`x86_64-w64-mingw32-gcc` vs `i686-w64-mingw32-gcc`)
- Output verification strategy (can't run `.exe` natively on Linux — needs Wine or file inspection)
- Makefile/build system for cross-compilation
- Platform-specific testing constraints

This is intentionally harder than a native "Hello, world" to stress-test the workflow's ability to handle non-trivial toolchain decisions.

---

## 3. Architecture: Three-Directory Model

```
/home/josiah/
├── workflow/                  ← SOURCE (read-only during test)
│   ├── docs/verification/     ← Test kit documents (this file)
│   ├── template/              ← Scaffold source
│   ├── scripts/               ← install.sh, sync-prompts.sh, etc.
│   ├── meta-prompts/          ← Phase definitions
│   └── prompts/               ← Copilot prompt files
│
├── workflow-example/          ← REFERENCE (read-only oracle)
│   ├── .specify/constitution.md
│   ├── specs/001-task-crud.md
│   ├── tasks/001-task-crud.md
│   ├── decisions/0001-sqlite-storage.md
│   ├── bugs/LOG.md
│   └── workflow/STATE.json
│
└── hello-verify/              ← TARGET (agent works here)
    ├── AGENTS.md              ← Patched with observer reference
    ├── CLAUDE.md              ← Patched with observer bootstrap step
    ├── workflow/
    │   ├── EXPERIMENT_OBSERVER.md  ← Injected from docs/verification/
    │   ├── BOUNDARIES.md           ← Patched with logging ALWAYS rule
    │   ├── STATE.json
    │   └── ... (workflow policy files)
    ├── experiment-log.md      ← Agent writes here autonomously
    ├── .specify/
    │   └── constitution.md    ← Created in Phase 2
    ├── specs/                 ← Created in Phase 3
    ├── tasks/                 ← Created in Phase 5
    ├── src/
    │   └── hello.c            ← Created in Phase 6
    ├── tests/                 ← Created in Phase 6
    ├── Makefile               ← Created in Phase 4/6
    └── bugs/
        └── LOG.md             ← Created in Phase 7 (bug injection)
```

### Role of Each Directory

| Directory | Role | Modified? |
|-----------|------|-----------|
| `workflow/` | Source of truth for the workflow system. Scripts, templates, and docs live here. | No — read-only during test |
| `workflow-example/` | Completed TaskFlow CLI example. Used to compare artifact structure at each phase. | No — read-only oracle |
| `hello-verify/` | The new project being built. Agent works here. `/continue` runs from this root. | Yes — primary workspace |

### Why This Model Works for `/continue`

1. `install.sh` copies the **full scaffold** (AGENTS.md, workflow/, .claude/, prompts, meta-prompts) into `hello-verify/`
2. Every tool reads `AGENTS.md` first → it's in `hello-verify/` root → no context re-injection needed
3. `workflow/STATE.json` persists phase state → `/continue` resumes correctly across sessions
4. The experiment observer is in `workflow/EXPERIMENT_OBSERVER.md` → referenced by AGENTS.md → picked up automatically
5. Opening `hello-verify/` as its own VS Code window gives the agent a clean project context

---

## 4. Experiment Observer

The observer makes the agent self-log every action to `experiment-log.md`. See [`experiment_observer.md`](experiment_observer.md) for the full contract.

**Key points:**
- Injected post-scaffold by copying into `hello-verify/workflow/EXPERIMENT_OBSERVER.md`
- Referenced in AGENTS.md Quick Reference table → agent reads it on session start
- Append-only structured markdown with severity levels (info/warning/error/critical)
- Agent logs: files read/written, commands + output, decisions, failures, retries, instruction clarity issues, proposed fixes
- After test: `experiment-log.md` is copied back to `workflow/docs/verification/` for analysis

---

## 5. Dual-Repo Validation

At each phase, compare the hello-verify artifacts against workflow-example:

| Phase | hello-verify Artifact | workflow-example Oracle | What to Compare |
|-------|----------------------|------------------------|-----------------|
| 2 | `.specify/constitution.md` | `.specify/constitution.md` | All 8 sections present, no placeholders |
| 3 | `specs/001-hello-world.md` | `specs/001-task-crud.md` | Feature ID format, 3–7 ACs, GWT format |
| 5 | `tasks/001-hello-world.md` | `tasks/001-task-crud.md` | Task breakdown, AC mapping, model assignment |
| 6 | `src/hello.c` + `Makefile` | *(no source in example)* | Code exists, builds successfully |
| 7-Bug | `bugs/LOG.md` | `bugs/LOG.md` | BUG-NNN format, all fields present |
| 7b | *(review artifact)* | *(not in example)* | PASS/FAIL with criterion evidence |
| State | `workflow/STATE.json` | `workflow/STATE.json` | Phase advances correctly, schema matches |

---

## 6. What Must Be Observed and Recorded

The experiment observer captures these dimensions automatically in `experiment-log.md`:

| Dimension | What to Record |
|-----------|---------------|
| **Execution order** | Which phases were entered, in what order |
| **Phase gates** | Whether gate criteria were checked before advancing |
| **Files read** | Every file the agent reads, with purpose |
| **Files written** | Every artifact created or modified |
| **Commands executed** | Build/test/git commands with exit codes and output |
| **Tool used** | Which tool (Copilot/Claude Code/Codex) executed each step |
| **Decisions** | Choices between alternatives and reasoning |
| **Loops/retries** | How many times an action was retried and why |
| **Files skipped** | What was skipped and the reason |
| **Instruction issues** | Ambiguous, contradictory, or missing instructions |
| **Context confusion** | Conflicting information across files |
| **Proposed fixes** | What should change in the workflow repo |

---

## 7. Scoring Rubric

### Per-Phase Scoring (6 criteria each)

For each workflow phase, score these criteria as PASS (1) or FAIL (0):

| # | Criterion | How to Verify |
|---|-----------|---------------|
| 1 | **Phase entered correctly** | STATE.json shows correct `projectPhase` value |
| 2 | **Inputs read correctly** | experiment-log.md shows the right files were read |
| 3 | **Outputs produced correctly** | Expected artifacts exist and match schema in FILE_CONTRACTS.md |
| 4 | **Tool handoff executed** | If phase was assigned to a different tool, handoff is logged |
| 5 | **`/continue` transition worked** | STATE.json updated, next phase detected correctly |
| 6 | **Observer entry logged** | experiment-log.md has an entry for this phase |

### Phase Checklist

| Phase | P1: Entered | P2: Inputs | P3: Outputs | P4: Handoff | P5: Transition | P6: Logged | Score |
|-------|:-----------:|:----------:|:-----------:|:-----------:|:--------------:|:----------:|:-----:|
| 1. Scaffold | | | | | | | /6 |
| 2. Compass | | | | | | | /6 |
| 3. Define Features | | | | | | | /6 |
| 4. Scaffold Project | | | | | | | /6 |
| 5. Fine-tune | | | | | | | /6 |
| 6. Code | | | | | | | /6 |
| 6.5 Bug Injection | | | | | | | /6 |
| 7. Bug Track | | | | | | | /6 |
| 7b. Review & Ship | | | | | | | /6 |
| 8. Maintain | | | | | | | /6 |
| **Total** | | | | | | | **/60** |

### Overall Score Interpretation

| Score | Verdict | Action |
|-------|---------|--------|
| 54–60 (90–100%) | **PASS** | Workflow works as designed. Minor polish only. |
| 42–53 (70–89%) | **PASS WITH ISSUES** | Workflow works but has documentation gaps or friction points. Address logged issues. |
| 30–41 (50–69%) | **CONDITIONAL** | Workflow partially works. Significant fixes needed before recommending to others. |
| 0–29 (<50%) | **FAIL** | Workflow has fundamental issues. Major revision required. |

---

## 8. Tool Coverage Plan

Each phase can be executed by any of the three tools. To test tool handoffs, the runbook assigns specific tools to specific phases:

| Phase | Primary Tool | Alternate Run |
|-------|-------------|---------------|
| 1. Scaffold | Manual (install.sh) | Same for all |
| 2. Compass | Copilot (`compass.prompt.md`) | Claude Code (`/compass`) |
| 3. Define Features | Copilot (`define-features.prompt.md`) | Claude Code (`/define-features`) |
| 4. Scaffold Project | Claude Code (`/scaffold`) | Copilot (`scaffold.prompt.md`) |
| 5. Fine-tune | Copilot (`fine-tune.prompt.md`) | Codex (batch) |
| 6. Code | Codex (batch `implement`) | Copilot (`implement.prompt.md`) |
| 6.5 Bug Injection | Manual | Same for all |
| 7. Bug Track | Claude Code (`/bug`, `/bugfix`) | Copilot (`bug.prompt.md`, `bugfix.prompt.md`) |
| 7b. Review | Copilot (`review-session.prompt.md`) | Claude Code (`/cross-review`) |
| 8. Maintain | Copilot (`maintain.prompt.md`) | Claude Code (`/maintain`) |

This ensures each tool is primary for at least 2 phases and alternate for at least 2 others.

---

## 9. Success Criteria Summary

The test is successful when ALL of these are true:

1. [ ] `hello.exe` exists and is a valid Windows PE executable
2. [ ] Running `hello.exe` (via Wine or Windows) prints `Hello, world!` and exits 0
3. [ ] All workflow phases (1–8) were entered in correct order
4. [ ] `workflow/STATE.json` reflects phase 8-maintain or done
5. [ ] Bug injection was detected, logged via `/bug`, and fixed via `/bugfix`
6. [ ] `experiment-log.md` has entries for every phase with no gaps
7. [ ] At least one tool handoff occurred and was logged
8. [ ] All artifacts match FILE_CONTRACTS.md schemas (constitution, spec, task, bug log)
9. [ ] Overall score ≥ 42/60 (70%)
10. [ ] `experiment-log.md` contains actionable proposed fixes (even if the finding is "no issues")

---

## 10. Verification Maintenance Sub-Process

This is a verification-only parallel process that runs from `docs/verification/`.

### Intent

1. Detect issues in `~/hello-verify/experiment-log.md`.
2. Perform local discovery and remediation design in `~/workflow`.
3. Implement generic/local fixes in `~/workflow` first.
4. Copy selected outputs to `~/hello-verify` for dry-run validation.

### Required Artifacts

- `docs/verification/agentic_test_change_proposals.md` (CP entries + statuses)
- `experiment_findings/phaseN_name/README.md`
- `experiment_findings/phaseN_name/01-issue-summary.md`
- `experiment_findings/phaseN_name/02-phased-remediation-plan.md`
- `experiment_findings/phaseN_name/03-file-impact-matrix.md`
- `experiment_findings/phaseN_name/04-copy-manifest.md`

### Success Criteria

1. [ ] At least one error/warning finding is translated to a CP with evidence line references.
2. [ ] Findings bundle is created in `~/workflow` using the standard folder structure.
3. [ ] Copy-forward dry-run reports expected file changes only.
4. [ ] Copy-forward apply succeeds and scaffold validation still passes in `~/hello-verify`.
5. [ ] Dry-run pass result is logged in `~/hello-verify/experiment-log.md`.
