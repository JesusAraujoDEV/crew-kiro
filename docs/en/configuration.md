# Configuration — `crew.json`

`crew.json` is the project's policy file for the crew guards: one small JSON file at the project root that decides which rules are enforced and how hard. Every value in it is explicit — the file *is* the policy, visible and versioned with the code. When a guard blocks you and you want to know why, this page tells you which field it obeyed; the deny messages themselves are catalogued in [enforcement.md](enforcement.md).

## How guards find it

Every guard resolves the config by walking **up** from the directory of the file being edited (or from the session's working directory, as a fallback), looking for `crew.json`, up to 30 levels or the filesystem root. The first `crew.json` found wins. This means a monorepo can carry one `crew.json` per project and each edit is governed by the nearest one above it. Reader: [`../../hooks/lib/config.js`](../../hooks/lib/config.js).

## The legacy rule — no `crew.json`

**No `crew.json` (or one with invalid JSON) means exact v0.19.1 behavior.** The reader returns nothing and every guard falls back to its pre-config behavior:

- `docs/work/` entries and Closed work items: immutable.
- Estimation gate at closure: active.
- Timestamps guard: **off** (it only exists when `"metrics": true`).
- Code quality: **enforce** — writes over the ceiling are denied.
- Work-log Stop hook: active wherever `docs/work/` exists.

Two consequences worth internalizing. First, the plugin has **no hidden defaults**: the friendlier values new projects get (`advise`, metrics on) are not built in — they exist only because [`../../bin/init-project.sh`](../../bin/init-project.sh) writes them explicitly into the scaffolded `crew.json`. Second, a `crew.json` with a JSON syntax error behaves like no file at all — which silently turns `"quality": "advise"` back into enforce. If a guard suddenly got stricter, check the JSON parses.

## Field reference

| Field | Values | Default when absent | What it controls |
|---|---|---|---|
| `mode` | `"team"` \| `"solo"` | `"team"` | Whether the full delivery-circuit ceremony applies. Anything other than the exact string `"solo"` counts as team. |
| `metrics` | `true` \| `false` | `false` | The estimation-timestamps discipline. Only the literal `true` activates it. |
| `quality` | `"advise"` \| `"enforce"` \| `"off"` | `"enforce"` | What the write-time code-quality guard does on a ceiling violation. Unknown values fall back to `"enforce"`. |
| `ceilings` | object `{ kind: lines }` | `{}` | Per-kind overrides of the file-size line ceilings. Non-object values fall back to `{}`. |

Absent fields normalize to the legacy-equivalent value in the third column — a `crew.json` containing only `{"mode": "solo"}` is valid and means solo, no metrics, quality enforce, default ceilings.

### `mode`

`team` assumes the full crew circuit: stories/requirements are contracts, Closed items are history, sessions leave a work-log trace. `solo` keeps the cheap always-valuable pieces (immutable `docs/work/` entries, the quality gate) and drops the team ceremony: Closed items stay editable, no Stop-hook reminder, and the estimation gate applies only if you opted into metrics.

### `metrics`

When `true`, two things activate: the estimation gate applies even in solo mode, and the [timestamps guard](enforcement.md#timestamps) starts validating that `Started`/`Finished` cells are written **in real time** (correct format, within 15 minutes of the machine clock, consistent with each other). This is the discipline that makes [/crew:metrics](metrics.md) trustworthy. When `false` or absent, the timestamps guard is completely silent.

### `quality`

Controls the **write-time** guard only ([`../../hooks/guard-code-quality.js`](../../hooks/guard-code-quality.js)):

| Mode | At write time (agent Edit/Write) | At commit time (pre-commit gate) |
|---|---|---|
| `advise` | Write proceeds; the agent sees a visible notice | Blocks the commit |
| `enforce` | Write is denied | Blocks the commit |
| `off` | Silent | Still blocks — the gate is managed separately |

`advise` is what the scaffold writes for new projects: the agent keeps momentum and the hard stop is the commit. Note that the pre-commit gate ([`../../bin/check-quality.sh`](../../bin/check-quality.sh)) does **not** read `quality` at all — turning quality `off` silences the hook, not the gate. To remove the gate, delete its line from `.git/hooks/pre-commit`.

### `ceilings`

The line ceilings by file kind, and how a file's kind is detected (first match wins):

| Kind | Default ceiling | Detected when |
|---|---|---|
| `test` | 250 | `.test.`/`.spec.` in the name, or under `__tests__/`, `test/`, `tests/` |
| `rust` | 300 | `.rs` extension |
| `hook` | 80 | `.ts`/`.tsx` named `use-*` or `useXxx` (React-style hooks) |
| `page` | 200 | under `pages/` or `routes/`, or `.page.`/`.route.` in the name |
| `service` | 150 | under `services/` or `stores/`, or `.service.`/`.store.`/`.slice.` in the name |
| `component` | 150 | `.tsx`/`.jsx` whose name starts with a capital letter |
| `module` | 200 | everything else (the default kind) |

Only code files are checked (`.ts`, `.tsx`, `.js`, `.jsx`, `.mjs`, `.cjs`, `.rs`, `.py`, `.go`, `.java`, `.rb`, `.php`, `.cs`, `.kt`, `.swift`, `.vue`, `.svelte`, …). `"ceilings"` overrides the number per kind — it does not change kind detection. Both the write-time guard and the pre-commit gate honor the same overrides, and both honor [pre-registered exemptions](enforcement.md#exemptions) in `docs/DEVIATIONS.md`. Logic: [`../../hooks/lib/ceilings.js`](../../hooks/lib/ceilings.js).

## Behavior matrix — guard × config

| Guard | Reads | `team` | `solo` | No `crew.json` (v0.19.1) |
|---|---|---|---|---|
| `docs/work/` entries immutable ([guard-immutable](../../hooks/guard-immutable.js)) | nothing | immutable | immutable | immutable |
| Closed stories/requirements immutable (guard-immutable) | `mode` | immutable | **editable** | immutable |
| Estimation complete at closure ([guard-estimation](../../hooks/guard-estimation.js)) | `mode`, `metrics` | always active | only when `metrics: true` | active |
| Real-time timestamps ([guard-timestamps](../../hooks/guard-timestamps.js)) | `metrics` | when `metrics: true` | when `metrics: true` | off |
| File-size ceilings at write ([guard-code-quality](../../hooks/guard-code-quality.js)) | `quality`, `ceilings` | per `quality` mode | per `quality` mode | enforce |
| Work-log reminder on Stop ([check-work-log](../../hooks/check-work-log.js)) | `mode` | active where `docs/work/` exists | off | active where `docs/work/` exists |
| Pre-commit quality gate ([check-staged.js](../../bin/check-staged.js)) | `ceilings` | always, once installed | always, once installed | always, once installed |
| `/crew:metrics` report ([metrics.js](../../bin/metrics.js)) | nothing | runs | runs | runs |

The last row is the pattern to remember: **the report runs anywhere; only the discipline is gated** by `metrics: true`. Details in [metrics.md](metrics.md).

## How `init-project.sh` writes it

`bash <plugin>/bin/init-project.sh` (from your project root) scaffolds the crew structure and writes `crew.json` with **every value explicit**:

```json
{
  "mode": "team",
  "metrics": true,
  "quality": "advise",
  "ceilings": {}
}
```

With `--solo` it writes `"mode": "solo"` (same other values) and scaffolds only the minimal structure: `AGENTS.md`, `CLAUDE.md`, `standards/`, `docs/decisions/`, `docs/work/` — no stories/requirements/briefs taxonomy. In both modes it also installs the quality gate as `.git/hooks/pre-commit`: if a pre-commit hook already exists, the gate line is **appended**, never overwriting; if it already runs `check-quality.sh`, it is left alone; if there is no `.git`, it tells you to `git init` and re-run. Existing files — including an existing `crew.json` — are never overwritten.

## Worked examples

**Team default** — what the scaffold writes. Full ceremony, metrics discipline on, quality advisory at write with the hard stop at commit:

```json
{ "mode": "team", "metrics": true, "quality": "advise", "ceilings": {} }
```

**Solo with metrics** — you work alone but want honest numbers. Closed items stay editable and no work-log reminder, but the estimation table and real-time timestamps are enforced:

```json
{ "mode": "solo", "metrics": true, "quality": "advise", "ceilings": {} }
```

**Solo without ceremony** — the minimum. Only `docs/work/` immutability remains (and the pre-commit gate, if installed):

```json
{ "mode": "solo", "metrics": false, "quality": "off", "ceilings": {} }
```

**Ceilings override** — your components legitimately run larger and your test files longer:

```json
{ "mode": "team", "metrics": true, "quality": "advise",
  "ceilings": { "component": 250, "test": 400 } }
```

For one-off large files (generated code, flat data), don't raise the ceiling for the whole kind — [pre-register an exemption](enforcement.md#exemptions) instead.
