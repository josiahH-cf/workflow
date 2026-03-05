<!-- role: derived | canonical-source: meta-prompts/08-maintain.md -->
<!-- generated-from-metaprompt -->
# Phase 8 — Maintain

**Objective:** Produce and maintain project documentation, enforce standards, and ensure compliance.

**Trigger:** Feature shipped (post-Phase 7) or periodic maintenance trigger.

**Entry commands:**
- Claude: `/maintain`
- Copilot: `maintain.prompt.md`

---

## What Happens

### Initial Setup (first run after shipping)
1. Generate README from constitution + feature specs
2. Generate CONTRIBUTING from AGENTS.md conventions
3. Produce release notes from implemented features
4. Run security baseline check

### Ongoing (periodic)
1. Compliance check — all specs have tests, all tests pass
2. Documentation drift — README/CONTRIBUTING vs current state
3. Dependency audit — outdated or vulnerable
4. Auto-corrections — lint, format, stale TODOs
5. Bug log review — stale entries flagged or closed

## Gate

- README exists and reflects current project state
- CONTRIBUTING exists with branch naming, commit format, PR requirements
- Security baseline checked
- No stale compliance issues

## Output

- Updated documentation
- Compliance report
- Bug log entries for any findings

## Rules

- Do not change application logic — maintenance only
- Commit maintenance changes separately from feature work

## See Also

- Bug tracking parallel workflow: `AGENTS.md → Bug Track`
