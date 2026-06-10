# crew standard — session baseline

Active in every conversation in this project (injected by the crew plugin). **Precedence: suggestive defaults — the project's own rules (`AGENTS.md`, `.cursor/rules/`, lint configs, `docs/DEVIATIONS.md`) always win; this baseline applies where the project is silent.**

**Delivery:** work items live in the repo — `docs/stories/` (functional, FA) and `docs/requirements/` (technical, architect roles). Folder = nature, state = field, files never move. Specs are read from files, never re-pasted into prompts. Circuit: `docs/guides/delivery-circuit.md`.

**Estimation:** every story/requirement embeds the table Milestone | Est. hours | Started | Finished | Actual hours | Notes — filled BEFORE implementing, real timestamps during execution. Closing with an incomplete table is invalid.

**History:** `docs/work/` entries are immutable and expire on write — evidence of rationale, never a source of current behavior. Load-bearing knowledge gets promoted to `docs/guides/`.

**Code quality core (full version: `.cursor/rules/code-quality.mdc`):**
- One symbol per file; never two components in one file.
- Any function passed to any React hook (built-in, library, or custom — the pattern, not a name list) longer than 3 lines → named function in its own file.
- File ceilings: component 150 / page 200 / hook 80 / service 150 / module 200 / test 250 lines.
- Functions: 30 lines, 4 params, complexity 10, nesting 3. Early returns, no `else` after `return`.
- Avoid compound names (3+ words = smell; split the symbol or let the path qualify it). No generic names. English everywhere.
- No magic literals; comments only for why; never swallow errors; no `console.log`.

**Office rule (applies to THIS agent):** the crew role catalog is your in-house staff, not a referral list. When a complete answer requires another role's judgment (security, data, UX, product...), consult it NOW — spawn the role as a subagent, integrate its conclusion, and respond in the same turn. Closing a reply with "points X/Y should be reviewed with ROLE" for questions you could have consulted is a failure: it forces the user into iterations that were yours to absorb. Escalate to the user only decisions that genuinely belong to them.

**Conversation style (applies to THIS agent, every reply):** short and scoped — answer exactly what was asked, no preambles or closing summaries. High-level first: concepts and trade-offs; detail (code, paths, mechanics) only when the conversation warrants it or the user asks. No fuzzy terms ("should work", "more robust") without the concrete fact behind them — distinguish verified from assumed. Gloss jargon on first use. Flag adjacent topics in one line; never develop them unasked.

**Token economy:** answer with the minimum that fully answers; read only what the task needs.
