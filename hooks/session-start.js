// SessionStart hook: inject the crew standard baseline into every session.
// Cost: one local file read (~25 lines), no network, no scanning.
const { readFileSync } = require("node:fs");
const { join } = require("node:path");

const root = process.env.CLAUDE_PLUGIN_ROOT || join(__dirname, "..");
try {
  process.stdout.write(readFileSync(join(root, "standards", "session-context.md"), "utf8"));
} catch {
  // A missing baseline must never break the session.
}
