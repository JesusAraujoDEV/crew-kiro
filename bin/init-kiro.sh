#!/usr/bin/env bash
# Install or update crew-kiro for Kiro IDE.
# Workspace (recommended): ./init-kiro.sh [--solo] [--target /project]
# Global user profile:     ./init-kiro.sh --global

set -euo pipefail

MODE="team"
GLOBAL=false
TARGET="$(pwd)"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --solo) MODE="solo" ;;
    --global) GLOBAL=true ;;
    --target)
      shift
      [ "$#" -gt 0 ] || { echo "--target requires a path" >&2; exit 2; }
      TARGET="$1"
      ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CREW_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

sync_file() {
  local source="$1" destination="$2"
  mkdir -p "$(dirname "$destination")"
  cp -f "$source" "$destination"
  printf '  synced: %s\n' "$destination"
}

sync_tree() {
  local source="$1" destination="$2"
  mkdir -p "$destination"
  cp -Rf "$source/." "$destination/"
  printf '  synced tree: %s\n' "$destination"
}

copy_if_missing() {
  local source="$1" destination="$2"
  if [ -e "$destination" ]; then
    printf '  preserved: %s\n' "$destination"
    return
  fi
  sync_file "$source" "$destination"
}

install_global() {
  local kiro_home="${KIRO_HOME:-$HOME/.kiro}"
  echo "Installing crew-kiro globally into $kiro_home"

  sync_file "$CREW_ROOT/.kiro/steering/crew-baseline.md" "$kiro_home/steering/crew-baseline.md"
  sync_file "$CREW_ROOT/.kiro/steering/crew-roles.md" "$kiro_home/steering/crew-roles.md"
  sync_tree "$CREW_ROOT/.kiro/agents" "$kiro_home/agents"
  sync_tree "$CREW_ROOT/.kiro/skills" "$kiro_home/skills"
  sync_tree "$CREW_ROOT/agents" "$kiro_home/crew/agents"
  sync_file "$CREW_ROOT/bin/metrics.js" "$kiro_home/crew/bin/metrics.js"

  echo
  echo "Global crew installed. Start a new Kiro session so agents and steering reload."
  echo "Kiro will route ordinary requests automatically; selecting an agent is optional."
}

install_workspace() {
  TARGET="$(cd "$TARGET" && pwd)"
  if [ "$TARGET" = "$CREW_ROOT" ]; then
    echo "Refusing to install the distributable into its own source repository. Use --global or another --target." >&2
    exit 1
  fi
  command -v node >/dev/null 2>&1 || {
    echo "Node.js is required by crew's workspace hooks but was not found on PATH." >&2
    exit 1
  }

  echo "Installing crew-kiro into $TARGET (mode: $MODE)"

  # Crew-managed Kiro assets converge on every run.
  sync_file "$CREW_ROOT/.kiro/steering/crew-baseline.md" "$TARGET/.kiro/steering/crew-baseline.md"
  sync_file "$CREW_ROOT/.kiro/steering/crew-roles.md" "$TARGET/.kiro/steering/crew-roles.md"
  sync_tree "$CREW_ROOT/.kiro/agents" "$TARGET/.kiro/agents"
  sync_tree "$CREW_ROOT/.kiro/skills" "$TARGET/.kiro/skills"
  sync_tree "$CREW_ROOT/.kiro/hooks" "$TARGET/.kiro/hooks"
  sync_tree "$CREW_ROOT/agents" "$TARGET/.kiro/crew/agents"
  sync_file "$CREW_ROOT/bin/metrics.js" "$TARGET/.kiro/crew/bin/metrics.js"

  for script in "$CREW_ROOT"/hooks/kiro-*.js; do
    [ -f "$script" ] && sync_file "$script" "$TARGET/hooks/$(basename "$script")"
  done
  for library in config.js ceilings.js kiro-input.js; do
    sync_file "$CREW_ROOT/hooks/lib/$library" "$TARGET/hooks/lib/$library"
  done

  # Project-owned scaffold is never overwritten.
  local templates="$CREW_ROOT/templates"
  copy_if_missing "$templates/standards/code-quality.md" "$TARGET/standards/code-quality.md"
  copy_if_missing "$templates/docs/decisions/README.md" "$TARGET/docs/decisions/README.md"
  copy_if_missing "$templates/docs/decisions/0000-template.md" "$TARGET/docs/decisions/0000-template.md"
  copy_if_missing "$templates/docs/work/README.md" "$TARGET/docs/work/README.md"

  if [ "$MODE" = "team" ]; then
    for relative in \
      docs/INDEX.md \
      docs/MAINTAINING.md \
      docs/DEVIATIONS.md \
      docs/briefs/README.md \
      docs/stories/README.md \
      docs/requirements/README.md \
      docs/proposals/README.md \
      docs/guides/delivery-circuit.md \
      docs/guides/delivery-circuit.es.md; do
      [ -f "$templates/$relative" ] && copy_if_missing "$templates/$relative" "$TARGET/$relative"
    done
  fi

  if [ ! -e "$TARGET/crew.json" ]; then
    cat > "$TARGET/crew.json" <<EOF
{
  "mode": "$MODE",
  "metrics": true,
  "quality": "advise",
  "ceilings": {}
}
EOF
    echo "  created: $TARGET/crew.json"
  else
    echo "  preserved: $TARGET/crew.json"
  fi

  echo
  echo "Workspace crew installed. Open a new Kiro session to reload agents, steering, and hooks."
  echo "Kiro now chooses relevant crew roles automatically. Aliases remain optional overrides."
}

if [ "$GLOBAL" = true ]; then
  [ "$MODE" = "team" ] || echo "Warning: --solo is ignored with --global." >&2
  install_global
else
  install_workspace
fi
