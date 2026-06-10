# Stories — Functional work items

Units of user-observable behavior with verifiable acceptance criteria, authored by functional analysis (`FA` role). The functional half of the backlog; [`../requirements/`](../requirements/README.md) is the technical half.

## Structure

```
docs/stories/
└── <feature>/                # kebab-case English
    ├── README.md             # feature context (1 line) + story index + recommended order
    └── NNN-slug.md           # one story; numbering restarts per feature
```

## Lifecycle

```
Draft → Ready → In progress → Delivered → Validated → Closed
```

- **Draft** — being written; may contain open questions.
- **Ready** — criteria complete and unambiguous; an implementer can start without coming back. Stories enter the repo via PR approved by the product owner — that approval is what makes them Ready.
- **In progress** — a dev took it; branch noted in the header.
- **Delivered** — implementation merged; functional validation pending.
- **Validated** — analyst walked the written criteria against actual behavior; per-criterion verdict recorded in the **Validation** section.
- **Closed** — full pass. From here the file is **immutable**; new work is a new story.

Until Closed, the story is editable. Any criteria change after In progress is logged in the **Changes** section with date and reason — the implementer must be able to see the target moved.

## Rules

- The story defines behavior, never technical decisions. If implementation requires a decision with trade-offs, that is an ADR in `decisions/`, linked under Dependencies.
- The tracker (if any) holds only: link to this file, state, assignee. On any discrepancy, **this file wins**.
- The estimation table is mandatory before implementation starts (see [`../AGENTS.md`](../AGENTS.md#estimation-discipline-mandatory)).

## Story template

```markdown
# NNN — Short title

- **Status:** Draft | Ready | In progress | Delivered | Validated | Closed
- **Feature:** <feature> ([README](README.md))
- **Date:** YYYY-MM-DD
- **Branch:** (on In progress: `story/<feature>-NNN-slug`)
- **Depends on:** (stories or ADRs that must land first; "None" if none)

## Narrative

As a (actor), I want (behavior), so that (outcome).

## Acceptance criteria

1. (Observable and verifiable by using the product, without reading code.)
2. ...

## Edge cases

- (Empty states, limits, permissions, error paths the happy path hides.)

## Out of scope

- (What this story deliberately does NOT include.)

## Estimation

| Milestone | Est. hours | Started | Finished | Actual hours | Notes |
|-----------|-----------|---------|----------|--------------|-------|
| | | | | | |

(Filled by the evaluating agent BEFORE implementation; Started/Finished timestamps recorded during execution.)

## Open questions

- (Ambiguity + who owns the answer. Must be empty to reach Ready.)

## Changes

- (Only if criteria change after In progress: date, what, why.)

## Validation

- (On validation: per-criterion verdict — pass/fail + observed behavior in one line.)
```
