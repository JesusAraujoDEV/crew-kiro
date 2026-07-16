#!/usr/bin/env bash
# Install crew-kiro into a target project's .kiro/ directory.
# Run from the root of your target project.
#
# Usage:
#   bash /path/to/crew-kiro/bin/init-kiro.sh          # team mode (full circuit)
#   bash /path/to/crew-kiro/bin/init-kiro.sh --solo   # solo mode (minimal)
#
# What it does:
#   1. Copies .kiro/steering/ files (baseline + roles + agent steering files)
#   2. Copies .kiro/hooks/ JSON definitions
#   3. Copies hooks/kiro-*.js scripts and hooks/lib/ helpers
#   4. Copies agents/ and skills/ directories (referenced by steering files)
#   5. Optionally scaffolds crew.json, standards/, and docs/ skeleton

set -euo pipefail

MODE="team"
if [ "${1:-}" = "--solo" ]; then
  MODE="solo"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CREW_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="$(pwd)"

if [ "$TARGET" = "$CREW_ROOT" ]; then
  echo "Refusing to install into the crew-kiro repo itself. cd to your project first." >&2
  exit 1
fi

echo "Installing crew-kiro into: $TARGET (mode: $MODE)"
echo

# --- Helper ---
copy_if_absent() {
  local src="$1" dest="$2"
  if [ -e "$dest" ]; then
    echo "  skip (exists): ${dest#$TARGET/}"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "  wrote:         ${dest#$TARGET/}"
  fi
}

copy_dir() {
  local src="$1" dest="$2"
  if [ -d "$dest" ]; then
    echo "  skip (exists): ${dest#$TARGET/}/"
  else
    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest"
    echo "  wrote:         ${dest#$TARGET/}/"
  fi
}

# --- 1. .kiro/steering ---
echo "=== Steering files ==="
mkdir -p "$TARGET/.kiro/steering/agents"

copy_if_absent "$CREW_ROOT/.kiro/steering/crew-baseline.md" "$TARGET/.kiro/steering/crew-baseline.md"
copy_if_absent "$CREW_ROOT/.kiro/steering/crew-roles.md"    "$TARGET/.kiro/steering/crew-roles.md"

for f in "$CREW_ROOT/.kiro/steering/agents/"*.md; do
  [ -f "$f" ] || continue
  copy_if_absent "$f" "$TARGET/.kiro/steering/agents/$(basename "$f")"
done
echo

# --- 2. .kiro/hooks ---
echo "=== Hooks ==="
mkdir -p "$TARGET/.kiro/hooks"

for f in "$CREW_ROOT/.kiro/hooks/"*.json; do
  [ -f "$f" ] || continue
  copy_if_absent "$f" "$TARGET/.kiro/hooks/$(basename "$f")"
done
echo

# --- 3. Hook scripts (Node.js) ---
echo "=== Hook scripts ==="
mkdir -p "$TARGET/hooks/lib"

for f in "$CREW_ROOT/hooks/kiro-"*.js; do
  [ -f "$f" ] || continue
  copy_if_absent "$f" "$TARGET/hooks/$(basename "$f")"
done

# Copy shared libraries
for f in "$CREW_ROOT/hooks/lib/"*.js; do
  [ -f "$f" ] || continue
  copy_if_absent "$f" "$TARGET/hooks/lib/$(basename "$f")"
done
echo

# --- 4. Agent definitions (source of truth for steering references) ---
echo "=== Agent definitions ==="
copy_dir "$CREW_ROOT/agents" "$TARGET/agents"
echo

# --- 5. Skills ---
echo "=== Skills ==="
copy_dir "$CREW_ROOT/skills" "$TARGET/skills"
echo

# --- 6. Standards & docs skeleton ---
echo "=== Standards & documentation skeleton ==="
TEMPLATES="$CREW_ROOT/templates"

mkdir -p "$TARGET/standards"
mkdir -p "$TARGET/docs/decisions"
mkdir -p "$TARGET/docs/work"

if [ -f "$TEMPLATES/standards/code-quality.md" ]; then
  copy_if_absent "$TEMPLATES/standards/code-quality.md" "$TARGET/standards/code-quality.md"
fi

copy_if_absent "$TEMPLATES/docs/decisions/README.md"        "$TARGET/docs/decisions/README.md"
copy_if_absent "$TEMPLATES/docs/decisions/0000-template.md" "$TARGET/docs/decisions/0000-template.md"
copy_if_absent "$TEMPLATES/docs/work/README.md"             "$TARGET/docs/work/README.md"

if [ "$MODE" = "team" ]; then
  mkdir -p "$TARGET/docs/briefs"
  mkdir -p "$TARGET/docs/stories"
  mkdir -p "$TARGET/docs/requirements"
  mkdir -p "$TARGET/docs/proposals"
  mkdir -p "$TARGET/docs/guides"

  [ -f "$TEMPLATES/docs/INDEX.md" ] && copy_if_absent "$TEMPLATES/docs/INDEX.md" "$TARGET/docs/INDEX.md"
  [ -f "$TEMPLATES/docs/DEVIATIONS.md" ] && copy_if_absent "$TEMPLATES/docs/DEVIATIONS.md" "$TARGET/docs/DEVIATIONS.md"
  [ -f "$TEMPLATES/docs/briefs/README.md" ] && copy_if_absent "$TEMPLATES/docs/briefs/README.md" "$TARGET/docs/briefs/README.md"
  [ -f "$TEMPLATES/docs/stories/README.md" ] && copy_if_absent "$TEMPLATES/docs/stories/README.md" "$TARGET/docs/stories/README.md"
  [ -f "$TEMPLATES/docs/requirements/README.md" ] && copy_if_absent "$TEMPLATES/docs/requirements/README.md" "$TARGET/docs/requirements/README.md"
  [ -f "$TEMPLATES/docs/proposals/README.md" ] && copy_if_absent "$TEMPLATES/docs/proposals/README.md" "$TARGET/docs/proposals/README.md"
  [ -f "$TEMPLATES/docs/guides/delivery-circuit.md" ] && copy_if_absent "$TEMPLATES/docs/guides/delivery-circuit.md" "$TARGET/docs/guides/delivery-circuit.md"
  [ -f "$TEMPLATES/docs/guides/delivery-circuit.es.md" ] && copy_if_absent "$TEMPLATES/docs/guides/delivery-circuit.es.md" "$TARGET/docs/guides/delivery-circuit.es.md"
fi
echo

# --- 7. crew.json ---
echo "=== Configuration ==="
CREW_JSON="$TARGET/crew.json"
if [ -e "$CREW_JSON" ]; then
  echo "  skip (exists): crew.json"
else
  cat > "$CREW_JSON" <<EOF
{
  "mode": "$MODE",
  "metrics": true,
  "quality": "advise",
  "ceilings": {}
}
EOF
  echo "  wrote:         crew.json"
fi
echo

echo "Done! crew-kiro installed for Kiro IDE."
echo
echo "Next steps:"
echo "  1. Open the project in Kiro — steering files and hooks activate automatically."
echo "  2. Use #system-architect, #ux-architect, etc. in chat to invoke roles."
echo "  3. Or prefix messages with SYS:, UX:, DA:, etc. for role activation."
if [ "$MODE" = "team" ]; then
  echo "  4. Review crew.json — flip quality to 'enforce' when the team is ready."
  echo "  5. Write docs/spec.md with your project specification."
fi
