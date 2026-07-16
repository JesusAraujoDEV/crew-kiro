# Deprecated — Claude Code slash commands

These files preserve the original `/crew:<alias>` command format and are not used by Kiro.

Kiro-native behavior is automatic:

1. `.kiro/steering/crew-roles.md` classifies ordinary requests and assigns one owning authority.
2. Kiro may invoke the matching custom subagent from `.kiro/agents/` when isolated delegation adds value.
3. The main Kiro agent integrates multi-role work.

Aliases such as `SYS:` and explicit custom-agent selection remain optional overrides. They are not required for installation or normal usage. Canonical role definitions live in `agents/` and are installed under `.kiro/crew/agents/` or `~/.kiro/crew/agents/`.
