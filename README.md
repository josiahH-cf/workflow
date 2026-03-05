# Workflow Scaffold

Agent-assisted structured development with Claude, Copilot, and Codex. Agents interview you, then build — you stay in control of decisions, scope, and approvals.

## Quickstart

```bash
git clone https://github.com/your-org/workflow.git
./scripts/install.sh /path/to/your/project
cd /path/to/your/project
```

Then in your AI tool:

```
/compass              # Define your project (interactive interview)
/define-features      # Map features from constitution capabilities
/scaffold             # Plan technical architecture
/fine-tune            # Create task plans with model assignments
/continue             # Build, test, review, ship (loops automatically)
```

`/continue` is the primary command — it detects the current phase, executes it, and auto-advances. It pauses at stop gates (interviews, plan approval, blocking bugs) and tells you what input is needed.

## Which Platform?

| Platform | Commands | Setup |
|----------|----------|-------|
| **Copilot (VS Code)** | Slash commands in Chat (`/compass`, etc.) | Installed to VS Code prompts dir |
| **Claude Code** | `/command` in terminal | `.claude/commands/` in your project |
| **Codex** | Reference docs | `meta-prompts/` in your project |

Pick one or combine them. You don't need all three.

## How It Works

Everything traces to the **project constitution** produced by the Compass interview.

```
Constitution          → defines WHAT the project is
Feature Specs         → define HOW TO VERIFY each capability
Task Files            → define WHAT TO BUILD (ordered, model-assigned)
PRs                   → prove THAT IT WORKS (test evidence per criterion)
Decisions             → record WHY non-obvious choices were made
```

### The 8-Phase Workflow

```
1. SCAFFOLD IMPORT   → Install files (install.sh)
2. COMPASS           → Interview → constitution.md
3. DEFINE FEATURES   → Map features to constitution capabilities
4. SCAFFOLD PROJECT  → Architecture decisions (no code)
5. FINE-TUNE PLAN    → Ordered specs, ACs, model assignments, branches
6. CODE              → TDD implementation from spec
7. TEST + REVIEW     → Verify ACs, review, ship (per feature)
8. MAINTAIN          → Docs, compliance, release notes
   BUG TRACK         → Parallel bug capture from any phase
```

Phases 2–3 require interviews. Phases 4–5 need architecture approval. Phases 6–8 run autonomously via `/continue`.

## Install Options

```bash
# Default: template + prompts + meta-prompts
./scripts/install.sh /path/to/project

# Template only (no prompts)
./scripts/install.sh --minimal /path/to/project

# With platform-specific extras
./scripts/install.sh --with-github-templates --with-github-agents --with-codex /path/to/project
```

## Reference Example

See [workflow-example](examples/sample-project/) for a completed sample project.

## Docs

- [Quickstart (detailed)](docs/quickstart-first-success.md)
- [Principles](docs/reference/principles.md)
- [Troubleshooting](TROUBLESHOOTING.md)

## Updates

Run [`meta-prompts/update.md`](meta-prompts/update.md) from your target project to update an existing scaffold.

## License

MIT

### Major vs minor meta-prompts

- **`meta-prompts/minor/`** — Canonical sources for individual phase commands and support commands.
- **`meta-prompts/major/`** — Session-oriented batch prompts that combine multiple phases into sustained deep-work sessions (plan-session, build-session, review-session). These are convenience wrappers, not canonical sources.
