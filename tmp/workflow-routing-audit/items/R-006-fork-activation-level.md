# R-006: Fork Activation Level — User-Configured Fork Sensitivity

## Problem

R-001 introduced deterministic fork detection (F-1 through F-4) as stop gates in `/continue`. Every project now gets identical fork behavior regardless of the user's experience level, project complexity, or tolerance for interruption. A solo developer iterating on a small CLI tool is stopped at the same forks as a team running a multi-service platform build. There is no way for the user to express "I trust the defaults — only stop me when it really matters" or "I want full control over every decision point."

## Goal

During project initialization, ask the user how aggressively the workflow should pause at decision forks. Persist their choice and have the orchestration layer respect it throughout the project lifecycle.

### Activation Levels

| Level | Intent |
|-------|--------|
| **Light** | Auto-continue with recommended defaults at most forks. Only present a checklist when the decision carries high risk or is irreversible. |
| **Standard** | Present forks at key transition points where multiple valid paths exist. This is the behavior R-001 implemented. |
| **Active** | Present forks more broadly, including at lower-stakes transitions and confirmations that Standard would skip. |

The implementing agent must determine:
- Which existing fork conditions (and any future ones) qualify as "high risk" vs "standard" vs "low-stakes."
- Where in the orchestration flow the activation level should be checked.
- How "auto-continue with recommended default" interacts with the stop-gate contract (forks are currently defined as mandatory stops).
- Whether the level should influence only fork behavior or also advisory tone/frequency.

## Relationship to R-001

This item **extends** R-001's fork detection. R-001 defines the fork conditions and checklist format. R-006 adds a sensitivity dial that modulates when those forks actually fire. R-001 must be complete before R-006 is implemented.

Reference: `tmp/workflow-routing-audit/items/R-001-fast-router.md`

## Candidate Files

- `meta-prompts/phase-2-compass.md` — Compass discovery interview; activation level question would be asked here or during initialization
- `meta-prompts/admin/initialization.md` — Initialization flow; may be the right place to capture this preference early
- `meta-prompts/phase-10-continue.md` — Fork detection logic (Step 2c) that would need to respect the configured level
- `template/workflow/ORCHESTRATOR.md` — Template orchestrator fork detection and dispatch
- `template/workflow/STATE.json` — Persisted state; would need to store the activation level

## Acceptance Criteria

- The user is asked during project setup to choose a fork activation level (light, standard, active).
- The choice is persisted in project state and survives across sessions.
- The orchestration layer reads the persisted level and modulates fork behavior accordingly.
- Light level auto-continues at forks that Standard would stop at, except for high-risk decisions.
- Active level introduces additional confirmation points that Standard skips.
- Standard level matches R-001's current behavior exactly (backward-compatible default).
- The user can change their activation level at any time (similar to `advisoryProfile`).
- The distinction between "high risk" and "standard" forks is documented with rationale.

## Validation

- Simulated state at Standard: identical behavior to R-001 (regression-free).
- Simulated state at Light: forks that are not high-risk auto-continue without stopping.
- Simulated state at Active: additional confirmation points fire that Standard would skip.
- Level change mid-project: new level takes effect on next `/continue` invocation.
- Default when not set: Standard (backward-compatible).

## Open Questions

- Should fork activation level and `advisoryProfile` be independent settings, or should they be linked (e.g., `concise` advisory implies `light` forks)?
- Should the level affect only `/continue` forks, or also confirmation prompts in other commands?
- Is there a case for a fourth level (e.g., "off" — never stop at forks)?
