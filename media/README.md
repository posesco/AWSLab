# Media Convention

Use this directory for diagrams and other review-facing assets referenced by root, docs, and per-lab READMEs.

## Generated Terraform Graphs

`scripts/tf-docs.sh` writes Terraform graph SVGs here using this naming convention:

```text
media/<module_or_lab_name>_graph.svg
```

The same script preserves a README preamble before `## Requirements`, refreshes Terraform reference sections, and appends a `## Diagram` section that links the generated graph.

Safe rerun note: `scripts/tf-docs.sh` currently appends a new `## Diagram` section on every run instead of replacing the previous one. Before committing regenerated docs, keep one diagram section and remove duplicate appended sections manually.

## Manual Assets

- Prefer SVG or PNG for diagrams.
- Name assets after the lab or foundation module they explain.
- Do not commit screenshots that expose account IDs, secrets, public IPs, private endpoints, or cost-account details.
