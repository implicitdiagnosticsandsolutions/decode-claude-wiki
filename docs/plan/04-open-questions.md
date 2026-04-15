# Open Questions

Decisions pending. Each has an owner (who resolves) and a blocker (what it blocks).

---

## Q1. Does the plugin marketplace mechanism work for arbitrary GitHub-org repos?

**Context:** Anthropic's plugin marketplace docs show `/plugin marketplace add owner/repo` as the install mechanism. Unclear whether `implicitdiagnosticsandsolutions/decode-claude-wiki` works the same as an official Anthropic-listed marketplace — auto-update, version control, etc.

**Owner:** Rollout owner
**Blocks:** All plugin work
**Resolution:** Half-day empirical test. Scaffold a minimal plugin in this repo, register it from the supervisor's machine, confirm install + update flow works.
**Status:** ⬜ Not started

---

## Q2. Should this repo be public or private?

**Context:** The incident log will eventually reference customer names, cost narratives, internal decisions. That's sensitive.

**Options:**
- **Public (current):** easier onboarding, aligns with "anyone can see our standards" culture.
- **Private:** protects incident details, restricts to org members.

**Owner:** Supervisor
**Blocks:** Seeding the incident log with customer-specific incidents
**Resolution:** Decision needed before Q1 2026-end. Recommendation from reviewer: **private**.
**Status:** ⬜ Pending decision

---

## Q3. Should reviewer-agent discipline be enforced at commit time?

**Context:** Social-media-analytics Rule 5 says non-trivial changes must get a second-opinion reviewer agent. Two ways to enforce:

- **Pre-commit hook** — reviewer runs before commit, blocks on unresolved findings.
- **Stop hook (reminder only)** — reminds the model at end of turn, doesn't block.

**Tradeoff:** Pre-commit is stricter but adds latency (reviewer takes 30–60s). Stop is more practical but weaker.

**Owner:** Supervisor
**Blocks:** Definition of done for Wave 1+
**Resolution:** Pilot both on `strategy-suite` for one week, pick based on friction.
**Status:** ⬜ Not started

---

## Q4. Does DECODE have access to Claude for Enterprise server-managed settings?

**Context:** Anthropic offers server-managed settings (central enforcement of hooks/permissions via admin console) for Enterprise-plan orgs. Would eliminate per-repo hook config in favor of org-wide central control.

**What we know:** DECODE is on GitHub Teams (GitHub's plan, 19/19 seats). The Claude subscription status is separate and not yet checked.

**Owner:** Supervisor
**Blocks:** Potentially simpler Wave rollouts (but Wave 1 scoping does not depend on this — can proceed either way)
**Resolution:** One-day check of the Anthropic billing/admin page. If on Enterprise, re-scope mandatory rails to lean on server-managed settings. If not, proceed with repo-tracked artifacts as planned.
**Status:** ⏸️ Blocked on 1-day supervisor check

---

## Q5. How do non-programmers (Juliane, Dirk) use this?

**Context:** Strategy-suite has a `jmdh-collab` skill specifically for Juliane/Dirk — guided collaboration workflow because they don't write code directly. These standards are currently written for engineers. Data and UX contributors need a simpler path.

**Owner:** Rollout owner (in consultation with Juliane/Dirk during Wave 3)
**Blocks:** Wave 3 readiness for `icat_app` etc.
**Resolution:** Port `strategy-suite/.claude/skills/jmdh-collab/` into the plugin marketplace; validate it still works for them.
**Status:** ⬜ Not started

---

## Q6. Where does the "data analysis" ruleset come from — port from `social-media-analytics` or draft fresh?

**Context:** `social-media-analytics/CLAUDE.md` has 17 hard rules specifically tuned for data-analysis work (artifact/generator discipline, reproducibility gates, jsdom ground-truth checks, per-cell gate coverage). These would apply to DECODE's data repos too. But those rules reference social-media-analytics incidents, not DECODE ones.

**Options:**
- **Port verbatim:** fast, but incident refs are from another repo — reduces rule credibility.
- **Port + re-anchor:** replace social-media-analytics incident refs with matching DECODE incidents where they exist; keep the original ref as "analogous incident" otherwise.

**Owner:** Rollout owner
**Blocks:** Wave 2+ (data-tier repos)
**Resolution:** Plan: port + re-anchor. Track re-anchoring work in the incident log.
**Status:** ⬜ Not started

---

## Q7. What's the error-monitoring story for Wave 1 repos?

**Context:** `strategy-suite` has Sentry + structured logging (see `memory/project-error-monitoring.md` on the supervisor's machine). The Wave 1 targets — `datasystem-backend`, `datasystem-frontend`, `decoder_transformations` — have no documented Sentry setup. If hooks or gates introduce behavior that surfaces runtime errors (e.g. a pre-commit gate that exercises a code path), there needs to be a destination for those signals. More broadly: a rollout that hardens dev-time guardrails without a matching runtime observability story is only half a job.

**Owner:** Rollout owner (in consultation with Willi for the Velocity repos)
**Blocks:** Wave 1 definition of done — "observability is sufficient for Claude-introduced changes to be caught if they ship"
**Resolution:** Inventory current monitoring per Wave 1 repo; decide whether Sentry/equivalent is a Wave 1 scope item or a follow-up wave.
**Status:** ⬜ Not started

---

## Template for new questions

```markdown
## Q#. Short question

**Context:** one paragraph.
**Owner:** who resolves.
**Blocks:** what's blocked on this.
**Resolution:** how we'll decide.
**Status:** ⬜ / 🟨 / ✅ / ⏸️
```
