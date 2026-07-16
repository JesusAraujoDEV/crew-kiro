# Using crew

Normal usage is deliberately uneventful: install crew-kiro, start a new Kiro session, and describe the outcome you need. Kiro chooses the owning role and any required specialist consultations.

## Ask in ordinary language

```text
Decide whether notifications belong in the core or an extension module.
Turn these requirements into acceptance criteria and edge cases.
Design the account recovery flow, then implement the approved UI.
Instrument trial activation and define the dashboard KPIs.
```

You do not need to know the catalog first. The router classifies the decision by authority—not by keywords alone—and keeps one owner for each decision.

Kiro may answer directly with the relevant role lens for a simple question. It delegates to a custom subagent when isolated specialist work materially improves the result. Multi-role work is sequenced by the main Kiro agent; subagents do not orchestrate one another.

Security/compliance is mandatory when authentication, authorization, sensitive data, tenant isolation, consent, retention, encryption, auditability, or regulation is involved. UX is consulted before implementing interface work.

## Optional overrides

Overrides are escape hatches, not prerequisites:

- Prefix a request with an alias such as `SYS:`, `UX:`, `SEC:`, or `QA:`.
- Prefix it with the full role name, such as `System Architect:`.
- Select a custom agent explicitly in Kiro when diagnosing routing or when you intentionally want one narrow authority.
- Use `GEN:` when you explicitly want a general synthesis rather than a specialist-owned deliverable; mandatory security and UX consultations still apply.

The active alias map and composition rules live in `.kiro/steering/crew-roles.md`. Do not duplicate them in project documentation.

## Workspace and global behavior

A workspace install is portable with the repository and includes hooks plus `crew.json`. A global install makes routing and agents available to the current user across workspaces, but does not impose hooks or project process.

When both exist, project steering and project facts take precedence. Start a new Kiro session after installing or updating either scope.

## Team and solo modes

`crew.json` controls project process:

- **`team`** — full documentation scaffold, immutable closed work items, estimation closure checks, and closure context.
- **`solo`** — specialist catalog without team ceremony; closed items remain editable and closure context is not required.

`metrics` is independent of the mode. With `"metrics": true`, estimation timestamps are checked in real time and the closure gate applies in solo mode too. See [configuration](configuration.md).

## Start or onboard a project

For a new project, run the workspace installer with team or solo mode. It creates missing scaffold files but does not create an `AGENTS.md`; Kiro's active instructions live in `.kiro/steering/`.

Keep project-specific facts in a project-owned steering file such as `.kiro/steering/project-context.md`: purpose, stack, architecture constraints, folder layout, common commands, and human ownership. The installer only manages the two `crew-*` steering files, so it will not overwrite your project context.

For an existing project, run the same installer. Existing `crew.json`, standards, and documentation are preserved. Then ask in normal language:

```text
Audit this project's documentation against the installed crew structure. Preserve intentional differences and record the decisions.
```

The documentation steward should classify findings as aligned, missing, or intentionally divergent. Project rules win over crew defaults; record durable exceptions in `docs/DEVIATIONS.md` rather than re-litigating them each session.

## Managed versus project-owned files

Rerunning the installer replaces crew-managed steering, agents, skills, hooks, hook scripts, canonical role definitions, and the metrics utility. Do not customize those installed copies; change the source repository and reinstall.

The installer preserves existing `crew.json`, `standards/`, and `docs/` files. Those become project-owned as soon as they are created. Updates do not merge newer template text into them; audit and reconcile deliberately.

## Metrics

With measured closed stories or requirements, run from the project root:

```powershell
node .kiro/crew/bin/metrics.js
node .kiro/crew/bin/metrics.js 2026-07
node .kiro/crew/bin/metrics.js --csv
```

A global-only installation exposes the same utility at `~/.kiro/crew/bin/metrics.js`. The report scans `docs/stories/` and `docs/requirements/`; `--csv` writes `docs/work/metrics.csv`. See [metrics](metrics.md) for interpretation.

## Composition rules

- One owner per decision.
- Consult another role only for a distinct authority; do not create consensus ownership.
- The main agent integrates consultations and returns one answer in the same turn.
- `security-compliance` may block an unsafe proposal.
- `researcher` returns evidence and uncertainty, never recommendations.
- A new role must have distinct, recurring authority and routing value that exceeds its cost.

The full catalog and boundaries are in [roles](roles.md).
