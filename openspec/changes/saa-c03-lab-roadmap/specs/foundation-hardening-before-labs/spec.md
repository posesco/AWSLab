# Foundation Hardening Before Labs Specification

## Purpose

Define the approval criterion that must pass before expanding new SAA-C03 lab implementation.

## Requirements

### Requirement: Hardening Gate

The system MUST treat foundation hardening as a phase gate before expanding new lab implementation. Approval SHALL require explicit remediation plans or completed fixes for SSH exposure, tfvars secrets, IAM/S3 scope, committed lock files, Terraform validation, and stale documentation. `projects/ec2_hermes_workspace` MUST be preserved and optimized.

#### Scenario: Gate passes for safe baseline

- GIVEN new lab implementation is requested
- WHEN the phase gate is reviewed
- THEN each hardening item MUST be marked fixed or backed by an approved remediation task
- AND `projects/ec2_hermes_workspace` MUST remain preserved

#### Scenario: Gate blocks unsafe expansion

- GIVEN any hardening item has no fix, remediation task, or explicit approval
- WHEN a new lab is proposed
- THEN the change MUST remain blocked from implementation beyond specification and design
