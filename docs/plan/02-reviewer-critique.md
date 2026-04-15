# Reviewer Critique of v1 and Changes in v2

v1 was an initial proposal. A fresh-context reviewer agent critiqued it; v2 ([`01-strategy.md`](01-strategy.md)) integrates the critique.

## v1 in brief

v1 proposed five layers: plugin marketplace → CLAUDE.md base → hooks → `.githooks/pre-commit` → skills. Plugins were the distribution center. Rollout started with Silke's repo (highest Claude volume, zero guardrails). Hooks were one-size-fits-all. CLAUDE.md capped at ≤150 lines. Rules were generic engineering principles.

## Critique (summary of findings)

### 1. Plugin marketplace mechanism needs verification before investment

The marketplace system is real (Anthropic official docs), but whether arbitrary-GitHub-org repos can be registered with auto-update behavior needs empirical check. Don't have the rollout owner invest days into building plugins against unverified assumptions.

**Action taken:** Moved plugin marketplace verification to [`04-open-questions.md`](04-open-questions.md) Q1, as a gate before any plugin work begins.

### 2. Incident log gap is structural, not cosmetic

Rules without real-incident references get ignored at the same rate as wiki pages. "Verify before claiming" is a platitude. `"Never claim it's in memory without reading the memory file — cost: 2026-04-11 incident where I told a user v10 repro command was in memory; it was actually in a README that isn't auto-loaded"` sticks.

**Action taken:** Incident log made a hard prerequisite for any wave. Candidate incidents listed in [`01-strategy.md`](01-strategy.md) mined from existing memory files.

### 3. Rollout ordering was wrong for blast radius

v1 started with Silke's PBI utils because she has the most attributed Claude commits (21). But PBI utils is internal tooling. Willi's Velocity backend/frontend touches real customer data. If Claude does something destructive there without guardrails, the damage is customer-facing.

**Action taken:** Velocity moved to Wave 1 (parallel), PBI utils + Roshan's PPT moved to Wave 2.

### 4. `block-dangerous-git.sh` was too aggressive for data repos

`git checkout .` and `git restore .` are routine scratch-cleanup in data analysis work. Blocking them would generate workarounds and hook bypass.

**Action taken:** Two hook tiers — product (full git lockdown) and data (narrower, only `--force`, `reset --hard`, `clean -f`, `branch -D`).

### 5. "≤150 lines" was unjustified

v1 capped CLAUDE.md at 150 lines. But `strategy-suite/CLAUDE.md` is 623 lines and works well — because it's specific. 150 lines of vague rules is worse than 600 lines of specific ones.

**Action taken:** Line limit dropped. Replaced with a specificity criterion: every rule must cite an incident or name a concrete file path.

### 6. (The biggest one) Plugins are voluntary — what about bypass?

v1 had no answer to: "what if Silke simply never runs `/plugin install`?" The plugin layer is purely opt-in. The only mandatory rails are `.claude/settings.json`, `.claude/hooks/*.sh`, and `.githooks/pre-commit` committed in each repo.

**Action taken:** Architecture inverted. Plugins are a productivity layer, not enforcement. Enforcement lives in repo-committed files. CI runs the same gate scripts as a second backstop.

## What didn't change from v1

- Hook library borrowed from `strategy-suite` (`block-dangerous-git`, `monitor-ci`, `session-reflect`, `check-doc-index`, Stop-hook invariant check).
- Data-tier rules ported from `social-media-analytics` (ground-truth rules 12/13/16/17).
- `decode-claude-wiki` as the plugin marketplace destination and knowledge-layer home.
- Five-layer model preserved, but the weight of each layer shifted.
