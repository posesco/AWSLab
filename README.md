# AWS Lab Infrastructure

Terraform-based AWS lab portfolio for foundational infrastructure, reusable project modules, and SAA-C03 certification practice across `dev`, `staging`, and `prod` workspaces.

## Portfolio Status

| Area | Status | Notes |
|------|--------|-------|
| Foundation | Active | Remote state, networking, IAM/OIDC, billing, secrets, and shared tags. |
| Hermes workspace | Preserved | EC2 ARM64 workspace hardened before new labs. |
| SAA-C03 roadmap | Active | See [SAA-C03 Lab Roadmap](docs/saa-c03-roadmap.md). |
| Legacy n8n project | Migration candidate | Do not remove until a replacement lab or explicit removal decision exists. |
| Legacy RDS project | Migration candidate | Do not remove until `saa_db_patterns` or explicit removal is approved. |

## SAA-C03 Domain Coverage

| Domain | Weight | Repository coverage |
|--------|--------|---------------------|
| Security | 30% | Foundation hardening, IAM/OIDC, SSM/Secrets Manager, planned IAM/secrets lab. |
| Resilience | 26% | Planned ALB/ASG, event-driven, and database-pattern labs. |
| Performance | 24% | Planned ALB/ASG, S3/CloudFront, endpoints, and event-driven labs. |
| Cost Optimization | 20% | Budgets, endpoint tradeoff lab, cleanup evidence, and paid-resource guardrails. |

## Active Labs and Projects

| Project | Lifecycle | Domain(s) | Documentation |
|---------|-----------|-----------|---------------|
| `projects/ec2_hermes_workspace` | Preserved | Security, Performance | [README](projects/ec2_hermes_workspace/README.md) |
| `projects/ec2_n8n` | Migration candidate | Legacy workload | [README](projects/ec2_n8n/README.md) |
| `projects/rds_db` | Migration candidate | Legacy database | [README](projects/rds_db/README.md) |
| `projects/saa_*` | Planned disposable labs | Security, Resilience, Performance, Cost | [Roadmap](docs/saa-c03-roadmap.md) |

## Documentation and Evidence

| Path | Purpose |
|------|---------|
| `projects/_template/README.md` | Per-lab README preamble template preserved by `scripts/tf-docs.sh`. |
| `docs/saa-c03-roadmap.md` | Lab matrix, coverage status, lifecycle state, and cost posture. |
| `docs/lab-evidence/` | Deploy, operate, cleanup, and cost evidence conventions. |
| `media/` | Terraform graphs and portfolio diagrams. |

## Architecture

```
foundation/             # Core infrastructure modules (deploy in order)
├── tfstate/            # S3 backend for Terraform state
├── networking/         # VPC, subnets, gateways, VPC endpoints
├── iam/                # Users, groups, roles, access keys
├── billing/            # Budget alerts and cost monitoring
└── secrets/            # AWS Secrets Manager resources
modules/
├── common-tags/        # Shared tagging module
└── ssm/                # SSM Parameter Store helper
projects/               # Projects using shared infrastructure
├── ec2_hermes_workspace/  # EC2 ARM64 workspace (Hermes)
├── ec2_n8n/               # EC2 n8n automation instance
├── rds_db/                # RDS database layer
└── _template/             # Terraform project and README template
scripts/                # Operational utilities
```

## Prerequisites

- Terraform >= 1.15.0
- AWS Provider ~> 6.0
- AWS CLI configured with appropriate credentials

## Deployment Order

1. **tfstate** - Bootstrap remote state backend
2. **networking** - Create VPC and network infrastructure
3. **iam** - Configure identity and access management
4. **billing** - Set up cost monitoring
5. **projects** - Projects using shared infrastructure

## Quick Start

```bash
# Initialize and deploy a module
cd foundation/<module>
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Foundation Modules

### tfstate
S3 bucket for remote Terraform state with versioning, encryption, and lifecycle policies.

### networking
- VPC (10.0.0.0/16)
- Public subnets: 10.0.1.0/24, 10.0.2.0/24
- Private subnets: 10.0.11.0/24, 10.0.12.0/24
- Internet Gateway
- S3 and DynamoDB VPC endpoints

### iam
RBAC groups with predefined permissions:
| Group | Access Level |
|-------|-------------|
| admins | AdministratorAccess |
| developers | EC2 + RDS full access |
| finance | Billing read-only |
| cli-deployers | PowerUser + IAM read-only |

Includes OIDC provider for GitHub Actions CI/CD and IAM access keys stored in SSM Parameter Store.

### billing
AWS Budget alerts with configurable thresholds and email notifications.

### secrets
AWS Secrets Manager resources for centralized secret storage across environments.

## Modules

| Module | Description |
|--------|-------------|
| `modules/common-tags` | Generates standard tags applied to all resources |
| `modules/ssm` | Helper to write secrets/config values to SSM Parameter Store |

## Scripts

| Script | Description |
|--------|-------------|
| `scripts/assume-role.sh` | Manage Cost Explorer role assumption |
| `scripts/cost-report.sh` | Generate AWS cost reports |
| `scripts/tf-docs.sh` | Auto-generates documentation |

## Tagging Strategy

All resources include standard tags: `ManagedBy`, `Owner`, `Environment`, `Project`, `Component`.

## Documentation

| Document | Description |
|----------|-------------|
| [Git Strategy](docs/git-strategy.md) | Branching model, CI/CD pipeline, environments |
| [SAA-C03 Lab Roadmap](docs/saa-c03-roadmap.md) | Certification lab matrix, domain coverage, lifecycle, and cost posture |
| [Lab Evidence Convention](docs/lab-evidence/README.md) | Deploy, operate, cleanup, and cost evidence structure |
| [Media Convention](media/README.md) | Diagram and generated graph conventions |

## License

Copyright 2026 Jesús David Posada Escobar

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.
