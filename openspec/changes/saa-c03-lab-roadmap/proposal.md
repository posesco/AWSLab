# Proposal: SAA-C03 Lab Roadmap

## Outcome

Turn this Terraform AWS lab into an SAA-C03 study-and-portfolio system: first harden unsafe foundations, then add disposable, documented labs mapped to Security 30%, Resilience 26%, Performance 24%, and Cost Optimization 20%.

## Problem

The repo already has useful AWS building blocks, but it is not yet safe or structured enough for repeated certification labs: public SSH, tfvars secrets, broad S3 access, missing Terraform CI/tests, stale docs, and ignored lock files must be fixed before adding paid or interview-facing resources.

## Goals

- Preserve and optimize `projects/ec2_hermes_workspace`.
- Remove or replace disposable `projects/ec2_n8n` and `projects/rds_db` when better labs exist.
- Prefer existing `foundation -> modules -> projects` architecture; add labs under `projects/`.
- Produce portfolio-grade diagrams, per-lab READMEs, root README updates, and explicit cleanup verification.
- Balance exam coverage with realistic architecture decisions.

## Non-Goals

- No separate repository unless the existing structure becomes unsuitable.
- No code implementation in this proposal phase.
- No long-lived paid resources without destroy instructions.

## Scope

### In Scope
- Foundation hardening before new labs: SSH, secrets, IAM/S3 scope, lockfile, CI validation, stale docs.
- Roadmap and specs for disposable SAA-C03 labs across all official domains.
- Cost and cleanup guardrails for every lab.
- Portfolio documentation requirements.

### Out of Scope
- Applying Terraform changes.
- Creating production-grade enterprise infrastructure.

## Capabilities

### New Capabilities
- `saa-c03-lab-roadmap`: Certification-aligned lab sequencing and domain coverage.
- `lab-cleanup-guardrails`: Destroy automation, resource verification, and cost safety rules.
- `portfolio-lab-documentation`: Diagrams, lab READMEs, and root README portfolio index.

### Modified Capabilities
- None; no existing OpenSpec capabilities are present.

## Phased Approach

1. **Hardening Gate**: close public SSH exposure, move secrets out of tfvars, reduce wildcard S3 policy, commit lock files, add Terraform fmt/validate/plan CI, refresh docs.
2. **Foundation Optimization**: keep VPC, IAM/OIDC, budgets, secrets, SSM, and common-tags as reusable lab substrate.
3. **Lab Roadmap**: add disposable `projects/*` labs mapped to SAA-C03 domains, using paid resources only when they teach core concepts.
4. **Portfolio Layer**: require diagrams, README, decisions, destroy steps, and resource verification per lab; update root README.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `foundation/**` | Modified | Hardening and reusable baseline improvements. |
| `modules/**` | Modified/New | Shared helpers only when repeated lab patterns justify them. |
| `projects/ec2_hermes_workspace` | Modified | Preserve and optimize. |
| `projects/ec2_n8n`, `projects/rds_db` | Removed/Replaced | Treat as disposable candidates. |
| `projects/*` | New | Add destroyable SAA-C03 labs. |
| `.github/workflows/**`, `scripts/**`, `README.md`, `docs/**`, `media/**` | Modified | CI, docs, diagrams, cleanup automation. |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Cost drift from paid labs | Med | Budgets, short-lived resources, destroy verification. |
| Overbuilding beyond SAA-C03 | Med | Map every lab to exam domain and portfolio outcome. |
| Unsafe baseline reused by labs | High | Hardening gate must pass before lab expansion. |

## Rollback Plan

Keep roadmap changes as docs/spec artifacts first. Future Terraform changes must be delivered in small PRs with per-module plans and reversible lab deletion via `terraform destroy` plus AWS resource checks.

## Success Criteria

- [ ] Hardening work is specified before any new lab.
- [ ] Each official SAA-C03 domain has planned practical coverage.
- [ ] Every lab requires README, diagram, cost note, destroy command, and verification.
- [ ] Existing repo structure and mandatory `common-tags` remain the default path.
- [ ] Root README stays current as the portfolio entry point.
