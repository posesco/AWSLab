#!/bin/bash

set -e

MODULE_NAME=$(basename "$(pwd)")
MEDIA_DIR="$(git rev-parse --show-toplevel)/media"
GRAPH_FILE="${MODULE_NAME}_graph.svg"

echo "Generating documentation for: $MODULE_NAME"

mkdir -p "$MEDIA_DIR"

# Generate fresh tf-docs output into a temp file
TMP_DOCS=$(mktemp)
docker run --rm \
  --volume "$(pwd):/terraform-docs" \
  -u "$(id -u)" \
  quay.io/terraform-docs/terraform-docs \
  markdown /terraform-docs > "$TMP_DOCS"

# If README.md exists and has content before ## Requirements, preserve it
if [ -f README.md ]; then
  PREAMBLE=$(awk '/^## Requirements/{exit} {print}' README.md)

  if [ -n "$PREAMBLE" ]; then
    echo "README.md exists with custom content before '## Requirements' — preserving it."

    # Extract everything from ## Requirements onwards from the new tf-docs output
    TF_SECTION=$(awk '/^## Requirements/{found=1} found{print}' "$TMP_DOCS")

    # Combine: preserved preamble + new tf-docs section
    {
      printf '%s\n' "$PREAMBLE"
      printf '%s\n' "$TF_SECTION"
    } > README.md
  else
    echo "README.md exists but has no custom preamble — overwriting fully."
    cp "$TMP_DOCS" README.md
  fi
else
  echo "No README.md found — creating from scratch."
  cp "$TMP_DOCS" README.md
fi

rm -f "$TMP_DOCS"

# Generate Terraform graph and append Diagram section
terraform graph | dot -Tsvg > "$MEDIA_DIR/$GRAPH_FILE"

RELATIVE_PATH=$(realpath --relative-to="$(pwd)" "$MEDIA_DIR")

cat >> README.md << EOF

## Diagram

![Terraform Graph](${RELATIVE_PATH}/${GRAPH_FILE})
EOF

echo "Done! README.md updated with diagram."