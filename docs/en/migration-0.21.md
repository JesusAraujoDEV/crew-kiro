# Migrating to v0.21

v0.21.0 consolidates the role catalog into 16 core roles + 1 extended profile + 1 skill — every retired role was absorbed by a successor, none was dropped — and introduces optional per-repo modes via `crew.json`. This guide is for projects that already use the crew and are updating the plugin.

The short version: **nothing in your delivery circuit changes**. Stories, requirements, estimation tables, ADRs, and work entries all stay exactly as they are. Only the door you knock on changes — some roles merged into others, and their old commands tell you where to go.

## Who needs to do what

| Your situation | Action needed |
|---|---|
| Repo without `crew.json` | **None.** Behavior is identical to v0.19.1. |
| Repo scaffolded with an alias table referencing retired roles | Update the alias table in `AGENTS.md` (see below). |
| Muscle memory on a retired command | None — the old command redirects you and proceeds with the task, for one version. |
| Want per-repo modes (solo/team, metrics, quality gates) | Add `crew.json` — entirely opt-in. See the [solo quickstart](solo-quickstart.md). |

## Role migration table

| Old role (alias) | Successor | Why |
|---|---|---|
| performance-reliability (`PERF`) | **platform (`OPS`)** | One door for everything post-merge: releases, versioning, deploys, CI/CD, cloud infra, SLOs, error budgets, observability, performance budgets. |
| release-manager (`REL`) | **platform (`OPS`)** | Same consolidation. |
| atlas-deploy (`INFRA`) | **platform (`OPS`)** | Same consolidation. |
| spec-compliance (`SC`) | **qa-test-architect (`QA`), "verdict mode"** | "Is it well tested?" and "does it match the spec?" are one conversation. |
| web-strategist (`WEB`) | **commercial-strategist (`COM`)** | The public web is commercial message. |
| module-extension-architect (`MOD`) | **system-architect (`SYS`)** | Extension contracts are architecture decisions. |
| visual-identity (`VIS`) | **ux-architect (`UX`)** | UX redesigned: owns the visual system and visual taste (composition, density, hierarchy, elegance); consulted at design phase before coding UI; a design-quality verdict requires seeing the render. |
| crew-architect (`CA`) | **crew (`CREW`)** | Governing the catalog and installing it are two verbs of the same owner. |
| crew-installer (`INST`) | **crew (`CREW`)** | Same merge. |
| communications-strategist (`COMM`) | **writing skill** (`skills/writing/`) | A horizontal craft any role loads when authoring a piece; no longer a role. |
| dx-architect (`DX`) | **api (`API`), extended profile** | Renamed and moved to the opt-in extended profile — activate only when the product exposes a public API/SDK. |
| researcher (`LEA`) | **researcher (`RES`)** | Alias renamed only; the role is unchanged. |

## Retired commands redirect, then disappear

Every retired slash command — `/crew:perf`, `/crew:rel`, `/crew:infra`, `/crew:sc`, `/crew:web`, `/crew:mod`, `/crew:vis`, `/crew:ca`, `/crew:inst`, `/crew:dx`, `/crew:lea`, `/crew:comm` — answers with a redirect to its successor **and proceeds with the task**. Nothing breaks mid-flight. The redirects live for one version; after that the commands are removed. Update habits and any saved prompts before the next release.

## Fixing an already-scaffolded AGENTS.md

The plugin never overwrites your scaffolded files. If your project's `AGENTS.md` carries the pre-0.21 alias table, it will keep referencing retired roles until you update it. Two ways to fix it:

1. **Recommended:** re-run the activation update — ask `/crew:crew` to update the crew activation in this project. It replaces the alias table section with the current one and touches nothing else.
2. **Manual:** replace the alias table section in your `AGENTS.md` with the current one from [`templates/AGENTS.md`](../../templates/AGENTS.md).

Either way, your project facts, stack table, deviations, and everything else you edited stay untouched.

## What does not change

- The delivery circuit: stories, requirements, the Ready gate, the lifecycle, the estimation table — all identical.
- Every artifact on disk: nothing moves, nothing is renamed, nothing needs regeneration.
- Hooks and guards keep working as before.
- Repos without `crew.json` behave exactly like v0.19.1. Adding `crew.json` is opt-in and is how you access the new modes (solo/team, metrics, quality enforcement).

## Also new in 0.21

- `crew.json` per-repo config: `mode` (solo|team), `metrics`, `quality` (advise|enforce|off), ceilings.
- `init-project.sh --solo` for one-person repos — see the [solo quickstart](solo-quickstart.md).
- `/crew:metrics report` for estimation-vs-actual reporting.
- Real-time timestamps guard when `metrics: true`.
- Quality advise mode, a pre-commit gate, and `crew:exempt` pre-registered exemptions in `docs/DEVIATIONS.md`.
