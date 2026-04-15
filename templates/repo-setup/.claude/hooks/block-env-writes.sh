#!/usr/bin/env bash
#
# decode-base plugin — PreToolUse hook on Edit / Write tools.
# Blocks writes to .env* files, credentials files, and key files.
#
# Exits 2 (block) if the target path matches the denylist.

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Only gate Edit / Write
case "$TOOL" in
  Edit|Write|NotebookEdit) ;;
  *) exit 0 ;;
esac

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

BASENAME=$(basename "$FILE_PATH")

# Denylist patterns (exact basename or glob-style)
case "$BASENAME" in
  .env|.env.local|.env.*|credentials|credentials.*|*.pem|*.key|*.pfx|id_rsa|id_rsa.*|service-account.json)
    cat >&2 <<EOF
BLOCKED: write to '$FILE_PATH' denied.

Files containing credentials or secrets should never be modified by Claude
automatically. If this is intentional, ask the user to edit manually, or
use a gitignored .env.local that is not in the denylist.
EOF
    exit 2
    ;;
esac

exit 0
