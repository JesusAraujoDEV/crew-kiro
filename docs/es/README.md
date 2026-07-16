# crew-kiro

> **Español** · [Read in English](../../README.md)

Instala una vez y habla con normalidad. **crew-kiro** da a Kiro un catálogo gobernado de 17 roles especialistas y permite que Kiro elija automáticamente la autoridad correcta para cada solicitud. No necesitas slash commands, prefijos ni seleccionar steering files a mano.

Cada decisión tiene un solo dueño. Cuando una solicitud cruza límites, Kiro puede consultar varios especialistas, pero el agente principal conserva la responsabilidad de secuenciar sus aportes y entregar una respuesta coherente.

## Inicio rápido

Clona este repositorio y elige un alcance.

### Este workspace (recomendado)

```powershell
# Windows
& "C:\ruta\a\crew-kiro\bin\init-kiro.ps1" -Target "C:\ruta\al\proyecto"

# Proceso mínimo para una persona
& "C:\ruta\a\crew-kiro\bin\init-kiro.ps1" -Solo -Target "C:\ruta\al\proyecto"
```

```bash
# macOS / Linux
bash /ruta/a/crew-kiro/bin/init-kiro.sh --target /ruta/al/proyecto
bash /ruta/a/crew-kiro/bin/init-kiro.sh --solo --target /ruta/al/proyecto
```

La instalación por workspace requiere `node` en `PATH`, porque los hooks de Kiro ejecutan scripts Node.js.

### Todos los workspaces del usuario

```powershell
& "C:\ruta\a\crew-kiro\bin\init-kiro.ps1" -Global
```

```bash
bash /ruta/a/crew-kiro/bin/init-kiro.sh --global
```

La instalación global aporta routing, custom agents, definiciones de roles, skill de escritura y utilidad de métricas. Deliberadamente **no** instala hooks ni proceso de proyecto en todos los repositorios.

Después de instalar, inicia una **sesión nueva de Kiro** y pide el trabajo en lenguaje normal:

```text
Diseña el límite de autorización para administradores de tenant.
Planifica la pantalla de onboarding e impleméntala de forma accesible.
Define eventos y un funnel para la activación del trial.
```

Kiro clasifica la decisión, aplica el rol dueño y delega solo cuando hace falta una autoridad distinta. `SYS:`, `UX:`, nombres completos y la selección explícita de agente siguen disponibles como overrides opcionales.

## Documentación

| Si quieres… | Lee |
|---|---|
| Instalar, actualizar, verificar o quitar | [Instalación](installation.md) |
| Usar routing automático, modos y overrides | [Usar crew](using-crew.md) |
| Conocer la autoridad de cada rol | [Roles](roles.md) |
| Configurar `crew.json` | [Configuración](configuration.md) |
| Resolver un aviso o bloqueo de hook | [Enforcement](enforcement.md) |
| Generar y leer métricas | [Métricas](metrics.md) |
| Empezar con proceso mínimo | [Quickstart solo](solo-quickstart.md) |
| Usar crew desde un rol no técnico | [Roles no técnicos](non-technical-roles.md) |
| Contribuir al catálogo | [Contribuir](contributing.md) |

## Material heredado

`.claude-plugin/`, `commands/`, `templates/CLAUDE.md` y `bin/init-project.sh` se conservan solo como compatibilidad o referencia del proyecto original. La instalación Kiro y la documentación activa no dependen de ellos.

## Licencia

MIT.
