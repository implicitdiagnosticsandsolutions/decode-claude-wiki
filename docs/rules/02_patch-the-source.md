---
number: 02
title: patch-the-source
tiers: [data-python, data-r]
enforcement: language-gate.sh (advisory) + reviewer-subagent (blocking)
justification: proactive-risk
incidents: []
status: shipped
---

# 02. Patch the source, not the generated artifact

## Rule statement

Before editing a file produced by a script, locate the generator. Patch the generator, regenerate, and verify the output matches what you intended.

## Why

`justification: proactive-risk`. This rule closes a class of silent-regression failure that is known to occur in any codebase that ships both generators and generated artifacts (dashboards, exports, compiled HTML/CSV/JSON, fixtures). Editing the artifact directly appears to work, but the next regeneration reverts the fix without warning. The longer the gap between the edit and the next regeneration, the harder the debugging.

DECODE has not had its own documented incident yet; the rule is adopted proactively because:

1. Every DECODE data repo has generator scripts (`scripts/analysis-*`) that produce outputs under `output/`, `dist/`, or equivalent.
2. The failure mode is irreversible once triggered — the fix is lost silently.
3. The cost of the guardrail is zero: running the generator takes seconds; checking which file generated what is a mechanical grep.

If a real DECODE incident materialises later, add it to `incidents:` and flip `justification` to `incident`.

## How to apply

Before editing any file under `output/`, `dist/`, or any path the repo's `language-gate.sh` flags as generator-produced:

1. Find the generator — usually a script in `scripts/` that writes to the same path.
2. Patch the generator.
3. Regenerate.
4. Verify the change is present in the artifact.

If you cannot find the generator, stop and ask — editing the artifact without understanding the regeneration loop is the failure mode this rule prevents.

## Enforcement

- **Hook:** none directly.
- **Gate:** `scripts/language-gate.sh` emits an advisory `WARNING: artifacts changed under output/ or dist/ without any staged generator change under scripts/` when staged changes match this pattern. Advisory because legitimate manual edits to output do exist (seed data, test fixtures); the agent is expected to stop and think when the warning fires.
- **Reviewer check:** blocking. The `feature-dev:code-reviewer` subagent reviews every substantive change before commit via the Stop hook + commit-msg gate. If the diff changes an artifact path without touching its generator, the reviewer is expected to flag it as high-confidence.

## Tiers

- [ ] product
- [x] data-python
- [x] data-r
- [ ] meta (usually off)

## Related rules

- Rule 03 (reviewer subagent required) — enforces the review pass where a patch-source violation gets caught.
- Rule 07 (invariants exit non-zero) — complementary; the `language-gate.sh` warning is deliberately advisory, not a hard fail, because artifact edits can be legitimate.
