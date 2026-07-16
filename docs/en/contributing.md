# Contributing and maintenance

crew-kiro has two layers: native Kiro entry points under `.kiro/`, and canonical role/process sources used by those entry points. Keep one owner and one canonical source for every rule.

## Active structure

```text
crew-kiro/
├── .kiro/
│   ├── steering/             # automatic router + always-on baseline
│   ├── agents/               # 17 native custom-agent wrappers
│   ├── skills/writing/       # native horizontal writing skill
│   └── hooks/                # native Kiro hook definitions
├── agents/                   # canonical authority definitions
├── hooks/
│   ├── kiro-*.js             # Kiro command-hook implementations
│   └── lib/                  # config, ceilings, Kiro payload adapter
├── bin/
│   ├── init-kiro.ps1         # Windows workspace/global installer
│   ├── init-kiro.sh          # Bash workspace/global installer
│   └── metrics.js            # installed report utility
├── templates/                # project-owned scaffold defaults
├── docs/en/ and docs/es/     # mirrored human documentation
└── crew.json                 # example/project policy when present
```

`.claude-plugin/`, `commands/`, `templates/CLAUDE.md`, old non-Kiro hook scripts, and `bin/init-project.sh` are compatibility/reference material, not active Kiro architecture.

## Change a role

Role-catalog changes are governed by the `crew` meta-role. Before adding a role, prove that it owns a distinct, recurring decision, materially changes the answer, and can be routed without an elaborate decision tree. Audiences, one-off tasks, and horizontal crafts are not roles.

A role change is complete only when all affected surfaces move together:

1. `agents/<role>.md` — canonical authority, boundaries, anti-patterns, workflow, response behavior.
2. `.kiro/agents/<role>.md` — precise automatic-delegation description, least-privilege tools, and canonical-definition lookup.
3. `.kiro/steering/crew-roles.md` — owner table, routing trigger, optional alias, and composition implications.
4. `docs/en/roles.md` and `docs/es/roles.md` — human-facing authority catalog.
5. Installers/validation expectations if the number or layout changes.
6. `CHANGELOG.md` and release metadata used by the project.

Names describe functions. Optional aliases are unique 2–5 letter uppercase labels, cannot prefix another alias, and remain secondary to normal-language routing.

## Change routing or baseline behavior

- Keep automatic classification and one-owner rules in `.kiro/steering/crew-roles.md`.
- Keep shared behavior in `.kiro/steering/crew-baseline.md`.
- Do not duplicate either in `AGENTS.md`, role files, or docs.
- Steering applies to the main agent and subagents; hooks do not run inside subagents. Design write flows accordingly.
- The main Kiro agent orchestrates multi-role work. Do not add a universal orchestrator custom agent.

## Change hooks

Hook definitions live in `.kiro/hooks/*.json`; implementations live in `hooks/kiro-*.js`. Shared input normalization belongs in `hooks/lib/kiro-input.js`.

When creating a hook from Kiro, use Kiro's hook creation mechanism/UI rather than hand-authoring the JSON. Hook command scripts must:

- Accept Kiro snake_case and camelCase payload variants where applicable.
- Resolve relative paths against workspace/session context.
- Evaluate resulting content for write/edit/append operations.
- Return standard Kiro allow/deny output.
- Fail open on internal errors.

Global installation must remain hook-free.

## Change installers

`init-kiro.ps1` and `init-kiro.sh` must remain behaviorally equivalent:

- Workspace mode converges crew-managed files and preserves project-owned scaffold plus existing `crew.json`.
- Global mode installs steering, agents, skills, canonical definitions, and utilities only.
- Workspace hooks require Node.js.
- Reruns are idempotent and require a new Kiro session afterward.

Test both first-run and rerun behavior in temporary directories. Never test global installation against a real user home; set a temporary `KIRO_HOME`.

## Documentation

Human documentation is maintained in English and Spanish with structural parity in the same change. Lead with normal-language automatic routing; aliases and explicit agent selection are optional overrides. Keep exact operational commands in installation/usage guides and link to them instead of copying details across every README.

Historical claims may remain in `CHANGELOG.md`, but active guides must not present Claude marketplace, slash commands, manual steering selection, or legacy pre-commit behavior as Kiro features.

## Validation before release

- Parse every `.kiro/hooks/*.json`.
- Validate all custom-agent YAML frontmatter and expected count/names.
- Run `node --check` on Kiro hook scripts and shared libraries.
- Exercise allow/deny hook cases with representative stdin payloads.
- Install team, solo, and temporary-global variants; rerun to verify convergence and preservation.
- Check bilingual links and search active docs for legacy invocation claims.
