# Deprecated — Claude Code slash commands

These command files are the **Claude Code slash command format** (`/crew:<alias>`). They are NOT used by Kiro IDE.

In Kiro, roles are invoked via:
1. `#` in chat → select the role steering file (e.g. `#system-architect`)
2. Alias prefix in messages (e.g. `SYS: design the auth layer`)
3. Full role name prefix (e.g. `System Architect: ...`)

The Kiro-native steering files live in `.kiro/steering/agents/`.
