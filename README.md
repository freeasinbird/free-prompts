# free-prompts

A synced store of reusable agent prompts. It version-controls the
system-level configuration files for AI coding agents — Claude Code's
`CLAUDE.md`, Codex's `AGENTS.md`, and more as tools are added — so the same
canonical prompts can be applied across every machine.

## Layout

```text
system/
  claude/CLAUDE.md     # → ~/.claude/CLAUDE.md
  codex/AGENTS.md      # → ~/.codex/AGENTS.md
```

Each file is an independent artifact optimized for its agent. They share
ideas, not bytes — a principle change is applied (with per-tool wording)
across the relevant files in one change, reviewed side by side.

`system/` is the only scope today. If project-level prompt templates appear
later, they get a sibling scope (e.g. `project/`).

## Syncing

Each stored prompt is symlinked into its tool's config location, so a
`git pull` refreshes every machine in place:

- `system/claude/CLAUDE.md` → `~/.claude/CLAUDE.md`
- `system/codex/AGENTS.md` → `~/.codex/AGENTS.md`

<!-- TODO: add scripts/link.sh — an idempotent symlink reconcile modeled on
free-skills' link-skills.sh (--dry-run / --adopt, prunes stale links),
driven by the file→destination map above. -->

## Working on this repo

Conventions for editing, branching, and PRs live in [AGENTS.md](AGENTS.md).
The root `CLAUDE.md`/`AGENTS.md` configure work on this repo; they are not
synced anywhere — the synced payloads are under `system/<tool>/`.

```sh
npm install        # once
npm run lint       # prettier --check + markdownlint
npm run format     # prettier --write
```

## License

This work is licensed under [CC BY-SA 4.0](./LICENSE).

See [LICENSING-PHILOSOPHY.md](./LICENSING-PHILOSOPHY.md) for why we chose
this license.
