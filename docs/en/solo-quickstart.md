# Solo quickstart

Use solo mode when one person wants Kiro's full specialist catalog without team handoff ceremony.

## 1. Install into the project

```powershell
& "C:\path\to\crew-kiro\bin\init-kiro.ps1" -Solo -Target "C:\path\to\project"
```

```bash
bash /path/to/crew-kiro/bin/init-kiro.sh --solo --target /path/to/project
```

This installs Kiro steering, 17 custom agents, the writing skill, hooks, canonical role definitions, the metrics utility, minimal decisions/work/quality docs, and a new `crew.json` with `mode: solo`. Existing project files are preserved.

Start a new Kiro session.

## 2. Work normally

Ask for outcomes without selecting a role:

```text
Review this architecture before I implement it.
Design and build an accessible settings screen.
Check whether this release needs migration or rollback work.
```

Kiro routes the request automatically. Aliases and explicit agent selection remain optional overrides.

## 3. What solo removes

- No full briefs/stories/requirements/proposals scaffold.
- Closed stories and requirements remain editable.
- The Stop closure-context agent stays silent.
- Estimation closure is required only when metrics is enabled.

## 4. What remains

- All specialist roles and automatic routing.
- Security and UX mandatory consultations where applicable.
- Immutable existing entries under `docs/work/YYYY-MM/`.
- Code-quality policy and optional metrics discipline.

The generated config enables metrics and uses advisory quality by default. Edit `crew.json` if you want a different policy.

## 5. Optional metrics

When you want to measure a piece of work, create a story or requirement with an `## Estimation` table. Record timestamps as work happens, then run:

```powershell
node .kiro/crew/bin/metrics.js
```

## Move to team later

1. Change `crew.json` to `"mode": "team"`.
2. Rerun the workspace installer **without** `-Solo`/`--solo` to add missing team documentation.
3. Start a new Kiro session.

The installer preserves your existing config and docs; it only adds missing scaffold and updates crew-managed assets.
