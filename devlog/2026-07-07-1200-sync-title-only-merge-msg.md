# Sync pull-requests block to canonical title-only merge messages

Ran `/agent-setup` update mode ("sync skill updates"). Only the
`pull-requests` managed block had drifted; the other five blocks and all
four scaffolding files already matched canonical.

## Decisions

- **Adopted title-only, reversing the 2026-07-05 opt-in.** Canonical's
  `pull-requests` text moved from "PR title and body become the merge
  commit message" to "the PR title is the _entire_ merge commit message:
  merges are title-only." Two days ago (2026-07-05 entry) we had opted the
  repo into title+body (`merge_commit_message=PR_BODY`). Surfaced the
  reversal to the user rather than silently flipping a recent decision;
  user chose to adopt title-only. Rationale in canonical: body review
  material (screenshots, verification, review notes) stays out of git
  history while `git log --first-parent` still reads as PR titles.
- **Block and repo setting move together.** Syncing the block alone would
  leave AGENTS.md saying "title-only" while the live GitHub setting said
  title+body, the exact internal contradiction the authoring rules warn
  against. So the setting flip is part of this unit even though it lands
  outside the diff.

## Fixed

- AGENTS.md `pull-requests`: refreshed to canonical (title-only wording in
  the Title bullet, the "durable record on the forge" body-currency bullet,
  the repo-settings-enforce bullet, and the explicit `--subject/--body`
  merge recipe). Comparator now reports all six blocks `ok`.

## Done outside the diff

- **Repo merge-message setting.** `merge_commit_message` `PR_BODY` → `BLANK`
  (title stays `PR_TITLE`); GitHub validates the combo, so both fields were
  PATCHed together. A GitHub-config change, applied outside the PR diff.

## Verification

- `compare-managed-blocks.sh AGENTS.md`: all six blocks `ok`.
- Scaffolding diff (devlog/README, PR template, CONTRIBUTING, CLAUDE.md)
  against canonical templates: all four MATCH; nothing to refresh.
- `prettier --check AGENTS.md` + `markdownlint-cli2 AGENTS.md`: clean.
  (The repo-wide `prettier --check .` warns only on untracked
  `.claude/settings.local.json`, gitignored and absent in CI.)
- `gh api repos/{owner}/{repo}`: confirmed `PR_TITLE` / `BLANK`.

## To promote

- Nothing outstanding.
