#!/bin/sh
set -eu

echo "startup HOME=$HOME"

startup_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
sudo install -d -m 755 /etc/codex/hooks
sudo install -m 755 "$startup_dir/register-trajectories.sh" /etc/codex/hooks/register-trajectories.sh
sudo install -m 644 "$startup_dir/requirements.toml" /etc/codex/requirements.toml

f="/home/workspace/.config/JetBrains/Air/artifacts.watch"
mkdir -p "$(dirname "$f")"
touch "$f"
echo "using artifacts watch list: $f (AIR_ARTIFACTS_WATCH_LIST=${AIR_ARTIFACTS_WATCH_LIST:-<unset>})"

for dir in "$HOME/.claude/projects"; do
  mkdir -p "$dir"
  if grep -qxF "$dir/**" "$f"; then
    echo "already registered: $dir/**"
  else
    echo "$dir/**" >> "$f"
    echo "registered: $dir/**"
  fi
done
