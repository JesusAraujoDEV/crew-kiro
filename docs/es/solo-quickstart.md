# Quickstart solo

Usa modo solo cuando una persona quiere todo el catálogo especialista de Kiro sin ceremonia de handoff de equipo.

## 1. Instalar en el proyecto

```powershell
& "C:\ruta\a\crew-kiro\bin\init-kiro.ps1" -Solo -Target "C:\ruta\al\proyecto"
```

```bash
bash /ruta/a/crew-kiro/bin/init-kiro.sh --solo --target /ruta/al/proyecto
```

Instala steering de Kiro, 17 custom agents, skill de escritura, hooks, definiciones canónicas, utilidad de métricas, documentación mínima de decisiones/historial/calidad y un `crew.json` nuevo con `mode: solo`. Conserva archivos existentes.

Inicia una sesión nueva de Kiro.

## 2. Trabajar normalmente

Pide resultados sin seleccionar un rol:

```text
Revisa esta arquitectura antes de implementarla.
Diseña y construye una pantalla de ajustes accesible.
Comprueba si este release necesita migración o rollback.
```

Kiro rutea automáticamente. Los aliases y la selección explícita siguen siendo overrides opcionales.

## 3. Qué elimina solo

- No instala el scaffold completo de briefs/stories/requirements/proposals.
- Stories y requirements cerrados siguen editables.
- El agente Stop de contexto de cierre permanece en silencio.
- El cierre de estimación se exige solo con métricas activas.

## 4. Qué permanece

- Todos los roles especialistas y routing automático.
- Consultas obligatorias de seguridad y UX cuando aplican.
- Entradas existentes bajo `docs/work/YYYY-MM/` inmutables.
- Política de calidad y disciplina opcional de métricas.

La config generada activa métricas y usa calidad advisory por defecto. Edita `crew.json` si quieres otra política.

## 5. Métricas opcionales

Cuando quieras medir un trabajo, crea una story o requirement con tabla `## Estimation`. Registra timestamps mientras sucede y ejecuta:

```powershell
node .kiro/crew/bin/metrics.js
```

## Pasar a team más adelante

1. Cambia `crew.json` a `"mode": "team"`.
2. Repite el instalador workspace **sin** `-Solo`/`--solo` para añadir documentación de equipo faltante.
3. Inicia una sesión nueva de Kiro.

El instalador conserva config y docs existentes; solo añade scaffold faltante y actualiza assets administrados.
