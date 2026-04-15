# Rules Catalog

The library of hard rules DECODE's Claude Code usage enforces. Each rule is a single file. Tier templates (product / data-python / data-r) assemble subsets into their respective `CLAUDE.md` imports.

## Rule file = one rule

Filename: `NN_short-name.md` where `NN` is the rule number in the DECODE base (01–99). Ordering within a tier's CLAUDE.md import is controlled by the tier template, not the filename.

Each rule file has:

- **Rule statement** — the actual text that goes into `CLAUDE.md`. Imperative mood. One sentence.
- **Why** — what failure the rule prevents. Reference to at least one incident in `../incidents/`.
- **How to apply** — concrete guidance for when/where the rule kicks in.
- **Enforcement** — which hook, gate, or check-list item operationalizes this rule (if any). Rules that are pure CLAUDE.md advisories are fine; rules that *should* have enforcement but don't are tech debt.
- **Tiers** — which tier templates import this rule (`product`, `data-python`, `data-r`, `all`).

Use [`_template.md`](_template.md).

## Rule lifecycle

**Step 1 is non-negotiable.** Rules without a filed incident never reach draft status.

1. **Incident file exists** under `../incidents/YYYY-MM-DD_repo_shortname.md` with real data (date, repo, SHA, cost). If this file does not exist, stop — file the incident first.
2. **Rule drafted** → new file under this directory with `status: draft` and non-empty `incidents:` frontmatter linking to step 1.
3. **Rule reviewed** → supervisor signs off on wording, tier assignment, and enforcement mechanism.
4. **Rule status advances to `ready`** → passed the quality bar, has a concrete enforcement mechanism (or is explicitly marked CLAUDE.md-advisory-only with tech-debt flag).
5. **Rule ships** → status `shipped`. Imported into relevant tier CLAUDE.md templates; if enforceable, hook or gate lands in the same commit.
6. **Rule tracked** → if violated again, new incident links back to this rule as "rule existed but was not followed" — triggers review of whether enforcement is strong enough or the rule wording is unclear.

## Rule quality bar

Every rule must pass this test: **could a reader predict whether their action is compliant without asking?**

A rule like "write clean code" fails. A rule like "every `src/app/api/**/*.ts` handler must call `requireResearcher()` or `requireAuth()` at the top" passes.

Specificity beats breadth. One concrete rule that catches one real failure is worth more than five general principles that catch none.

## Candidate rules for the DECODE base (v1)

These are the starter set. Before any ship, each must have at least one linked incident in `../incidents/`.

These are drafts. **No rule ships until it has a linked incident file under `../incidents/` with date + SHA + cost.** Vague rules are flagged here so they get rewritten before shipping, not so they ship vague.

| # | Rule statement (draft) | Status | Likely incident source |
|---|---|---|---|
| 01 | Before citing a file, path, command, or memory reference, open it and confirm it contains what you claim — paste the matching line into the response. | Specific enough | `social-media-analytics` Rule 2 + DECODE memory-lookup failures |
| 02 | Before editing a file produced by a script, locate the generator. Patch the generator, regenerate, verify byte-identical. | Specific enough | `social-media-analytics` Rule 1 |
| 03 | For any change that modifies a client deliverable, generator, methodology, or architectural invariant, dispatch a reviewer agent with the code and expected results before committing. | Specific enough | `social-media-analytics` Rule 5 |
| 04 | When staging files, name each one. Never `git add -A` or `git add .`. | Specific enough | `social-media-analytics` Rule 4 |
| 05 | No AI attribution in commits. Author = human. Conventional commit format. | Specific enough | Global CLAUDE.md rule, already enforced |
| 06 | When creating a new doc under `docs/`, add it to `docs/INDEX.md` in the same commit. When changing a shared source-of-truth file, `grep -r <concept> docs/` and update references in the same commit. | Specific enough | `strategy-suite` check-doc-index.sh hook |
| 07 | Invariant checks that matter must exit non-zero on failure and be wired into a pre-commit gate or CI step. A check that only prints a warning is not a gate. | Specific enough | `social-media-analytics` Rule 11 |
| 08 | Destructive ops are paused for explicit user sign-off: `push --force`, `reset --hard`, `rm -rf`, `git clean -f`, `git branch -D`, `DROP`, `TRUNCATE`. | Specific enough | `block-dangerous-git.sh` hook |
| 09 | A reproducibility test must delete or back up the committed artifact, run the generator end-to-end from committed inputs, and compare the regenerated output to the backup. Hashing a committed file against its own hash is not a reproducibility test. | Specific enough | `social-media-analytics` Rule 3 |
| 10 | The word "should" in a response is a prompt to replace it with an actual check. Before sending "X should work now", run the check. | Specific enough | `social-media-analytics` Rule 9 |
| 11 | Every connection to the DECODE Aurora cluster must use `sslmode=require`. Without it, auth failures surface as misleading "password authentication failed". | Specific enough — DECODE-native | `memory/feedback-ssl.md` |

All rules 01-10 are ports from `social-media-analytics` that need re-anchoring to DECODE incidents per [`../plan/04-open-questions.md`](../plan/04-open-questions.md) Q6. Until re-anchored, they carry the social-media-analytics incident reference as an "analogous incident" with a flag.

### Excluded from DECODE base (too specific)

These were candidate rules but do not generalize across the 26 repos. They belong in per-repo CLAUDE.md, not the shared base.

| Rule | Why excluded |
|---|---|
| "Update both Prisma schemas (dev + prod)" | Specific to `strategy-suite`. Other repos either use a single Prisma schema (`questionnaire-editor`) or no Prisma at all (all data repos). Belongs in `strategy-suite/CLAUDE.md` only. |

## Data-tier-only rules (candidate)

Specific to `data-python` and `data-r` tier repos. Ports from `social-media-analytics`:

| # | Rule statement | Source |
|---|---|---|
| D1 | Raw per-asset ground-truth data (e.g. S3 JSON) is mandatory for any client simulator. CSV totals alone are insufficient. | social-media-analytics Rule 12 |
| D2 | The shipped client-facing HTML is the single source of truth. Python side-channels must gate against it. | social-media-analytics Rule 13 |
| D3 | Gates must cover every cell in the JSON they protect — not just headlines. | social-media-analytics Rule 16 |
| D4 | Path-selection before citation — declare which code path produced a number before citing it. | social-media-analytics Rule 17 |

These apply to DECODE repos like `icat_app`, `network_html`, `synthetic-consumer`, `PBI_team_utils`, and `bi2pyhton2point`.
