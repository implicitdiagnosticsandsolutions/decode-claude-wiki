# Claude Models — Comparison & Usage Guide

> Opus 4.6 · Sonnet 4.6 · Haiku 4.5 · Last updated: April 2026

---

## The Three Models at a Glance

| | Opus 4.6 | Sonnet 4.6 | Haiku 4.5 |
|---|---|---|---|
| **Best for** | Deep reasoning, highest precision | Everyday work, best balance | Speed, simple tasks |
| **Speed** | Slow | Medium | Very fast |
| **Intelligence** | Highest | High | Good |
| **Context Window** | 1,000,000 tokens | 200,000 tokens | 200,000 tokens |
| **Usage cost** | Highest | Medium | Lowest |

---

## Which Model for Which Use Case?

| Use Case | Recommendation | Reason |
|---|---|---|
| Complex analysis & research | **Opus** | Deep reasoning across long documents |
| Coding & software development | **Opus** | 80.8% SWE-bench, understands large codebases |
| Daily work tasks (emails, summaries) | **Sonnet** | Excellent quality at lower usage cost |
| Corporate writing & reports | **Sonnet** | Clear structure, correct register |
| Brainstorming & ideation | **Sonnet** | Fully sufficient, saves limit for priority tasks |
| Quick queries & translations | **Haiku** | Instant responses, minimal usage consumption |
| Automation & API integrations | **Haiku** | 5× cheaper than Sonnet for routine tasks |
| Very long documents (150,000+ words) | **Opus** | Only model with 1M token context |
| Scientific / PhD-level questions | **Opus** | 91.3% GPQA Diamond benchmark |

---

## Quick Decision

**🤔 I need the best possible answer, limit doesn't matter**
→ Complex analysis, critical decisions, difficult code
→ **Opus**

**⚖️ I want great quality while being mindful of my limit**
→ Daily work, writing, research, standard coding
→ **Sonnet**

**⚡ I need it instantly, simple task**
→ Short questions, translations, simple summaries
→ **Haiku**

**🔁 Automation / many requests at once**
→ API integrations, batch jobs, workflows
→ **Haiku**

---

## API Pricing per 1 Million Tokens

| Model | Input | Output | Cache Write | Cache Read |
|---|---|---|---|---|
| **Opus 4.6** | $5.00 | $25.00 | $6.25 | $0.50 |
| **Sonnet 4.6** | $3.00 | $15.00 | $3.75 | $0.30 |
| **Haiku 4.5** | $0.80 | $4.00 | $1.00 | $0.08 |

> 💡 **Rule of thumb:** Opus costs ~6× more than Sonnet and ~30× more than Haiku. Shifting 80% of tasks to Sonnet/Haiku can reduce costs and usage by **60–70%** — with no noticeable quality drop for standard tasks.

---

## Practical Recommendation for DECODE

- **Default model for everyday work → Sonnet 4.6**
- **Complex analysis, strategy, long documents → Opus 4.6**
- **Quick questions, simple tasks → Haiku 4.5**

When in doubt: start with Sonnet. Switch to Opus only if the output isn't good enough.
