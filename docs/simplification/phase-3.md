# Phase 3: Unify Installation + Onboarding

> **Status**: COMPLETE
> **Prereqs**: Phase 2 complete
> **Outcome**: Single install command works with no flags. README ≤ 100 lines. Clear platform-specific next steps.

## Objective

One install command, one golden path, one clear "what next" per platform.

---

## Step 1: Simplify install.sh Defaults

### 1a. Make prompts + meta-prompts DEFAULT

Change `--with-prompts` and `--with-meta-prompts` from opt-in to default behavior:
- Default: install template + prompts (to VS Code) + meta-prompts (into target)
- `--minimal`: template only (no prompts, no meta-prompts)
- Keep existing `--prompts-dir DIR` for override
- Keep `--force` and `--dry-run`

### 1b. Add post-install validation

After copying files, verify the install succeeded:
```bash
# Check critical files exist
for f in AGENTS.md CLAUDE.md workflow/STATE.json workflow/LIFECYCLE.md; do
  [ -f "$TARGET/$f" ] || echo "WARNING: Missing $f"
done
```

### 1c. Print platform-specific next steps

Post-install message should clearly route by platform:

```
✓ Scaffold installed to /path/to/project

Next steps:
  cd /path/to/project

  Copilot (VS Code):  Type /compass in Copilot Chat
  Claude Code:         Run /compass
  Codex:               Reference meta-prompts/02-compass.md

Then: /define-features → /scaffold → /fine-tune → /continue
```

### 1d. Fix WSL2 detection

Replace `cmd.exe`-based detection with:
```bash
if [ -n "$USERPROFILE" ]; then
  PROMPTS_DIR="$USERPROFILE/AppData/Roaming/Code/User/prompts"
elif [ -f /proc/version ] && grep -qi microsoft /proc/version; then
  # WSL2 fallback — require --prompts-dir
  echo "WSL2 detected. Use --prompts-dir to specify VS Code prompts location."
fi
```

### 1e. Remove deprecated flags from help text

Since `--with-prompts` and `--with-meta-prompts` are now default, update `--help` to reflect:
- Remove these as flags (or keep as no-ops for backward compat)
- Document `--minimal` as the opt-out

---

## Step 2: Rewrite README.md

Target: ≤ 100 lines. Structure:

```markdown
# Workflow Scaffold

One-paragraph description: what this is, honestly. Agent-assisted (not autonomous)
structured development with Claude, Copilot, and Codex.

## Quickstart

    git clone <repo>
    ./scripts/install.sh /path/to/your/project
    cd /path/to/your/project

    # Then in your AI tool:
    /compass              # Define your project
    /define-features      # Map features from capabilities
    /scaffold             # Plan technical architecture
    /fine-tune            # Create task plans with model assignments
    /continue             # Build, test, review, ship (loops automatically)

## Which Prompt Interface?

| Platform | Commands | Location |
|----------|----------|----------|
| Copilot (VS Code) | Slash commands in Chat | Installed to VS Code prompts dir |
| Claude Code | `/command` in terminal | `.claude/commands/` in your project |
| Codex | Reference docs | `meta-prompts/` in your project |

## Workflow

(Brief description of 8 phases + concurrent bug track)
(Link to new diagram — placeholder until Phase 5)

## Reference Example

See [workflow-example](link) for a completed sample project.
(Placeholder link until Phase 4)

## Docs

- [Quickstart (detailed)](docs/quickstart-first-success.md)
- [Principles](docs/reference/principles.md)
- [Troubleshooting](TROUBLESHOOTING.md)

## License

MIT
```

### Key writing rules:
- NO "V1"/"V2" language
- NO time estimates ("15 minutes")
- Honest about human involvement (interview, decisions, approval)
- Golden path prominently displayed
- Platform routing visible immediately

---

## Step 3: Update Quickstart Doc

### `docs/quickstart-first-success.md`

- Remove "15-Minute Path" framing → replace with "5 Commands to First Feature"
- Ensure ONLY current workflow commands are referenced
- Remove any legacy command references
- Align steps with README quickstart section (README is brief, quickstart is detailed)
- Include the golden path diagram:
  ```
  install → /compass → /define-features → /scaffold → /fine-tune → /continue
                                                            ↕
                                                      /bug (concurrent)
  ```

---

## Step 4: Update TROUBLESHOOTING.md

- Remove any troubleshooting for legacy commands (ideate, scope, plan, etc.)
- Remove any V1/V2 language
- Ensure all referenced commands exist in the current workflow
- Update paths from `meta-prompts/minor/` or `meta-prompts/major/` to flat `meta-prompts/`

---

## Step 5: Update docs/README.md

- Ensure the docs index page reflects the simplified structure
- Remove references to legacy workflows or archived content
- Link to quickstart, principles, and troubleshooting

---

## Verification Commands

```bash
# Install with no flags works
TMPDIR=$(mktemp -d)
scripts/install.sh "$TMPDIR" 2>&1 | tee /tmp/install-output.txt
echo "---"
# Check prompts were installed
ls "$TMPDIR"/meta-prompts/ 2>/dev/null | head -5 && echo "PASS: meta-prompts installed by default" || echo "FAIL"
# Check post-install message mentions platform-specific next steps
grep -q "Copilot\|Claude Code\|Codex" /tmp/install-output.txt && echo "PASS: platform guidance" || echo "FAIL"
rm -rf "$TMPDIR"

# README line count
wc -l README.md
[ "$(wc -l < README.md)" -le 100 ] && echo "PASS: ≤ 100 lines" || echo "NEEDS REVIEW"

# No legacy in quickstart
grep -ri "v1\|v2\|legacy\|ideate\|scope.*phase\|15.minute\|15-minute" docs/quickstart-first-success.md && echo "FAIL" || echo "PASS"

# No legacy in troubleshooting
grep -ri "v1\|v2\|legacy\|ideate\|scope.*phase" TROUBLESHOOTING.md && echo "FAIL" || echo "PASS"

# All tests
scripts/test-scripts.sh
```

---

## Acceptance Criteria

- [ ] `./scripts/install.sh /tmp/test-project` (no flags) produces working scaffold WITH prompts and meta-prompts
- [ ] `--minimal` flag produces template-only install
- [ ] Post-install output includes platform-specific next steps (Copilot / Claude Code / Codex)
- [ ] README.md ≤ 100 lines
- [ ] README contains golden path, platform routing table, quickstart steps
- [ ] No "V1"/"V2"/"legacy"/"15 minute" language in README, quickstart, or troubleshooting
- [ ] Quickstart doc aligned with README, references only current workflow commands
- [ ] TROUBLESHOOTING.md contains no legacy command references
- [ ] All test scripts pass

## Files Summary

- **Modified**: `scripts/install.sh`, `README.md`, `docs/quickstart-first-success.md`, `TROUBLESHOOTING.md`, `docs/README.md`
- **No files deleted or created** (content changes only)
