#!/bin/sh
set -eu

echo "startup HOME=$HOME"

project_root="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
codex_home="${CODEX_HOME:-$HOME/.config/JetBrains/Air/.codex}"
python3 - "$codex_home/config.toml" "$project_root" <<'PY'
import json
import re
import sys
from pathlib import Path

config = Path(sys.argv[1])
project = sys.argv[2]
config.parent.mkdir(parents=True, exist_ok=True)
text = config.read_text() if config.exists() else ""
header = f"[projects.{json.dumps(project)}]"
section = re.search(r"(?m)^" + re.escape(header) + r"\s*\n", text)
if section:
    start = section.end()
    next_section = re.search(r"(?m)^\s*\[", text[start:])
    end = start + next_section.start() if next_section else len(text)
    body = text[start:end]
    body, count = re.subn(r'(?m)^\s*trust_level\s*=.*$', 'trust_level = "trusted"', body)
    if not count:
        body = 'trust_level = "trusted"\n' + body
    text = text[:start] + body + text[end:]
else:
    text = text.rstrip() + f'\n\n{header}\ntrust_level = "trusted"\n'
config.write_text(text)
print(f"Trusted Codex project: {project}")
PY

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
