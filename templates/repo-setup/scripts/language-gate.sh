#!/usr/bin/env bash
#
# DECODE shared language gate.
#
# Used by:
# - .githooks/pre-commit   (default: staged files)
# - .github/workflows/gate.yml (explicit changed-file list)
#
# Hard-fail on deterministic lint errors. Heuristic artifact checks stay
# advisory so normal regenerate flows are not blocked by noisy guesses.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

if [ "$#" -gt 0 ]; then
  FILES=$(printf '%s\n' "$@")
else
  FILES=$(git diff --cached --name-only --diff-filter=ACMR || true)
fi

if [ -z "$FILES" ]; then
  exit 0
fi

FAIL=0

PY_FILES=$(printf '%s\n' "$FILES" | grep -E '\.py$' || true)
if [ -n "$PY_FILES" ]; then
  if command -v ruff >/dev/null 2>&1; then
    if ! printf '%s\n' "$PY_FILES" | xargs ruff check; then
      echo >&2 "[gate] ruff check failed on Python files"
      FAIL=1
    fi
  else
    echo >&2 "[gate] WARN: ruff not installed — skipping Python lint."
  fi
fi

JS_FILES=$(printf '%s\n' "$FILES" | grep -E '\.(ts|tsx|js|jsx)$' || true)
if [ -n "$JS_FILES" ] && [ -f "package.json" ]; then
  if [ -x "node_modules/.bin/eslint" ]; then
    if ! printf '%s\n' "$JS_FILES" | xargs node_modules/.bin/eslint; then
      echo >&2 "[gate] eslint failed on JS/TS files"
      FAIL=1
    fi
  else
    echo >&2 "[gate] WARN: eslint not installed — skipping JS/TS lint."
  fi
fi

R_FILES=$(printf '%s\n' "$FILES" | grep -E '\.(R|r)$' || true)
if [ -n "$R_FILES" ] && command -v Rscript >/dev/null 2>&1; then
  printf '%s\n' "$R_FILES" | while IFS= read -r f; do
    [ -f "$f" ] || continue
    Rscript -e "lints <- tryCatch(lintr::lint('$f'), error = function(e) NULL); if (!is.null(lints) && length(lints) > 0) { cat(format(lints)); }" 2>/dev/null || true
  done
fi

ARTIFACT_FILES=$(printf '%s\n' "$FILES" | grep -E '^(output|dist)/.*\.(csv|json|html|xlsx)$' || true)
SCRIPT_FILES=$(printf '%s\n' "$FILES" | grep -E '^scripts/.*\.(py|R|r|js|ts)$' || true)
if [ -n "$ARTIFACT_FILES" ] && [ -z "$SCRIPT_FILES" ]; then
  echo >&2 "[gate] WARNING: artifacts changed under output/ or dist/ without any staged generator change under scripts/."
  echo >&2 "[gate] WARNING: if these files are generated, rule 02 expects patching the generator and regenerating."
fi

if [ "$FAIL" -ne 0 ]; then
  cat >&2 <<'EOF'
================================================================
DECODE LANGUAGE GATE: deterministic checks failed.

Fix the issues above and retry. The commit-msg hook may still allow a
reviewer override marker, but CI will rerun this same language gate.
================================================================
EOF
  exit 1
fi

exit 0
