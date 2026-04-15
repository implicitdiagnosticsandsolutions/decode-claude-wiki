#!/usr/bin/env bash
#
# decode-base plugin — Stop hook.
# Blocks session stop when substantive files are modified and no fresh
# reviewer-clean marker exists. The detailed procedure lives in CLAUDE.md
# under "Reviewer procedure" — this hook just triggers it.
#
# Emits JSON with decision: "block" (structured) instead of exit 2 +
# stderr, to avoid rendering a verbose "hook error" block in the
# terminal UI. The reason goes to the model; the UI stays quiet.

set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 0
fi

cd "$(git rev-parse --show-toplevel)"

PATTERNS='\.(py|ts|tsx|js|jsx|R|r|java|sql)$|^scripts/|^output/|^dist/'

MODIFIED=$( {
  git diff --name-only --diff-filter=ACMRD HEAD 2>/dev/null || true
  git ls-files --others --exclude-standard 2>/dev/null || true
  git diff --cached --name-only --diff-filter=ACMR 2>/dev/null || true
} | sort -u )

if ! echo "$MODIFIED" | grep -qE "$PATTERNS"; then
  exit 0
fi

MARKER=".decode-reviewer-clean"
if [ -f "$MARKER" ]; then
  MARKED_SHA=$(awk 'NR==1 {print $1}' "$MARKER" 2>/dev/null || echo "")
  CURRENT_SHA=$(git rev-parse HEAD 2>/dev/null || echo "initial")
  if [ "$MARKED_SHA" = "$CURRENT_SHA" ]; then
    exit 0
  fi
fi

cat <<'JSON'
{"decision": "block", "reason": "Substantive files were modified and no fresh .decode-reviewer-clean marker exists. Run the 'Reviewer procedure' from CLAUDE.md before ending the session or committing."}
JSON
exit 0
