# 2026-06-27 16:34 — Reuse-first rung in both payloads

Added a **Reuse before building** principle under `## Design principles` in
both payloads (`system/claude/CLAUDE.md`, `system/codex/AGENTS.md`). Closes a
real gap — the prompts had no reuse-first instruction — and is the first
application of the per-tool authoring rules added in the companion PR #3
(devlog entry `2026-06-27-1632-per-tool-authoring.md`, which lands with that
PR — plain reference, not a relative link, since either PR may merge first).

## Decisions

- **Placement: after "No premature abstraction," as a peer design principle.**
  Closest relative — both are "don't build more than the problem needs." Worded
  as **subordinate** to the existing principles (explicit "the principles above
  take precedence") so it can't be read as license to add coupling just to
  avoid a few lines.
- **Two optimized variants, not identical text** — first real exercise of the
  authoring rules. Claude variant carries the rationale ("keeps the surface
  small and the intent legible"); Codex variant is terser and more directive
  ("use it instead of building"), no narration. Same intent, different tilt.
- **"already-installed dependency" → "a dependency the project already declares
  in the appropriate scope"** (Codex P2, both payloads). "Installed" overshot:
  it could endorse importing a transitive, global, vendored, or dev-only
  package that isn't in the project's declared contract — green locally, broken
  on clean install / CI. "Declares in the appropriate scope" excludes all four.

## Scope

- Adds _one_ principle, optimized per tool. Did **not** rewrite the rest of the
  (still byte-identical) payload prose into per-tool variants — that larger
  optimization stays deferred (see prior entry) as its own future unit.

## Verification

- Passed: `npm run lint` (prettier --check + markdownlint-cli2) clean.
- Checked: both payloads read correctly; the rung sits under Design principles
  and reads as subordinate; the two variants differ in wording/emphasis only.

## To promote

- Nothing outstanding.
