# Enforcement — when a Kiro hook reacts

Workspace installation adds five native Kiro hooks. Four `PreToolUse` command hooks inspect write operations; one `Stop` agent hook checks closure context. Global installation adds none.

The write hooks support `fs_write`, `str_replace`, and `fs_append`, including Kiro's snake_case/camelCase payload variants. They resolve relative paths against the session workspace and evaluate the resulting file content.

All command guards fail open on internal errors. A deliberate rule decision is returned through Kiro's standard allow/deny response.

## Code quality

Files: `.kiro/hooks/guard-code-quality.json`, `hooks/kiro-guard-code-quality.js`.

When a supported code file exceeds its kind's configured line ceiling:

- `quality: advise` allows the write and returns an advisory.
- `quality: enforce` denies it.
- `quality: off` skips the check.

Split the file by responsibility. For a legitimately large generated or flat-data file, record a reasoned exemption before writing it.

### Exemptions

Use a machine-readable block in `docs/DEVIATIONS.md`:

```markdown
<!-- crew:exempt
src/generated/**        # generated API client
fixtures/large-data.ts  # static data, no logic
-->
```

Paths are relative to the detected project root and use `/`. `**` crosses directories; `*` stays within one segment.

The Kiro installer does not install a Git pre-commit gate. Hook enforcement applies to Kiro write tools only.

## Immutability

Files: `.kiro/hooks/guard-immutable.json`, `hooks/kiro-guard-immutable.js`.

- Existing `docs/work/YYYY-MM/*.md` entries are immutable in every mode. Write a new entry that references the old one.
- Existing Closed stories/requirements are immutable in team mode and when no valid config exists. Represent new work with a new item.
- Closed stories/requirements remain editable in solo mode.

## Estimation closure

Files: `.kiro/hooks/guard-estimation.json`, `hooks/kiro-guard-estimation.js`.

The guard acts only on a transition to `Closed`/`Cerrada` for Markdown under `docs/stories/` or `docs/requirements/`. It requires:

- A literal `## Estimation` section.
- At least one milestone row.
- Non-empty `Milestone`, `Est. hours`, `Started`, `Finished`, and `Actual hours` cells. `Notes` may be empty.

It is active in team mode and without valid config. In solo mode it is active only when `metrics: true`.

## Real-time timestamps

Files: `.kiro/hooks/guard-timestamps.json`, `hooks/kiro-guard-timestamps.js`.

Active only when `metrics: true`. When a previously empty `Started` or `Finished` cell is first populated, the value must:

- Match `YYYY-MM-DD HH:mm ±TZ`; `Z`, `+02`, `+0200`, and `+02:00` zone forms are accepted.
- Be within 15 minutes of the current machine time.
- Preserve `Finished >= Started`.
- Keep `Actual hours` no greater than elapsed wall-clock time, with 5% tolerance.

The guard includes the current correctly formatted time in timestamp denials. Never reconstruct or backdate timestamps. After an interrupted session, use the real time when work resumes/closes and explain the gap in `Notes`.

## Session close

File: `.kiro/hooks/check-work-log.json`.

This is a native **agent** Stop hook, not a blocking command. Before the session ends it reads `crew.json`:

- No config or solo mode: no comment.
- Team mode with no significant implementation iteration closed: no comment.
- Team mode with significant work closed: check complete estimation and the applicable `docs/work` entry.

If evidence is missing, it names the missing artifact and lets the user decide whether the work falls below the documented significance threshold. It must not invent history or reconstruct timestamps.

## Troubleshooting

- **Unexpected enforce behavior:** validate `crew.json`; invalid JSON uses conservative fallbacks.
- **Wrong policy in a monorepo:** the nearest `crew.json` above the edited file wins.
- **Hook did not fire:** confirm workspace installation, start a new Kiro session, and check the feature's activation (`metrics`, `mode`, or `quality`). Hooks do not run inside custom subagents, so the main agent must perform guarded writes.
- **Exemption did not match:** use a root-relative path with `/`; remember `*` does not cross a directory.
- **Estimation section ignored:** keep status in the first 600 characters and use the literal heading `## Estimation`.
