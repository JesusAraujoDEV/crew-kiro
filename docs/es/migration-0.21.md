# Migrar a v0.21

v0.21.0 consolida el catálogo de roles en 16 core + 1 perfil extendido + 1 skill — cada rol retirado fue absorbido por un sucesor, ninguno se descartó — e introduce modos opcionales por repositorio vía `crew.json`. Esta guía es para proyectos que ya usan el crew y actualizan el plugin.

La versión corta: **nada de tu circuito de entrega cambia**. Stories, requirements, tablas de estimación, ADRs y entradas de work quedan exactamente como están. Solo cambia la puerta a la que golpeás — algunos roles se fusionaron en otros, y sus comandos viejos te indican adónde ir.

## Quién tiene que hacer qué

| Tu situación | Acción necesaria |
|---|---|
| Repo sin `crew.json` | **Ninguna.** El comportamiento es idéntico a v0.19.1. |
| Repo scaffoldeado con una tabla de alias que referencia roles retirados | Actualizar la tabla de alias en `AGENTS.md` (ver abajo). |
| Memoria muscular sobre un comando retirado | Ninguna — el comando viejo te redirige y sigue con la tarea, durante una versión. |
| Querés modos por repo (solo/team, métricas, gates de calidad) | Agregar `crew.json` — totalmente opt-in. Ver el [quickstart solo](solo-quickstart.md). |

## Tabla de migración de roles

| Rol anterior (alias) | Sucesor | Por qué |
|---|---|---|
| performance-reliability (`PERF`) | **platform (`OPS`)** | Una sola puerta para todo lo post-merge: releases, versionado, deploys, CI/CD, infraestructura cloud, SLOs, error budgets, observabilidad, presupuestos de performance. |
| release-manager (`REL`) | **platform (`OPS`)** | Misma consolidación. |
| atlas-deploy (`INFRA`) | **platform (`OPS`)** | Misma consolidación. |
| spec-compliance (`SC`) | **qa-test-architect (`QA`), "modo veredicto"** | "¿Está bien testeado?" y "¿cumple la spec?" son una misma conversación. |
| web-strategist (`WEB`) | **commercial-strategist (`COM`)** | La web pública es mensaje comercial. |
| module-extension-architect (`MOD`) | **system-architect (`SYS`)** | Los contratos de extensión son decisiones de arquitectura. |
| visual-identity (`VIS`) | **ux-architect (`UX`)** | UX rediseñado: es dueño del sistema visual y del criterio visual (composición, densidad, jerarquía, elegancia); se lo consulta en fase de diseño antes de codear UI; un veredicto de calidad de diseño exige ver el render. |
| crew-architect (`CA`) | **crew (`CREW`)** | Gobernar el catálogo e instalarlo son dos verbos del mismo dueño. |
| crew-installer (`INST`) | **crew (`CREW`)** | Misma fusión. |
| communications-strategist (`COMM`) | **skill writing** (`skills/writing/`) | Un oficio horizontal que cualquier rol carga al redactar una pieza; deja de ser un rol. |
| dx-architect (`DX`) | **api (`API`), perfil extendido** | Renombrado y movido al perfil extendido opt-in — se activa solo cuando el producto expone una API/SDK pública. |
| researcher (`LEA`) | **researcher (`RES`)** | Solo cambia el alias; el rol queda igual. |

## Los comandos retirados redirigen, y luego desaparecen

Cada slash command retirado — `/crew:perf`, `/crew:rel`, `/crew:infra`, `/crew:sc`, `/crew:web`, `/crew:mod`, `/crew:vis`, `/crew:ca`, `/crew:inst`, `/crew:dx`, `/crew:lea`, `/crew:comm` — responde con una redirección a su sucesor **y sigue con la tarea**. Nada se rompe en el medio. Las redirecciones viven una versión; después los comandos se eliminan. Actualizá hábitos y prompts guardados antes del próximo release.

## Corregir un AGENTS.md ya scaffoldeado

El plugin nunca sobrescribe tus archivos scaffoldeados. Si el `AGENTS.md` de tu proyecto lleva la tabla de alias previa a 0.21, va a seguir referenciando roles retirados hasta que la actualices. Dos formas de corregirlo:

1. **Recomendada:** volver a correr la actualización de activación — pedile a `/crew:crew` que actualice la activación del crew en este proyecto. Reemplaza la sección de la tabla de alias por la actual y no toca nada más.
2. **Manual:** reemplazar la sección de la tabla de alias de tu `AGENTS.md` por la actual de [`templates/AGENTS.md`](../../templates/AGENTS.md).

En cualquiera de los dos casos, tus datos de proyecto, tabla de stack, desviaciones y todo lo demás que hayas editado quedan intactos.

## Qué no cambia

- El circuito de entrega: stories, requirements, el gate de Ready, el ciclo de vida, la tabla de estimación — todo idéntico.
- Cada artefacto en disco: nada se mueve, nada se renombra, nada necesita regenerarse.
- Hooks y guards siguen funcionando como antes.
- Los repos sin `crew.json` se comportan exactamente como en v0.19.1. Agregar `crew.json` es opt-in y es la vía de acceso a los modos nuevos (solo/team, métricas, enforcement de calidad).

## También nuevo en 0.21

- Config por repo `crew.json`: `mode` (solo|team), `metrics`, `quality` (advise|enforce|off), techos.
- `init-project.sh --solo` para repos de una sola persona — ver el [quickstart solo](solo-quickstart.md).
- `/crew:metrics report` para el reporte de estimado vs. real.
- Guard de timestamps en tiempo real cuando `metrics: true`.
- Modo advise de calidad, gate de pre-commit y exenciones pre-registradas `crew:exempt` en `docs/DEVIATIONS.md`.
