# 2026-06-27 18:18 — Refresh payloads; shared core + per-tool tail; reconcile docs

User supplied revised `CLAUDE.md` / `AGENTS.md` payloads. Replaced both
(`system/claude/CLAUDE.md`, `system/codex/AGENTS.md`) and reconciled the repo
docs to the new structure, in one PR.

## Structural shift

- Payloads moved from near-identical-but-independent files to a
  **byte-identical tool-agnostic core** (between `<!-- SHARED ... -->` /
  `<!-- END SHARED ... -->` markers) plus a **per-tool tail**
  (`## Claude Code specifics` / `## Codex specifics`). Verified the SHARED
  blocks diff clean after formatting.
- Content also expanded: Code style (least-code, comment-the-why, don't-annotate
  -untouched-code), a "scale effort to the task" Workflow with verify-against-
  acceptance-criteria + don't-thrash, tighter Design/Communication prose.

## Decisions

- **Reconcile docs in the same PR** (user choice). The old docs said
  "share ideas, not bytes / independent artifacts, not generated from a shared
  source" — directly contradicted by a byte-identical shared core. AGENTS.md's
  own "keep instructions internally consistent" rule applies to repo docs too,
  so leaving the contradiction was not an option. Updated: README layout note,
  Repository-layout bullet, Cross-cutting-edits gotcha, Per-tool prompt
  authoring opening + procedure. **Kept** the per-tool tilt table + sources —
  they now govern the tails and the rare genuinely-divergent principle, not
  every principle.
- **Two commits:** (1) payload swap = the cross-cutting prompt edit, both files
  together; (2) doc reconciliation = separate concern.
- **`npm run format` over `.prettierignore`.** Only normalization was
  `*why*`/`*what*` → `_why_`/`_what_`, applied identically to both files, so
  SHARED byte-parity is preserved. No need to pin byte-exact.
- **SHARED HTML comments ship to live configs by design.** The payloads sync
  verbatim, so the markers land in `~/.claude/CLAUDE.md` / `~/.codex/AGENTS.md`.
  Inert markdown comments, intended as maintenance aids — kept.

## Note

- Payloads are symlinked into live config on this machine, so the swap
  live-updated the user's global configs (the repo's intended sync behavior).

## Verification

- Passed: `npm run lint` (prettier --check + markdownlint-cli2) clean, 14 files.
- Checked: SHARED blocks byte-identical post-format (awk-extract + diff);
  tails are tool-correct; `grep` for old-model phrases in README/AGENTS.md
  returns none.

## Review (Codex)

- **P2 confirmed + folded into commit 1:** the shared-core sentence said repo
  facts "live in each project's AGENTS.md" — but in the byte-identical core that
  ships into `~/.claude/CLAUDE.md`, naming `AGENTS.md` is wrong for Claude
  (whose project memory is `CLAUDE.md`). The filename is tool-specific, so it
  doesn't belong byte-identical in the core. Made it filename-neutral ("each
  project's own config, not here") in both payloads, preserving SHARED parity.
  Good example of the new model catching its own leak.

## To promote

- Nothing outstanding (commit 2 promotes the convention change into AGENTS.md;
  this entry records the reasoning).
