# Migrar un proyecto crew v0.21 legacy a Kiro

Esta página conserva el mapa de consolidación de roles v0.21 y explica la migración actual. Kiro no usa los slash commands Claude, el marketplace de plugins ni tablas de routing incrustadas en `AGENTS.md`.

## Pasos de migración

1. Instala crew-kiro en el workspace con `init-kiro.ps1 -Target <proyecto>` o `init-kiro.sh --target <proyecto>`.
2. Inicia una sesión nueva de Kiro.
3. Conserva hechos del proyecto en `AGENTS.md` si otras herramientas lo usan, pero elimina routing/aliases crew obsoletos. El router canónico Kiro es `.kiro/steering/crew-roles.md`.
4. Conserva stories, requirements, ADRs, historial y desviaciones intencionales.
5. Revisa o crea `crew.json`; el instalador conserva uno existente.
6. Reemplaza prompts guardados con slash commands por lenguaje normal. Los aliases actuales siguen disponibles como prefijos opcionales.

## Mapa de consolidación

| Rol/alias legacy | Dueño actual | Razón del límite |
|---|---|---|
| performance-reliability (`PERF`) | `platform` (`OPS`) | Performance runtime, confiabilidad, observabilidad y releases comparten autoridad post-merge. |
| release-manager (`REL`) | `platform` (`OPS`) | Mecánica de release/versionado pertenece a platform. |
| atlas-deploy (`INFRA`) | `platform` (`OPS`) | Infraestructura de despliegue pertenece a platform. |
| spec-compliance (`SC`) | `qa-test-architect` (`QA`) | Adecuación de tests y cumplimiento funcional son una autoridad de verificación. |
| web-strategist (`WEB`) | `commercial-strategist` (`COM`) | Posicionamiento y mensaje del sitio público son estrategia comercial. |
| module-extension-architect (`MOD`) | `system-architect` (`SYS`) | Contratos de extensión son arquitectura de sistema. |
| visual-identity (`VIS`) | `ux-architect` (`UX`) | UX posee sistema visual, interacción, accesibilidad y calidad de diseño. |
| crew-architect (`CA`) | `crew` (`CREW`) | Gobierno del catálogo pertenece al meta-rol crew. |
| crew-installer (`INST`) | `crew` (`CREW`) | Instalación Kiro y gobierno comparten el dueño del sistema crew. |
| communications-strategist (`COMM`) | skill `writing` | Escritura es un oficio horizontal del dueño de dominio, no autoridad separada. |
| alias dx legacy (`DX`) | `dx-architect` (`API`) | DX de API/SDK pública sigue como autoridad especialista opt-in. |
| researcher (`LEA`) | `researcher` (`RES`) | Solo cambió el alias; la evidencia sigue siendo read-only y no prescriptiva. |

Kiro rutea solicitudes normales a estos dueños automáticamente; los aliases legacy no son comandos ni entradas compatibles garantizadas.

## Artefactos existentes

No hace falta migrar los artefactos de entrega. Conserva:

- `docs/stories/`, `docs/requirements/`, `docs/decisions/` y `docs/work/`.
- Tablas `## Estimation` y timestamps históricos.
- Standards del proyecto y `docs/DEVIATIONS.md`.
- `crew.json` existente, revisando sus valores contra [configuración](configuration.md).

El instalador Kiro actualiza assets administrados y crea solo scaffold faltante. No sobrescribe documentación ni config existentes.

## Reemplazos actuales

| Mecanismo legacy | Reemplazo nativo Kiro |
|---|---|
| Slash command por rol | Lenguaje normal + router automático; prefijo opcional. |
| Marketplace Claude | `init-kiro.ps1` / `init-kiro.sh`. |
| Tabla de routing en `AGENTS.md` | `.kiro/steering/crew-roles.md`. |
| Inyección SessionStart | `.kiro/steering/crew-baseline.md`. |
| Subagents del plugin | `.kiro/agents/*.md`. |
| Comando legacy de métricas | `node .kiro/crew/bin/metrics.js`. |
| Hooks legacy | `.kiro/hooks/*.json` + `hooks/kiro-*.js`. |

El instalador Kiro no instala el antiguo gate Git pre-commit. Configura un gate separado de repositorio/CI si lo necesitas.
