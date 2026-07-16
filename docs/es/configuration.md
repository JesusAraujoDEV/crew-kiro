# Configuración — `crew.json`

`crew.json` es la política de workspace que leen los guards de crew-kiro. Controla el proceso del proyecto; no elige roles. El routing automático viene de `.kiro/steering/crew-roles.md`.

El instalador de workspace crea este archivo solo si falta:

```json
{
  "mode": "team",
  "metrics": true,
  "quality": "advise",
  "ceilings": {}
}
```

El archivo pertenece al proyecto. Repetir el instalador nunca lo reemplaza.

## Cómo resuelven la política los guards

Para un archivo editado, los guards suben desde su directorio buscando el `crew.json` más cercano, hasta la raíz o 30 niveles. Si no hay ruta de archivo, usan el directorio de trabajo de la sesión. Esto permite una política por proyecto en un monorepo.

JSON inválido o ilegible se trata como ausencia de config. Aplican fallbacks conservadores: inmutabilidad y cierre de estimación estilo team, timestamps de métricas apagados y calidad `enforce`. El agente Stop no emite recordatorio de cierre si falta `crew.json`.

## Campos

| Campo | Valores | Fallback si falta/es inválido | Controla |
|---|---|---|---|
| `mode` | `"team"` o `"solo"` | `"team"` | Protecciones de equipo o proceso mínimo individual. |
| `metrics` | `true` o `false` | `false` | Timestamps en tiempo real; también habilita cierre de estimación en solo. |
| `quality` | `"advise"`, `"enforce"` u `"off"` | `"enforce"` | Decisiones Kiro de tamaño al escribir. |
| `ceilings` | objeto `{ tipo: líneas }` | `{}` | Overrides de techo por tipo. |

Los valores desconocidos normalizan de forma conservadora: solo `"solo"` exacto selecciona solo; solo `true` habilita métricas; calidad desconocida se vuelve `enforce`.

## `mode`

`team` protege stories/requirements cerrados, exige estimación completa antes de cerrar y permite que el agente Stop revise la trazabilidad de una sesión significativa.

`solo` conserva el historial `docs/work/` inmutable y la política de calidad, pero los ítems cerrados siguen editables y el agente Stop permanece en silencio. El cierre de estimación aplica en solo únicamente con métricas activas.

Cambiar flags del instalador no modifica una config existente. Edita `mode` directamente cuando cambie el estilo de trabajo.

## `metrics`

Con `true`, las celdas nuevas `Started` y `Finished` deben usar `YYYY-MM-DD HH:mm ±TZ`, estar a menos de 15 minutos del reloj actual, respetar el orden y mantener las horas reales dentro del intervalo wall-clock.

La utilidad de reporte puede ejecutarse con cualquier valor; `metrics: true` vuelve mecánicamente confiables sus datos fuente.

## `quality`

| Modo | Comportamiento de escritura en Kiro |
|---|---|
| `advise` | Permite la escritura y devuelve un aviso visible. |
| `enforce` | Deniega hasta dividir el archivo o registrar una exención. |
| `off` | No revisa techos de tamaño. |

El instalador Kiro de crew-kiro **no** instala un hook Git pre-commit. Si el proyecto necesita un gate de commit/CI, configúralo aparte; no lo infieras de `quality: advise`.

## `ceilings`

| Tipo | Default | Detección |
|---|---:|---|
| `test` | 250 | Nombre test/spec o directorio de tests. |
| `rust` | 300 | `.rs`. |
| `hook` | 80 | Hook TypeScript estilo `use-*`/`useXxx`. |
| `page` | 200 | Ruta o nombre page/route. |
| `service` | 150 | Ruta o nombre service/store. |
| `component` | 150 | `.tsx`/`.jsx` con mayúscula inicial. |
| `module` | 200 | Otro archivo de código soportado. |

Los overrides cambian el número, no la detección:

```json
{
  "mode": "team",
  "metrics": true,
  "quality": "advise",
  "ceilings": { "component": 220, "test": 400 }
}
```

Para rutas grandes legítimas, generadas o de datos planos, registra una exención `crew:exempt` razonada en `docs/DEVIATIONS.md`; ver [enforcement](enforcement.md#exenciones).

## Matriz de guards

| Guard | Team | Solo | Sin config válida |
|---|---|---|---|
| `docs/work/YYYY-MM/*.md` existente inmutable | Sí | Sí | Sí |
| Story/requirement cerrado inmutable | Sí | No | Sí |
| Estimación completa al pasar a Closed | Sí | Solo con metrics | Sí |
| Timestamps en tiempo real | Con metrics | Con metrics | No |
| Techo de archivo | Según quality | Según quality | Enforce |
| Revisión Stop de contexto de cierre | Solo trabajo significativo | No | No |

Todos los guards PreToolUse fallan abiertos ante errores internos: un defecto del guard no debe bloquear trabajo legítimo.

## Utilidad de métricas

Instalación workspace:

```powershell
node .kiro/crew/bin/metrics.js
node .kiro/crew/bin/metrics.js 2026-07 --csv
```

Instalación solo global: ejecuta `node "$HOME/.kiro/crew/bin/metrics.js"` desde la raíz del proyecto.
