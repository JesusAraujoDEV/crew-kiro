# Configuración — `crew.json`

`crew.json` es el archivo de política del proyecto para los guards del crew: un JSON pequeño en la raíz que decide qué reglas se aplican y con qué dureza. Cada valor es explícito — el archivo *es* la política, visible y versionada junto al código. Cuando un guard te bloquea y querés saber por qué, esta página te dice a qué campo obedeció; los mensajes de denegación están catalogados en [enforcement.md](enforcement.md).

## Cómo lo encuentran los guards

Cada guard resuelve la configuración subiendo desde el directorio del archivo que se está editando (o desde el directorio de trabajo de la sesión, como fallback), buscando `crew.json`, hasta 30 niveles o la raíz del filesystem. Gana el primer `crew.json` encontrado. En un monorepo, cada proyecto puede llevar su propio `crew.json` y cada edición se rige por el más cercano hacia arriba. Lector: [`../../hooks/lib/config.js`](../../hooks/lib/config.js).

## La regla legacy — sin `crew.json`

**Sin `crew.json` (o con JSON inválido), el comportamiento es exactamente el de v0.19.1.** El lector no devuelve nada y cada guard cae a su comportamiento pre-configuración:

- Entradas de `docs/work/` e ítems de trabajo Closed: inmutables.
- Puerta de estimación al cierre: activa.
- Guard de timestamps: **apagado** (solo existe con `"metrics": true`).
- Calidad de código: **enforce** — las escrituras que superan el techo se deniegan.
- Stop hook del work-log: activo donde exista `docs/work/`.

Dos consecuencias que conviene internalizar. Primera, el plugin **no tiene defaults ocultos**: los valores más amables que reciben los proyectos nuevos (`advise`, métricas activadas) no vienen de fábrica — existen solo porque [`../../bin/init-project.sh`](../../bin/init-project.sh) los escribe explícitamente en el `crew.json` scaffoldeado. Segunda, un `crew.json` con un error de sintaxis JSON se comporta como si no existiera — lo que convierte silenciosamente `"quality": "advise"` en enforce. Si un guard se puso más estricto de golpe, verificá que el JSON parsea.

## Referencia de campos

| Campo | Valores | Default si falta | Qué controla |
|---|---|---|---|
| `mode` | `"team"` \| `"solo"` | `"team"` | Si aplica la ceremonia completa del circuito de entrega. Cualquier cosa distinta del string exacto `"solo"` cuenta como team. |
| `metrics` | `true` \| `false` | `false` | La disciplina de timestamps de estimación. Solo el literal `true` la activa. |
| `quality` | `"advise"` \| `"enforce"` \| `"off"` | `"enforce"` | Qué hace el guard de calidad en tiempo de escritura ante una violación de techo. Valores desconocidos caen a `"enforce"`. |
| `ceilings` | objeto `{ kind: líneas }` | `{}` | Overrides por tipo de los techos de líneas por archivo. Valores no-objeto caen a `{}`. |

Los campos ausentes se normalizan al valor equivalente-legacy de la tercera columna — un `crew.json` que contiene solo `{"mode": "solo"}` es válido y significa solo, sin métricas, calidad enforce, techos por defecto.

### `mode`

`team` asume el circuito completo del crew: las historias/requerimientos son contratos, los ítems Closed son historia, las sesiones dejan traza en el work-log. `solo` conserva las piezas baratas y siempre valiosas (entradas de `docs/work/` inmutables, la puerta de calidad) y suelta la ceremonia de equipo: los ítems Closed siguen editables, no hay recordatorio del Stop hook, y la puerta de estimación aplica solo si optaste por métricas.

### `metrics`

Con `true` se activan dos cosas: la puerta de estimación aplica incluso en modo solo, y el [guard de timestamps](enforcement.md#timestamps) empieza a validar que las celdas `Started`/`Finished` se escriban **en tiempo real** (formato correcto, dentro de 15 minutos del reloj de la máquina, coherentes entre sí). Esta es la disciplina que hace confiable a [/crew:metrics](metrics.md). Con `false` o ausente, el guard de timestamps queda completamente en silencio.

### `quality`

Controla **solo** el guard en tiempo de escritura ([`../../hooks/guard-code-quality.js`](../../hooks/guard-code-quality.js)):

| Modo | En la escritura (Edit/Write del agente) | En el commit (puerta pre-commit) |
|---|---|---|
| `advise` | La escritura procede; el agente ve un aviso visible | Bloquea el commit |
| `enforce` | La escritura se deniega | Bloquea el commit |
| `off` | Silencio | Sigue bloqueando — la puerta se gestiona aparte |

`advise` es lo que el scaffold escribe para proyectos nuevos: el agente no pierde impulso y el freno duro está en el commit. Ojo: la puerta pre-commit ([`../../bin/check-quality.sh`](../../bin/check-quality.sh)) **no** lee `quality` — poner calidad en `off` silencia el hook, no la puerta. Para quitar la puerta, borrá su línea de `.git/hooks/pre-commit`.

### `ceilings`

Los techos de líneas por tipo de archivo, y cómo se detecta el tipo (gana la primera coincidencia):

| Tipo | Techo por defecto | Se detecta cuando |
|---|---|---|
| `test` | 250 | `.test.`/`.spec.` en el nombre, o bajo `__tests__/`, `test/`, `tests/` |
| `rust` | 300 | extensión `.rs` |
| `hook` | 80 | `.ts`/`.tsx` llamado `use-*` o `useXxx` (hooks estilo React) |
| `page` | 200 | bajo `pages/` o `routes/`, o `.page.`/`.route.` en el nombre |
| `service` | 150 | bajo `services/` o `stores/`, o `.service.`/`.store.`/`.slice.` en el nombre |
| `component` | 150 | `.tsx`/`.jsx` cuyo nombre empieza con mayúscula |
| `module` | 200 | todo lo demás (el tipo por defecto) |

Solo se revisan archivos de código (`.ts`, `.tsx`, `.js`, `.jsx`, `.mjs`, `.cjs`, `.rs`, `.py`, `.go`, `.java`, `.rb`, `.php`, `.cs`, `.kt`, `.swift`, `.vue`, `.svelte`, …). `"ceilings"` sobreescribe el número por tipo — no cambia la detección del tipo. Tanto el guard de escritura como la puerta pre-commit respetan los mismos overrides, y ambos respetan las [exenciones pre-registradas](enforcement.md#exenciones) en `docs/DEVIATIONS.md`. Lógica: [`../../hooks/lib/ceilings.js`](../../hooks/lib/ceilings.js).

## Matriz de comportamiento — guard × config

| Guard | Lee | `team` | `solo` | Sin `crew.json` (v0.19.1) |
|---|---|---|---|---|
| Entradas de `docs/work/` inmutables ([guard-immutable](../../hooks/guard-immutable.js)) | nada | inmutables | inmutables | inmutables |
| Historias/requerimientos Closed inmutables (guard-immutable) | `mode` | inmutables | **editables** | inmutables |
| Estimación completa al cierre ([guard-estimation](../../hooks/guard-estimation.js)) | `mode`, `metrics` | siempre activo | solo con `metrics: true` | activo |
| Timestamps en tiempo real ([guard-timestamps](../../hooks/guard-timestamps.js)) | `metrics` | con `metrics: true` | con `metrics: true` | apagado |
| Techos de tamaño al escribir ([guard-code-quality](../../hooks/guard-code-quality.js)) | `quality`, `ceilings` | según `quality` | según `quality` | enforce |
| Recordatorio de work-log al cerrar sesión ([check-work-log](../../hooks/check-work-log.js)) | `mode` | activo donde exista `docs/work/` | apagado | activo donde exista `docs/work/` |
| Puerta de calidad pre-commit ([check-staged.js](../../bin/check-staged.js)) | `ceilings` | siempre, una vez instalada | siempre, una vez instalada | siempre, una vez instalada |
| Reporte `/crew:metrics` ([metrics.js](../../bin/metrics.js)) | nada | corre | corre | corre |

La última fila es el patrón a recordar: **el reporte corre en cualquier lado; lo que `metrics: true` habilita es la disciplina**. Detalles en [metrics.md](metrics.md).

## Cómo lo escribe `init-project.sh`

`bash <plugin>/bin/init-project.sh` (desde la raíz de tu proyecto) scaffoldea la estructura del crew y escribe `crew.json` con **todos los valores explícitos**:

```json
{
  "mode": "team",
  "metrics": true,
  "quality": "advise",
  "ceilings": {}
}
```

Con `--solo` escribe `"mode": "solo"` (mismos otros valores) y scaffoldea solo la estructura mínima: `AGENTS.md`, `CLAUDE.md`, `standards/`, `docs/decisions/`, `docs/work/` — sin la taxonomía de stories/requirements/briefs. En ambos modos instala además la puerta de calidad como `.git/hooks/pre-commit`: si ya existe un hook pre-commit, la línea de la puerta se **agrega al final**, nunca sobreescribe; si ya corre `check-quality.sh`, lo deja en paz; si no hay `.git`, avisa que hagas `git init` y vuelvas a correr el script. Los archivos existentes — incluido un `crew.json` existente — nunca se sobreescriben.

## Ejemplos trabajados

**Team por defecto** — lo que escribe el scaffold. Ceremonia completa, disciplina de métricas activa, calidad advisory al escribir con el freno duro en el commit:

```json
{ "mode": "team", "metrics": true, "quality": "advise", "ceilings": {} }
```

**Solo con métricas** — trabajás solo pero querés números honestos. Los ítems Closed siguen editables y no hay recordatorio de work-log, pero la tabla de estimación y los timestamps en tiempo real se hacen cumplir:

```json
{ "mode": "solo", "metrics": true, "quality": "advise", "ceilings": {} }
```

**Solo sin ceremonia** — el mínimo. Solo queda la inmutabilidad de `docs/work/` (y la puerta pre-commit, si está instalada):

```json
{ "mode": "solo", "metrics": false, "quality": "off", "ceilings": {} }
```

**Override de techos** — tus componentes legítimamente son más grandes y tus tests más largos:

```json
{ "mode": "team", "metrics": true, "quality": "advise",
  "ceilings": { "component": 250, "test": 400 } }
```

Para archivos grandes puntuales (código generado, datos planos), no subas el techo de todo el tipo — [pre-registrá una exención](enforcement.md#exenciones).
