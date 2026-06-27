# Disposable Lab Lifecycle Specification

## Purpose

Define the structure, lifecycle, and destroyability expectations for SAA-C03 lab projects.

## Requirements

### Requirement: Disposable Project Lifecycle

Each lab project MUST be environment-aware, destroyable, and aligned to the existing `foundation -> modules -> projects` structure. Labs SHALL use existing foundation outputs where applicable. `projects/ec2_n8n` and `projects/rds_db` SHALL be treated as disposable candidates that MAY be deleted or replaced only when a replacement lab is specified or an explicit removal decision exists.

#### Scenario: Lab uses reusable foundation

- GIVEN a new `projects/*` lab is planned
- WHEN its dependencies are specified
- THEN it MUST consume existing networking, IAM/OIDC, budget, secrets, SSM, and common-tags patterns where applicable

#### Scenario: Lab lifecycle is explicit

- GIVEN a lab is added under `projects/*`
- WHEN its scope is reviewed
- THEN it MUST declare deploy, operate, and destroy lifecycle states
- AND it MUST identify any stateful resources requiring cleanup verification

#### Scenario: Legacy project is replaced

- GIVEN `projects/ec2_n8n` or `projects/rds_db` is proposed for deletion or replacement
- WHEN the lifecycle decision is reviewed
- THEN a replacement lab specification or explicit removal decision MUST exist first
- AND migration or cleanup notes MUST be recorded
