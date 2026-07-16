# Métricas — de estimación a evidencia

Stories y requirements cerrados pueden llevar una tabla `## Estimation`. La utilidad instalada convierte esas tablas en lead time, tiempo de ejecución, totales estimado/real y desviación. El routing automático no depende de métricas; son evidencia de entrega opcional.

## Tabla de estimación

```markdown
## Estimation

| Milestone | Est. hours | Started | Finished | Actual hours | Notes |
|---|---:|---|---|---:|---|
| Contrato API | 2 | 2026-07-14 09:12 -03:00 | 2026-07-14 11:05 -03:00 | 1.8 | |
| Implementación | 4 | 2026-07-14 11:20 -03:00 | 2026-07-15 10:40 -03:00 | 4.5 | sesión interrumpida |
```

Quien ejecuta añade hitos y estimaciones antes de implementar. `Started`, `Finished` y `Actual hours` se registran durante la ejecución. Los timestamps requieren offset de zona horaria.

Con `"metrics": true`, los hooks de Kiro validan timestamps nuevos en tiempo real e impiden cerrar un ítem medido con tabla incompleta. Ver [enforcement](enforcement.md).

## Ejecutar el reporte

Desde la raíz de un proyecto con instalación workspace:

```powershell
node .kiro/crew/bin/metrics.js
node .kiro/crew/bin/metrics.js 2026-07
node .kiro/crew/bin/metrics.js --csv
```

Con instalación únicamente global:

```powershell
node "$HOME/.kiro/crew/bin/metrics.js"
```

El script no tiene dependencias de paquetes. Escanea `docs/stories/**` y `docs/requirements/**` buscando ítems Closed con estimación parseable. Un argumento `YYYY-MM` filtra por mes de finalización; `--csv` escribe `docs/work/metrics.csv`.

## Salida

Por ítem:

| Medida | Significado |
|---|---|
| Lead days | Creación del archivo hasta el último `Finished`. |
| Execution hours | Primer `Started` hasta último `Finished`. |
| Estimated hours | Suma de estimaciones por hito. |
| Actual hours | Suma de horas de trabajo reportadas. |
| Deviation | `(real - estimado) / estimado`. |

Los agregados incluyen mediana y p90 de ejecución, desviación promedio y desgloses por carpeta y mes.

## Interpretación

- Una brecha grande entre lead y ejecución indica cola, no ejecución lenta.
- Una desviación aislada es ruido; una media persistente sirve para calibrar.
- Un p90 alto frente a la mediana sugiere hitos demasiado grandes o impredecibles.
- El wall-clock incluye pausas y revisiones. `Actual hours` representa esfuerzo reportado; no compares personas por wall-clock.

El reporte corre aunque `metrics` sea false, pero solo `metrics: true` aporta disciplina de timestamps exigida por hooks.
