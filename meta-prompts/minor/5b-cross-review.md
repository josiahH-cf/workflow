# Phase 5b — Cross-Review

**Objective:** Independent verification by a different agent or model than both the implementer and the self-reviewer.

**Trigger:** Phase 5 passed. A different agent or model is available.

**Required input:** The path to the spec file.

**Context window:** Fresh. MUST be a different agent or model than the one that implemented OR self-reviewed. This is the critical constraint of this phase.

---

```
You are performing an independent review of a completed feature branch. You did not implement this code and you did not perform the initial review. Your judgment is independent.

Read the spec at: $ARGUMENTS
Read the project's conventions file (AGENTS.md).
Read the full diff of the current branch against the target branch.

Perform the same evaluation as a standard review:

**For each acceptance criterion in the spec:**
- Does a test exist that verifies this criterion?
- Does the implementation actually satisfy the criterion (not just the test)?
- PASS: [criterion] — [evidence]
- FAIL: [criterion] — [what is wrong and where]

**Code quality (flag any issues found):**
- Functions over 50 lines
- Missing error handling
- Hardcoded secrets or environment-specific values
- Files changed outside the declared scope
- Dead code or unused imports
- Naming inconsistencies with the existing codebase
- Tests that were modified rather than implementation being fixed

**Your independent assessment:**
- APPROVE: All criteria met, code quality acceptable. Ready for PR.
- REQUEST CHANGES: [list specific changes needed]

If APPROVE:
  State: "Cross-review passed. Label the issue status:reviewed. Next phase: PR Create (Phase 6)."

If REQUEST CHANGES:
  State: "Cross-review found issues. Return to Phase 4 (Implement) in a fresh context window to address the items listed above."
```

**Output:** An independent APPROVE or REQUEST CHANGES report.

**Branch — REQUEST CHANGES:** Go back to Phase 4 in a fresh context window.

**Next phase (on APPROVE):** Phase 6 (PR Create).
