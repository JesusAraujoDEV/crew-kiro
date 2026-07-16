# Configuration — `crew.json`

`crew.json` is the workspace policy read by crew-kiro guards. It controls project process; it does not choose roles. Automatic routing comes from `.kiro/steering/crew-roles.md`.

A workspace installer creates this file only when it is absent:

```json
{
  "mode": "team",
  "metrics": true,
  "quality": "advise",
  "ceilings": {}
}
```

The file is project-owned. Installer reruns never replace it.

## How guards resolve policy

For an edited file, guards walk upward from that file's directory looking for the nearest `crew.json`, up to the filesystem root or 30 levels. They fall back to the session working directory when no file path is available. This supports one policy per project in a monorepo.

Invalid or unreadable JSON is treated like no config. Conservative guard fallbacks then apply: team-style closed-item immutability and estimation closure checks, metrics timestamps off, and code quality `enforce`. The Stop agent emits no closure reminder when `crew.json` is absent.

## Fields

| Field | Values | Fallback when absent/invalid | Controls |
|---|---|---|---|
| `mode` | `"team"` or `"solo"` | `"team"` | Team delivery protections versus minimal solo process. |
| `metrics` | `true` or `false` | `false` | Real-time timestamp validation; also enables estimation closure in solo mode. |
| `quality` | `"advise"`, `"enforce"`, or `"off"` | `"enforce"` | Kiro write-time file-size decisions. |
| `ceilings` | object `{ kind: lines }` | `{}` | Per-kind line-ceiling overrides. |

Unknown values normalize conservatively: only exact `"solo"` selects solo; only literal `true` enables metrics; unknown quality modes become `enforce`.

## `mode`

`team` protects closed stories/requirements, requires complete estimation before closure, and lets the Stop agent check significant-session traceability.

`solo` keeps immutable `docs/work/` history and code-quality policy, but closed stories/requirements remain editable and the Stop agent stays silent. Estimation closure applies in solo only when `metrics` is true.

Changing installer flags does not modify an existing config. Edit `mode` directly when a project changes operating style.

## `metrics`

With `true`, newly recorded `Started` and `Finished` cells in estimation tables must use `YYYY-MM-DD HH:mm ±TZ`, be within 15 minutes of the current clock, preserve ordering, and keep actual hours within elapsed wall-clock time.

The report utility itself can run regardless of this flag; `metrics: true` makes the source data mechanically trustworthy.

## `quality`

| Mode | Kiro write behavior |
|---|---|
| `advise` | Allows the write and returns a visible advisory. |
| `enforce` | Denies the write until the file is split or pre-exempted. |
| `off` | Does not check file-size ceilings. |

crew-kiro's Kiro installer does **not** install a Git pre-commit hook. If your project wants a commit/CI gate, configure it separately; do not infer one from `quality: advise`.

## `ceilings`

| Kind | Default | Detection |
|---|---:|---|
| `test` | 250 | Test/spec name or test directory. |
| `rust` | 300 | `.rs`. |
| `hook` | 80 | React-style `use-*`/`useXxx` TypeScript hook. |
| `page` | 200 | Page/route path or filename. |
| `service` | 150 | Service/store path or filename. |
| `component` | 150 | Capitalized `.tsx`/`.jsx`. |
| `module` | 200 | Other supported code files. |

Overrides change only the number, not kind detection:

```json
{
  "mode": "team",
  "metrics": true,
  "quality": "advise",
  "ceilings": { "component": 220, "test": 400 }
}
```

Legitimately large generated or flat-data paths should use a reasoned `crew:exempt` entry in `docs/DEVIATIONS.md`; see [enforcement](enforcement.md#exemptions).

## Guard matrix

| Guard | Team | Solo | No valid config |
|---|---|---|---|
| Existing `docs/work/YYYY-MM/*.md` immutable | Yes | Yes | Yes |
| Closed story/requirement immutable | Yes | No | Yes |
| Complete estimation required on transition to Closed | Yes | Only if metrics | Yes |
| Real-time timestamp validation | If metrics | If metrics | No |
| File-size ceiling | Per quality | Per quality | Enforce |
| Stop closure-context check | Significant work only | No | No |

All PreToolUse guards fail open on internal errors: a guard defect must not block legitimate work.

## Metrics utility

Workspace install:

```powershell
node .kiro/crew/bin/metrics.js
node .kiro/crew/bin/metrics.js 2026-07 --csv
```

Global-only install: run `node "$HOME/.kiro/crew/bin/metrics.js"` from the project root.
