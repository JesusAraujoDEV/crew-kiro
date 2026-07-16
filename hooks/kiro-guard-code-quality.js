// PreToolUse hook for Kiro IDE: code-quality file-size ceiling gate on
// fs_write|str_replace|fs_append. Adapts the crew guard to Kiro's stdin format.
//
// Kiro stdin JSON shape:
//   { tool_name, tool_input: { path, oldStr, newStr, text, ... }, cwd, ... }
//
// Exit codes:
//   0 with permissionDecision JSON → allow/deny/ask
//   0 without output → allow (silent)
//   2 → block (stderr forwarded)
//
// Quality modes (crew.json "quality"):
//   advise  — write proceeds, agent sees notice
//   enforce — deny at write time
//   off     — silent
const { readFileSync, existsSync } = require("node:fs");
const { dirname } = require("node:path");
const { configFor } = require("./lib/config");
const { violation, isExempt, findRoot } = require("./lib/ceilings");

function respond(decision, reason) {
  process.stdout.write(
    JSON.stringify({
      hookSpecificOutput: {
        permissionDecision: decision,
        permissionDecisionReason: reason + (decision === "deny" ? " [See: docs/en/enforcement.md]" : ""),
      },
    }),
  );
  process.exit(0);
}

function resolveFilePath(input) {
  // Kiro tools use "path" for fs_write/fs_append, and "path" for str_replace
  return input.tool_input && (input.tool_input.path || input.tool_input.targetFile || "");
}

function resultingContent(input, path) {
  const toolName = input.tool_name || "";

  if (toolName === "fs_write") {
    return input.tool_input.text || "";
  }

  if (toolName === "fs_append") {
    if (!existsSync(path)) return input.tool_input.text || "";
    const current = readFileSync(path, "utf8");
    return current + "\n" + (input.tool_input.text || "");
  }

  if (toolName === "str_replace") {
    if (!existsSync(path)) return "";
    const current = readFileSync(path, "utf8");
    const oldStr = input.tool_input.oldStr || "";
    const newStr = input.tool_input.newStr || "";
    if (!oldStr || !current.includes(oldStr)) return "";
    return input.tool_input.replace_all
      ? current.split(oldStr).join(newStr)
      : current.replace(oldStr, newStr);
  }

  return "";
}

try {
  const raw = readFileSync(0, "utf8").replace(/^\uFEFF/, "");
  const input = JSON.parse(raw);

  const toolName = input.tool_name || "";
  if (!["fs_write", "str_replace", "fs_append"].includes(toolName)) process.exit(0);

  const path = resolveFilePath(input);
  if (!path) process.exit(0);

  const cfg = configFor(path, input.cwd);
  const quality = cfg ? cfg.quality : "enforce";
  if (quality === "off") process.exit(0);

  const content = resultingContent(input, path);
  if (!content) process.exit(0);

  const v = violation(path, content, cfg && cfg.ceilings);
  if (!v) process.exit(0);

  const root = findRoot(dirname(path));
  if (root && isExempt(root, path)) process.exit(0);

  const detail =
    `This file would be ${v.lines} lines; the crew ceiling for a ${v.kind} file is ${v.ceiling} ` +
    `(standards/code-quality.md). Split it — extract a symbol into its own file — instead of ` +
    `growing past the limit. If this path is legitimately large (generated code, flat data), ` +
    `pre-register it in the crew:exempt block of docs/DEVIATIONS.md with its rationale.`;

  if (quality === "enforce") respond("deny", detail);
  respond(
    "allow",
    `Code-quality notice (advisory, write allowed): ${detail}`,
  );
} catch {
  // Fail open: a guard bug must never block legitimate work.
}
process.exit(0);
