# Token Limits in the Claude Team Plan: What Business Users Need to Know

The Claude Team Plan uses a **two-tier limit system**: a 5-hour session limit and a weekly total limit. Each team member gets their own individual quota — there is no shared pool. Since August 2025, teams can choose between Standard and Premium seats, which differ significantly in available usage capacity. Anthropic deliberately does not publish exact token numbers, but provides monitoring tools and the option to purchase additional quota at API prices.

---

## What a Token Is — and Why It Matters

A token is the smallest processing unit Claude uses to read and generate text. It's not simply a word — it's a text fragment that can correspond to a word, part of a word, a punctuation mark, or just a few characters. For English, the rule of thumb is: **1 token ≈ 4 characters or ¾ of a word**. For German text, due to longer words, it's closer to 1 token ≈ 3–3.5 characters.

In concrete terms: **1,000 tokens ≈ 750 English words** or roughly 2–3 pages of body text. Code is more token-dense — brackets, indentation and syntax elements each count as separate tokens. Images and PDF attachments are also converted into tokens and can consume significant amounts.

For billing, Anthropic distinguishes three token types:
- **Input tokens** — the text you send to Claude
- **Output tokens** — Claude's response (~5× more expensive than input)
- **Cache tokens** — reused context from projects, discounted or free

---

## Two Limit Levels: Session and Week

**Session limit (5-hour window)**
Within each rolling 5-hour window, a certain amount of usage capacity is available. How many messages that means varies depending on message length, attached files, conversation length, model used and features activated (web search, code execution, research). Anthropic deliberately gives **no fixed message count**.

Estimated token capacity per session:
| Seat Type | Estimated Tokens per Session |
|---|---|
| Standard | ~55,000 tokens |
| Premium | ~275,000 tokens |

**Weekly total limit**
In addition to the session limit, a weekly cap exists that resets 7 days after the session begins.

> ⚠️ **Important:** All Claude surfaces — claude.ai, Claude Code and Claude Desktop — count toward the same limit.

---

## Each Member Has Their Own Quota

Limits in the Team Plan are **per member, not a shared pool**. If one member reaches their limit, it has no effect on other members' limits.

Teams can **mix Standard and Premium seats** to give power users more capacity:

| Seat Type | Monthly | Annual | Capacity vs. Pro |
|---|---|---|---|
| **Standard** | $25/member/month | $20/member/month | **1.25×** more per session |
| **Premium** | $125/member/month | $100/member/month | **6.25×** more per session |

- Minimum 5 members, maximum 150 seats
- Members can switch between Standard and Premium at any time
- Upgrades are billed proportionally immediately; downgrades lower limits immediately

---

## What Happens When You Hit the Limit

Without Extra Usage activated, a **hard stop** occurs: no new messages can be sent until the limit resets (5 hours for session, 7 days for weekly).

**Monitoring:** Settings → Usage shows progress bars for current 5-hour window and weekly limit.
**Claude Code:** `/status` command shows real-time remaining limit.

**Extra Usage** allows members to continue working after their included quota is exhausted — billed at standard API prices.

Setup:
1. Owner pre-pays an Extra Usage credit balance
2. Set an org-wide monthly spend limit (e.g. $500/month)
3. Optionally set individual monthly spend caps per member
4. Configure auto-reload

---

## Opus, Sonnet, Haiku: Significant Differences in Usage

| Model | Input (per 1M tokens) | Output (per 1M tokens) | Usage factor |
|---|---|---|---|
| **Opus 4.6** | $5 | $25 | Highest |
| **Sonnet 4.6** | $3 | $15 | Medium |
| **Haiku 4.5** | $1 | $5 | Lowest |

**Opus consumes the quota 3–5× faster than Sonnet** for comparable tasks. Anthropic officially recommends using **Haiku or Sonnet for the majority of everyday tasks** and reserving Opus for demanding analysis and complex coding.

**Standard seats** have a single weekly limit across all models.
**Premium seats** have **two separate weekly limits**: one for all models combined and an additional dedicated limit for Sonnet models only.

---

## Practical Recommendations

- **Power users (developers, analysts) → Premium seats** — the 5× capacity difference justifies the extra cost in most cases
- **Activate Extra Usage with defined spend limits** — avoids workflow interruptions
- **Model strategy:** Sonnet 4.6 for most daily work, Opus 4.6 only for complex tasks, Haiku 4.5 for quick queries — can reduce effective usage by **60–70%** compared to Opus-only usage
- **Use the Projects feature** — context stored there is cached and does not impact the usage limit when reused
