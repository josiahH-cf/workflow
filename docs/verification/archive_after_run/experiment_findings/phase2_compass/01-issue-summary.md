# Issue Summary — Phase 2 Compass

## Evidence Source

- `/home/josiah/hello-verify/experiment-log.md`

## Key Findings

### 1. Scaffold validator path ambiguity (CP-001 — implemented)

- **Severity:** error
- **Evidence:** `experiment-log.md` entry `[2-compass] 2026-03-05T13:52:03` — `./validate-scaffold.sh` exit 127 ("No such file or directory")
- **Root cause:** Runbook and initialization instructions referenced `./validate-scaffold.sh` without specifying the full path `scripts/validate-scaffold.sh`.
- **Impact:** False setup failure; agent fell back to manual file-by-file verification.
- **Status:** Fixed in CP-001 — explicit script path now used.

### 2. Constitution write blocked by governance (CP-003 — proposed)

- **Severity:** error
- **Evidence:** `experiment-log.md` entry `[2-compass] 2026-03-05T14:16:38` — "Constitution write was blocked during Compass even though Compass requires writing `.specify/constitution.md`"
- **Root cause:** `constitution.md` header says "read-only during normal workflow. Edit only via `/compass-edit`", which governance enforcement interpreted as blocking the exact phase that must write the file.
- **Impact:** Compass phase stalled; constitution could not be populated.

### 3. Agent stoppage from governance/tooling blockage (CP-004 — new)

- **Severity:** error
- **Evidence:** `experiment-log.md` entry `[2-compass] 2026-03-05T14:16:39` — "Assistant became blocked from applying in-workspace edits during constitution-phase follow-up, causing stoppage and requiring deferred/manual patch suggestion"
- **Root cause:** No documented recovery path exists for when governance policy blocks a write that the current phase explicitly requires.
- **Impact:** Agent progress halted entirely; edits were deferred and required manual intervention in a subsequent chat session.
