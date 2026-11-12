#!/bin/sh
set -eu

echo "startup HOME=$HOME"

f=""
for candidate in \
  "${AIR_ARTIFACTS_WATCH_LIST:-}" \
  "/mnt/air-workspace/config/artifacts.watch" \
  "/home/workspace/.config/JetBrains/Air/artifacts.watch"
do
  if [ -n "$candidate" ] && [ -f "$candidate" ]; then
    f="$candidate"
    break
  fi
done

if [ -z "$f" ]; then
  echo "no artifacts watch list found (AIR_ARTIFACTS_WATCH_LIST=${AIR_ARTIFACTS_WATCH_LIST:-<unset>}); trajectories will not be exported" >&2
  exit 0
fi
echo "using artifacts watch list: $f"

for dir in "$HOME/.claude/projects" "$HOME/.config/JetBrains/Air/.codex/sessions"; do
  mkdir -p "$dir"
  if grep -qxF "$dir/**" "$f"; then
    echo "already registered: $dir/**"
  else
    echo "$dir/**" >> "$f"
    echo "registered: $dir/**"
  fi
