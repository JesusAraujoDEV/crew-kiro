# Using crew

How to invoke the roles, scaffold a new project, and onboard an existing one. For the end-to-end process the roles follow, see the [delivery circuit](../../templates/docs/guides/delivery-circuit.md).

## Bootstrap a new project

From the root of the new (empty) project:

```bash
bash C:/w/crew-plugin/bin/init-project.sh
```

This drops in `AGENTS.md`, `CLAUDE.md`, the `.cursor/rules/` baseline, and the full `docs/` taxonomy (stories, requirements, decisions, proposals, guides, work, DEVIATIONS). Existing files are preserved (skipped, not overwritten).

Then:

1. Edit `AGENTS.md` — fill in `{PROJECT_NAME}`, stack table, folder layout, and commands.
2. Write `docs/spec.md` with the project's technical spec.
3. Pick stack-specific rules from `templates/.cursor/rules-stack-examples/` (Tauri+React, Rust, Node sidecar) and copy the relevant ones into `.cursor/rules/`.
4. [Install the plugin](installation.md) so `/crew:sys`, `/crew:ux`, etc. are available.

## Onboard an existing project

Do **not** scaffold over a project that already has docs and conventions. The entry point is the audit:

```
/crew:doc audit this project's docs against the crew standard
```

The documentation-steward inventories the project against the plugin taxonomy, reports aligned/deviated/missing findings, and you decide per finding: converge (becomes a story/requirement) or keep the deviation. Kept deviations are recorded in `docs/DEVIATIONS.md` and the precedence resolution is written into the project's root `AGENTS.md` — binding for all agents, never re-litigated per session. The plugin baseline is suggestive; the project's own rules always win.

## Invoking a role

### Slash command

```
/crew:sys add an IPC command for spawning a process with custom env vars
```

Spawns the `system-architect` subagent. It reads its role doc, restricts itself to the role's authority, and returns the canonical deliverable (in this case: an architectural spec).

### Alias prefix (interpreted by AGENTS.md)

```
SYS: add an IPC command for spawning a process with custom env vars
UX: redesign the process panel for the "All" view
LEA: where is the workspace detection implemented?
```

The project's `AGENTS.md` instructs the main agent to honor the prefix and either spawn the subagent or read the role doc and adopt its constraints.

## Composition rules

From `agents/` (each role doc):

- One owner per decision.
- Specs before code. Roles can search and edit code, but implement only after the direction converges or the user explicitly asks — never as the first response. `researcher` is the exception: strictly read-only.
- `security-compliance` may interrupt any role.
- `researcher` returns findings, never recommendations.
- Roles know the full catalog. The "Role relationships" section in each role doc lists **typical** handoffs and consults; any role may invoke any other when the situation warrants it.
- **Consult, don't defer.** When a complete answer needs another role's judgment, the agent obtains it now (spawn or lens-adoption) and answers in the same turn — never closes with "review this with ROLE".
- **Chaining policy.** After a deliverable, the next role chains in-session only if its human owner (per the project's `AGENTS.md` § Role ownership map) is the session user; otherwise the work stops at the artifact and awaits that human's approval.
- **Estimation discipline.** Every story/requirement embeds a milestone estimation table (estimated vs. actual hours), filled before implementation — this is how teams measure the cost of each agentic iteration.
