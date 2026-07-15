---
description: "Retired alias — use /crew:qa (qa-test-architect)"
argument-hint: <task>
---

This alias was retired in the catalog consolidation (25 → 17 roles). spec-compliance is now the verdict mode of qa-test-architect: "is it well tested?" and "does it match the spec?" are one conversation.

Tell the user in one line: `SC → use /crew:qa (qa-test-architect)`. Then, if a task was given, proceed with it as qa-test-architect would — spawn that subagent (or apply that skill) so the user is not left at a dead end.

Task: $ARGUMENTS
