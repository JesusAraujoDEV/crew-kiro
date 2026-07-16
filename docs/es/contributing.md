# Contribuir y mantenimiento

crew-kiro tiene dos capas: entradas nativas de Kiro bajo `.kiro/` y fuentes canónicas de roles/proceso consumidas por esas entradas. Mantén un dueño y una fuente canónica por regla.

## Estructura activa

```text
crew-kiro/
├── .kiro/
│   ├── steering/             # router automático + baseline siempre activo
│   ├── agents/               # 17 wrappers de custom agents
│   ├── skills/writing/       # skill horizontal nativa
│   └── hooks/                # definiciones nativas de hooks Kiro
├── agents/                   # definiciones canónicas de autoridad
├── hooks/
│   ├── kiro-*.js             # implementaciones de command hooks
│   └── lib/                  # config, techos, adaptador de payload Kiro
├── bin/
│   ├── init-kiro.ps1         # instalador Windows workspace/global
│   ├── init-kiro.sh          # instalador Bash workspace/global
│   └── metrics.js            # utilidad de reporte instalada
├── templates/                # defaults de scaffold propios del proyecto
├── docs/en/ y docs/es/       # documentación humana en espejo
└── crew.json                 # política de proyecto cuando existe
```

`.claude-plugin/`, `commands/`, `templates/CLAUDE.md`, scripts antiguos no Kiro y `bin/init-project.sh` son compatibilidad/referencia, no arquitectura activa.

## Cambiar un rol

Los cambios de catálogo están gobernados por el meta-rol `crew`. Antes de añadir uno, demuestra que posee una decisión distinta y recurrente, cambia materialmente la respuesta y puede rutearse sin un árbol de decisión complejo. Audiencias, tareas puntuales y oficios horizontales no son roles.

Un cambio queda completo solo cuando se actualizan juntas todas las superficies afectadas:

1. `agents/<rol>.md` — autoridad, límites, anti-patrones, workflow y respuesta canónicos.
2. `.kiro/agents/<rol>.md` — descripción precisa de delegación automática, tools mínimos y lookup canónico.
3. `.kiro/steering/crew-roles.md` — tabla de dueño, trigger, alias opcional e implicaciones de composición.
4. `docs/en/roles.md` y `docs/es/roles.md` — catálogo humano.
5. Instaladores/expectativas de validación si cambia número o layout.
6. `CHANGELOG.md` y metadata de release mantenida por el proyecto.

Los nombres describen funciones. Los aliases opcionales son etiquetas mayúsculas únicas de 2–5 letras, no pueden prefijar otro alias y siguen siendo secundarios frente al lenguaje normal.

## Cambiar routing o baseline

- Mantén clasificación automática y propiedad en `.kiro/steering/crew-roles.md`.
- Mantén comportamiento compartido en `.kiro/steering/crew-baseline.md`.
- No dupliques ninguno en `AGENTS.md`, roles o docs.
- El steering aplica al agente principal y subagents; los hooks no corren dentro de subagents. Diseña las escrituras acorde.
- El agente Kiro principal orquesta el trabajo multirol. No añadas un custom agent orquestador universal.

## Cambiar hooks

Las definiciones viven en `.kiro/hooks/*.json`; las implementaciones en `hooks/kiro-*.js`. La normalización compartida pertenece a `hooks/lib/kiro-input.js`.

Al crear un hook desde Kiro, usa el mecanismo/UI de creación de hooks, no escribas el JSON a mano. Los scripts deben:

- Aceptar variantes snake_case y camelCase cuando corresponda.
- Resolver rutas relativas contra workspace/sesión.
- Evaluar contenido resultante de write/edit/append.
- Devolver salida allow/deny estándar de Kiro.
- Fallar abiertos ante errores internos.

La instalación global debe permanecer sin hooks.

## Cambiar instaladores

`init-kiro.ps1` e `init-kiro.sh` deben conservar paridad:

- Workspace converge archivos administrados y preserva scaffold propio más `crew.json` existente.
- Global instala solo steering, agentes, skills, definiciones canónicas y utilidades.
- Los hooks workspace requieren Node.js.
- Las repeticiones son idempotentes y requieren una sesión Kiro nueva.

Prueba primera instalación y repetición en directorios temporales. Nunca pruebes global contra el home real; define un `KIRO_HOME` temporal.

## Documentación

La documentación humana se mantiene en inglés y español con paridad estructural en el mismo cambio. Empieza por routing automático en lenguaje natural; aliases y selección explícita son overrides. Mantén comandos exactos en instalación/uso y enlázalos en vez de duplicarlos.

`CHANGELOG.md` puede conservar hechos históricos, pero las guías activas no deben presentar marketplace Claude, slash commands, selección manual de steering ni pre-commit legacy como funciones Kiro.

## Validación antes de release

- Parsear todos los `.kiro/hooks/*.json`.
- Validar frontmatter YAML y nombres/cantidad de custom agents.
- Ejecutar `node --check` sobre hooks Kiro y librerías.
- Probar casos allow/deny con payloads stdin representativos.
- Instalar variantes team, solo y global temporal; repetir para verificar convergencia y preservación.
- Comprobar links bilingües y buscar claims legacy en docs activas.
