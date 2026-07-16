# AGENTS.md — {PROJECT_NAME}

> Optional cross-tool project facts template. crew-kiro does not install or depend on this file for Kiro routing. Kiro-native instructions live in `.kiro/steering/`; role routing belongs only in `.kiro/steering/crew-roles.md`.

## Project

{ONE_PARAGRAPH_DESCRIPTION}

Primary specification: [`docs/spec.md`](docs/spec.md).

## Stack

| Layer | Technology |
|---|---|
| {layer} | {technology} |

Locked decisions that should not be reopened without a new decision record:

- {decision}

## Architecture constraints

- {constraint}
- {constraint}

## Folder layout

```text
{paste the actual layout}
```

## Common commands

```powershell
# build
{command}

# test
{command}

# lint/type check
{command}
```

## Project rules

- Canonical code-quality rules: [`standards/code-quality.md`](standards/code-quality.md).
- Architecture decisions: [`docs/decisions/`](docs/decisions/).
- Intentional deviations: [`docs/DEVIATIONS.md`](docs/DEVIATIONS.md).
- Update documentation in the same change when behavior changes.
- Project rules override crew defaults where they conflict.

## Human ownership

| Decision area | Approver |
|---|---|
| Product scope | {name/role} |
| Architecture | {name/role} |
| Security/compliance | {name/role} |
| Release | {name/role} |

Keep this file limited to durable project facts. Do not duplicate the crew role catalog, aliases, automatic-routing protocol, or hook behavior here.
