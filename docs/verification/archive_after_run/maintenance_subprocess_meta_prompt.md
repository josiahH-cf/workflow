Read `docs/verification/agentic_test_change_proposals.md`, `docs/verification/agentic_test_runbook.md`, and `~/hello-verify/experiment-log.md`.
Extract warning/error/critical findings and create or update `experiment_findings/phaseN_name/` in this repo.
Translate findings into CP entries with evidence references, then implement generic/local fixes in this repo first.
Do not copy core files from `~/hello-verify` back here; only read/copy evidence artifacts like `experiment-log.md`.
Prepare `04-copy-manifest.md`, dry-run/apply copy forward to `~/hello-verify`, validate scaffold, and log pass/fail there.
After implementing fixes, overwrite the corresponding files in `~/hello-verify` per the file mapping in the Copy-Forward Contract (see `agentic_test_change_proposals.md`). For `constitution.md`, patch only the HTML comment — do not overwrite project-specific content.