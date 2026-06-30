#!/usr/bin/env bash
# Export a marimo notebook as a themed WASM embed for this Hugo site.
#
# Usage:  scripts/embed-marimo.sh <notebook.py> <slug>
# Then in a post:  {{< marimo src="/notebooks/<slug>/" >}}
#
# - --show-code shows the implementation (per-cell hide_code is respected)
# - patches the embedded theme to dark (no --theme flag exists)
# - also writes edit.html: a full editable runner sharing the same ./assets,
#   which the shortcode's "Open in marimo" button links to (new tab)
set -euo pipefail
NB="${1:?usage: embed-marimo.sh <notebook.py> <slug>}"
SLUG="${2:?usage: embed-marimo.sh <notebook.py> <slug>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/static/notebooks/$SLUG/"
marimo export html-wasm "$NB" -o "$OUT" --show-code -f
sed -i '' 's/"theme": "light"/"theme": "dark"/g' "${OUT}index.html"

# Editable runner (edit.html) — only index.html differs from run mode, so it
# reuses the run export's assets; just drop in its patched index.html.
TMP="$(mktemp -d)"
marimo export html-wasm "$NB" -o "$TMP" --mode edit -f >/dev/null
sed 's/"theme": "light"/"theme": "dark"/g' "$TMP/index.html" > "${OUT}edit.html"
rm -rf "$TMP"

echo "Embedded -> /notebooks/$SLUG/   (use:  {{< marimo src=\"/notebooks/$SLUG/\" >}} )"
echo "  editable runner: /notebooks/$SLUG/edit.html (button links here)"
