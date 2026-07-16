# Instalación

crew-kiro se instala copiando steering, custom agents, skills y—en alcance workspace—hooks nativos a las rutas que Kiro lee. No hay marketplace, gestor de plugins ni registro de slash commands.

## Requisitos

- Un clon local de este repositorio.
- Kiro IDE.
- PowerShell en Windows o Bash en macOS/Linux.
- `node` en `PATH` para instalar por workspace. La instalación global no instala hooks y no necesita Node durante la instalación.
- Un directorio destino existente. El instalador no crea la raíz del proyecto.

## Elegir alcance

Usa **workspace** cuando el repositorio deba llevar su propio routing, hooks, política de proceso y comportamiento portable para el equipo. Usa **global** para tener routing automático y custom agents en todos tus workspaces sin imponer hooks ni archivos de proyecto.

Las reglas del workspace tienen precedencia cuando ambos alcances están instalados.

## Instalación por workspace (recomendada)

### Windows

```powershell
& "C:\ruta\a\crew-kiro\bin\init-kiro.ps1" -Target "C:\ruta\al\proyecto"

# Proceso mínimo
& "C:\ruta\a\crew-kiro\bin\init-kiro.ps1" -Solo -Target "C:\ruta\al\proyecto"
```

Sin `-Target`, usa el directorio actual.

### macOS/Linux

```bash
bash /ruta/a/crew-kiro/bin/init-kiro.sh --target /ruta/al/proyecto
bash /ruta/a/crew-kiro/bin/init-kiro.sh --solo --target /ruta/al/proyecto
```

Sin `--target`, usa el directorio actual.

El instalador escribe o actualiza los assets administrados por crew:

- `.kiro/steering/crew-baseline.md` y `crew-roles.md`
- `.kiro/agents/*.md`
- `.kiro/skills/writing/SKILL.md`
- `.kiro/hooks/*.json`
- `.kiro/crew/agents/*.md` y `.kiro/crew/bin/metrics.js`
- `hooks/kiro-*.js` y los `hooks/lib/*.js` requeridos

Solo crea archivos de scaffold propios del proyecto cuando faltan. También crea `crew.json` únicamente si no existe. Al repetir la instalación conserva la documentación y configuración del proyecto, mientras converge los archivos administrados a la versión instalada.

`team` instala el scaffold documental completo. `solo` instala la estructura mínima de decisiones, historial y calidad. Si ya existe `crew.json`, `-Solo`/`--solo` no lo modifica; edita su `mode` explícitamente.

## Instalación global

### Windows

```powershell
& "C:\ruta\a\crew-kiro\bin\init-kiro.ps1" -Global
```

### macOS/Linux

```bash
bash /ruta/a/crew-kiro/bin/init-kiro.sh --global
```

El destino es `$env:KIRO_HOME` si está definido o `$HOME/.kiro` en PowerShell; Bash usa `$KIRO_HOME` o `$HOME/.kiro`. La instalación global sincroniza:

- `steering/crew-baseline.md` y `steering/crew-roles.md`
- `agents/*.md`
- `skills/writing/SKILL.md`
- `crew/agents/*.md` y `crew/bin/metrics.js`

No instala hooks, `crew.json` ni documentación de proyecto. `-Solo`/`--solo` no tiene efecto global.

## Reiniciar y verificar

Inicia una **sesión nueva de Kiro** después de instalar; una sesión existente puede conservar el steering y catálogo anteriores.

Primero verifica el filesystem:

```powershell
Test-Path "C:\ruta\al\proyecto\.kiro\steering\crew-roles.md"
(Get-ChildItem "C:\ruta\al\proyecto\.kiro\agents" -Filter *.md).Count
```

Una instalación completa contiene 17 archivos de custom agents. Después haz una solicitud normal, sin prefijo:

```text
Revisa este diseño de autorización e identifica riesgos de aislamiento entre tenants.
```

Kiro debe rutearla con la autoridad de seguridad sin pedirte que la selecciones. Elegir el agente explícitamente o escribir `SEC:` sirve como diagnóstico/override, no como uso normal.

## Actualizar

Trae los últimos cambios del repositorio y repite el mismo comando de instalación. Los archivos administrados se reemplazan por la versión actual; el scaffold propio del proyecto y un `crew.json` existente se conservan.

Revisa el diff después de actualizar. La instalación global puede reemplazar archivos con el mismo nombre dentro de sus rutas administradas; no guardes personalizaciones ajenas a crew en esos archivos.

## Quitar

No hay un desinstalador destructivo automático. Revisa y elimina solo rutas administradas por crew.

En un workspace, elimina los dos steering files de crew, los 17 agentes, la skill de escritura, los cinco JSON de hooks, `.kiro/crew/`, y `hooks/kiro-*.js` más `hooks/lib/kiro-input.js` si nada más lo usa. Conserva o elimina por separado `crew.json`, `standards/` y `docs/`: son propiedad del proyecto.

En una instalación global, elimina `~/.kiro/steering/crew-baseline.md`, `crew-roles.md`, los agentes crew bajo `~/.kiro/agents/`, `~/.kiro/skills/writing/` y `~/.kiro/crew/`. Revisa cada ruta si ya tenías archivos con esos nombres.

Inicia una sesión nueva de Kiro después de quitarlo.

## Solución de problemas

- **La ruta destino no existe.** Crea el directorio primero o pasa una ruta existente.
- **No encuentra Node.js en `PATH`.** Instala Node.js o usa alcance global; los hooks de workspace lo requieren.
- **El instalador rechaza el destino.** El repositorio fuente no puede instalarse sobre sí mismo. Usa otro workspace o alcance global.
- **Sigue el comportamiento anterior.** Inicia una sesión nueva de Kiro.
- **Los hooks no corren globalmente.** Es intencional: el alcance global excluye hooks.
- **`-Solo` no cambió un proyecto existente.** Es intencional: `crew.json` pertenece al proyecto y se conserva. Edita `"mode"` manualmente.
- **Un custom agent no encuentra su definición.** Confirma `.kiro/crew/agents/<rol>.md` en workspace o `~/.kiro/crew/agents/<rol>.md` en global.

## Referencias de Kiro

- [Custom agents](https://kiro.dev/docs/custom-agents/)
- [Subagents](https://kiro.dev/docs/chat/subagents/)
- [Steering](https://kiro.dev/docs/steering/)
- [Hooks](https://kiro.dev/docs/hooks/)
