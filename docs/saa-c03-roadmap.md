# SAA-C03 Lab Roadmap

This roadmap turns the repository into a certification-aligned portfolio. The current focus is to keep the foundation safe, make every lab disposable by default, and show domain coverage before adding paid resources.

## Coverage Summary

| SAA-C03 domain | Weight | Coverage status | Planned depth |
|----------------|--------|-----------------|---------------|
| Security | 30% | Foundation hardening complete; dedicated IAM/secrets lab planned. | High |
| Resilience | 26% | ALB/ASG and event-driven labs planned. | High |
| Performance | 24% | CloudFront/S3, ALB/ASG, endpoints, and event-driven labs planned. | High |
| Cost Optimization | 20% | Cleanup guardrails now documented; endpoint and database tradeoff labs planned. | Medium |

## Lab Matrix

| Lab | Domain(s) | Portfolio outcome | Services | Lifecycle | Cost posture | Evidence |
|-----|-----------|-------------------|----------|-----------|--------------|----------|
| `projects/ec2_hermes_workspace` | Security, Performance | Preserved workspace hardened before lab expansion. | EC2, IAM, SSM, Cloudflare tunnel | Preserved | Low; EC2 always costs while running | `docs/lab-evidence/ec2_hermes_workspace/` |
| `projects/saa_iam_secrets` | Security | Least privilege, secret retrieval, no public SSH. | IAM, SSM, Secrets Manager, EC2 access | Planned disposable | Low | `docs/lab-evidence/saa_iam_secrets/` |
| `projects/saa_alb_asg` | Resilience, Performance | Multi-AZ stateless workload, health checks, scaling. | ALB, ASG, EC2, CloudWatch | Planned disposable | Paid; short-lived | `docs/lab-evidence/saa_alb_asg/` |
| `projects/saa_s3_cloudfront` | Performance, Cost, Security | Static acceleration, cache behavior, private origin access. | S3, CloudFront, IAM/OAC | Planned disposable | Low but paid; short-lived | `docs/lab-evidence/saa_s3_cloudfront/` |
| `projects/saa_event_sqs_lambda` | Resilience, Performance, Cost | Decoupling, retries, DLQ, serverless scaling. | SQS, Lambda, CloudWatch Logs, IAM | Planned disposable | Free-tier friendly | `docs/lab-evidence/saa_event_sqs_lambda/` |
| `projects/saa_vpc_endpoints` | Cost, Security, Performance | Endpoint versus NAT egress tradeoffs. | VPC endpoints, route tables, optional NAT | Planned disposable | Endpoint/NAT paid; time-boxed | `docs/lab-evidence/saa_vpc_endpoints/` |
| `projects/saa_db_patterns` | Resilience, Security, Cost | Private database, backup, Multi-AZ, replica tradeoffs. | RDS, Secrets Manager, subnet groups, KMS | Planned disposable | Paid; short-lived | `docs/lab-evidence/saa_db_patterns/` |

## Lifecycle State

| Area | State | Rule |
|------|-------|------|
| Foundation | Hardened gate complete for Unit 1. | New labs depend on Terraform validation and narrow access patterns staying green. |
| Portfolio framework | Active in Unit 2. | New labs must use the README template and evidence conventions. |
| Legacy `ec2_n8n` | Migration candidate. | Do not delete until a replacement lab or explicit removal decision exists. |
| Legacy `rds_db` | Migration candidate. | Do not delete until `saa_db_patterns` or explicit removal is approved. |
| New `projects/saa_*` labs | Planned. | Add one disposable lab per chained PR slice. |

Planned lab folder names are capped at 20 characters so they can be created with `scripts/new-project.sh` without changing the project generator.

## Cost Posture

- Labs default to disposable and should be applied in `dev` first.
- Paid resources must list resource types, expected duration, and cleanup evidence before apply.
- Preserved resources need a long-lived-resource justification.
- Cleanup evidence must show destroyed resources or explain intentionally retained resources.

## Evidence and Diagram Conventions

- Lab evidence lives under `docs/lab-evidence/<lab_name>/`.
- Generated Terraform graphs live under `media/<lab_name>_graph.svg`.
- Per-lab READMEs link evidence instead of duplicating it.
- `scripts/tf-docs.sh` is the base workflow for refreshing generated README sections and graph diagrams.
- Safe rerun note: the script currently appends a new `## Diagram` section on every run. Before committing regenerated docs, keep one diagram section and remove any duplicate appended sections manually.

## Next Implementation Slices

1. Add `projects/saa_iam_secrets` with README, diagram, and cleanup checks.
2. Add `projects/saa_alb_asg` with short-lived paid-resource warnings.
3. Add `projects/saa_s3_cloudfront` with CloudFront/S3 cleanup proof.
