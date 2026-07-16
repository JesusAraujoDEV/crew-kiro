# Usar crew

El uso normal es deliberadamente simple: instala crew-kiro, inicia una sesión nueva de Kiro y describe el resultado que necesitas. Kiro elige el rol dueño y las consultas especialistas necesarias.

## Pide en lenguaje normal

```text
Decide si las notificaciones pertenecen al core o a un módulo de extensión.
Convierte estos requisitos en criterios de aceptación y casos límite.
Diseña la recuperación de cuenta y luego implementa la UI aprobada.
Instrumenta la activación del trial y define los KPIs del dashboard.
```

No necesitas conocer primero el catálogo. El router clasifica la decisión por autoridad—no solo por palabras clave—y mantiene un único dueño por decisión.

Kiro puede responder directamente con la lente pertinente en una pregunta simple. Delega a un custom subagent cuando el trabajo especialista aislado mejora materialmente el resultado. El agente principal secuencia el trabajo multirol; los subagents no se orquestan entre sí.

Seguridad/compliance es obligatorio cuando hay autenticación, autorización, datos sensibles, aislamiento entre tenants, consentimiento, retención, cifrado, auditoría o regulación. UX se consulta antes de implementar interfaz.

## Overrides opcionales

Son vías de escape, no requisitos:

- Prefija una solicitud con un alias como `SYS:`, `UX:`, `SEC:` o `QA:`.
- Usa el nombre completo, por ejemplo `System Architect:`.
- Selecciona un custom agent explícitamente en Kiro para diagnosticar routing o pedir intencionalmente una autoridad estrecha.
- Usa `GEN:` cuando quieras una síntesis general en vez de un entregable con dueño especialista; las consultas obligatorias de seguridad y UX siguen aplicando.

El mapa activo de aliases y las reglas de composición viven en `.kiro/steering/crew-roles.md`. No los dupliques en la documentación del proyecto.

## Comportamiento workspace y global

La instalación por workspace viaja con el repositorio e incluye hooks y `crew.json`. La global deja routing y agentes disponibles para el usuario en todos sus workspaces, pero no impone hooks ni proceso de proyecto.

Cuando coexisten, el steering y los hechos del proyecto tienen precedencia. Inicia una sesión nueva de Kiro tras instalar o actualizar cualquier alcance.

## Modos team y solo

`crew.json` controla el proceso del proyecto:

- **`team`** — scaffold documental completo, ítems cerrados inmutables, chequeo de estimación al cierre y contexto de cierre.
- **`solo`** — catálogo especialista sin ceremonia de equipo; los ítems cerrados siguen editables y no se exige contexto de cierre.

`metrics` es independiente del modo. Con `"metrics": true`, los timestamps de estimación se validan en tiempo real y la puerta de cierre también aplica en solo. Ver [configuración](configuration.md).

## Iniciar o incorporar un proyecto

Para un proyecto nuevo, ejecuta el instalador de workspace en modo team o solo. Crea el scaffold faltante, pero no crea `AGENTS.md`; las instrucciones activas de Kiro viven en `.kiro/steering/`.

Guarda los hechos del proyecto en un steering propio como `.kiro/steering/project-context.md`: propósito, stack, restricciones de arquitectura, layout, comandos comunes y propiedad humana. El instalador solo administra los dos steering files `crew-*`, así que no sobrescribe tu contexto.

En un proyecto existente, usa el mismo instalador. Conserva `crew.json`, standards y documentación existentes. Después pide en lenguaje normal:

```text
Audita la documentación de este proyecto contra la estructura crew instalada. Conserva las diferencias intencionales y registra las decisiones.
```

El documentation steward debe clasificar cada hallazgo como alineado, faltante o divergencia intencional. Las reglas del proyecto ganan sobre los defaults de crew; registra excepciones durables en `docs/DEVIATIONS.md` en vez de reabrirlas en cada sesión.

## Archivos administrados y propios

Repetir el instalador reemplaza steering, agentes, skills, hooks, scripts, definiciones canónicas y utilidad de métricas administrados por crew. No personalices esas copias instaladas; cambia el repositorio fuente y reinstala.

El instalador conserva `crew.json`, `standards/` y `docs/` existentes. Esos archivos son del proyecto desde que se crean. Las actualizaciones no fusionan texto nuevo de las plantillas; audita y reconcilia de forma deliberada.

## Métricas

Con stories o requirements cerrados y medidos, ejecuta desde la raíz:

```powershell
node .kiro/crew/bin/metrics.js
node .kiro/crew/bin/metrics.js 2026-07
node .kiro/crew/bin/metrics.js --csv
```

Una instalación solo global expone la utilidad en `~/.kiro/crew/bin/metrics.js`. El reporte escanea `docs/stories/` y `docs/requirements/`; `--csv` escribe `docs/work/metrics.csv`. Ver [métricas](metrics.md) para interpretarlo.

## Reglas de composición

- Un dueño por decisión.
- Consulta otro rol solo por una autoridad distinta; no crees propiedad por consenso.
- El agente principal integra consultas y devuelve una sola respuesta en el mismo turno.
- `security-compliance` puede bloquear una propuesta insegura.
- `researcher` devuelve evidencia e incertidumbre, nunca recomendaciones.
- Un rol nuevo necesita autoridad distinta y recurrente, y un valor de routing mayor que su coste.

El catálogo y sus límites están en [roles](roles.md).
