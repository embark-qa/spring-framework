#!/bin/sh
set -eu

debug() {
  printf '[register-trajectories] DEBUG: %s\n' "$*" >&2
}

debug "AIR_ARTIFACTS_WATCH_LIST=${AIR_ARTIFACTS_WATCH_LIST-<unset>}"
debug "CODEX_HOME=${CODEX_HOME-<unset>}"

air_watch_list="$HOME/.config/JetBrains/Air/artifacts.watch"
jcp_watch_list="/tmp/jcp-agent-host/artifacts.watch"

if [ -n "${AIR_ARTIFACTS_WATCH_LIST:-}" ]; then
  watch_list="$AIR_ARTIFACTS_WATCH_LIST"
  debug "Using AIR_ARTIFACTS_WATCH_LIST: $watch_list"
else
  watch_list=""
  for candidate in "$air_watch_list" "$jcp_watch_list"; do
    if [ -f "$candidate" ]; then
      watch_list="$candidate"
      debug "Found artifacts watch file: $watch_list"
      break
    fi
    debug "Artifacts watch file not found: $candidate"
  done
  if [ -z "$watch_list" ]; then
    watch_list="$air_watch_list"
    debug "No existing artifacts watch file found; using: $watch_list"
  fi
fi

mkdir -p "$(dirname "$watch_list")"
if [ ! -e "$watch_list" ]; then
  touch "$watch_list"
  debug "Created artifacts watch file: $watch_list"
fi

register_sessions() {
  entry="${1%/}/sessions/**"
  # Keep the new entry separate if the existing file has no final newline.
  if [ -s "$watch_list" ] && [ "$(tail -c 1 "$watch_list" | wc -l)" -eq 0 ]; then
    printf '\n' >> "$watch_list"
    debug "Added missing final newline to: $watch_list"
  fi
  printf '%s\n' "$entry" >> "$watch_list"
  debug "Added entry to $watch_list: $entry"
}

register_sessions "$HOME/.config/JetBrains/Air/.codex"
register_sessions "$HOME/.codex"
