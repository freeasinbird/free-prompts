# 2026-07-14 20:25 Adopt the Decision-log profile, retire the queue protocol

Ran `/agent-setup` in update mode. The canonical sections replaced the
per-session devlog protocol with a profile system; this note records
the migration decisions. Owner-directed (the /agent-setup invocation
named the migration explicitly).

## Decisions

- **Chose the Decision-log profile** over Standard and High-assurance.
  Standard would drop durable rationale this repo demonstrably uses:
  all 16 historical entries record decisions with rejected
  alternatives, and prompt-authoring work turns on exactly that kind
  of judgment. High-assurance was rejected because the owner named no
  change classes that must always carry a note; the finish line's
  refute-first risk classes (destructive paths, credential surfaces,
  trust boundaries) already cover the rare risky change without a
  mandatory-note list. Recorded as the `Agent-setup profile:` line in
  AGENTS.md's intro.
- **Retired the queue protocol without a final sweep of entries.** Per
  the new canonical: no per-session entries, no latest-entry reading,
  no `## To promote` sweeps, no `-> re-deferred` clocks, and no more
  edits to frozen entries (the `->` marker exception is gone). The 16
  queue-era entries stay byte-frozen as evidence; devlog/README.md's
  Historical entries section says how to read them.
- **Legacy queue audited once, empty.** The 2026-07-08 session had
  already drained every queue item: marked drained in place or
  escalated to issues #17/#18/#19. The owner closed all three on
  2026-07-13 with no work done on them (the repo is still private, so
  #17's trigger never occurred): read as the owner dropping open-work
  bookkeeping for conditional ideas, which matches the new protocol's
  stance. They are recognized here as observations, not reopened:
  - Revisit when the repo goes public: add branch protection / a
    ruleset on `main` (require the lint and shellcheck checks, block
    direct pushes); unavailable on the current private free plan.
  - Revisit when a Windows consumer of the system prompts appears: a
    native PowerShell variant of `scripts/link-system-prompts.sh`.
  - Revisit when per-tool payload divergence becomes worthwhile:
    optimizing the byte-identical `system/<tool>/` prose per tool
    beyond the reuse-first divergence already begun.
- **Kept the Codex automated-reviewer record and the nested
  done-checks block untouched**; both sit where syncs don't reach, and
  the tracker conventions they encode (filter review activity by
  login, evaluate findings on merits) remain useful under the new
  protocol.
- **Enabled `allow_update_branch`** (Always suggest updating pull
  request branches) to back the new base-freshness bullets in the
  pull-requests block; the other merge settings already matched.
