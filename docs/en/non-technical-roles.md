# The crew for non-developers

You do not need commands or role knowledge. In a Kiro workspace with crew-kiro installed, describe the decision or outcome in ordinary language; Kiro chooses the relevant specialist automatically.

```text
Help me decide whether this client opportunity is commercially viable.
Turn these stakeholder notes into clear acceptance criteria.
Define the KPIs that would show whether onboarding works.
Show me what is blocked and which decision would unblock delivery.
```

If you intentionally want one lens, an alias such as `COM:`, `PROD:`, `FA:`, `COORD:`, or `ANA:` is an optional override.

## Executive and commercial work

| Need | Owning role |
|---|---|
| Client discovery, commercial viability, project manifesto, public-site message | `commercial-strategist` |
| Product scope, priority, roadmap, target user, success outcome | `product-strategist` |
| KPIs, funnels, event taxonomy, experiment measurement | `analytics-architect` |

Briefs under `docs/briefs/` are decision documents for human review and approval. You can review Markdown through the repository host without local developer tooling.

Do not edit implementation estimation tables, immutable `docs/work/` history, code, or technical standards unless you own those decisions.

## Analyst and delivery work

| Need | Owning role |
|---|---|
| Stories, acceptance criteria, behavioral edge cases, functional validation | `functional-analyst` |
| Sequencing, dependencies, blockers, handoff integrity | `delivery-coordinator` |
| Information a screen must expose and how users act on it | `data-experience-architect` |

Stories and requirements are editable until Closed in team mode. Closed items are history; corrections become new linked items. A Ready item needs complete, unambiguous acceptance criteria and at least one test scenario.

The executor—not the analyst—adds the `## Estimation` table during planning and records timestamps while work happens.

## When the request crosses boundaries

Ask the whole question once. The main Kiro agent consults additional authorities when needed and returns a combined answer with one owner per decision. You do not need to route technical follow-ups yourself.

Security/compliance can block unsafe handling of sensitive data or permissions. Product, commercial, and technical owners still approve decisions that belong to them; automatic routing does not remove human accountability.
