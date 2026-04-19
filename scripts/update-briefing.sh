#!/usr/bin/env bash
# Publish a dated briefing and set it as the live page (updates briefings/current.json).
# Usage:
#   ./scripts/update-briefing.sh 2026-08-04 path/to/briefing.md
#   ./scripts/update-briefing.sh 2026-08-04   # paste content, end with Ctrl-D
#   ./scripts/update-briefing.sh 2026-08-04 - <<'EOF'
#   # My briefing
#   EOF

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BRIEF="$ROOT/briefings"

usage() {
  echo "Usage: $0 YYYY-MM-DD [source.md]" >&2
  echo "  Or:  $0 YYYY-MM-DD   # read markdown from stdin" >&2
  exit 1
}

[[ $# -ge 1 ]] || usage
DATE="$1"
if [[ ! "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "First argument must be YYYY-MM-DD" >&2
  exit 1
fi

OUT="$BRIEF/${DATE}.md"

if [[ -n "${2:-}" ]]; then
  cp "$2" "$OUT"
else
  cat > "$OUT"
fi

printf '%s\n' "{\"file\": \"${DATE}.md\"}" > "$BRIEF/current.json"
echo "Wrote $OUT"
echo "Wrote $BRIEF/current.json -> ${DATE}.md"
