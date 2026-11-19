#!/bin/sh
set -eu

echo "startup HOME=$HOME"

startup_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
sudo install -d -m 755 /etc/codex/hooks
sudo install -m 755 "$startup_dir/register-trajectories.sh" /etc/codex/hooks/register-trajectories.sh
sudo install -m 644 "$startup_dir/requirements.toml" /etc/codex/requirements.toml
