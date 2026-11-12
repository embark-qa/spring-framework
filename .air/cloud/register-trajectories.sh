#!/bin/sh
set -eu

watch_list="${AIR_ARTIFACTS_WATCH_LIST:-$HOME/.config/JetBrains/Air/artifacts.watch}"
sessions="${CODEX_HOME:-$HOME/.config/JetBrains/Air/.codex}/sessions"
mkdir -p "$(dirname "$watch_list")" "$sessions"
touch "$watch_list"
if ! grep -qxF "$sessions/**" "$watch_list"; then
  echo "$sessions/**" >> "$watch_list"
fi
