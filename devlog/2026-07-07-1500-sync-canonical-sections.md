# 2026-07-07 15:00 Sync managed sections to latest agent-setup skill

Ran `/agent-setup` in update mode to pull the root AGENTS.md and devlog
protocol up to the skill's current canonical text. Change is a pure sync,
no new conventions authored here.

## Decisions

- **Adopted the `context` managed block** (Context discipline), which the
  skill has since added to canonical and which this repo never carried.
  Inserted at its conventional position, between `finish-line` and the
  project-specific `## Repository layout`. Not an opt-out: no devlog
  decision excluded it, so absence was "not yet adopted", and the explicit
  sync request adopts it.
- **devlog block + devlog/README.md gained the incremental-checkpoint
  clause** as one theme: the managed `devlog` block now says an entry may
  be built incrementally at checkpoints while its PR is unmerged (pointing
  at devlog/README.md), and README.md gained the matching "Checkpoint long
  sessions" bullet. Kept in lockstep so the block and the protocol it
  references don't contradict.
- **Everything else already matched canonical**: finish-line, branches,
  pull-requests, commits, done, plus CLAUDE.md, CONTRIBUTING.md, and the PR
  template. The Codex automated-reviewer record sits outside the managed
  blocks, so the sync left it untouched.

## Verification

- `compare-managed-blocks.sh` reports all seven blocks `ok`.
- devlog/README.md now byte-identical to the scaffolding template.
- `prettier --check` and markdownlint clean on both changed files
  (repo-wide lint's only warning is untracked, gitignored
  `.claude/settings.local.json`).

## To promote

- Nothing outstanding.
