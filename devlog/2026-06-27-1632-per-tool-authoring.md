# 2026-06-27 16:32 — Per-tool prompt authoring rules

Added a `## Per-tool prompt authoring` section to root AGENTS.md: how to take
one shared principle and render it as a Claude-flavored and a Codex-flavored
variant. Closes the gap where "Cross-cutting prompt edits land together" said
per-tool differences are _expected_ but never said how to produce them. First
of two work units; the reuse-first rung (next PR) is the first application.

## Decisions

- **Home: a section in root AGENTS.md, not a `system/AUTHORING.md`.** It's a
  development convention, and AGENTS.md is the declared single source of truth
  for those; it also extends the existing "Cross-cutting prompt edits" bullet
  (now cross-linked). Guaranteed-read (every session opens AGENTS.md) beats a
  separate file that only gets read if the link is followed. Respects the
  repo's anti-premature-structure ethos (cf. not pre-building `project/`).
  **Extract-on-evidence trigger:** if the section grows worked per-tool
  examples that bloat AGENTS.md, _then_ split to `system/AUTHORING.md` and
  leave a pointer — cheap and reversible.
- **Grounded in a deep-research pass, not memory.** Ran the deep-research
  workflow over current Anthropic + OpenAI prompting docs (Verification
  facts-only discipline applies to doc claims). 24/25 verified claims; sources
  cited inline in the section.
- **Shared core + per-tool tilts** framing (not a flat list of differences):
  both agents want clarity, internal consistency, and absolutes reserved for
  invariants; the tilts (emphasis/structure/rationale/verbosity) differ.

## Rejected / omitted

- **Sycophancy (Claude) and "over-literal compliance" (GPT)** as named,
  promptable failure modes — the research premise, but _unconfirmed_ by primary
  prompt-engineering docs (verified Claude mode is contradiction-arbitrariness;
  verified GPT mode is conflict-induced oscillation). Omitted, and the section
  says so, so a later session doesn't re-add them as fact.
- **XML-tag guidance** — real for Claude _API_ prompts, but these payloads are
  markdown memory/config files; including it would misapply it. Noted as a
  one-line aside in the table instead.
- No version-pinning (said "newer Claude," not specific model numbers) so the
  doc stays durable.

## Verification

- Passed: `npm run lint` (prettier --check + markdownlint-cli2) clean, 10 files.
- Checked: section renders; prettier-normalized table well-formed; anchor link
  `#per-tool-prompt-authoring` matches the heading.

## To promote

- Nothing outstanding (this entry _is_ the promotion of the convention).

## Deferred

- Full per-tool optimization of the existing (byte-identical) payload prose —
  out of scope here; the reuse-first rung PR begins the divergence with one
  principle. Larger rewrite is a future unit if wanted.
  -> Refs #19
- Pre-existing: `scripts/link.sh` (now in-flight on `feat/link-system-prompts`),
  branch protection until public — not touched.
  -> promoted in 2026-06-27-1537 (`scripts/link.sh`)
  -> Refs #17 (branch protection)
