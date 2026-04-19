#!/usr/bin/env bash
#
# DECODE hardening PreToolUse hook on Bash.
# Blocks destructive git operations without explicit user sign-off.
#
# Tier-aware: product tier repos (node, java) get the full lockdown.
# Data tier repos (python, r) get a narrower lockdown that allows
# `checkout .` and `restore .` (routine scratch-exploration cleanup).
#
# Tier detection:
#   - If repo has package.json (and no pyproject.toml/setup.py): node (full)
#   - If repo has pom.xml or build.gradle: java (full)
#   - Otherwise: data tier (narrow)
#
# Override: user must ask Claude to run the destructive command manually
# after explicit confirmation in chat. The hook does not have an env var
# override — bypasses must be visible.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Detect tier
TIER="data"
if [ -f "package.json" ] && [ ! -f "pyproject.toml" ] && [ ! -f "setup.py" ]; then
  TIER="product"
elif [ -f "pom.xml" ] || [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
  TIER="product"
fi

# Patterns blocked in ALL tiers (always dangerous).
# Note: rm patterns are anchored to end-of-argument or followed by a
# slash-terminated root — this prevents false positives on `rm -rf /tmp/foo`
# (legitimate) while still blocking `rm -rf /` (catastrophic), `rm -rf ~`,
# and `rm -rf ~/` (same home-directory wipe with trailing slash).
BLOCKED_ALL=(
  "git[[:space:]]+push[[:space:]].*--force"
  "git[[:space:]]+push[[:space:]]+-f([[:space:]]|$)"
  "git[[:space:]]+reset[[:space:]]+--hard"
  "git[[:space:]]+clean[[:space:]]+-[a-z]*f"
  "git[[:space:]]+branch[[:space:]]+-D"
  "(^|[^a-zA-Z0-9_/])rm[[:space:]]+-[a-z]*r[a-z]*f[a-z]*[[:space:]]+/(\s|$)"
  "(^|[^a-zA-Z0-9_/])rm[[:space:]]+-[a-z]*r[a-z]*f[a-z]*[[:space:]]+~/?(\s|$)"
)

# Patterns blocked only in PRODUCT tier
BLOCKED_PRODUCT=(
  "git[[:space:]]+checkout[[:space:]]+\.([[:space:]]|$)"
  "git[[:space:]]+checkout[[:space:]]+--[[:space:]]+\.([[:space:]]|$)"
  "git[[:space:]]+restore[[:space:]]+\.([[:space:]]|$)"
)

# Check all-tier patterns
for pattern in "${BLOCKED_ALL[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    cat >&2 <<EOF
BLOCKED: destructive command matched pattern '$pattern'
Command: $COMMAND

Destructive operations require explicit user sign-off. If the user asked
for this, the model should surface the command in chat for confirmation
before invoking the tool. See decode-claude-wiki/docs/rules for rule 08.
EOF
    exit 2
  fi
done

# Check product-tier-only patterns
if [ "$TIER" = "product" ]; then
  for pattern in "${BLOCKED_PRODUCT[@]}"; do
    if echo "$COMMAND" | grep -qE "$pattern"; then
      cat >&2 <<EOF
BLOCKED: '$pattern' is blocked in product-tier repos (this repo detected as $TIER).
Command: $COMMAND

If you need to discard working-tree changes, use a narrower pattern
(specific paths) or ask the user to run it manually.
EOF
      exit 2
    fi
  done
fi

exit 0
