# Cleanup and Cost Verification Specification

## Purpose

Own explicit cleanup verification evidence and cost guardrail acceptance for SAA-C03 labs.

## Requirements

### Requirement: Cleanup Verification

Every lab MUST document explicit teardown commands, expected post-destroy checks, required evidence, and cost guardrail acceptance. Paid labs SHALL be short-lived unless the lab documents an approved long-lived-resource justification.

#### Scenario: Lab cleanup succeeds

- GIVEN a lab has been applied
- WHEN cleanup is executed
- THEN the documented `terraform destroy` or equivalent teardown command MUST be runnable for the lab scope
- AND verification evidence MUST show expected lab resources no longer exist or are intentionally retained

#### Scenario: Cost risk is visible

- GIVEN a lab includes paid resources
- WHEN the lab is reviewed before apply
- THEN it MUST list expected paid resource types and budget or alert expectations
- AND approval MUST require cleanup verification steps or a documented long-lived-resource justification
