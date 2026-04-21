# Rules Catalog

The library of hard rules DECODE's Claude Code usage enforces. Tier templates (`python`, `node`, `r`, `docs`) assemble subsets into target repos via `templates/repo-setup/CLAUDE.md.template`.

## One file per rule

Filename: `NN_short-name.md`. Template: [`_template.md`](_template.md).

Each rule file has:

- **Rule statement** — imperative mood, one sentence. This is what goes into target-repo `CLAUDE.md`.
- **Why** — which incident(s) in `../incidents/` justify the rule.
- **How to apply** — concrete guidance; a reader must be able to tell whether their action complies.
- **Enforcement** — which hook, gate, or CI check operationalizes this.
- **Tiers** — which target-repo tiers import this rule.
- **Status** — `draft`, `ready`, `shipped`.

## Hard requirement

**A rule with empty `incidents:` frontmatter is not ship-ready.** The template enforces this at the frontmatter level. Lifecycle:

1. Incident file exists in `../incidents/`.
2. Rule drafted here with `status: draft` and non-empty `incidents:` list.
3. Rule reviewed and marked `status: ready`.
4. Rule shipped — imported into target-repo CLAUDE.md template; enforcement (hook / gate) lands in the same commit.
5. Rule tracked — new violations link back to the rule as "existed but not followed."

## Candidate rules — draft set

These are drafts. No rule ships until it has a linked incident file.

| # | Rule statement (draft) | Status | Incident source |
|---|---|---|---|
| 01 | Before citing a file, path, command, or memory reference, open it and confirm it contains what you claim. | draft | Pending DECODE incident |
| 02 | Before editing a file produced by a script, locate the generator. Patch the generator, regenerate, verify byte-identical. | draft | Pending DECODE incident; enforced by hook today |
| 03 | For any change that modifies source code, generator scripts, methodology, data outputs, or architectural invariants, dispatch the reviewer subagent before committing. | draft | Pending DECODE incident; enforced by hook today |
| 04 | Stage files explicitly. Never `git add -A` or `git add .`. | draft | Pending DECODE incident |
| 05 | No AI attribution in commits. Conventional format, human author. | shipped | Enforced via supervisor's global CLAUDE.md |
| 06 | When creating a new doc under `docs/`, add it to `docs/INDEX.md` (if the repo has one) in the same commit. | draft | Ported from strategy-suite `check-doc-index.sh` |
| 07 | Invariant checks that matter must exit non-zero on failure. A warning that doesn't block is not a gate. | draft | Pending DECODE incident; foundation of Gate 2 |
| 08 | Destructive ops (`push --force`, `reset --hard`, `rm -rf`, `DROP`, `TRUNCATE`) require explicit user sign-off in chat before execution. | shipped | Enforced via `block-dangerous-git.sh` hook |
| 09 | Reproducibility tests regenerate from scratch. Hashing a committed file against its own hash is not a reproducibility test. | draft | Pending DECODE incident; narrow tier — data repos only |
| 10 | The word "should" in a response is a prompt to replace it with a check. Before sending "X should work", run the check. | draft | Pending DECODE incident |
| 11 | Every Aurora PostgreSQL connection must use `sslmode=require`. | draft (DECODE-native) | `memory/feedback-ssl.md` — pending seeding to `../incidents/` |

## Excluded (too specific)

| Rule | Why excluded |
|---|---|
| "Update both Prisma schemas (dev + prod)" | Specific to `strategy-suite` (excluded from rollout). Other target repos don't have dual Prisma schemas. |

