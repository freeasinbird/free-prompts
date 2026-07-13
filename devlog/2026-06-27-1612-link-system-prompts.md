# 2026-06-27 16:12 — `link-system-prompts.sh`

Added the sync helper that symlinks the system prompts into their live tool
config locations. Drains the `scripts/link.sh` item deferred in the
`2026-06-27-1537` entry. Adapted from `free-skills/scripts/link-skills.sh`.

## Decisions

- **Scoped name, not a generic linker.** `link-system-prompts.sh`, not
  `link.sh`. The repo may grow other prompt kinds later; those get their own
  helper. Reinforced in the header comment and AGENTS.md.
- **Explicit file→file map over auto-discovery.** A `MAP` array of
  `"system-rel|dest"` pairs, not a glob of `system/`. Destinations don't
  follow a derivable convention (`~/.claude/CLAUDE.md` vs `~/.codex/AGENTS.md`),
  and an explicit map keeps scope tight — nothing gets linked by accident.
- **Backup-on-adopt for live configs.** Destinations are the user's _live_
  global prompts. `--adopt` `mv`s a real file to `<dest>.bak-<timestamp>`
  before symlinking (free-skills just `rm`s; these single config files are
  higher-stakes, so back up). Foreign symlinks are replaced without backup
  (no content to lose). Default stays non-destructive: real files / foreign
  symlinks are skipped without `--adopt`.
- **No prune.** Map is tiny and explicit, destinations are scattered single
  files (no single managed dir to scan safely). Dropping a tool = remove its
  link by hand.
- **shellcheck added to CI** as a separate `shellcheck` job (preinstalled on
  `ubuntu-latest`) — new convention for these repos, since the script has
  `mv`/`rm`/symlink logic worth gating. Also documented for local runs.

## Verification

- `shellcheck scripts/link-system-prompts.sh` clean (0.11.0).
- Branch-coverage harness against a throwaway `HOME` (no risk to live
  configs): 13/13 — create, skip-real, adopt+backup, idempotent up-to-date,
  drift-refresh, foreign skip/replace, dry-run no-op.
- `--dry-run` against the real env confirms it _would_ skip the existing real
  `~/.claude/CLAUDE.md` / `~/.codex/AGENTS.md` (need `--adopt`); no changes.

## Deferred

- Windows (use WSL; a PowerShell variant is a separate task) — as free-skills.
  -> Refs #18
- Branch protection / ruleset — still deferred until the repo is public.
  -> Refs #17

## To promote

- Nothing outstanding.
