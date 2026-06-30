#!/usr/bin/env bash
# Export a marimo notebook as a themed WASM embed for this Hugo site.
#
# Usage:  scripts/embed-marimo.sh <notebook.py> <slug>
# Then in a post:  {{< marimo src="/notebooks/<slug>/" >}}
#
# - --show-code shows the implementation (per-cell hide_code is respected)
# - patches the embedded theme to dark (no --theme flag exists)
set -euo pipefail
NB="${1:?usage: embed-marimo.sh <notebook.py> <slug>}"
SLUG="${2:?usage: embed-marimo.sh <notebook.py> <slug>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/static/notebooks/$SLUG/"
marimo export html-wasm "$NB" -o "$OUT" --show-code -f
sed -i '' 's/"theme": "light"/"theme": "dark"/g' "${OUT}index.html"
echo "Embedded -> /notebooks/$SLUG/   (use:  {{< marimo src=\"/notebooks/$SLUG/\" >}} )"
