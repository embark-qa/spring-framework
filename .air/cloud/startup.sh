#!/bin/sh
set -eu

f="${AIR_ARTIFACTS_WATCH_LIST:-/mnt/air-workspace/config/artifacts.watch}"
if [ ! -f "$f" ]; then
  echo "artifacts watch list $f not found; trajectories will not be exported" >&2
  exit 0
fi

for dir in "$HOME/.claude/projects" "${CODEX_HOME:-$HOME/.codex}/sessions"; do
  mkdir -p "$dir"
  if grep -qxF "$dir/**" "$f"; then
    echo "already registered: $dir/**"
  else
    echo "$dir/**" >> "$f"
    echo "registered: $dir/**"
  fi
done
