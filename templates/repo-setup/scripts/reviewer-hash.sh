#!/usr/bin/env bash
#
# DECODE reviewer hash — single source of truth for the DIFF_HASH captured in
# the .decode-reviewer-clean marker.
#
# Used identically by:
#   - the reviewer procedure (Claude writing the marker, per CLAUDE.md)
#   - the Stop hook (.claude/hooks/reviewer-stop.sh)
#   - the commit-msg hook (.githooks/commit-msg)
#
# Default mode is --staged because commit-msg authorizes the exact staged
# commit payload, including content, file mode, and deletions. Use --all for
# Stop-hook checks over the full working tree.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

MODE="${1:---staged}"

hash_staged() {
  git -c core.quotepath=false diff \
    --cached --full-index --binary --find-renames --diff-filter=ACMRD HEAD 2>/dev/null || true
}

hash_all() {
  git -c core.quotepath=false diff \
    --full-index --binary --find-renames --diff-filter=ACMRD HEAD 2>/dev/null || true

  git -c core.quotepath=false ls-files --others --exclude-standard -z 2>/dev/null \
    | sort -zu \
    | while IFS= read -r -d '' f; do
      [ -n "$f" ] || continue
      [ -f "$f" ] || continue
      MODE=$(stat -c '%a' "$f" 2>/dev/null || echo "unknown")
      printf 'UNTRACKED %s %s\n' "$MODE" "$f"
      cat "$f"
      printf '\n'
    done
}

case "$MODE" in
  --staged) hash_staged ;;
  --all) hash_all ;;
  *)
    echo >&2 "usage: scripts/reviewer-hash.sh [--staged|--all]"
    exit 2
    ;;
esac | git hash-object --stdin
