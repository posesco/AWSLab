# Tasks: SAA-C03 Lab Roadmap

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | 1,200-1,800 |
| Estimated changed files | 35-55 |
| 800-line budget risk | High |
| 400-line budget risk | High |
| Chained PRs recommended | Yes |
| Suggested split | PR 1 hardening -> PR 2 docs framework -> PR 3 security lab -> PR 4 resilience lab -> PR 5 CloudFront lab |
| Delivery strategy | auto-forecast |
| Chain strategy | approved feature-branch-chain |

Decision needed before apply: No; feature-branch-chain approved by orchestrator
Chained PRs recommended: Yes
Chain strategy: feature-branch-chain
400-line budget risk: High
800-line budget risk: High

### Suggested Work Units

| Unit | Goal | Likely PR | Notes |
|------|------|-----------|-------|
| 1 | Pass hardening gate | PR 1 | Blocks all new labs; validate foundation and Hermes. |
| 2 | Add portfolio framework | PR 2 | README template, roadmap, evidence paths, diagrams. |
| 3 | Add Security lab | PR 3 | `projects/saa_security_iam_secrets`; low-cost first lab. |
| 4 | Add Resilience lab | PR 4 | `projects/saa_resilience_alb_asg`; paid short-lived lab. |
| 5 | Add Performance/Cost lab | PR 5 | `projects/saa_performance_s3_cloudfront`; paid cleanup proof. |

## Phase 1: Hardening Gate

- [x] 1.1 Update `.gitignore` to track `.terraform.lock.hcl` while ignoring tfvars/secrets; verify no committed secret values.
- [x] 1.2 Harden `projects/ec2_hermes_workspace/*` SSH, secret access, and tags without deleting the workspace.
- [x] 1.3 Reduce unsafe IAM/S3 wildcards in `foundation/iam/*` or record approved remediation tasks.
- [x] 1.4 Create `.github/workflows/terraform-validate.yml` for `terraform fmt -check -recursive`, init/validate, shell syntax checks, and safe targeted plans.
- [x] 1.5 Run `terraform fmt -check -recursive`, per-module `terraform init -backend=false`, `terraform validate`, shell/workflow static checks, and targeted `dev` plans where credentials allow.

### Phase 1 Validation Evidence

- `terraform fmt -check -recursive` from repo root: pass.
- `terraform init -backend=false && terraform validate` in `foundation/iam`: pass.
- `terraform init -backend=false && terraform validate` in `projects/ec2_hermes_workspace`: pass with warnings from ignored local `terraform.tfvars` containing removed legacy variables (`cloudflare_tunnel_token`, `hermes_ui_pass`); configuration validation passed.
- `bash -n projects/ec2_hermes_workspace/user_data.sh`: pass.
- `ruby -e "require 'yaml'; YAML.load_file('.github/workflows/terraform-validate.yml')"`: pass.
- `git diff --check`: pass.
- Targeted `dev` plans: skipped in this surgical pass to avoid AWS credential/backend requirements; workflow supports credentialed `workflow_dispatch` plans after IAM remote state is updated.

## Phase 2: Documentation and Lifecycle Framework

- [ ] 2.1 Create `projects/_template/README.md` with domain mapping, paid resources, lifecycle, commands, evidence links, and cleanup checklist.
- [ ] 2.2 Create `docs/saa-c03-roadmap.md` with the lab matrix, coverage status, lifecycle state, and cost posture.
- [ ] 2.3 Update `README.md` as the portfolio index for active labs, domain coverage, and legacy migration notes.
- [ ] 2.4 Add `docs/lab-evidence/` and `media/` conventions; use `scripts/tf-docs.sh` as the generated-docs base.

## Phase 3: Legacy Project Decisions

- [ ] 3.1 Add cleanup/migration notes for `projects/ec2_n8n/`; do not delete unless `saa_event_driven_sqs_lambda` or explicit removal is approved.
- [ ] 3.2 Add cleanup/migration notes for `projects/rds_db/`; do not delete unless `saa_database_patterns` or explicit removal is approved.

## Phase 4: First SAA-C03 Labs

- [ ] 4.1 Create `projects/saa_security_iam_secrets/` with required Terraform files, `common_tags`, remote state key, README, diagram, and cleanup checks.
- [ ] 4.2 Create `projects/saa_resilience_alb_asg/` with ALB/ASG short-lived lifecycle, health checks, README, diagram, and destroy evidence commands.
- [ ] 4.3 Create `projects/saa_performance_s3_cloudfront/` with S3/CloudFront/OAC scope, README, diagram, paid-resource warning, and deletion checks.

## Phase 5: Validation and Cost Cleanup

- [ ] 5.1 Run `terraform fmt -check -recursive`, validate each changed lab, and targeted `terraform plan` in `dev` where credentials allow.
- [ ] 5.2 Run `scripts/tf-docs.sh` and verify root/per-lab README manual sections are preserved.
- [ ] 5.3 Record cleanup evidence templates for SG/IAM/SSM/Secrets, ALB/ASG/EC2, S3/CloudFront, and expected cost checks.
