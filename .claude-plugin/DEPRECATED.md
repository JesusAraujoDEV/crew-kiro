# Deprecated — Claude Code plugin format

This directory preserves metadata from the original Claude Code plugin for historical reference. Kiro does not read or install it.

Active Kiro-native surfaces are:

| Concern | Kiro location |
|---|---|
| Automatic routing and authority | `.kiro/steering/crew-roles.md` |
| Always-on behavior | `.kiro/steering/crew-baseline.md` |
| Native custom subagents | `.kiro/agents/*.md` |
| Canonical role definitions | `agents/*.md` (installed under `.kiro/crew/agents/` or `~/.kiro/crew/agents/`) |
| Native skill | `.kiro/skills/writing/SKILL.md` |
| Workspace hooks | `.kiro/hooks/*.json` + `hooks/kiro-*.js` |
| Installation | `bin/init-kiro.ps1` or `bin/init-kiro.sh` |

Normal Kiro usage is automatic: users ask in ordinary language and Kiro chooses the relevant authority. No Claude marketplace or slash-command registration is involved.

For the original Claude Code project, see [crew-plugin](https://github.com/jircdev/crew-plugin).
