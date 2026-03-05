# Remediation Plan — Best-Practice Alignment

This directory contains 9 self-contained phase documents for aligning the workflow scaffold with agentic best practices. Each phase is designed to be executed by an agent in a **fresh context window** using the meta-prompt in `docs/remediation/meta-prompt.md`.

## Execution Order

| Phase | File | Name | Depends On |
|-------|------|------|-----------|
| 1 | `phase-01.md` | AGENTS.md Decomposition | — (foundational) |
| 2 | `phase-02.md` | Autonomous Loop Architecture | Phase 1 |
| 3 | `phase-03.md` | CI Workflows & Automation | Phase 1 |
| 4 | `phase-04.md` | Issue/PR Templates & Review | Phase 1 |
| 5 | `phase-05.md` | Spec & AC Enhancement (EARS) | Phase 1 |
| 6 | `phase-06.md` | Multi-Agent Concurrency & Drift | Phase 1 |
| 7 | `phase-07.md` | Tool Configurations | Phase 1 |
| 8 | `phase-08.md` | Scripts & Test Harness Update | Phases 1–7 |
| 9 | `phase-09.md` | Documentation & Finalization | Phases 1–8 |

**Phases 3–7 may be executed in parallel** after Phase 1 completes.
Phase 8 must wait for all prior phases. Phase 9 is the final pass.

## How to Execute

Copy the contents of `meta-prompt.md` into a fresh agent session. It will:
1. Read this directory to find the next incomplete phase
2. Execute that phase to completion
3. Mark it done and report results

Repeat in fresh sessions until all phases are complete. Phase 9 deletes this directory as its final step.
