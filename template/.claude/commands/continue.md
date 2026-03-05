<!-- role: canonical-source -->
You are the orchestration brain. Your job: determine where the project is, advance to the next phase, and keep building until a stop gate.

## Note on Human-Input Phases

Phase 2 (Compass) and Phase 5 (Fine-tune Plan) always require human input. When these phases are reached, `/continue` will pause and describe what input is needed. Phase 1 (Scaffold Import) is not a phase this command manages — if scaffold files are missing, state that and stop.

## Step 1: Read Project State

Read these files (skip any that don't exist — their absence is data):

1. `.specify/constitution.md` — does it exist? Is it populated (not just placeholders)?
2. `.specify/` directory listing — any feature specs?
3. `/specs/` directory listing — any task breakdowns?
4. `/tasks/` directory listing — any tasks? What are their statuses?
5. `/AGENTS.md` — are Core Commands and Code Conventions filled in?
6. `/bugs/LOG.md` — any blocking bugs?
7. Recent git log (last 10 commits) — what was last worked on?
8. Test results — run the test suite if Core Commands are populated.
9. Scaffold presence check — do `AGENTS.md`, `.specify/`, `workflow/` exist? If not, scaffold is missing.

## Step 2: Determine Current Phase

Check exit criteria in order. The current phase is the first one whose exit criteria are NOT met:

| Phase | Exit Criteria |
|-------|--------------|
| 2 — Compass | `.specify/constitution.md` exists with all 8 sections populated (no `[PROJECT-SPECIFIC]` placeholders) |
| 3 — Define Features | At least one feature spec exists in `/specs/` with Compass mapping |
| 4 — Scaffold Project | `AGENTS.md` Code Conventions section is populated (not placeholder). Folder structure documented. |
| 5 — Fine-tune Plan | Task breakdowns exist with ordered tasks, ACs (EARS/GWT format), model assignments, branch names |
| 6 — Code | All tasks in current feature's task file are marked Complete. Tests pass. |
| 7 — Test | All acceptance criteria verified. Bug log reviewed. No blocking bugs. |
| 7b — Review & Ship | PR created, reviewed (cross-agent review passed), and merged to main. |
| 8 — Maintain | README exists. CONTRIBUTING exists. Security baseline checked. |

## Step 3: Execute the Phase

Run the appropriate command for the current phase:

| Phase | Action |
|-------|--------|
| 2 | Run `/compass` — start the adaptive interview |
| 3 | Run `/define-features` — translate constitution into features |
| 4 | Run `/scaffold` — reason about architecture (no code) |
| 5 | Run `/fine-tune` — create ordered specs with ACs and assignments |
| 6 | Run `/implement` with the next incomplete task file |
| 7 | Run `/test` with the current feature's task file |
| 7b | Run `/review`, then `/cross-review`, then `/pr-create`, then `/merge` |
| 8 | Run `/maintain` in initial mode |

## Step 4: After Phase Completes

Re-check exit criteria for the phase just executed:
- **Met** → advance to the next phase. Go back to Step 2.
- **Not met** → report what's missing. If it needs human input, hit the stop gate.

## Stop Gates (Pause and Report)

Stop and clearly state the situation when:
- **Human input needed** — Compass questions, design decisions, ambiguous requirements
- **Blocking bug** — a bug with severity "blocking" exists in the log
- **All features complete** — Phase 8 exit criteria met for all features. State: "All features implemented, tested, and documented. Ready for human testing."
- **Test failures unresolvable** — implementation cannot satisfy ACs after 2 attempts
- **Scope question** — something needed that isn't in the constitution

When stopping, always state:
1. Current phase and what was accomplished
2. What's blocking progress
3. What the developer needs to do
4. The command to resume: `/continue`

## Multi-Feature Loop

If multiple features exist:
1. Complete Phases 6–7b for each feature before moving to Phase 8.
2. Prioritize features in the order listed in the fine-tuned plan.
3. After all features pass Phase 7b (merged to main), run Phase 8 once.

## Rules

- Never skip a phase — phases are sequential for a reason.
- Never fabricate exit criteria evidence — actually check.
- If in doubt about phase status, re-read the artifacts.
- Log all phase transitions: "Advancing from Phase N to Phase N+1. Reason: [exit criteria met]."
