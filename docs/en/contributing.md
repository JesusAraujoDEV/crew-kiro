# Contributing & maintenance

## Folder structure

```
crew-plugin/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── agents/
│   ├── product-strategist.md
│   ├── functional-analyst.md
│   ├── system-architect.md
│   ├── ... (25 total)
├── commands/
│   ├── prod.md
│   ├── fa.md
│   ├── sys.md
│   ├── ... (25 total)
├── hooks/
│   ├── hooks.json            # registers the two hooks below
│   ├── session-start.js      # SessionStart: inject standards/session-context.md
│   └── guard-immutable.js    # PreToolUse: deny edits to immutable artifacts
├── standards/
│   └── session-context.md    # always-on session baseline (suggestive defaults)
├── templates/
│   ├── AGENTS.md             # canonical agent context (precedence, ownership map, interop)
│   ├── CLAUDE.md             # thin @AGENTS.md pointer
│   ├── standards/
│   │   └── code-quality.md   # universal core (suggestive; project rules win)
│   └── docs/                 # taxonomy seeded into consumer projects
├── bin/
│   └── init-project.sh
├── docs/                     # this plugin's own documentation
│   ├── en/                   # English sub-docs (roles, install, usage, contributing)
│   └── es/                   # Spanish (full README + sub-docs)
├── LICENSE
└── README.md                 # canonical English README (ES → docs/es/README.md)
```

## Updating the plugin

Roles and templates evolve. To propagate changes to consumers:

1. Edit the relevant file in `agents/`, `commands/`, or `templates/`.
2. Bump `version` in `.claude-plugin/plugin.json`.
3. Commit and push.
4. Consumers run `/plugin update crew@factory-crew`. (Author/local-dev installs consume the working tree directly — just pull.)

For template changes, existing projects must re-run `bin/init-project.sh` (which skips existing files) or merge the new template manually.

## Maintenance

- **Adding a new role**: drop a new `agents/<name>.md` (with frontmatter), a new `commands/<alias>.md`, and add a row to the matching **area** in the `templates/AGENTS.md` alias table — then list it under that same area in [`roles.md`](roles.md) (and its Spanish counterpart in `../es/roles.md`). The grouped alias table in `templates/AGENTS.md` is the source of truth for area assignment; the `roles.md` catalog is its index. Keep the role count consistent across the README flow table, both `roles.md` files, and the folder tree above.
- **Renaming a role**: don't. Aliases are a shared vocabulary; renaming breaks all downstream projects.
- **Stack-specific rule**: keep it in the consumer project's own `standards/` or `AGENTS.md`, never in the universal `templates/standards/code-quality.md` core.
- **Editing the docs**: every human doc is bilingual — update both `docs/en/` and `docs/es/` in the same change, and `templates/docs/guides/delivery-circuit.md` has a Spanish twin `delivery-circuit.es.md` that must move with it. The agent role files, the rest of `templates/`, and the session baseline stay English (the canonical machine layer).
