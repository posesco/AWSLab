# Design: SAA-C03 Lab Roadmap

## Technical Approach

Use this Terraform repo as the SAA-C03 lab platform. Preserve `foundation -> modules -> projects`, S3 remote state, workspaces, and `modules/common-tags`. Sequence: harden first, add portfolio/evidence scaffolding, then implement disposable `projects/saa_*` labs with domain, cost, lifecycle, and cleanup evidence.

## Phase Architecture

1. **Hardening gate** — block new labs until SSH exposure, tfvars secrets, IAM/S3 scope, lockfile policy, Terraform validation, and stale docs are fixed or approved as remediation tasks. Hermes stays.
2. **Portfolio framework** — lab README template, diagrams, root portfolio index, cleanup/cost evidence paths.
3. **First recommended disposable sequence** — after hardening: `saa_iam_secrets` -> `saa_alb_asg` -> `saa_s3_cloudfront`.
4. **Tracking** — maintain domain coverage, lifecycle, cleanup proof, and cost posture in `docs/saa-c03-roadmap.md`.

## Architecture Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Repo | Optimize in-place | Existing VPC, IAM/OIDC, billing, SSM, Secrets Manager, and template are useful learning substrate. |
| Lab unit | One `projects/<snake_case_lab>/` per lab, capped at 20 characters | Keeps state, plans, cleanup, and PR review bounded while staying executable by `scripts/new-project.sh`. |
| Egress | Prefer endpoints/no-NAT; add NAT only when taught | Current S3/DynamoDB endpoints keep baseline cost low. |
| Legacy | Preserve Hermes; gate n8n/RDS removal | Specs require explicit replacement/removal and cleanup notes. |
| Docs | Curated README plus generated Terraform docs | Portfolio evidence needs decisions, diagrams, and lifecycle proof. |

## SAA-C03 Lab Matrix

| Folder/name | Domain(s) | Outcome | Services | Cost/lifecycle | Existing project relationship | Cleanup evidence |
|---|---|---|---|---|---|---|
| `projects/saa_iam_secrets` | Security 30% | Least privilege, secret retrieval, no public SSH | IAM, SSM, Secrets Manager, EC2 access | Low-cost; preserved hardening plus disposable checks | Preserves/hardens Hermes; independent of n8n/RDS | Destroy if resources exist; AWS CLI checks for SGs, IAM, SSM/Secrets, no public SSH |
| `projects/saa_alb_asg` | Resilience 26%, Performance 24% | Multi-AZ stateless workload, health checks, scaling | ALB, ASG, EC2, CloudWatch, VPC | Paid; short-lived/disposable | Independent; may replace n8n only by explicit decision | ALB, target group, ASG, launch template, EC2, SG absence |
| `projects/saa_s3_cloudfront` | Performance 24%, Cost 20%, Security 30% | Static acceleration, cache behavior, origin access | S3, CloudFront, IAM/OAC, optional ACM | Low but paid; short-lived unless approved preserved | Independent | Bucket empty/deleted, distribution disabled/deleted, OAC/IAM removed, cost note |
| `projects/saa_event_sqs_lambda` | Resilience 26%, Performance 24%, Cost 20% | Decoupling, retries, DLQ, serverless scaling | SQS, Lambda, CloudWatch Logs, IAM | Free-tier friendly; short-lived/disposable | Independent; possible n8n replacement pattern if approved | Queue, DLQ, Lambda, log group, IAM role removed or retained-log justification |
| `projects/saa_vpc_endpoints` | Cost 20%, Security 30%, Performance 24% | Endpoint versus NAT egress tradeoffs | VPC endpoints, route tables, S3/DynamoDB, optional NAT | Endpoint/NAT paid; time-boxed disposable | Independent; reuses networking | Endpoint/route removal, NAT absence if used, before/after cost note |
| `projects/saa_db_patterns` | Resilience 26%, Security 30%, Cost 20% | Private DB, backups, Multi-AZ/read-replica tradeoffs | RDS, Secrets Manager, subnet groups, KMS | Paid; short-lived only | Replaces/removes `rds_db` only with migration/cleanup note | RDS delete/snapshot evidence, subnet/parameter/SG checks, retained snapshot justification |

## Data Flow

```text
foundation/tfstate -> remote S3 backend
foundation/networking/iam/billing/secrets + modules/common-tags -> projects/<lab>
projects/<lab> -> README + diagram + domain map -> cleanup/cost evidence
```

## File Changes

| File | Action | Description |
|---|---|---|
| `.github/workflows/terraform-validate.yml` | Create | fmt, init/validate, safe plan jobs. |
| `.gitignore` | Modify | Track `.terraform.lock.hcl`; keep tfvars/secrets ignored. |
| `projects/ec2_hermes_workspace/*` | Modify | Preserve and harden access/secrets. |
| `projects/ec2_n8n/`, `projects/rds_db/` | Conditional modify/delete | Require explicit replacement/removal and cleanup notes. |
| `projects/_template/README.md` | Create | Domain/cost/lifecycle/evidence template. |
| `projects/saa_*` | Create | Matrix labs. |
| `docs/saa-c03-roadmap.md`, `docs/lab-evidence/`, `media/`, `README.md` | Create/modify | Portfolio, diagrams, readiness, cleanup, cost evidence. |

## Interfaces / Contracts

Lab folders MUST contain `backend.tf`, `providers.tf`, `variables.tf`, `main.tf`, `outputs.tf`, `README.md`. Each lab MUST use `terraform.workspace`, remote key `projects/<lab>/terraform.tfstate`, foundation remote state where applicable, and `module "common_tags"`. READMEs MUST declare domains, paid resources, lifecycle, commands, and evidence links.

## Testing Strategy

| Layer | What | Approach |
|---|---|---|
| Static | Formatting, lockfiles, secrets | `terraform fmt -check -recursive`; no committed tfvars. |
| Validation | Syntax/providers | `terraform init -backend=false` where possible; `terraform validate`. |
| Plan | Workspace/cost | `terraform plan` in `dev`; cost note for paid services. |
| Cleanup | Destroyability | `terraform destroy` plus lab AWS CLI checks. |

## Migration / Rollout

No data migration in design. Roll out as hardening, docs framework, then one lab slice at a time. n8n/RDS destructive changes require explicit approval and cleanup evidence.

## Open Questions

- [ ] None blocking design; order after the first three labs may change by cost and study priority.
