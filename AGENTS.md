# AWS Lab — Project Instructions

This is a **Terraform**-based Infrastructure as Code (IaC) project designed to manage AWS resources in a modular, multi-environment structure.

## Architecture and Structure

The project is split into deployment layers:

1.  **Foundation:** Base resources required by everything else.
    *   `foundation/tfstate`: S3 bucket and DynamoDB table for the remote backend.
    *   `foundation/networking`: VPC, subnets, gateways, and endpoints.
    *   `foundation/iam`: Users, groups, and roles, including OIDC for GitHub Actions. Access keys are stored in SSM Parameter Store.
    *   `foundation/billing`: Budgets and cost alerts.
    *   `foundation/secrets`: AWS Secrets Manager resources.
2.  **Modules:** Reusable resources.
    *   `modules/common-tags`: Generates the required standard tags.
    *   `modules/ssm`: Helper for writing parameters to SSM Parameter Store.
3.  **Projects:** Specific applications or services that consume the foundation infrastructure.
    *   `projects/ec2_hermes_workspace`: EC2 ARM64 (Graviton) workspace with Docker and cloudflared.
    *   `projects/ec2_n8n`: EC2 instance for n8n automation.
    *   `projects/rds_db`: RDS database layer.

## Commands and Workflow

### Environment Management (Terraform Workspaces)
The project distinguishes between **GLOBAL** and **PER-ENVIRONMENT** modules:

*   **GLOBAL modules** (`tfstate`, `iam`): Deployed once per account.
    ```bash
    cd foundation/iam
    terraform init
    terraform plan
    terraform apply
    ```
*   **PER-ENVIRONMENT modules** (`networking`, `billing`, `projects/*`): Use workspaces (`dev`, `staging`, `prod`).
    ```bash
    cd foundation/networking
    terraform workspace select dev # or staging/prod
    terraform plan
    ```

### Utility Scripts
*   `./scripts/new-project.sh <name>`: Creates a new project from the `projects/_template` template.
*   `./scripts/cost-report.sh`: Generates AWS cost reports.
*   `./scripts/tf-docs.sh`: Updates module documentation automatically. Preserves manual content, such as a `## Features` section, that appears before `## Requirements` in the existing README.

## Development Conventions

*   **Minimum versions:** Terraform `>= 1.15.0`, AWS Provider `~> 6.0`.
*   **Git strategy:** Trunk-Based Development. Use short-lived branches (`feature/*`, `fix/*`) that merge into `master`.
*   **Tagging:** All resources must include the `common-tags` module. Mandatory tags: `ManagedBy`, `Owner`, `Environment`, `Project`.
*   **Backend:** Always use the remote backend configured in `foundation/tfstate`.
*   **Security:**
    *   Use IAM roles and OIDC for CI/CD (GitHub Actions).
    *   Do not hardcode credentials; use environment variables or a configured AWS CLI profile.

## CI/CD (GitHub Actions)
Currently, `.github/workflows/` contains a commented exploratory workflow for testing GitHub Actions and AWS OIDC. Do not assume an active Terraform pipeline exists for automatic plan/apply until a production workflow is added.

The expected strategy is documented in `docs/git-strategy.md`: changes target `master`, plans run on PRs, merges apply automatically to `dev`, and promotion to `staging`/`prod` is manual via `workflow_dispatch`.

---
*Note: This file contains instructions for AI agents working in this repository. For user-facing documentation, see `README.md`.*
