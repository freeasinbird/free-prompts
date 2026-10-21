# 2026-10-21 08:47 Remove Codex code review

The owner turned off Codex code review for this repository, both automatic
passes and `@codex review` on request. The project config now records no
automated reviewer.

## Decisions

- **Chose removing Codex entirely over keeping it on demand.** The owner
  decided against on-demand `@codex review`, so the reviewer record's login,
  clean-pass reaction, and status-comment details no longer describe
  anything an agent will see. Keeping them would invite agents to wait for
  or request passes that won't run.
- **Set the landing record's Reviewer to `none` and dropped its completion
  marker.** `land-approved-prs` holds back any PR without a completed round
  from the recorded reviewer on its current head, so leaving Codex recorded
  would stop every approved PR from landing. With `none`, the landing step
  falls back to a fresh-context reviewer or hands the PR back.
- **Kept a one-line "None" reviewer record instead of deleting the section.**
  The managed "Record an automated reviewer you observe" rule would
  otherwise let an agent re-record Codex from older PRs that still carry
  its reviews and reactions.
- **Left older Codex notes unchanged.** They record how the reviewer was
  configured at the time; this note supersedes them.

With no bot reviewer, the managed pre-push-review rule applies: risky work
gets a fresh-context review before pushing, and handoff relies on that and
the owner's review.

Revisit when the repository adopts another automated reviewer: record it
from an observed review, and set the landing record's Reviewer and
completion marker from that record.
