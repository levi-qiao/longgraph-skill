#!/usr/bin/env sh
# longgraph-skill installer — clones the library once and symlinks it as
# `/longgraph` (primary) into hosts whose loaders FOLLOW symlinks: Codex, Cursor,
# and Grok Build. Also links the legacy name `/octopus` to the same tree so older
# promotions still work.
# Claude Code does NOT load symlinked skill dirs — install it there as a plugin:
#   /plugin marketplace add levi-qiao/longgraph-skill  &&  /plugin install longgraph@longgraph-skill
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/levi-qiao/longgraph-skill/main/install.sh | sh
#   ./install.sh   # from a local checkout — links that tree
# Legacy curl (GitHub renames redirect):
#   curl -fsSL https://raw.githubusercontent.com/levi-qiao/octopus-skill/main/install.sh | sh
set -eu

REPO="https://github.com/levi-qiao/longgraph-skill.git"
# Prefer LONGGRAPH_CACHE; accept OCTOPUS_CACHE for older install notes / shells.
CACHE="${LONGGRAPH_CACHE:-${OCTOPUS_CACHE:-$HOME/.local/share/longgraph-skill}}"
PRIMARY="longgraph"
LEGACY="octopus"

# Prefer the checkout this script lives in (local `./install.sh`).
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd || true)
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/SKILL.md" ] && [ -d "$SCRIPT_DIR/skills/loop-graph" ]; then
  CACHE="$SCRIPT_DIR"
  echo "Using local checkout $CACHE"
elif [ -d "$CACHE/.git" ]; then
  echo "Updating longgraph-skill in $CACHE ..."
  git -C "$CACHE" pull --ff-only || echo "  (skipped pull — local changes present)"
else
  # Migrate old cache dir name if present and new path empty
  OLD_CACHE="${HOME}/.local/share/octopus-skill"
  if [ ! -e "$CACHE" ] && [ -d "$OLD_CACHE/.git" ] && [ "$CACHE" != "$OLD_CACHE" ]; then
    echo "Moving legacy cache $OLD_CACHE -> $CACHE"
    mkdir -p "$(dirname "$CACHE")"
    mv "$OLD_CACHE" "$CACHE"
  else
    echo "Cloning longgraph-skill -> $CACHE"
    mkdir -p "$(dirname "$CACHE")"
    git clone --depth 1 "$REPO" "$CACHE"
  fi
fi

# 2. Symlink the library and each invocable preset into each host skills dir.
#    Primary: longgraph (whole tree). Legacy alias: octopus → same tree.
#    Presets (loop-converge, …) are their own slash names → skills/<name>.
link_skill() {
  skills_dir="$1"
  name="$2"
  src="${3:-$CACHE}"
  [ -d "$(dirname "$skills_dir")" ] || return 0   # host not installed — skip
  mkdir -p "$skills_dir"
  dest="$skills_dir/$name"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    bak="$dest.bak-$(date +%Y%m%d%H%M%S)"
    mv "$dest" "$bak"
    echo "  backed up existing $name -> $bak"
  fi
  ln -sfn "$src" "$dest"
  echo "  linked $name -> $dest"
}

echo "Linking /longgraph, /loop-converge (and legacy /octopus) into symlink-following hosts (Codex, Cursor, Grok Build):"
for skills in \
  "${CODEX_SKILLS_DIR:-$HOME/.codex/skills}" \
  "${CURSOR_SKILLS_DIR:-$HOME/.cursor/skills}" \
  "${GROK_SKILLS_DIR:-$HOME/.grok/skills}"
do
  link_skill "$skills" "$PRIMARY"
  link_skill "$skills" "$LEGACY"
  link_skill "$skills" "loop-converge" "$CACHE/skills/loop-converge"
done

echo ""
echo "✅ Linked for Codex / Cursor / Grok Build — run:  /longgraph   or   /loop-converge"
echo "   (legacy alias still works:  /octopus )"
echo "ℹ️  Claude Code does not load symlinked skills; install it there as a plugin:"
echo "     /plugin marketplace add levi-qiao/longgraph-skill"
echo "     /plugin install longgraph@longgraph-skill"
echo "   After marketplace refresh, older posts that said octopus@octopus-skill should"
echo "   use longgraph@longgraph-skill (GitHub redirects the old repo name)."
