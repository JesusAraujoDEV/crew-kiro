# Enforcement — cuando reacciona un hook de Kiro

La instalación por workspace añade cinco hooks nativos de Kiro. Cuatro hooks de comando `PreToolUse` inspeccionan escrituras; un hook de agente `Stop` revisa el contexto de cierre. La instalación global no añade ninguno.

Los guards de escritura soportan `fs_write`, `str_replace` y `fs_append`, incluidas variantes snake_case/camelCase del payload de Kiro. Resuelven rutas relativas contra el workspace y evalúan el contenido resultante.

Todos los guards de comando fallan abiertos ante errores internos. Una decisión deliberada se devuelve mediante la respuesta allow/deny estándar de Kiro.

## Calidad de código

Archivos: `.kiro/hooks/guard-code-quality.json`, `hooks/kiro-guard-code-quality.js`.

Cuando un archivo de código soportado supera el techo de su tipo:

- `quality: advise` permite y devuelve un aviso.
- `quality: enforce` deniega.
- `quality: off` omite la revisión.

Divide el archivo por responsabilidad. Para un archivo generado o de datos planos legítimamente grande, registra antes una exención razonada.

### Exenciones

Usa un bloque legible por máquina en `docs/DEVIATIONS.md`:

```markdown
<!-- crew:exempt
src/generated/**        # cliente API generado
fixtures/large-data.ts  # datos estáticos, sin lógica
-->
```

Las rutas son relativas a la raíz detectada y usan `/`. `**` cruza directorios; `*` queda dentro de un segmento.

El instalador Kiro no instala un gate Git pre-commit. El enforcement aplica solo a herramientas de escritura de Kiro.

## Inmutabilidad

Archivos: `.kiro/hooks/guard-immutable.json`, `hooks/kiro-guard-immutable.js`.

- Las entradas existentes `docs/work/YYYY-MM/*.md` son inmutables en todo modo. Escribe una entrada nueva que referencie la anterior.
- Stories/requirements Closed son inmutables en team y sin config válida. Representa trabajo nuevo con un ítem nuevo.
- En solo, stories/requirements cerrados siguen editables.

## Cierre de estimación

Archivos: `.kiro/hooks/guard-estimation.json`, `hooks/kiro-guard-estimation.js`.

Actúa solo en la transición a `Closed`/`Cerrada` de Markdown bajo `docs/stories/` o `docs/requirements/`. Exige:

- Sección literal `## Estimation`.
- Al menos una fila de hito.
- Celdas no vacías en `Milestone`, `Est. hours`, `Started`, `Finished` y `Actual hours`. `Notes` puede quedar vacía.

Está activo en team y sin config válida. En solo, únicamente con `metrics: true`.

## Timestamps en tiempo real

Archivos: `.kiro/hooks/guard-timestamps.json`, `hooks/kiro-guard-timestamps.js`.

Activo solo con `metrics: true`. Cuando una celda antes vacía `Started` o `Finished` se llena por primera vez, debe:

- Cumplir `YYYY-MM-DD HH:mm ±TZ`; acepta zonas `Z`, `+02`, `+0200` y `+02:00`.
- Estar a menos de 15 minutos del reloj actual.
- Respetar `Finished >= Started`.
- Mantener `Actual hours` dentro del tiempo wall-clock, con tolerancia del 5%.

El guard incluye la hora actual correctamente formateada al denegar. Nunca reconstruyas ni retro-dates timestamps. Tras una interrupción, usa la hora real al retomar/cerrar y explica el hueco en `Notes`.

## Cierre de sesión

Archivo: `.kiro/hooks/check-work-log.json`.

Es un hook nativo de **agente** Stop, no un comando bloqueante. Antes de terminar lee `crew.json`:

- Sin config o modo solo: sin comentario.
- Team sin una iteración significativa cerrada: sin comentario.
- Team con trabajo significativo cerrado: revisa estimación completa y la entrada aplicable en `docs/work`.

Si falta evidencia, nombra el artefacto exacto y deja que el usuario decida si el trabajo cae bajo el umbral de significancia. No inventa historia ni reconstruye timestamps.

## Solución de problemas

- **Enforce inesperado:** valida `crew.json`; JSON inválido usa fallbacks conservadores.
- **Política equivocada en monorepo:** gana el `crew.json` más cercano por encima del archivo.
- **El hook no disparó:** confirma instalación workspace, inicia una sesión nueva y revisa la condición (`metrics`, `mode` o `quality`). Los hooks no corren dentro de custom subagents; el agente principal debe realizar las escrituras protegidas.
- **La exención no coincide:** usa ruta relativa a raíz con `/`; `*` no cruza directorios.
- **Ignora la estimación:** mantén el estado en los primeros 600 caracteres y usa el heading literal `## Estimation`.
