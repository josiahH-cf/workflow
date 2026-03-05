# Workflow Scaffold Simplification — Phase Tracker

> **Orchestrator**: Run `meta-prompts/simplify.md` to execute the current phase.
> Each phase is designed for **fresh context** — start a new session per phase.

## North Star

*"Install scaffold. Run commands. Ship a tested, reviewed feature with full traceability."*

### Golden Path

```
install → /compass → /define-features → /scaffold → /fine-tune → /continue
                                                          ↕
                                                    /bug (concurrent)
```

- `/define-features` = "what to build" (capabilities → feature specs)
- `/scaffold` = "how it's structured" (technical architecture)
- `/fine-tune` = "build order + assignments" (tasks, ACs, model assignments, branch naming)
- `/continue` = orchestrator (loops through code → test → review → ship → next feature)

---

## Phase Progress

- [x] **Phase 0** — North Star Alignment + Create Phase Docs
- [x] **Phase 1** — Delete Legacy + Flatten Meta-Prompts + Remove Version Language
- [x] **Phase 2** — Trim Template + Merge Workflow Docs + Delete Archive
- [x] **Phase 3** — Unify Installation + Onboarding
- [x] **Phase 4** — Extract Sample Project to `workflow-example` Repo
- [ ] **Phase 5** — New Workflow Diagram + Final Verification
- [ ] **Phase 6** — Cleanup (delete this directory + orchestrator meta-prompt)

---

## Global Acceptance Criteria (All Phases Complete)

- [ ] No legacy commands exist (ideate, scope, plan, execplan, pr-create, merge, fix-prompt)
- [ ] No "V1"/"V2"/"legacy" language anywhere in active files
- [ ] `meta-prompts/` is flat — no `major/` or `minor/` subdirectories
- [ ] Cross-review preserved as optional `07e-cross-review.md`
- [ ] `05-fine-tune-plan.md` includes model assignments + branch naming
- [ ] `archive/` deleted, `workflow-diagram.svg` deleted
- [ ] `examples/` moved to `workflow-example` GitHub repo, linked from README
- [ ] `workflow/SPECS.md` merged into `FILE_CONTRACTS.md`
- [ ] Platform files (`.github/ISSUE_TEMPLATE/`, `.github/agents/`, `.codex/`) are opt-in install flags
- [ ] `install.sh` defaults include prompts + meta-prompts, works with no flags
- [ ] README.md ≤ 100 lines with honest description + quickstart
- [ ] New Mermaid workflow diagram committed
- [ ] All test scripts pass
- [ ] `sync-prompts.sh --check` passes
- [ ] AGENTS.md routing table matches actual available commands
- [ ] `docs/simplification/` and `meta-prompts/simplify.md` deleted (self-cleanup)

---

## How to Run

1. Open a fresh AI session (Claude Code, Copilot Chat, or equivalent)
2. Paste or invoke `meta-prompts/simplify.md`
3. The orchestrator reads this README, identifies the next unchecked phase, reads `phase-N.md`, and executes it
4. After completion, it checks off the phase above
5. Start a new session for the next phase
