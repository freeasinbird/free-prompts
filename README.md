# free-prompts

A synced store of reusable agent prompts. It version-controls system-level
configuration files for AI coding agents and pasteable chat-interface
instructions, so the same canonical prompts can be applied across every
machine.

## Layout

```text
system/
  claude/CLAUDE.md     # → ~/.claude/CLAUDE.md
  codex/AGENTS.md      # → ~/.codex/AGENTS.md
chat/
  claude/instructions.md
  chatgpt/custom-instructions.md
```

`system/` files pair a byte-identical tool-agnostic core (between the
`SHARED` comment markers) with a per-tool tail of agent-specific guidance. A
change to the shared core lands in both files together and stays
byte-identical; tool-specific behavior lives only in each file's tail.

`chat/` files are hand-authored instructions for consumer chat interfaces.
They stay conceptually aligned across tools, but are not byte-identical:
Claude can carry more structure, while ChatGPT must fit its custom
instructions character limit.

[`docs/writing-style.md`](docs/writing-style.md) is Ben's personal voice
reference for agents. It is a standalone guide and is not automatically added
to any system or chat prompt.

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

Chat prompts are copied into each product's chat settings manually. They are
not installed by the system prompt linker.

## Working on this repo

Conventions for editing, branching, and PRs live in [AGENTS.md](AGENTS.md).
The root `CLAUDE.md`/`AGENTS.md` configure work on this repo; they are not
synced anywhere — the reusable prompt payloads are under `system/<tool>/` and
`chat/<tool>/`.

```sh
npm install        # once
npm run lint       # prettier --check + markdownlint
npm run format     # prettier --write
```

## License

This work is licensed under [CC BY-SA 4.0](./LICENSE).

See [LICENSING-PHILOSOPHY.md](./LICENSING-PHILOSOPHY.md) for why we chose
this license.
