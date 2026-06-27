# 2026-06-27 16:49 — Correct Codex trigger: reviews on every push

The recorded **Automated reviewer** note in AGENTS.md said Codex triggers on
PR open / ready-for-review or `@codex review` — "not on every push." That is
wrong. Corrected it.

## What prompted it

While iterating on PR #4 (reuse-first rung), Codex posted a _second_ review
after a force-push, then a third after the next push — re-reviewing each push,
not just the open/ready events. User confirmed: **Codex reviews on every
push**; when a push produces no inline review, Codex either approved it (a
thumbs-up / no-findings review) or errored. Absence of findings ≠ absence of a
run.

## Decision

- Rewrote the trigger sentence: every push (plus open / ready / `@codex
review`), and added the "no findings is not no run" reading plus the practical
  consequence — advance the review-watch baseline to each new push rather than
  treating a prior review as final.
- Kept it in the unmanaged **Automated reviewer** section (agent-setup won't
  overwrite it); scoped to this one correction. The finish-line text already
  says "use the actual push event for open/push-triggered reviews," so it was
  consistent — only the reviewer record carried the wrong "not on every push."

## Verification

- Passed: `npm run lint` (prettier --check + markdownlint-cli2) clean.
- Observed basis: PR #4 drew Codex reviews at 21:37, 21:42 (post-push), with a
  further pass expected after the 21:46 push — re-review-per-push behavior, now
  user-confirmed.

## To promote

- Nothing outstanding (this entry _is_ the correction of a recorded invariant).
