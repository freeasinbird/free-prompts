#!/usr/bin/env bash
#
# link-system-prompts.sh — symlink this repo's system prompts into their live
# tool config locations, so a `git pull` refreshes every machine in place.
#
# Scope: SYSTEM PROMPTS ONLY. It links exactly the files in the MAP below (the
# `system/<tool>/` payloads) to their destinations. It is intentionally not a
# generic "link anything" helper — other prompt kinds this repo might grow
# later (e.g. project-level templates) would get their own scoped script, not
# this one.
#
# Idempotent reconcile: run it once per machine, then again after a `git pull`
# that adds or removes a mapped prompt. Because each installed entry is a
# symlink into this clone, `git pull` alone refreshes the linked content in
# place — re-run this only to add newly-mapped prompts or fix drift.
#
# Safety: by default only touches symlinks that already point into THIS repo.
# A real file or a foreign symlink at a destination is left alone (skipped
# with a message), so the script can't clobber unrelated configs. Pass
# --adopt to replace them — and for a real file (e.g. your existing
# ~/.claude/CLAUDE.md), --adopt first backs it up to <dest>.bak-<timestamp>.
#
# Portable across macOS (BSD) and Linux (GNU). Not for Windows — use WSL.
#
# Usage:
#   scripts/link-system-prompts.sh            # apply changes
#   scripts/link-system-prompts.sh --dry-run  # show what would change, do nothing
#   scripts/link-system-prompts.sh --adopt    # also replace real files / foreign
#                                             # symlinks (real files backed up first)

set -euo pipefail

DRY_RUN=0
ADOPT=0
for arg in "$@"; do
  case "$arg" in
    --dry-run | -n) DRY_RUN=1 ;;
    --adopt) ADOPT=1 ;;
    -h | --help)
      grep '^#' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "unknown argument: $arg (try --help)" >&2
      exit 2
      ;;
  esac
done

# Repo root is the parent of this script's directory, so the script works from
# any clone path and any working directory.
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$SCRIPT_DIR/.." && pwd)
SRC="$REPO/system"

# The system-prompt map: "<path-under-system>|<destination>". One line per
# tool. Add a tool by adding a line — nothing else discovers files, so other
# prompt kinds never get linked by accident.
MAP=(
  "claude/CLAUDE.md|$HOME/.claude/CLAUDE.md"
  "codex/AGENTS.md|$HOME/.codex/AGENTS.md"
)

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf 'would: %s\n' "$*"
  else
    "$@"
  fi
}

link_one() {
  local rel=$1 dest=$2 src cur bak
  src="$SRC/$rel"

  if [ ! -f "$src" ]; then
    echo "missing source (mapped but not in repo): $src" >&2
    return 1
  fi

  run mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    cur=$(readlink "$dest")
    case "$cur" in
    "$SRC"/*)
      # already ours — refresh only if the target drifted
      if [ "$cur" = "$src" ]; then
        echo "up-to-date: $dest"
      else
        echo "refresh (drifted): $dest -> $src"
        run ln -sfn "$src" "$dest"
      fi
      ;;
    *)
      # symlink to somewhere else
      if [ "$ADOPT" -eq 1 ]; then
        echo "adopt (replacing foreign symlink): $dest -> $src"
        run rm -f "$dest"
        run ln -sfn "$src" "$dest"
      else
        echo "skip (foreign symlink — re-run with --adopt to replace): $dest -> $cur"
      fi
      ;;
    esac
  elif [ -e "$dest" ]; then
    # real file or directory, e.g. your current global prompt
    if [ "$ADOPT" -eq 1 ]; then
      bak="$dest.bak-$(date +%Y%m%d-%H%M%S)"
      echo "adopt (backing up real file): $dest -> $bak"
      run mv "$dest" "$bak"
      echo "link: $dest -> $src"
      run ln -sfn "$src" "$dest"
    else
      echo "skip (real file — re-run with --adopt to back up and replace): $dest"
    fi
  else
    echo "link: $dest -> $src"
    run ln -sfn "$src" "$dest"
  fi
}

[ -d "$SRC" ] || {
  echo "no system/ directory at $SRC" >&2
  exit 1
}

for entry in "${MAP[@]}"; do
  link_one "${entry%%|*}" "${entry#*|}"
done

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Done (dry run — no changes made)."
else
  echo "Done."
fi
