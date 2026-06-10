# Changelog

All notable changes to the crew plugin. Format: [Keep a Changelog](https://keepachangelog.com).

## [0.9.0] — 2026-06-10

First publishable version.

### Added

- 20 role subagents (`agents/`) + 20 `/crew:<alias>` slash commands, conversational by default; deliverables only on explicit request. Caps per role: exact scope, short format, max 2 open questions, jargon glossing, token economy, no premature handoffs, consult-don't-defer.
- `functional-analyst` role (`/crew:fa`): requirements → stories with acceptance criteria → functional validation.
- Full `docs/` taxonomy templates: `stories/`, `requirements/`, `decisions/` (state-in-file, no pending folder), `proposals/`, `guides/delivery-circuit.md`, `work/` (evidence-never-truth contract), `DEVIATIONS.md`.
- Delivery circuit standard with chaining policy and role ownership map.
- Mandatory estimation tables (milestones, estimated vs. actual hours) embedded in work items.
- `SessionStart` hook: injects `standards/session-context.md` baseline into every session.
- `PreToolUse` hook: denies edits to existing `docs/work/` entries and Closed work items; fails open.
- Universal code-quality core (`templates/.cursor/rules/code-quality.mdc`) as suggestive defaults; project rules take precedence.
- Interop contract: `AGENTS.md` (open standard) as canonical agent context; `CLAUDE.md` as `@AGENTS.md` pointer.
- Documentation-steward audit protocol for onboarding existing projects (findings → owner decides → DEVIATIONS + precedence written into AGENTS.md).
- Roles inherit all tools (search/edit code) gated by specs-before-code; `researcher` stays read-only.
