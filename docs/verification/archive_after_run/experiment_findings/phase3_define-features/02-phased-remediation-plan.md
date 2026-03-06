# Phased Remediation Plan

## Phase A - Capture and classify
- Parse `~/hello-verify/experiment-log.md` for warning/error/critical entries.
- Group findings by target file family.
- Open CP entries in `docs/verification/agentic_test_change_proposals.md`.

## Phase B - Local generic remediation
- Update verification docs to remove command-path ambiguity.
- Define completion evidence requirements for Define Features.
- Clarify Compass constitution write policy boundaries.

## Phase C - Copy-forward and validate
- Build `04-copy-manifest.md` with all files to transfer.
- Execute `rsync --dry-run` then `rsync` to `~/hello-verify/experiment_findings/`.
- Run `bash /home/josiah/workflow/scripts/validate-scaffold.sh /home/josiah/hello-verify`.
- Log dry-run pass/fail in `~/hello-verify/experiment-log.md`.
