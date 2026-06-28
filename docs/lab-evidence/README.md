# Lab Evidence Convention

Use this directory for operator evidence that proves a lab was deployed, observed, destroyed, and cost-checked. Keep large screenshots or diagrams in `media/`; keep text evidence and command output summaries here.

## Directory Shape

```text
docs/lab-evidence/
└── <lab_name>/
    ├── deploy.md
    ├── operate.md
    ├── cleanup.md
    └── cost.md
```

## Evidence Template

| File | Required content |
|------|------------------|
| `deploy.md` | Workspace, plan/apply command, reviewed changes, outputs captured. |
| `operate.md` | Service behavior, health checks, SAA-C03 learning notes. |
| `cleanup.md` | `terraform destroy` command, post-destroy AWS checks, retained-resource justification if any. |
| `cost.md` | Paid resources, expected duration, budget/alert notes, post-cleanup cost check. |

## Review Checklist

- [ ] Evidence uses the same lab folder name as the Terraform project.
- [ ] Paid resources have an owner, expected runtime, and cleanup proof.
- [ ] Any retained resource has a written justification.
- [ ] Commands avoid embedding secrets, account IDs, tokens, or private endpoints.
