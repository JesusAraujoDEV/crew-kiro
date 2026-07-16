// PreToolUse hook for Kiro IDE: protect immutable artifacts (docs/work/ entries
// and closed work items). Pure path/content check on write tool calls.
//
// Kiro stdin JSON shape:
//   { tool_name, tool_input: { path, ... }, cwd, ... }
//
// Modes (crew.json): docs/work/ immutability holds in both modes;
// Closed-item immutability is team-only.
const { readFileSync, existsSync } = require("node:fs");
const { configFor } = require("./lib/config");

function deny(reason) {
  process.stdout.write(
    JSON.stringify({
      hookSpecificOutput: {
        permissionDecision: "deny",
        permissionDecisionReason: reason + " [See: docs/en/enforcement.md]",
      },
    }),
  );
  process.exit(0);
}

function resolveFilePath(input) {
  return input.tool_input && (input.tool_input.path || input.tool_input.targetFile || "");
}

function isClosedWorkItem(path) {
  const inBacklog = /docs[\\/](stories|requirements)[\\/].+\.md$/i.test(path);
  if (!inBacklog || !existsSync(path)) return false;
  const header = readFileSync(path, "utf8").slice(0, 600);
  return /\*\*(Status|Estado):\*\*\s*(Closed|Cerrada)\b/i.test(header);
}

try {
  const raw = readFileSync(0, "utf8").replace(/^\uFEFF/, "");
  const input = JSON.parse(raw);

  const toolName = input.tool_name || "";
  if (!["fs_write", "str_replace", "fs_append"].includes(toolName)) process.exit(0);

  const path = resolveFilePath(input);
  if (!path) process.exit(0);

  const isWorkEntry = /docs[\\/]work[\\/]\d{4}-\d{2}[\\/].+\.md$/i.test(path);
  if (isWorkEntry && existsSync(path)) {
    deny(
      "docs/work/ entries are immutable once created (crew standard). Write a new entry referencing this one instead.",
    );
  }

  const cfg = configFor(path, input.cwd);
  if (cfg && cfg.mode === "solo") process.exit(0);

  if (isClosedWorkItem(path)) {
    deny(
      "This work item is Closed and therefore immutable (crew standard). New work is a new story/requirement.",
    );
  }
} catch {
  // Fail open: a guard bug must never block legitimate work.
}
process.exit(0);
