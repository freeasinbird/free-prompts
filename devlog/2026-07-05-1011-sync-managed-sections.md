# Sync managed workflow sections to canonical

Ran `/agent-setup` in update mode to fix setup drift. All six managed
blocks in AGENTS.md and three of four scaffolding files had drifted from
the agent-setup skill's current canonical text.

## Decisions

- **Direction: project ← canonical.** The divergence looked bidirectional
  at first (project's devlog block carried a "24-hour time / ≤40-line
  density target" that canonical lacks), but the skill's
  `canonical-sections.md` git log settles it: recent canonical commits add
  the worktree-per-work-unit convention, the subject-keyed commit map, and
  reviewer status signals, all present in canonical and absent here. The
  project's "extra" lines are old inline guidance that canonical
  deliberately relocated into `devlog/README.md` (the refreshed README
  restores them), so syncing to canonical loses nothing. Rejected: treating
  the project as authoritative and back-porting to the skill.
- **Preserved the project `done-checks`.** The nested
  `agents-md:project:done-checks` block (npm run lint, cross-cutting edits,
  payload-destination naming) is project-specific; only the surrounding
  managed text was refreshed.
- **Left unmanaged sections untouched.** The 25 em dashes remaining in
  AGENTS.md are all in project-specific sections (repo layout, per-tool
  authoring, reviewer record). The root config is not a payload, so the
  em-dash-free rule does not bind it; rewriting that prose is scope creep,
  not drift.

## Fixed

- AGENTS.md: refreshed devlog, finish-line, branches, pull-requests,
  commits, done blocks to canonical. Comparator now reports all six `ok`.
- CONTRIBUTING.md, devlog/README.md, .github/pull_request_template.md:
  overwritten with current templates. CLAUDE.md already matched.
- Codex (P2) flagged that the PR template's screenshot deadline ("before
  merging") lagged the refreshed AGENTS.md rule ("before handing off, and in
  every case before merge"). Root cause was upstream: the agent-setup skill's
  `scaffolding.md` and `canonical-sections.md` disagreed. Fixed the skill
  template to the handoff+merge wording and re-synced the PR template here
  (folded into the scaffolding commit), so the repo stays a verbatim copy
  rather than a local divergence.
- Codex round 2 (P2) flagged that the canonical `pull-requests` merge-cleanup
  recipe (`git checkout main`) breaks under the worktree workflow the
  `branches` block recommends. Declined in-PR (canonical text; a local edit
  reintroduces drift) and tracked upstream. Fixed upstream in free-skills #58
  (worktree-aware recipe), which merged; re-synced the `pull-requests` block
  here from the updated canonical (folded into the managed-sections commit).
  Comparator still reports all six `ok`.

## Done outside the diff

- **Repo merge-commit settings.** Was `merge_commit_title=MERGE_MESSAGE` /
  `merge_commit_message=PR_TITLE`; aligned (with the user's opt-in) to
  `PR_TITLE` / `PR_BODY` so `git log --first-parent` reads as PR titles.
  A GitHub-config change, so applied outside the PR diff rather than in it.

## Verification

- `npm run lint`: prettier + markdownlint clean on all four changed files.
  The stray `prettier --check .` warning on `.claude/settings.local.json`
  is a local untracked file ignored via global gitignore, absent in CI.
- `compare-managed-blocks.sh AGENTS.md`: all six blocks `ok`.

## To promote

- Nothing outstanding. Prior queue was already drained (the em-dash
  convention note landed in AGENTS.md Conventions & gotchas via
  2026-07-01-1505).
