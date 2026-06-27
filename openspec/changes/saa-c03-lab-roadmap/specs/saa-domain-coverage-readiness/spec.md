# SAA Domain Coverage Readiness Specification

## Purpose

Ensure the lab roadmap covers AWS SAA-C03 domains in exam-weighted, practical slices.

## Requirements

### Requirement: Exam Domain Coverage

The roadmap MUST map labs to Security 30%, Resilience 26%, Performance 24%, and Cost Optimization 20%. Each lab SHALL state the exact domain outcomes it teaches. A lab using paid or complex services MUST identify at least one matching SAA-C03 outcome before approval.

#### Scenario: Domain coverage is complete

- GIVEN the roadmap is reviewed
- WHEN domain coverage is checked
- THEN each official SAA-C03 domain MUST have at least one planned practical lab
- AND Security, Resilience, and Performance MUST each have coverage depth equal to or greater than Cost Optimization unless explicitly justified

#### Scenario: Overbuilt lab is rejected

- GIVEN a lab uses paid or complex AWS services
- WHEN no SAA-C03 outcome is mapped to that service choice
- THEN the lab MUST be simplified, replaced, deferred, or justified with a mapped outcome
