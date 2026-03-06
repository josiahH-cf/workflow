# Phased Remediation Plan — Phase 2 Compass

## Phase A — Capture and classify

- Parse `~/hello-verify/experiment-log.md` for error entries in `[2-compass]` phase.
- Group findings by target file family.
- Open CP entries in `docs/verification/agentic_test_change_proposals.md`.

## Phase B — Local generic remediation

- **CP-001 (done):** Explicit script path for scaffold validation.
- **CP-003:** Clarify `constitution.md` header comment to allow Compass-phase writes; add exception note in BOUNDARIES.md ASK FIRST section.
- **CP-004:** Add "Governance Blockage Recovery" subsection to BOUNDARIES.md with log → retry → escalate pattern.

## Phase C — Copy-forward and validate

- Build `04-copy-manifest.md` with all files to transfer.
- Execute `rsync --dry-run` then `rsync` to `~/hello-verify/experiment_findings/`.
- Run `bash /home/josiah/workflow/scripts/validate-scaffold.sh /home/josiah/hello-verify`.
- Log dry-run pass/fail in `~/hello-verify/experiment-log.md`.

## Acceptance

- CP-003 constitution.md comment allows Phase 2 writes.
- CP-004 BOUNDARIES.md has governance blockage recovery subsection.
- Scaffold validation passes after copy-forward.
