# Copy Manifest

## Findings Bundle

### Source

- `/home/josiah/workflow/experiment_findings/phase3_define-features/README.md`
- `/home/josiah/workflow/experiment_findings/phase3_define-features/01-issue-summary.md`
- `/home/josiah/workflow/experiment_findings/phase3_define-features/02-phased-remediation-plan.md`
- `/home/josiah/workflow/experiment_findings/phase3_define-features/03-file-impact-matrix.md`
- `/home/josiah/workflow/experiment_findings/phase3_define-features/04-copy-manifest.md`

### Destination Root

- `/home/josiah/hello-verify/experiment_findings/phase3_define-features/`

### Transfer Commands

```bash
rsync -av --dry-run /home/josiah/workflow/experiment_findings/ /home/josiah/hello-verify/experiment_findings/
rsync -av /home/josiah/workflow/experiment_findings/ /home/josiah/hello-verify/experiment_findings/
```

## Workflow File Overwrites (CP-002, CP-005)

| Source | Destination | CP |
|---|---|---|
| `template/workflow/PLAYBOOK.md` | `~/hello-verify/workflow/PLAYBOOK.md` | CP-002 |
| `prompts/define-features.prompt.md` | `~/hello-verify/.github/prompts/define-features.prompt.md` | CP-002 |
| `meta-prompts/admin/prompt-sync.md` | `~/hello-verify/meta-prompts/admin/prompt-sync.md` | CP-005 |

### Transfer Commands

```bash
cp /home/josiah/workflow/template/workflow/PLAYBOOK.md /home/josiah/hello-verify/workflow/PLAYBOOK.md
cp /home/josiah/workflow/prompts/define-features.prompt.md /home/josiah/hello-verify/.github/prompts/define-features.prompt.md
cp /home/josiah/workflow/meta-prompts/admin/prompt-sync.md /home/josiah/hello-verify/meta-prompts/admin/prompt-sync.md
```
