# Copy Manifest — Phase 2 Compass

## Findings Bundle

### Source

- `/home/josiah/workflow/experiment_findings/phase2_compass/README.md`
- `/home/josiah/workflow/experiment_findings/phase2_compass/01-issue-summary.md`
- `/home/josiah/workflow/experiment_findings/phase2_compass/02-phased-remediation-plan.md`
- `/home/josiah/workflow/experiment_findings/phase2_compass/03-file-impact-matrix.md`
- `/home/josiah/workflow/experiment_findings/phase2_compass/04-copy-manifest.md`

### Destination Root

- `/home/josiah/hello-verify/experiment_findings/phase2_compass/`

### Transfer Commands

```bash
rsync -av --dry-run /home/josiah/workflow/experiment_findings/ /home/josiah/hello-verify/experiment_findings/
rsync -av /home/josiah/workflow/experiment_findings/ /home/josiah/hello-verify/experiment_findings/
```

## Workflow File Overwrites (CP-003, CP-004)

| Source | Destination | CP |
|---|---|---|
| `template/workflow/BOUNDARIES.md` | `~/hello-verify/workflow/BOUNDARIES.md` | CP-003, CP-004 |
| `template/.specify/constitution.md` (comment only) | `~/hello-verify/.specify/constitution.md` | CP-003 |

### Transfer Commands

```bash
cp /home/josiah/workflow/template/workflow/BOUNDARIES.md /home/josiah/hello-verify/workflow/BOUNDARIES.md
sed -i '1s|^<!-- .*-->$|<!-- This file is generated during Phase 2 (Compass). During Phase 2, this is the primary write target — Compass directly populates all sections. After Phase 2 completes, this file is read-only. Post-Compass edits require /compass-edit or equivalent. -->|' /home/josiah/hello-verify/.specify/constitution.md
```
