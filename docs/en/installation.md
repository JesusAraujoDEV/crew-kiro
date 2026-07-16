# Installation

crew-kiro is installed by copying Kiro-native steering, custom agents, skills, and—at workspace scope—hooks into the paths Kiro reads. There is no marketplace, plugin manager, or slash-command registration step.

## Prerequisites

- A local clone of this repository.
- Kiro IDE.
- Windows PowerShell, or Bash on macOS/Linux.
- `node` on `PATH` for workspace installation. Global installation does not install hooks and does not require Node at install time.
- An existing target directory. The installer does not create the target root.

## Choose a scope

Use **workspace** scope when a repository should carry its own routing, hooks, process policy, and portable behavior for the team. Use **global** scope when you want automatic routing and custom agents in every Kiro workspace without imposing hooks or project files.

Workspace rules take precedence when both scopes are installed.

## Workspace installation (recommended)

### Windows

```powershell
& "C:\path\to\crew-kiro\bin\init-kiro.ps1" -Target "C:\path\to\project"

# Minimal project process
& "C:\path\to\crew-kiro\bin\init-kiro.ps1" -Solo -Target "C:\path\to\project"
```

If `-Target` is omitted, the current directory is used.

### macOS/Linux

```bash
bash /path/to/crew-kiro/bin/init-kiro.sh --target /path/to/project
bash /path/to/crew-kiro/bin/init-kiro.sh --solo --target /path/to/project
```

If `--target` is omitted, the current directory is used.

The installer writes or updates crew-managed assets:

- `.kiro/steering/crew-baseline.md` and `crew-roles.md`
- `.kiro/agents/*.md`
- `.kiro/skills/writing/SKILL.md`
- `.kiro/hooks/*.json`
- `.kiro/crew/agents/*.md` and `.kiro/crew/bin/metrics.js`
- `hooks/kiro-*.js` and their required `hooks/lib/*.js`

It creates project-owned scaffold files only when absent. It also creates `crew.json` only when absent. Reruns preserve existing project documentation and configuration while converging crew-managed files to the installed version.

`team` installs the full documentation scaffold. `solo` installs the minimal decisions/work/quality structure. If a project already has `crew.json`, `-Solo`/`--solo` does not rewrite it; edit its `mode` explicitly.

## Global installation

### Windows

```powershell
& "C:\path\to\crew-kiro\bin\init-kiro.ps1" -Global
```

### macOS/Linux

```bash
bash /path/to/crew-kiro/bin/init-kiro.sh --global
```

The destination is `$env:KIRO_HOME` when set, otherwise `$HOME/.kiro` on PowerShell; Bash uses `$KIRO_HOME` or `$HOME/.kiro`. Global installation synchronizes:

- `steering/crew-baseline.md` and `steering/crew-roles.md`
- `agents/*.md`
- `skills/writing/SKILL.md`
- `crew/agents/*.md` and `crew/bin/metrics.js`

It does not install hooks, `crew.json`, or project documentation. `-Solo`/`--solo` has no meaning at global scope.

## Restart and verify

Start a **new Kiro session** after installation; existing sessions may retain the previous steering and agent catalog.

Verify the filesystem first:

```powershell
Test-Path "C:\path\to\project\.kiro\steering\crew-roles.md"
(Get-ChildItem "C:\path\to\project\.kiro\agents" -Filter *.md).Count
```

A complete installation contains 17 custom-agent files. Then ask an ordinary, unprefixed request such as:

```text
Review this authorization design and identify any tenant-isolation risks.
```

Kiro should route the request using the security authority without requiring you to select it. Explicit agent selection or `SEC:` is only a diagnostic/override path, not normal usage.

## Update

Pull the latest repository changes and rerun the same installer command. Crew-managed files are replaced with the current versions; project-owned scaffold and an existing `crew.json` are preserved.

Review the diff after updating. Global installation can replace same-named files under the managed paths, so do not keep unrelated customizations in crew-owned files.

## Remove

There is no destructive automatic uninstaller. Review and remove only crew-managed paths.

For a workspace, remove the two crew steering files, the 17 crew agent files, the writing skill, the five crew hook JSON files, `.kiro/crew/`, and `hooks/kiro-*.js` plus `hooks/lib/kiro-input.js` if nothing else uses it. Keep or remove `crew.json`, `standards/`, and `docs/` separately: they are project-owned.

For a global install, remove `~/.kiro/steering/crew-baseline.md`, `crew-roles.md`, the crew agent files under `~/.kiro/agents/`, `~/.kiro/skills/writing/`, and `~/.kiro/crew/`. Review each path first if you had same-named files before installation.

Start a new Kiro session after removal.

## Troubleshooting

- **“Target path does not exist.”** Create the project directory first or pass an existing path.
- **“Node.js … was not found on PATH.”** Install Node.js or use global scope; workspace hooks require it.
- **Installer refuses the target.** The source repository cannot install into itself. Choose another workspace or use global scope.
- **Old behavior remains.** Start a new Kiro session. Steering and custom-agent discovery are session-scoped.
- **Hooks do not run globally.** Expected: global installation deliberately excludes hooks.
- **`-Solo` did not change an existing project.** Expected: `crew.json` is project-owned and preserved. Edit `"mode"` manually.
- **A custom agent cannot find its role definition.** Confirm `.kiro/crew/agents/<role>.md` exists for workspace scope or `~/.kiro/crew/agents/<role>.md` for global scope.

## Kiro references

- [Custom agents](https://kiro.dev/docs/custom-agents/)
- [Subagents](https://kiro.dev/docs/chat/subagents/)
- [Steering](https://kiro.dev/docs/steering/)
- [Hooks](https://kiro.dev/docs/hooks/)
