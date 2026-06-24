# Role catalog

24 roles, invoked as `/crew:<alias>` (or the `ALIAS:` prefix where activated). Read them two ways: by **delivery flow** (when each acts — see the table in the [README](README.md#how-the-work-flows)) and by **area** (how they're organized, below). Full ownership table: [`templates/AGENTS.md`](../../templates/AGENTS.md).

## By area

Each role belongs to exactly one of six areas, from discovery to governance — the plugin is not just architects, it covers the whole arc.

**1. Business & Discovery** — understand what the client needs, judge business viability, author the manifesto that starts the project.

| Alias | Role | What it does |
|-------|------|--------------|
| `COM` | commercial-strategist | Client-facing discovery and business viability; authors the project manifesto — the front door, upstream of product. |
| `PROD` | product-strategist | Product vision, roadmap, jobs-to-be-done, prioritization and success metrics — upstream of every product-facing role. |

**2. Product & Delivery** — turn intent into product and executable work: stories, acceptance criteria, team sequencing.

| Alias | Role | What it does |
|-------|------|--------------|
| `FA` | functional-analyst | Decomposes intent into stories with acceptance criteria; validates delivered work against them. |
| `COORD` | delivery-coordinator | Sequences roles, surfaces blockers, keeps intent fidelity — coordination, not technical or product decisions. |

**3. Design & Experience** — what information each screen needs, how it looks and behaves, and the cross-cutting visual system.

| Alias | Role | What it does |
|-------|------|--------------|
| `DEA` | data-experience-architect | Defines the informational spec per screen — what data each view needs. |
| `UX` | ux-architect | Layout, interaction, flow and accessibility. |
| `VIS` | visual-identity | Cross-cutting visual system: design tokens, typography, color, motion, iconography. |
| `WEB` | web-strategist | Brand and content strategy for the public-facing web: positioning, sitemap, messaging. |

**4. Engineering & Architecture** — how the system is built: architecture, data, frontend, extension and public-API contracts.

| Alias | Role | What it does |
|-------|------|--------------|
| `SYS` | system-architect | Architecture, API contracts, cross-module patterns. |
| `DA` | data-architect | Schema, integrity, migrations, query performance. |
| `MOD` | module-extension-architect | The base-platform ↔ modules/products extension contract. |
| `DX` | dx-architect | Public API/SDK developer experience: versioning, deprecation, ergonomics. |
| `FE` | frontend-architect | Frontend state, data fetching, routing, forms. |

**5. Quality, Security & Operations** — that what is built is correct, secure, measurable, and shippable: testing, security, performance, infra, release, analytics.

| Alias | Role | What it does |
|-------|------|--------------|
| `SEC` | security-compliance | Personal data, RBAC, regulatory — may interrupt any role. |
| `QA` | qa-test-architect | Testing strategy, fixtures, regression coverage. |
| `SC` | spec-compliance | Post-implementation verdict: code vs. the written specs. |
| `PERF` | performance-reliability | SLOs, error budgets, runtime observability, performance budgets. |
| `INFRA` | atlas-deploy | Cloud infra, CI/CD, deployment topology. |
| `REL` | release-manager | Release lifecycle, versioning, publish order, changelog. |
| `ANA` | analytics-architect | Event taxonomy, KPIs, instrumentation, funnels. |

**6. Governance & Meta** — the catalog and the documentation themselves: roles, standards, docs, read-only exploration.

| Alias | Role | What it does |
|-------|------|--------------|
| `DOC` | documentation-steward | Docs structure, lifecycle and drift prevention. |
| `LEA` | researcher | Read-only exploration — returns findings, never recommendations. |
| `CA` | crew-architect | The role catalog itself: add/merge/retire roles, resolve authority overlap, keep role docs consistent. |
| `INST` | crew-installer | Installs/activates the crew in a target so the `ALIAS:` prefix works. |
