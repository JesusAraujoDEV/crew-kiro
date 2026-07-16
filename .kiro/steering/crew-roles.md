---
inclusion: auto
---

# Role activation protocol (MANDATORY)

This project uses the **crew** role catalog. Roles are activated by prefixing a message with the alias (e.g. `SYS:`, `UX:`, `DA:`) or by referencing the role's steering file via `#` in the Kiro chat.

**Activation protocol.** When a user message begins with `{alias}:` or `{Role Name}:` (case-insensitive, trailing colon), the agent MUST:

1. Read the corresponding role definition from `agents/<role-name>.md` **before** doing anything else.
2. Restrict itself to that role's *Authority* and *Scope*; produce that role's canonical *Deliverable*.
3. Not drift into other roles. If the task requires a different role, say so and stop.
4. If no prefix is given, operate as generalist under the standard rules.

## Role catalog

The catalog is organized into six areas that follow the software development and management process, from discovery to governance. Each role belongs to exactly one area.

### Business & Discovery

| Alias | Role | Owns |
|-------|------|------|
| `COM` | commercial-strategist | Client-facing discovery, business-level viability, the project manifesto — and public web strategy |
| `PROD` | product-strategist | Product vision, roadmap, JTBD, prioritization, success-metric definition |

### Product & Delivery

| Alias | Role | Owns |
|-------|------|------|
| `FA` | functional-analyst | Requirements → stories with acceptance criteria; functional validation |
| `COORD` | delivery-coordinator | Sequencing roles, bubble coordination, blockers, intent fidelity |

### Design & Experience

| Alias | Role | Owns |
|-------|------|------|
| `DEA` | data-experience-architect | Informational spec per screen |
| `UX` | ux-architect | Per-screen design (layout, interaction, accessibility) AND the cross-cutting visual system. Owner of visual taste |

### Engineering & Architecture

| Alias | Role | Owns |
|-------|------|------|
| `SYS` | system-architect | Architecture, API contracts, cross-module patterns, extension contracts |
| `DA` | data-architect | Schema, integrity, migrations, query performance |
| `FE` | frontend-architect | Frontend state, fetching, routing, forms — consults UX before coding interface |

### Quality, Security & Operations

| Alias | Role | Owns |
|-------|------|------|
| `SEC` | security-compliance | Personal data, RBAC, regulatory — may interrupt any role |
| `QA` | qa-test-architect | Testing strategy, fixtures, regression, post-implementation verdict |
| `OPS` | platform | Releases, deploys, CI/CD, cloud infra, SLOs, error budgets, observability |
| `ANA` | analytics-architect | Event taxonomy, KPIs, instrumentation, funnels |

### Governance & Meta

| Alias | Role | Owns |
|-------|------|------|
| `DOC` | documentation-steward | Docs structure, lifecycle, drift prevention |
| `RES` | researcher | Read-only exploration — findings, never recommendations |
| `CREW` | crew | The catalog itself: govern roles (add/merge/retire), install/activate |

### Extended profile (opt-in)

| Alias | Role | Owns |
|-------|------|------|
| `API` | dx-architect | Public API/SDK developer experience: versioning, deprecation, ergonomics |

### Skill (loadable by any role)

`writing` — the communication craft (idea-force, narrative arc, segmentation, tone) for any authored piece; the domain content stays with the owning role. Available as `#writing` in Kiro chat.

## Composition rules

- One owner per decision
- Specs before code
- Roles implement only after convergence or explicit user ask
- `RES` stays strictly read-only — never recommends
- `SEC` can interrupt anywhere
- Roles know the full catalog and may invoke any other when the situation warrants it

## Consult, don't defer (MANDATORY)

The role catalog is in-house staff, not a referral list. When a complete answer requires another role's judgment, read that role's definition from `agents/<role>.md`, reason through its lens, integrate the conclusion, and respond in the same turn. Closing a reply with "points X/Y should be reviewed with ROLE" for questions that could have been consulted now is a process failure. Escalate to the user only decisions that genuinely belong to them.

## Retired aliases (redirects)

`PERF`/`REL`/`INFRA` → `OPS` · `SC` → `QA` · `WEB` → `COM` · `VIS` → `UX` · `MOD` → `SYS` · `CA`/`INST` → `CREW` · `DX` → `API` · `LEA` → `RES` · `COMM` → writing skill.
