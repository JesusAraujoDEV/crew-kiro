# Migrating a legacy v0.21 crew project to Kiro

This page preserves the v0.21 role-consolidation map while explaining the current migration path. Kiro does not use the old Claude slash commands, plugin marketplace, or routing tables embedded in `AGENTS.md`.

## Migration steps

1. Install crew-kiro into the workspace with `init-kiro.ps1 -Target <project>` or `init-kiro.sh --target <project>`.
2. Start a new Kiro session.
3. Keep project facts in `AGENTS.md` if other tools use it, but remove stale crew routing/alias instructions. Kiro's canonical router is `.kiro/steering/crew-roles.md`.
4. Preserve existing stories, requirements, ADRs, work history, and intentional deviations.
5. Review or create `crew.json`; the installer preserves an existing file.
6. Replace saved slash-command prompts with ordinary language. Optional current aliases may still be used as prefixes.

## Role consolidation map

| Legacy role/alias | Current owner | Boundary rationale |
|---|---|---|
| performance-reliability (`PERF`) | `platform` (`OPS`) | Runtime performance, reliability, observability, and release operations share post-merge authority. |
| release-manager (`REL`) | `platform` (`OPS`) | Release/version mechanics belong to platform. |
| atlas-deploy (`INFRA`) | `platform` (`OPS`) | Deployment infrastructure belongs to platform. |
| spec-compliance (`SC`) | `qa-test-architect` (`QA`) | Test adequacy and behavioral compliance are one verification authority. |
| web-strategist (`WEB`) | `commercial-strategist` (`COM`) | Public-site positioning and messaging are commercial strategy. |
| module-extension-architect (`MOD`) | `system-architect` (`SYS`) | Extension contracts are system architecture. |
| visual-identity (`VIS`) | `ux-architect` (`UX`) | UX owns the visual system, interaction, accessibility, and design quality. |
| crew-architect (`CA`) | `crew` (`CREW`) | Catalog governance belongs to the crew meta-role. |
| crew-installer (`INST`) | `crew` (`CREW`) | Kiro installation and catalog governance share the crew system owner. |
| communications-strategist (`COMM`) | `writing` skill | Writing is horizontal craft applied by the domain owner, not a separate decision authority. |
| legacy dx alias (`DX`) | `dx-architect` (`API`) | Public API/SDK developer experience remains an opt-in specialist authority. |
| researcher (`LEA`) | `researcher` (`RES`) | Alias change only; evidence remains read-only and non-prescriptive. |

Kiro routes ordinary requests to these current owners automatically; legacy aliases are not commands and are not guaranteed compatibility entry points.

## Existing artifacts

No migration is required for the delivery artifacts themselves. Keep:

- `docs/stories/`, `docs/requirements/`, `docs/decisions/`, and `docs/work/`.
- `## Estimation` tables and historical timestamps.
- Project standards and `docs/DEVIATIONS.md`.
- Existing `crew.json`, after checking its values against [configuration](configuration.md).

The Kiro installer updates crew-managed assets and creates only missing project scaffold. It does not overwrite existing project documentation or config.

## Current replacements

| Legacy mechanism | Kiro-native replacement |
|---|---|
| Slash command per role | Ordinary language + automatic router; alias prefix optional. |
| Claude plugin marketplace | `init-kiro.ps1` / `init-kiro.sh`. |
| Routing table in `AGENTS.md` | `.kiro/steering/crew-roles.md`. |
| SessionStart baseline injection | `.kiro/steering/crew-baseline.md`. |
| Plugin subagents | `.kiro/agents/*.md`. |
| Legacy metrics command | `node .kiro/crew/bin/metrics.js`. |
| Legacy write hooks | `.kiro/hooks/*.json` + `hooks/kiro-*.js`. |

The Kiro installer does not install the old Git pre-commit quality gate. Configure a separate repository/CI gate if required.
