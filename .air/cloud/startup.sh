#!/bin/sh
set -eu

echo "startup HOME=$HOME"

f="/home/workspace/.config/JetBrains/Air/artifacts.watch"
mkdir -p "$(dirname "$f")"
touch "$f"
echo "using artifacts watch list: $f (AIR_ARTIFACTS_WATCH_LIST=${AIR_ARTIFACTS_WATCH_LIST:-<unset>})"

for dir in "$HOME/.claude/projects" "$HOME/.config/JetBrains/Air/.codex/sessions"; do
  mkdir -p "$dir"
  if grep -qxF "$dir/**" "$f"; then
    echo "already registered: $dir/**"
  else
    echo "$dir/**" >> "$f"
    echo "registered: $dir/**"
  fi
done
