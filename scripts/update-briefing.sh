#!/usr/bin/env bash
# Write briefings/latest.md with the correct date header, and optionally archive the previous latest.
# The source must be the body only (no YAML front matter); this script adds date: for you.
#
# Usage:
#   ./scripts/update-briefing.sh 2026-08-05 path/to/draft.md
#   ./scripts/update-briefing.sh 2026-08-05   # body from stdin (end with Ctrl-D)
#
# If briefings/archive/YYYY-MM-DD.md does not exist yet, copies the current latest.md there first.

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LATEST="$ROOT/briefings/latest.md"
ARCHIVE_DIR="$ROOT/briefings/archive"

usage() {
  echo "Usage: $0 YYYY-MM-DD [source.md]" >&2
  echo "  Or:  $0 YYYY-MM-DD   # read body from stdin (no YAML; optional first # title line is removed)" >&2
  exit 1
}

[[ $# -ge 1 ]] || usage
DATE="$1"
if [[ ! "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "First argument must be a calendar date: YYYY-MM-DD (ISO 8601)." >&2
  exit 1
fi

mkdir -p "$ARCHIVE_DIR"
ARCHIVE="$ARCHIVE_DIR/${DATE}.md"

if [[ -f "$LATEST" && ! -f "$ARCHIVE" ]]; then
  cp "$LATEST" "$ARCHIVE"
  echo "Archived previous latest to $ARCHIVE"
fi

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

if [[ -n "${2:-}" ]]; then
  cat "$2" > "$TMP"
else
  cat > "$TMP"
fi

# Drop a single leading # heading line so the page does not repeat the title.
sed '1{ /^[[:space:]]*#[[:space:]]/d; }' "$TMP" > "${TMP}.stripped"
mv "${TMP}.stripped" "$TMP"

{
  echo "---"
  echo "date: $DATE"
  echo "---"
  echo ""
  cat "$TMP"
} > "$LATEST"

echo "Wrote $LATEST"
