# 2026-06-27 15:37 — Bootstrap + Codex reviewer record

First sessions: ran agent-setup to make the repo agent-ready, then recorded
the automated reviewer. Bootstrap landed as the `Initialize` commit directly
on `main` (the one allowed exception — you need a `main` to branch from);
this entry is the first conventional work unit, on a branch/PR.

## Decisions

- **Layout: `system/<tool>/` (by tool, with `system/` scope now).** Prompts
  are independent per-agent artifacts (not a shared source); co-locating
  them lets one PR carry a cross-cutting principle edit across tools.
  Chose to pre-build the `system/` scope even though only system-level
  prompts exist today; `project/` is a cheap sibling to add later.
- **Format the payloads (not byte-exact).** prettier (`proseWrap: preserve`)
  and markdownlint apply to `system/` too. The normalization is cosmetic
  (blank lines around headings) and LLM-irrelevant; uniform tooling beat a
  byte-exact carve-out. Reversible via `.prettierignore` if ever needed.
- **Lint scope.** `node_modules` excluded from the markdownlint glob;
  `prettier --check` covers the repo (LICENSE has no parser, skipped).
- **License: CC BY-SA 4.0** — knowledge artifact, matches sibling
  `free-skills`.
- **Repo settings** aligned: merge-commit only, branches auto-delete.

## This change

- Recorded **Codex** automated reviewer in an unmanaged AGENTS.md section:
  login `chatgpt-codex-connector` (`…[bot]` in REST), triggered on PR
  open / ready-for-review or a `@codex review` comment — _not_ on push
  (corrected from the initial assumption). Login confirmed by folding in
  Codex's own review of this PR, whose P2 flagged the placeholder TODO.

## Deferred

- `scripts/link.sh` symlink sync (modeled on free-skills' `link-skills.sh`) —
  README TODO; next work unit.
  -> promoted in `feat/link-system-prompts` (`scripts/link-system-prompts.sh`)
- Branch protection / ruleset — deferred until the repo goes public.
  -> Refs #17

## To promote

- Nothing outstanding.
