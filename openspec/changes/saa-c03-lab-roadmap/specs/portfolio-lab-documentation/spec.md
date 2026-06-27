# Portfolio Lab Documentation Specification

## Purpose

Make each lab understandable as certification practice and interview-facing portfolio evidence.

## Requirements

### Requirement: Lab Documentation Package

Every lab MUST include a per-lab README, architecture diagram, SAA-C03 domain mapping, decisions, deploy steps, and links to lifecycle and cleanup/cost evidence. The root `README.md` SHALL provide a current portfolio index linking each lab and its domain coverage.

#### Scenario: Reader reviews a lab

- GIVEN a lab exists under `projects/*`
- WHEN a reviewer opens its README
- THEN the README MUST explain purpose, architecture, commands, decisions, and domain mapping
- AND a diagram MUST be linked or embedded
- AND lifecycle and cleanup/cost evidence MUST be linked instead of duplicated

#### Scenario: Root index remains current

- GIVEN labs are added, removed, or replaced
- WHEN documentation is reviewed
- THEN the root README MUST list active labs, domain mapping, and lifecycle status
- AND removed or replaced projects MUST be absent or marked with a migration note
