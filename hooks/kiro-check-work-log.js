// Stop hook for Kiro IDE: checks closure traceability.
// When a session ends and work was performed on stories/requirements,
// reminds the agent to log work if not already done.
//
// This is advisory only (exit 0 with message to stdout).
const { readFileSync, existsSync } = require("node:fs");
const { join } = require("node:path");

try {
  const raw = readFileSync(0, "utf8").replace(/^\uFEFF/, "");
  const input = JSON.parse(raw);
  const cwd = input.cwd || process.cwd();

  // Check if crew.json exists and metrics are enabled
  const crewJsonPath = join(cwd, "crew.json");
  if (!existsSync(crewJsonPath)) process.exit(0);

  let cfg;
  try {
    cfg = JSON.parse(readFileSync(crewJsonPath, "utf8").replace(/^\uFEFF/, ""));
  } catch {
    process.exit(0);
  }

  if (!cfg.metrics) process.exit(0);

  // Check if docs/work directory exists
  const workDir = join(cwd, "docs", "work");
  if (!existsSync(workDir)) process.exit(0);

  // Advisory reminder
  process.stdout.write(
    "Reminder: if this session involved implementation work on a story or requirement, " +
    "ensure the estimation table timestamps are up to date and a work log entry exists " +
    "in docs/work/ for traceability."
  );
} catch {
  // Fail open
}
process.exit(0);
