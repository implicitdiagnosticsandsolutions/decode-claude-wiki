---
number: 03
title: reviewer-subagent-required
tiers: [product, data-python, data-r]
enforcement: reviewer-stop.sh + commit-msg gate
justification: proactive-risk
incidents: []
status: shipped
---

# 03. Dispatch the reviewer subagent before committing non-trivial work

## Rule statement

For any change that modifies source code, generator scripts, methodology, data outputs, or architectural invariants, dispatch the `feature-dev:code-reviewer` subagent before committing. The Stop hook blocks session end until the reviewer has run on the pending diff; the commit-msg hook blocks the commit until a fresh `.decode-reviewer-clean` marker is written.

## Why

`justification: proactive-risk`. This is the foundation of Gate 1 (Golden Rule). An agent reviewing its own work has well-documented blind spots: assumption-drift between spec and implementation, missed edge cases in its own code, overconfident summaries. An independent reviewer — different model session, constrained to review-only, findings-first — materially raises the floor on what ships.

DECODE has not had its own documented incident yet; the rule is adopted proactively because:

1. The cost of the review step is sub-90 seconds per substantive change.
2. The blast radius of an agent-authored bug reaching master is high — especially for a non-technical team that does not routinely PR-review each other.
3. The enforcement mechanism (marker file bound to diff hash) is tamper-resistant by construction; agents cannot silently bypass it.

If a real DECODE incident materialises later (reviewer caught X, reviewer would have caught Y), add it to `incidents:` and flip `justification` to `incident`.

## How to apply

On any session that has modified substantive files (`.py`, `.ts`, `.tsx`, `.js`, `.jsx`, `.R`, `.r`, `.java`, `.sql`, or anything under `scripts/`):

1. Run `git diff HEAD` via Bash.
2. Dispatch `feature-dev:code-reviewer` via the Agent tool. Pass the diff as context. Target sub-90-second latency; report only blocking issues (confidence ≥ 80).
3. On clean review: compute `DIFF_HASH=$(bash scripts/reviewer-hash.sh)` and write `.decode-reviewer-clean` with `<HEAD-SHA> <DIFF-HASH> <ISO-8601-UTC-timestamp>`.
4. On blocking findings: write `.decode-reviewer-findings.md` with the list. Do not write the clean marker.

The reviewer must not edit code directly. If it does, disclose those edits and treat them as part of the change under review — run another review pass over the final diff.

Hard escape hatch only: `[override-reviewer: <reason>]` anywhere in the commit message. Logged forever via `git log --grep="override-reviewer"`.

## Enforcement

- **Hook:** `.claude/hooks/reviewer-stop.sh` (SessionStop) blocks session end when substantive files changed and no fresh marker exists.
- **Gate:** `.githooks/commit-msg` blocks commits when the marker's HEAD and DIFF hashes do not match the current repo state.
- **Reviewer check:** the subagent itself. The marker is the evidence that it ran; the diff hash is the evidence that nothing changed between review and commit.

## Tiers

- [x] product
- [x] data-python
- [x] data-r
- [ ] meta (usually off)

## Related rules

- Rule 02 (patch the source) — the reviewer is the primary catch for this.
- Rule 07 (invariants exit non-zero) — the commit-msg gate is itself an invariant check; it hard-fails when the marker is missing or stale.
- Rule 08 (destructive ops require sign-off) — complementary rail; the reviewer runs before commit, block-dangerous-git.sh runs on every Bash.
