# 2026-07-01 15:05 Prompt adherence pass across all four payloads

User asked for a review of the system and chat payloads (how well they work
for Claude and ChatGPT/Codex, how to optimize). Review ran two lenses: my own
pass plus an independent fresh-context critique agent. Verdict: fundamentally
sound; defects were inert instructions, one contradiction, dense structure,
gate wording, and chat drift. Plan approved with all optional items.

## Decisions

- **Inert rules deleted, not kept as notes-to-self** (user choice via
  question). Verified against current Codex CLI docs first: reasoning effort
  is user-side (`/model` picker), `/compact` is no longer in the documented
  command set, "Plan mode" is not current Codex vocabulary. Deleted the
  reasoning-effort bullet; trimmed `/compact` + one-thread from Edit
  surgically; reworded Claude's `/clear` clause to suggest-the-user-clear.
  Don't re-add these as agent instructions; if wanted, they are human-facing
  README material.
- **Codex tail now answers the core's pre-work pointer** instead of
  contradicting it ("Don't preamble" vs core's restate-acceptance-criteria).
  New bullet: pre-work surfaces in the result, upfront plan only for
  genuinely ambiguous/architectural tasks.
- **Shared core gained two gate changes**: destructive-action gate reworded
  ("not clearly requested" + concrete git instances) and a new secrets bullet.
  Also priority 3 "that still solve the real problem" and a new-dependency
  clause on Reuse before building.
- **Dense core paragraphs (Code style, Scale-effort, Communication) split
  into bullets**, meaning preserved, per both vendors' structure guidance and
  the repo tilt table. Cores stay byte-identical.
- **ChatGPT chat prompt re-aligned**: restored "hidden" before assumptions;
  ported the anti-coaching guard ("without coaching"), funded by trimming
  "recommendation/next steps" to "recommendation". 1473 → 1487 chars of 1500.
- **gh sandbox bullet compressed** ~90 → ~55 words, behavior preserved (fresh
  from PR #8; content decisions untouched, register only).
- Rejected by verification: none. Accepted-by-decision skip: chat/claude
  needed no change (drift was one-directional, in the ChatGPT file).

## To promote

- Nothing outstanding. This PR clears the deferred em-dash-convention note
  from 2026-07-01-1015 (now in AGENTS.md Conventions & gotchas).
