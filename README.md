# crew-kiro

> Read in **English** · [Leer en español](docs/es/README.md)

Install once, then speak normally. **crew-kiro** gives Kiro a governed catalog of 17 specialist roles and lets Kiro choose the right authority for each request automatically. You do not need slash commands, role prefixes, or manual steering selection.

Each decision has one owner. Kiro can consult several specialists when a request crosses boundaries, but the main agent remains responsible for sequencing their input and returning one coherent answer.

## Quick start

Clone this repository, then choose one scope.

### This workspace (recommended)

```powershell
# Windows
& "C:\path\to\crew-kiro\bin\init-kiro.ps1" -Target "C:\path\to\project"

# Minimal process for one-person projects
& "C:\path\to\crew-kiro\bin\init-kiro.ps1" -Solo -Target "C:\path\to\project"
```

```bash
# macOS / Linux
bash /path/to/crew-kiro/bin/init-kiro.sh --target /path/to/project
bash /path/to/crew-kiro/bin/init-kiro.sh --solo --target /path/to/project
```

Workspace installation requires `node` on `PATH` because Kiro hooks execute Node.js scripts.

### Every workspace for this user

```powershell
& "C:\path\to\crew-kiro\bin\init-kiro.ps1" -Global
```

```bash
bash /path/to/crew-kiro/bin/init-kiro.sh --global
```

Global installation provides routing, custom agents, role definitions, the writing skill, and the metrics utility. It deliberately does **not** install hooks or project process into every repository.

After either installation, start a **new Kiro session**. Then ask for work in ordinary language:

```text
Design the authorization boundary for tenant administrators.
Plan the onboarding screen and implement it accessibly.
Define events and a funnel for trial activation.
```

Kiro classifies the decision, applies the owning role, and delegates only when a separate authority is materially needed. `SYS:`, `UX:`, full role names, and explicit agent selection remain optional overrides.

## What is native to Kiro

- `.kiro/steering/crew-roles.md` — automatic routing, ownership, composition, and escalation rules.
- `.kiro/agents/*.md` — native custom subagents with narrow descriptions and least-privilege tool access.
- `.kiro/steering/crew-baseline.md` — always-on behavior shared by the main agent and subagents.
- `.kiro/skills/writing/SKILL.md` — communication craft used when the deliverable depends on audience understanding or action.
- `.kiro/hooks/*.json` + `hooks/kiro-*.js` — workspace-only guards for quality, immutability, estimation, timestamps, and closure context.
- `.kiro/crew/agents/` — installed canonical role definitions used by the custom agents.

The main Kiro agent is the orchestrator; there is no extra universal orchestrator role to select.

## Installation scopes

| Capability | Workspace | Global |
|---|---:|---:|
| Automatic role routing | Yes | Yes |
| Native custom agents | Yes | Yes |
| Writing skill | Yes | Yes |
| Canonical role definitions | Yes | Yes |
| Metrics report utility | Yes | Yes |
| Kiro hooks | Yes | No |
| `crew.json` and project scaffold | Yes | No |

Rerunning an installer updates crew-managed files. It preserves project-owned documentation and an existing `crew.json`.

## Roles

The catalog covers commercial discovery, product strategy, functional analysis, delivery coordination, data experience, UX, system architecture, data architecture, frontend architecture, security and compliance, QA, platform, analytics, documentation, research, public API/SDK experience, and crew governance.

See [roles.md](docs/en/roles.md) for authority boundaries. A new role is justified only when it owns a distinct, recurring decision that no current role owns.

## Project policy

Workspace installation creates `crew.json` only when absent:

```json
{
  "mode": "team",
  "metrics": true,
  "quality": "advise",
  "ceilings": {}
}
```

`team` enables the full delivery process; `solo` removes team ceremony while retaining the specialist catalog. See [configuration](docs/en/configuration.md), [enforcement](docs/en/enforcement.md), and the [solo quickstart](docs/en/solo-quickstart.md).

Run the installed metrics report from a project root:

```powershell
node .kiro/crew/bin/metrics.js
node .kiro/crew/bin/metrics.js 2026-07 --csv
```

For a global-only install, use `node "$HOME/.kiro/crew/bin/metrics.js"` (PowerShell) or `node "$HOME/.kiro/crew/bin/metrics.js"` (Bash).

## Documentation

- [Install, update, verify, and remove](docs/en/installation.md)
- [Use automatic routing and optional overrides](docs/en/using-crew.md)
- [Configure project policy](docs/en/configuration.md)
- [Understand hook decisions](docs/en/enforcement.md)
- [Measure estimation and delivery](docs/en/metrics.md)
- [Role catalog and authority](docs/en/roles.md)

## Legacy material

`.claude-plugin/`, `commands/`, `templates/CLAUDE.md`, and `bin/init-project.sh` are preserved only as compatibility/reference material from the original [crew-plugin](https://github.com/jircdev/crew-plugin). Kiro installation and active documentation do not depend on them.

## License

MIT.
