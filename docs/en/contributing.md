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
│   ├── ...                   # one file per role
├── commands/
│   ├── prod.md
│   ├── fa.md
│   ├── sys.md
│   ├── ...                   # one file per alias
├── hooks/
│   ├── hooks.json            # registers the plugin hooks
│   ├── session-start.js      # SessionStart: inject standards/session-context.md
│   ├── guard-immutable.js    # PreToolUse: deny edits to immutable artifacts
│   ├── guard-estimation.js   # PreToolUse: estimation table complete before close
│   ├── guard-timestamps.js   # PreToolUse: real-time Started/Finished cells (metrics)
│   ├── guard-code-quality.js # PreToolUse: code-quality ceilings (advise/enforce)
│   └── check-work-log.js     # Stop: session closure check
├── standards/
│   └── session-context.md    # always-on session baseline (suggestive defaults)
├── templates/
│   ├── AGENTS.md             # canonical agent context (precedence, ownership map, interop)
│   ├── CLAUDE.md             # thin @AGENTS.md pointer
│   ├── standards/
│   │   └── code-quality.md   # universal core (suggestive; project rules win)
│   └── docs/                 # taxonomy seeded into consumer projects
├── bin/
│   ├── init-project.sh       # scaffold + crew.json (team / --solo)
│   ├── metrics.js            # /crew:metrics report
│   ├── check-quality.sh      # pre-commit quality gate (installed by init)
│   └── check-staged.js
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

- **Adding a new role**: drop a new `agents/<name>.md` (with frontmatter), a new `commands/<alias>.md`, and add a row to the matching **area** in the `templates/AGENTS.md` alias table — then list it under that same area in [`roles.md`](roles.md) (and its Spanish counterpart in `../es/roles.md`). The grouped alias table in `templates/AGENTS.md` is the source of truth for area assignment; the `roles.md` catalog is its index. Name and alias must follow the [naming and alias rules](#naming-and-alias-rules) below.
- **Renaming or retiring a role**: a catalog decision that goes through the `CREW` meta-role, never a casual edit. Aliases are a shared vocabulary; any alias change ships with a one-version redirect (see below).
- **Stack-specific rule**: keep it in the consumer project's own `standards/` or `AGENTS.md`, never in the universal `templates/standards/code-quality.md` core.
- **Editing the docs**: every human doc is bilingual, with Spanish as the source of truth and English as the mirror (see [canonical language](#canonical-language) below); `templates/docs/guides/delivery-circuit.md` has a Spanish twin `delivery-circuit.es.md` that must move with it. The agent role files, the rest of `templates/`, and the session baseline stay English (the canonical machine layer).

## Naming and alias rules

The role catalog — names, aliases, merges, retirements — is custodied by the `CREW` meta-role; every catalog change goes through it.

- **Name = function, always.** A role is named for what it does (`system-architect`, `qa-test-architect`). Zero codenames.
- **Alias shape**: 2–5 uppercase letters, unique across the catalog. No alias may be a prefix of another, and avoid edit-distance-1 pairs within the same area. `DA`/`DEA` is a deliberate exception, accepted with eyes open: both were established, and `DEA` earned its place with case evidence.
- **Alias changes ship with a redirect.** A renamed or retired alias keeps redirecting to its successor for one version, then disappears.

## Canonical language

An editorial decision, driven by the real audience of `docs/`: **Spanish is the source of truth**, English is the mirror — updated in the same PR, never later. Structural parity between the `docs/en/` and `docs/es/` trees (same files, same section skeleton) is verified through the `CREW` meta-role, or by a CI check once one exists.
