# Deprecated — Claude Code plugin format

These files are the **original Claude Code plugin format** preserved for reference and backward compatibility. They are NOT used by Kiro IDE.

The active Kiro-native equivalents are:

| Claude Code | Kiro equivalent |
|-------------|-----------------|
| `.claude-plugin/plugin.json` | Not needed — Kiro uses `.kiro/` directly |
| `.claude-plugin/marketplace.json` | Not needed |
| `commands/*.md` (slash commands) | `.kiro/steering/agents/*.md` (manual steering files, invoke via `#`) |
| `hooks/hooks.json` | `.kiro/hooks/*.json` (one JSON file per hook) |
| `hooks/*.js` (Claude format) | `hooks/kiro-*.js` (Kiro stdin format) |
| `standards/session-context.md` (injected by SessionStart hook) | `.kiro/steering/crew-baseline.md` (inclusion: auto) |

For the Claude Code version of this project, see [crew-plugin](https://github.com/jircdev/crew-plugin).
