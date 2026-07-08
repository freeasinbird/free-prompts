# 2026-07-08 12:00 Sync devlog queue-state-marker protocol to canonical

Ran `/agent-setup` in update mode. Pure sync: the skill's canonical text
added the `->` queue-item state-marker protocol since the last sync
(#13/#15), and this repo's `devlog`/`finish-line` blocks plus
`devlog/README.md` lagged it. No new conventions authored here.

## Decisions

- **Refreshed the `devlog` and `finish-line` managed blocks** to canonical.
  The delta is the queue-drain mechanism: an open queue item is now one
  with no `->` state marker (or an expired `-> re-deferred` clock), and
  draining/re-deferring appends a `->` marker to the source item. Both
  blocks gained the pointer to devlog/README.md, which defines the marker
  forms.
- **Refreshed `devlog/README.md`** in lockstep, since it is the source of
  truth the two blocks reference. Replaced the old "Frozen queue entries
  drain by reference" bullet with "Queue items drain by annotation" (the
  `->` forms), and pulled in the template's other accrued edits: the
  "Write for the future re-litigator" bullet, the append-only `->`
  exception to freeze, and the Verification/tracker-issue refinements.
  Now byte-identical to the scaffolding template.
- **Everything else already matched canonical**: context, branches,
  pull-requests, commits, done, plus CLAUDE.md, CONTRIBUTING.md, and the PR
  template. The Codex automated-reviewer record sits outside the managed
  blocks (line ~283), untouched. Repo merge settings and CI (lint.yml) all
  already aligned.

## Migration

Introducing the `->` rule retroactively makes pre-existing unmarked
deferrals "open" (Codex P2 on this PR). Swept the whole devlog queue and
annotated the genuinely-open pre-rule items in their frozen source
entries (the `->` marker is the one permitted frozen-entry edit):

- `scripts/link.sh` symlink sync (1537, 1632): done as
  `scripts/link-system-prompts.sh` -> `-> promoted`.
- Branch protection / ruleset until public (1537, 1612, 1632): repo still
  private, long-lived -> filed #17, `-> Refs #17`.
- Windows / PowerShell sync variant (1612): long-lived -> filed #18,
  `-> Refs #18`.
- Full per-tool payload-prose optimization (1632): speculative future unit
  -> filed #19, `-> Refs #19`.
- em-dash convention note (1015 `## To promote`): already drained by 1505;
  no action.

Review round (Codex P2, 2a4842c): the 1632 entry bundles `scripts/link.sh`
and branch protection in one deferral, and the first-pass marker packed both
resolutions into a single non-form line (`... promoted (see ...); branch
protection Refs #17`). A form-following sweep could miss the `-> Refs #17`
escalation mid-line. Split into two canonical markers matching this section's
stated intent: a `-> promoted in ...` line for the script and a separate
`-> Refs #17` line for branch protection, each naming its concern in a
trailing parenthetical.

## Verification

- `compare-managed-blocks.sh` reports all seven blocks `ok`.
- `devlog/README.md` diffs byte-identical to the scaffolding template.
- prettier + markdownlint clean on the changed files (repo-wide prettier's
  only warning is the untracked, gitignored `.claude/settings.local.json`).
- No em dashes added to AGENTS.md by this diff.

## To promote

- Nothing outstanding. Pre-rule open deferrals migrated to tracker issues
  #17/#18/#19 (see Migration); the queue is now marker-accurate.
