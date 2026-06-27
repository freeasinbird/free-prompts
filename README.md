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

Each file pairs a byte-identical tool-agnostic core (between the `SHARED`
comment markers) with a per-tool tail of agent-specific guidance. A change
to the shared core lands in both files together and stays byte-identical;
tool-specific behavior lives only in each file's tail. Changes are reviewed
side by side.

`system/` is the only scope today. If project-level prompt templates appear
later, they get a sibling scope (e.g. `project/`).

## Syncing

`scripts/link-system-prompts.sh` symlinks each system prompt into its tool's
config location, so a `git pull` refreshes every machine in place:

- `system/claude/CLAUDE.md` → `~/.claude/CLAUDE.md`
- `system/codex/AGENTS.md` → `~/.codex/AGENTS.md`

```sh
git clone https://github.com/freeasinbird/free-prompts.git
cd free-prompts
scripts/link-system-prompts.sh --dry-run   # preview, change nothing
scripts/link-system-prompts.sh             # create the symlinks
scripts/link-system-prompts.sh --adopt     # replace an existing real file
                                           # (backed up to *.bak-<ts> first)
```

Re-run after a `git pull` that adds or removes a mapped prompt; existing
links refresh in place through the clone. By default the script only touches
symlinks that already point into this repo — a real file or foreign symlink
at a destination is skipped unless you pass `--adopt`. It is scoped to system
prompts by design; other prompt kinds would get their own helper. See
`scripts/link-system-prompts.sh --help`.

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
