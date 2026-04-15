# Reviewer Critique — v1 → v2 → v3 History

This file is historical. Current strategy is in [`01-strategy.md`](01-strategy.md).

## v1 → v2

v1 proposed five layers with plugins as the distribution center. Critique from an independent reviewer agent surfaced six issues:

1. Plugin marketplace mechanism unverified (resolved in v3).
2. Incident log gap is structural, not cosmetic (resolved in v3 via auto-capture).
3. Rollout ordering wrong for blast radius (obsolete — v3 drops wave model entirely).
4. `block-dangerous-git.sh` too aggressive for data repos (preserved in v3 as tier-aware hook).
5. Line-count limits unjustified (v3 drops line limits, keeps specificity criterion).
6. Plugins are voluntary — what about bypass? (resolved in v3 by moving enforcement to repo-committed files, plugins carry only productivity skills).

## v2 → v3

v2 restored the repo-tracked enforcement model but kept wave-by-wave rollout and manual incident curation. Supervisor feedback: **over-engineered for a non-technical team.** DECODE has one real programmer; the rest is vibe coding. v3 rewrite:

- Cut wave model. One template PR per repo, Kleo merges.
- Cut manual incident curation. Auto-capture from commit messages, CI failures, reverts.
- Verified plugin auto-prompt mechanism empirically via Anthropic docs.
- Added strong override format (`[override-reviewer: reason]` in commit message) for auditability in `git log`.
- Reframed whole proposal around "harness the vibe": vibe coders don't need standards lectures, they need guardrails the model runs into.

## v1 scaffold review (this repo)

A second review found six further issues before the first commit:

1. Bypass story was dishonest about the `.githooks/pre-commit` opt-in gap. Fixed in `01-strategy.md` "Bypass — the honest picture" section.
2. Duplicate row for `new-research-paradigms` in Wave 4. Fixed.
3. Rule #1 ("Verify before claiming") was too vague. Rewritten to specific form.
4. Rule #12 (dual Prisma schemas) was strategy-suite-specific. Removed from base and flagged as excluded.
5. Rule template didn't hard-require incident link. Frontmatter now marks `incidents:` as required.
6. Q4 was mis-framed as open-ended. Reframed as "blocked on 1-day supervisor check."

All six fixed in v1 of the scaffold. The transition to v3 framing supersedes most of this — the whole scaffold was restructured around "auto-everything, minimal human touch."

## Why this history is preserved

Any future rollout owner inheriting this repo should be able to see that the design went through two rounds of external review before shipping. The reviews themselves caught real bugs. Keeping the history makes the process visible — and makes it easier for a successor to do the same (spot a bad assumption, propose a revision, review it, ship).

If the current design v3 also turns out to be wrong, this file grows a v3 → v4 section.
