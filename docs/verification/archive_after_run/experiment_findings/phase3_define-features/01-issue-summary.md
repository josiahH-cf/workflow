# Issue Summary

## Evidence Source
- `/home/josiah/hello-verify/experiment-log.md`

## Key Findings
1. Scaffold validation command ambiguity caused `validate-scaffold.sh` not found (`**Severity:** error`, near line 26).
2. Define Features phase accepted intent text without required output files (`**Severity:** error`, near line 102).
3. Compass constitution write guidance conflicted with phase-required writes (`**Severity:** error`, near line 187).
4. Prompt-sync tool-ID mismatch — interview-dependent phases lack fallback instructions for non-interactive tools (`**Severity:** info`, `[3-define-features] 2026-03-05T14:38:27` — proposed fix for `prompt-sync.md`). Tracked as CP-005.

## Impact
- False negatives in setup checks.
- Incomplete phase outputs treated as complete.
- Governance confusion that can stall execution.

## Target Outcome
- Deterministic script invocation.
- Stronger phase gate completion checks.
- Clear allowed write-path policy for Compass.
