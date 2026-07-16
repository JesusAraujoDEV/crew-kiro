# crew-kiro

> 🌐 Read this in **English** (below) · ¿Prefieres español? → **[Léelo en español](docs/es/README.md)**

Coding agents are generalists. Point one at your repo and it jumps straight to code — no one owns the decision, the rationale behind the architecture evaporates between sessions, and every new chat relitigates what you already settled. The hard part stopped being *writing the code*; it became *keeping a process sane enough to survive from one session to the next*.

crew-kiro is that process, adapted natively for **Kiro IDE**. It turns a single generalist agent into a structured crew: a catalog of 17 specialized roles where exactly one owns each decision, a spec-driven flow from idea to shipped, and conventions that live in the repo — read natively by Kiro via steering files, hooks, and skills — so each decision is written once and consumed many times instead of re-explained.

Forked from [crew-plugin](https://github.com/jircdev/crew-plugin) (Claude Code), fully adapted to Kiro's native mechanisms.

## How it works in Kiro

| Mechanism | What it does |
|-----------|-------------|
| **Steering files** (`.kiro/steering/`) | Always-on baseline + role catalog injected into every session; individual roles loadable via `#` |
| **Hooks** (`.kiro/hooks/`) | PreToolUse guards (file-size ceilings, immutable artifacts) + Stop advisory |
| **Agent definitions** (`agents/`) | Full role docs referenced by steering files — single source of truth |
| **Skills** (`skills/`) | Horizontal crafts loadable by any role (e.g. writing) |

## Quick start

### Install into an existing project

From your project root:

```powershell
# Windows (PowerShell)
& "C:\path\to\crew-kiro\bin\init-kiro.ps1"          # team mode
& "C:\path\to\crew-kiro\bin\init-kiro.ps1" -Solo    # solo mode
```

```bash
# macOS / Linux
bash /path/to/crew-kiro/bin/init-kiro.sh             # team mode
bash /path/to/crew-kiro/bin/init-kiro.sh --solo      # solo mode
```

This copies into your project:
- `.kiro/steering/` — baseline behavior + role activation + individual role files
- `.kiro/hooks/` — guard hooks (code quality, immutability, work log)
- `hooks/` — Node.js scripts that the hooks execute
- `agents/` — role definitions (referenced by steering files)
- `skills/` — horizontal craft files
- `standards/` + `docs/` — project documentation skeleton
- `crew.json` — per-project configuration

### Use directly (as a workspace)

Open this repository in Kiro IDE. The steering files and hooks activate automatically. Useful for testing or development of the crew itself.

## Invoking roles

Three ways to activate a specialized role:

1. **`#` reference in chat** — type `#` and select the role (e.g. `#system-architect`, `#ux-architect`)
2. **Alias prefix** — start your message with `SYS:`, `UX:`, `DA:`, etc.
3. **Role name prefix** — start your message with the full name: `System Architect:`, `UX Architect:`, etc.

## Role catalog

### Business & Discovery
| Alias | Role | Owns |
|-------|------|------|
| `COM` | commercial-strategist | Client discovery, viability, project manifesto, public web strategy |
| `PROD` | product-strategist | Product vision, roadmap, JTBD, prioritization, success metrics |

### Product & Delivery
| Alias | Role | Owns |
|-------|------|------|
| `FA` | functional-analyst | Requirements → stories with acceptance criteria |
| `COORD` | delivery-coordinator | Sequencing, coordination, blockers, intent fidelity |

### Design & Experience
| Alias | Role | Owns |
|-------|------|------|
| `DEA` | data-experience-architect | Informational spec per screen |
| `UX` | ux-architect | Visual design, interaction, accessibility, visual system |

### Engineering & Architecture
| Alias | Role | Owns |
|-------|------|------|
| `SYS` | system-architect | Architecture, API contracts, extension contracts |
| `DA` | data-architect | Schema, integrity, migrations, query performance |
| `FE` | frontend-architect | Frontend state, fetching, routing, forms |

### Quality, Security & Operations
| Alias | Role | Owns |
|-------|------|------|
| `SEC` | security-compliance | Data protection, RBAC, regulatory |
| `QA` | qa-test-architect | Testing strategy, post-implementation verdict |
| `OPS` | platform | Releases, deploys, CI/CD, infra, SLOs |
| `ANA` | analytics-architect | Event taxonomy, KPIs, instrumentation |

### Governance & Meta
| Alias | Role | Owns |
|-------|------|------|
| `DOC` | documentation-steward | Docs structure, lifecycle, drift prevention |
| `RES` | researcher | Read-only exploration — findings, never recommendations |
| `CREW` | crew | Catalog governance and installation |

### Extended (opt-in)
| Alias | Role | Owns |
|-------|------|------|
| `API` | dx-architect | Public API/SDK developer experience |

### Skill (loadable by any role)
| Name | Owns |
|------|------|
| `writing` | Communication craft: idea-force, narrative arc, tone |

## What's inside

```
crew-kiro/
├── .kiro/
│   ├── steering/
│   │   ├── crew-baseline.md        # Always-on session behavior
│   │   ├── crew-roles.md           # Always-on role catalog + activation protocol
│   │   └── agents/                 # Per-role steering (inclusion: manual)
│   │       ├── system-architect.md
│   │       ├── ux-architect.md
│   │       ├── ...
│   │       └── writing.md
│   └── hooks/
│       ├── guard-code-quality.json # PreToolUse: file-size ceilings
│       ├── guard-immutable.json    # PreToolUse: protect closed work items
│       └── check-work-log.json     # Stop: estimation traceability reminder
├── agents/                          # Full role definitions (source of truth)
├── skills/                          # Horizontal crafts
├── hooks/                           # Node.js scripts for Kiro hooks + Claude Code legacy
│   ├── kiro-guard-code-quality.js
│   ├── kiro-guard-immutable.js
│   ├── kiro-check-work-log.js
│   └── lib/                        # Shared helpers (config.js, ceilings.js)
├── bin/
│   ├── init-kiro.ps1               # PowerShell installer
│   ├── init-kiro.sh                # Bash installer
│   └── init-project.sh             # Legacy Claude Code installer
├── templates/                       # Doc skeleton for new projects
├── standards/                       # Session baseline
├── docs/                            # Documentation (en + es)
└── crew.json (scaffolded per project)
```

## Configuration

Per-project configuration lives in `crew.json`:

```json
{
  "mode": "team",
  "metrics": true,
  "quality": "advise",
  "ceilings": {}
}
```

| Key | Values | Effect |
|-----|--------|--------|
| `mode` | `solo` / `team` | Solo skips delivery ceremony (briefs, stories, closure traces) |
| `metrics` | `true` / `false` | Enables estimation discipline and work log checks |
| `quality` | `advise` / `enforce` / `off` | How file-size ceilings behave |
| `ceilings` | `{ "test": 300, ... }` | Override default line ceilings per file kind |

Reference: [configuration.md](docs/en/configuration.md)

## Hooks

| Hook | Trigger | What it does |
|------|---------|-------------|
| guard-code-quality | PreToolUse (writes) | Denies/warns when file exceeds line ceiling |
| guard-immutable | PreToolUse (writes) | Blocks modification of immutable artifacts |
| check-work-log | Stop | Advisory reminder for estimation timestamps |

All hooks fail open — a guard bug never blocks legitimate work.

## Documentation

| If you want to… | Read |
|-----------------|------|
| Meet the roles and what each owns | [roles.md](docs/en/roles.md) |
| Configure crew per repo | [configuration.md](docs/en/configuration.md) |
| Understand what each guard enforces | [enforcement.md](docs/en/enforcement.md) |
| Measure delivery (estimation → metrics) | [metrics.md](docs/en/metrics.md) |
| Work solo with minimum ceremony | [solo-quickstart.md](docs/en/solo-quickstart.md) |
| Use crew from a non-technical seat | [non-technical-roles.md](docs/en/non-technical-roles.md) |

## Compatibility

This repository is the **Kiro-native** fork. The original Claude Code plugin format files are preserved in `commands/` and `.claude-plugin/` for reference, but are not used by Kiro.

For the Claude Code version, see [crew-plugin](https://github.com/jircdev/crew-plugin).

## License

MIT.
