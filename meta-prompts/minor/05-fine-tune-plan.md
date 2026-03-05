<!-- role: canonical-source -->
<!-- phase: 5 -->
<!-- description: Create ordered specs with ACs, model assignments, and branches -->
# Phase 5 — Fine-tune Plan

**Objective:** Finalize the build plan: order task breakdowns, write acceptance criteria, assign models, and create branch names.

**Trigger:** Phase 4 complete (architecture plan exists, AGENTS.md populated).

**Entry commands:**
- Claude: `/fine-tune`
- Copilot: `fine-tune.prompt.md`

---

## What Happens

1. For each feature spec, produce an ordered list of tasks sized for one commit
2. Write acceptance criteria using EARS + GWT formats:
   - **EARS:** `When [trigger], the system shall [response]`
   - **GWT:** `Given [context], When [action], Then [outcome]`
3. Each criterion is a machine-parseable checkbox: `- [ ] criterion`
4. Assign models using `AGENTS.md → Agent Routing Matrix`
5. Name branches using `AGENTS.md → Branch Naming`: `model/type-short-description`
6. Note which model will review each task (different from implementer)

## Gate

- Task breakdowns exist with ordered tasks
- All ACs use EARS/GWT format and are machine-parseable checkboxes
- Model assignments present for every task
- Branch names follow convention
- Second-model review assignments documented

## Output

- Updated feature specs with ordered tasks and ACs
- Model assignments and branch names recorded
- Summary table for developer approval

## See Also

- AC template: `.specify/acceptance-criteria-template.md`
- Routing matrix: `AGENTS.md → Agent Routing Matrix`
- Branch naming: `AGENTS.md → Branch Naming`
- v1 equivalent: Phase 2 (Plan) — v2 adds model assignment and EARS/GWT requirements
