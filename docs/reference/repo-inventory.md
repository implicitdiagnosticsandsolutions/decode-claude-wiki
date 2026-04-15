# DECODE Repo Inventory — Claude Code Adoption Audit

Snapshot: 2026-04-15. Will drift; re-audit before each wave.

## Audit methodology

For each of the 26 repos in `implicitdiagnosticsandsolutions`, check:

- `CLAUDE.md` at root → committed intent for Claude behavior
- `.claude/` directory → hook/skill/command config
- `AGENTS.md` at root → Codex entrypoint (implies multi-agent workflow)
- Count of commits with Claude-attribution patterns in the message (`Claude`, `Co-Authored-By: Claude`, `Generated with Claude Code`)

**Important caveat:** Chris's global `CLAUDE.md` explicitly forbids Claude attribution in his own commits. So a repo with high attributed-commit count is almost certainly used by someone **other than Chris**; a repo with low attribution but a committed `CLAUDE.md` is most likely Chris's personal usage.

## Inventory

### Configured + attributed (heavy users)

| Repo | CLAUDE.md | .claude/ | AGENTS.md | Attributed commits | Likely user |
|---|---|---|---|---|---|
| `strategy-suite` | ✓ | ✓ | ✓ | 254 | Chris (mixed) |
| `decoder_transformations` | ✓ (lc) | ✓ | ✓ | 127 | Willi's team |
| `velocity-planning` | ✓ | — | — | 33 | Chris |
| `bi2pyhton2point` | — | ✓ (hidden) | — | 31 | Roshan |
| `PBI_team_utils` | — | — | — | 21 | Silke |

### Attributed but not configured (heavy user without guardrails)

| Repo | Attributed | Risk |
|---|---|---|
| `DECODE-App-Substitution` | 10 | Unknown owner. Active. |
| `synthetic-consumer` | 6 | Chris (with CLAUDE.md) |
| `PBI-URL-Updater` | 4 | Azure team |
| `icat_app`, `icat_results` | 3, 3 | Juliane (CLAUDE.md in icat_results) |
| `datasystem-backend`, `datasystem-frontend` | 2, 1 | Willi's team starting |
| `organize-github` | 2 | Admin tooling |
| `Blob-Scanner-Azure` | 1 | Azure team (CLAUDE.md present) |

### Chris's own (CLAUDE.md present, near-zero attribution)

Attribution is low because Chris's commits don't carry AI attribution per his global rule.

- `cmix-programmatic`
- `network_html`
- `questionnaire-editor`
- `synthetic-consumer` (some attribution in team portion)
- `Blob-Scanner-Azure`
- `PBI-URL-Updater`
- `icat_results`

### No signal

- `dashboard` (Silke's PBI files, minimal code)
- `new-research-paradigms`
- `videoextraction_app`

### Legacy / archived / placeholder

- `01_simplicit`, `cloudstack`, `decode_pbi` — old R-era work, archived
- `project-calendar`, `velocity-troubleshooting`, `Database_Spielplatz` — empty placeholders

## User-centric summary

| Person | Repos | Current state |
|---|---|---|
| Chris | strategy-suite, velocity-planning, synthetic-consumer, questionnaire-editor, cmix-programmatic, network_html, icat_results, Blob-Scanner-Azure, PBI-URL-Updater, others | Sprawling CLAUDE.md files in some repos; strategy-suite most mature; others uneven |
| Silke | PBI_team_utils, dashboard | Heavy Claude usage, zero CLAUDE.md, zero hooks |
| Roshan | bi2pyhton2point | Heavy Claude usage, `.claude/claude.md` exists but hidden at that nested path rather than root |
| Willi's team (Willi, Udo, Greetje, Jan) | datasystem-backend, datasystem-frontend, decoder_transformations | Just starting Claude usage; decoder_transformations has the deepest config of the three |
| Juliane | icat_app, icat_results, network_html, DECODE-App-Substitution (suspected) | Moderate usage; two repos have CLAUDE.md already |
| Dirk | strategy-suite (UX contributor, not primary owner) | Non-programmer role; uses the `jmdh-collab` skill pattern |
| Azure team (external) | Blob-Scanner-Azure, PBI-URL-Updater | Moderate usage; CLAUDE.md present |

## Implications for rollout

- **Highest blast radius**: Willi's Velocity stack (backend/frontend) + decoder_transformations. Customer-facing data. Wave 1.
- **Biggest behavior-change leverage**: Silke's PBI_team_utils + Roshan's bi2pyhton2point. Heavy usage with no rails. Wave 2.
- **Validated guardrails work here**: strategy-suite. The reference we port from.
- **Already partially configured**: Juliane's apps (icat_results, network_html). Wave 3 is faster because CLAUDE.md already exists — just needs hooks + standardization.
