# 2026-07-01 10:15 Strip em dashes from system prompts; ban Claude-isms

User's system prompts were emitting em dashes and Claude-isms into commits and
other output. The `chat/` prompts already ban both; the `system/` payloads did
not, and their own prose was dense with em dashes the model then mimics.

## Decisions

- Removed every em dash (21 in `claude/CLAUDE.md`, 23 in `codex/AGENTS.md`) by
  rewording, not by mechanical substitution: paired appositive dashes became
  parentheses, single dashes became commas/colons/semicolons per sense. Meaning
  and the dense style preserved.
- **Em-dash ban lives in the SHARED core** (Communication section), byte-identical
  in both files: "Write without em dashes; use commas, colons, semicolons, or
  parentheses instead." Tool-neutral because both Claude and GPT/Codex overproduce
  em dashes, so it's a genuine cross-cutting principle, not a per-tool tilt.
- **Claude-isms ban is Claude-only**, in the `## Claude Code specifics` tail per
  the user's "in particular" scope: no flattery, stock prefaces, or self-referential
  filler ("You're absolutely right," "Great question," "Perfect!," reflexive
  "Let me..."). Gave the why (Claude tilt: motivation beats bare directive): the
  tics leak into commit messages and reviews. Mirrors `chat/claude/instructions.md`.
- Also stripped the dashes from the SHARED/END-SHARED HTML comment markers and the
  per-tool tails so the payloads are dash-free end to end, not just the body prose.

## Verification

- Passed: `grep -c '—'` → 0 in both payloads.
- Passed: SHARED core (line 1 → END SHARED) byte-identical across both files (diff clean).
- Passed: `prettier --check` on both changed files; `markdownlint-cli2` 0 errors.
- Noted: repo-wide `npm run lint` flags gitignored `.claude/settings.local.json`
  only (won't exist in CI checkout); unrelated, left untouched.

## To promote

- Candidate: add a one-line "payloads avoid em dashes" note to AGENTS.md's
  authoring conventions so the ban is documented as a repo convention, not only
  self-enforced by the prompts. Deferred to keep this PR scoped to the payloads.
