# Contribuir y mantenimiento

## Estructura de carpetas

```
crew-plugin/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── agents/
│   ├── product-strategist.md
│   ├── functional-analyst.md
│   ├── system-architect.md
│   ├── ...                   # un archivo por rol
├── commands/
│   ├── prod.md
│   ├── fa.md
│   ├── sys.md
│   ├── ...                   # un archivo por alias
├── hooks/
│   ├── hooks.json            # registra los hooks del plugin
│   ├── session-start.js      # SessionStart: inyecta standards/session-context.md
│   ├── guard-immutable.js    # PreToolUse: deniega ediciones a artefactos inmutables
│   ├── guard-estimation.js   # PreToolUse: tabla de estimación completa antes de cerrar
│   ├── guard-timestamps.js   # PreToolUse: celdas Started/Finished en tiempo real (métricas)
│   ├── guard-code-quality.js # PreToolUse: techos de calidad de código (advise/enforce)
│   └── check-work-log.js     # Stop: chequeo de cierre de sesión
├── standards/
│   └── session-context.md    # baseline de sesión siempre activo (defaults sugeridos)
├── templates/
│   ├── AGENTS.md             # contexto canónico de agentes (precedencia, mapa de propiedad, interop)
│   ├── CLAUDE.md             # puntero fino @AGENTS.md
│   ├── standards/
│   │   └── code-quality.md   # núcleo universal (sugerido; las reglas del proyecto ganan)
│   └── docs/                 # taxonomía sembrada en los proyectos consumidores
├── bin/
│   ├── init-project.sh       # scaffold + crew.json (team / --solo)
│   ├── metrics.js            # reporte de /crew:metrics
│   ├── check-quality.sh      # puerta de calidad pre-commit (instalada por init)
│   └── check-staged.js
├── docs/                     # documentación propia del plugin
│   ├── en/                   # sub-docs en inglés (roles, install, usage, contributing)
│   └── es/                   # español (README completo + sub-docs)
├── LICENSE
└── README.md                 # README canónico en inglés (ES → docs/es/README.md)
```

## Actualizar el plugin

Los roles y las plantillas evolucionan. Para propagar cambios a los consumidores:

1. Edita el archivo relevante en `agents/`, `commands/` o `templates/`.
2. Sube la `version` en `.claude-plugin/plugin.json`.
3. Commit y push.
4. Los consumidores ejecutan `/plugin update crew@factory-crew`. (Las instalaciones autor/local consumen el working tree directamente — basta con hacer pull.)

Para cambios en plantillas, los proyectos existentes deben re-ejecutar `bin/init-project.sh` (que salta los archivos ya existentes) o fusionar la nueva plantilla a mano.

## Mantenimiento

- **Añadir un rol nuevo**: deja un nuevo `agents/<name>.md` (con frontmatter), un nuevo `commands/<alias>.md`, y añade una fila al **área** correspondiente en la tabla de alias de `templates/AGENTS.md` — luego lístalo bajo esa misma área en [`roles.md`](roles.md) (y en su contraparte inglesa `../en/roles.md`). La tabla de alias agrupada en `templates/AGENTS.md` es la fuente de verdad para la asignación de área; el catálogo `roles.md` es su índice. El nombre y el alias deben seguir las [reglas de nombres y alias](#reglas-de-nombres-y-alias) de abajo.
- **Renombrar o retirar un rol**: una decisión de catálogo que pasa por el meta-rol `CREW`, nunca una edición casual. Los alias son un vocabulario compartido; todo cambio de alias sale con un redirect de una versión (ver abajo).
- **Regla específica de stack**: mantenla en el `standards/` o el `AGENTS.md` del proyecto consumidor, nunca en el núcleo universal `templates/standards/code-quality.md`.
- **Editar la documentación**: cada doc humano es bilingüe, con el español como fuente de verdad y el inglés como espejo (ver [idioma canónico](#idioma-canónico) abajo); `templates/docs/guides/delivery-circuit.md` tiene un gemelo en español `delivery-circuit.es.md` que debe moverse con él. Los archivos de rol, el resto de `templates/` y el baseline de sesión quedan en inglés (la capa canónica para la máquina).

## Reglas de nombres y alias

El catálogo de roles — nombres, alias, fusiones, retiros — está bajo custodia del meta-rol `CREW`; todo cambio de catálogo pasa por él.

- **Nombre = función, siempre.** Un rol se nombra por lo que hace (`system-architect`, `qa-test-architect`). Cero nombres en clave.
- **Forma del alias**: 2–5 letras mayúsculas, único en todo el catálogo. Ningún alias puede ser prefijo de otro, y se evitan pares a distancia de edición 1 dentro de la misma área. `DA`/`DEA` es una excepción deliberada, aceptada a conciencia: ambos estaban establecidos, y `DEA` se ganó su lugar con evidencia de casos.
- **Todo cambio de alias sale con redirect.** Un alias renombrado o retirado sigue redirigiendo a su sucesor durante una versión, y luego desaparece.

## Idioma canónico

Una decisión editorial, guiada por la audiencia real de `docs/`: **el español es la fuente de verdad**, el inglés es el espejo — actualizado en el mismo PR, nunca después. La paridad estructural entre los árboles `docs/en/` y `docs/es/` (mismos archivos, mismo esqueleto de secciones) se verifica a través del meta-rol `CREW`, o con un check de CI cuando exista uno.
