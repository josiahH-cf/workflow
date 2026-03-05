<!-- role: canonical-source -->
<!-- slash-command: plan-session -->
<!-- description: Batch planning session covering ideation, scoping, and task planning -->
# Feature Lifecycle  -  Meta-Prompts

Three session-oriented meta-prompts covering the full lifecycle. Each is designed for sustained deep work  -  batch issue creation, iterative development, or bulk review  -  rather than one-phase-at-a-time invocations.

> **V2 Workflow Context:** These major meta-prompts complement the 8-phase agentic workflow (see `AGENTS.md → Workflow Phases`). Phases 2–5 (Compass → Fine-tune) handle project-level planning via adaptive interviews. These major meta-prompts handle feature-level planning (ideation, scoping, task planning) within an established project. Use `/compass` first to establish the constitution, then these sessions for individual features.

**Standing rules for all sessions:**

- Follow `AGENTS.md` and the workflow contracts in `/workflow/PLAYBOOK.md` and `/workflow/FILE_CONTRACTS.md`.
- Reference `.specify/constitution.md` for alignment on all design decisions.
- Every artifact produced (spec, task file, test, implementation, review report) is committed or written to its canonical location before moving on.
- Fresh context means: no prior conversation carried forward. When indicated, end the current session and begin a new one.

---

## Meta-Prompt 1  -  Plan

**Covers:** Phase 0 (Ideate), Phase 1 (Scope), Phase 2 (Plan), Phase 2b (ExecPlan if applicable)

**Purpose:** Turn raw ideas into fully planned, ready-to-build issues  -  in batch. This session is interactive. You will work through one idea at a time, completing all planning phases for each before moving to the next.

**Session inputs:** One or more ideas, described in plain language. Provide them one at a time when prompted.

---

```text
You are running a planning session. The goal is to take raw ideas and produce fully planned features  -  each with a filed issue, a locked spec, and an ordered task file  -  ready for an agent to pick up and build.

You will process one idea at a time through three phases. Do not skip phases. Do not write code or tests.

For each idea, work through the following in order:

PHASE 0  -  IDEATE
Ask: "Describe the feature or idea you'd like to plan."
When the idea is provided:
1. Determine if this is a single feature or a batch of related features.
   - Single feature: produce one issue.
   - Batch or epic: decompose into independently actionable issues. Each must stand alone. If issues depend on each other, state the dependency explicitly in the Notes section of the dependent issue.
2. For each issue, produce:
   - Title (concise, imperative)
   - Idea (1–3 sentences: what and why)
   - Desired Outcome (what should be true when done)
   - Sizing Guess (S / M / L / XL  -  if XL, note it should be split further during scoping)
   - Notes (context, dependencies on other issues if any)
   - Labels: type:feature or type:bug, status:idea, size:[S/M/L/XL]
3. Present the issue(s) for review. Ask: "Does this capture the intent? Adjust anything before I scope it?"
   Wait for confirmation before proceeding.

PHASE 1  -  SCOPE
For each confirmed issue:
1. Explore the codebase to understand what files, patterns, dependencies, and constraints are relevant.
2. Produce a spec at /specs/[feature-id]-[slug].md containing:
   - Description (2–3 sentences)
   - Acceptance Criteria (3–7 testable statements as checkboxes  -  each verifiable by an automated test)
   - Affected Areas (files, modules, directories)
   - Constraints (performance, compatibility, security  -  or "None")
   - Out of Scope (explicitly excluded)
   - Dependencies (or "None")
   - Notes (or "None")
3. Validate:
   - If criteria exceed 7, stop. Recommend how to split the feature into smaller issues. Present the split for approval, then restart Phase 0 for each sub-feature.
   - Every criterion must be concrete and testable  -  not vague ("works correctly") or procedural ("run the tests").
4. Present the spec for review. Ask: "Spec ready. Review the acceptance criteria  -  are these correct and complete?"
   Wait for confirmation before proceeding.

PHASE 2  -  PLAN
For each confirmed spec:
1. Decompose into 2–5 implementation tasks, ordered by dependency.
2. For each task, provide:
   - Name
   - Files it will create or modify
   - Done state (one sentence)
   - Which acceptance criteria it covers
   - Status: Not started
3. Write to /tasks/[feature-id]-[slug].md including:
   - Link to the spec
   - Status summary (total, complete, remaining)
   - Task list
   - Test Strategy (map each criterion to the task that tests it  -  every criterion appears exactly once)
   - Empty Session Log
4. Validate:
   - Maximum 5 tasks. If more are needed, recommend splitting the spec and loop back to Phase 1.
   - If any task touches more than 8 files, split that task. If the total would exceed 5, recommend splitting the spec instead.
   - Every acceptance criterion must be covered by at least one task.
5. If this feature involves milestones or long-running execution, also produce an ExecPlan alongside the task file following the structure in /.codex/PLANS.md.
6. Present the task file for review. Ask: "Tasks planned. Does this decomposition look right?"
   Wait for confirmation.

After completing all three phases for one idea:
- Confirm: "Issue, spec, and tasks are complete for [feature-id]-[slug]. Label the issue status:planned."
- Then ask: "Would you like to plan another feature, or is this planning session complete?"

If another feature: return to Phase 0 and ask for the next idea.
If complete: summarize all features planned in this session with their file paths:
  - Issues created
   - Specs: /specs/[feature-id]-[slug].md
   - Tasks: /tasks/[feature-id]-[slug].md
  - ExecPlans (if any)
State: "All planned features are ready for the Build phase."
```

**Output per idea:** A filed issue, `/specs/[feature-id]-[slug].md`, `/tasks/[feature-id]-[slug].md`, and optionally an ExecPlan.

**Output at session end:** A summary table of all planned features and their artifacts.

**Next:** Hand off to the Build meta-prompt. Each planned issue can be built independently in a separate session.
