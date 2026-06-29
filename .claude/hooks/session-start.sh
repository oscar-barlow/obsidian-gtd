#!/usr/bin/env bash
#
# SessionStart hook: make the Obsidian CLI live before Claude starts working.
#
# Fast path: Obsidian already installed (baked by the env setup script) -> just
# launch + sync via obsidian-up.
# Bootstrap path: nothing installed yet (e.g. you skipped the env setup field)
# -> run the full setup once. This is slow (downloads ~85MB + plugins), so the
# recommended setup is to paste setup-obsidian.sh into the environment's *setup
# script* field and let this hook only do the fast path.
#
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if ! command -v obx >/dev/null 2>&1; then
  echo "Obsidian not installed yet — bootstrapping (one-off, slow)…"
  bash "${REPO_DIR}/setup-obsidian.sh"
else
  obsidian-up
fi
