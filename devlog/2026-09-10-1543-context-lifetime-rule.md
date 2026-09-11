# 2026-09-10 15:43 Delegate by context lifetime, not model tier

User request: assess whether the payloads make Claude delegate reading and
review to cheaper models well, and whether Fable should hand rote
implementation to Opus or Sonnet subagents to save tokens. The assessment
ran on a month of local transcripts and a controlled trial, then landed as
free-prompts #48.

## Decisions

- **The shared core says context lifetime decides delegation.** Short,
  bounded, output-heavy work goes to a cheaper delegate at low effort with a
  return contract. Long-running or large-context work, including
  implementation and anything that waits on builds, tests, or reviews, stays
  in the main thread on the session model unless a tool-specific rule
  delegates it (the Codex review-fix delegate from 2026-08-02 is the
  standing case, at the main thread's own model and effort). The shared
  core owns the context-lifetime axis and thread placement, and carries
  only tool-neutral tier guidance: short bounded work to a cheaper delegate
  at low effort, and a session-capability floor for judgment. It sets no
  tier for the delegated long-lived case; the per-tool tail owns that, so
  the core neither restates nor contradicts a tail's routing, nor leaves
  that case under-specified by naming a tier the tail did not.
  Judgment runs on a model no less capable than the session's
  at any depth, which lets a tail route review up to a frontier tier but
  never down to a cheap one. Review of a diff is judgment, so the core's
  examples of cheap delegate work name reads only. This revises the 2026-07-02 Claude-tail decision to
  "send bulk mechanical work to the cheapest model that handles it reliably."
  That rule still holds for short reads. What changed is the measurement: a
  cheaper model in a long-lived subagent costs more, not less, because the
  bill is turns times context, and a delegate pays for its context on every
  turn and again when its cache lapses.
- **The Claude tail carries the mechanism, not the numbers.** A subagent's
  prompt cache is short-lived; a wait that outlives it rewrites the whole
  context. The tail says keep subagent waits short and put long waits in the
  main thread, and that appending is the expensive act. It does not name the
  5-minute subagent TTL, the 1-hour main-thread TTL, or the prices, upholding
  the 2026-08-20 decision that fixed durations and thresholds rot in a
  payload. The numbers live here and in the `await-pr-review` cost model.
- **The Codex tail keeps wait-once and gains its reason.** Codex's cache
  decays gradually rather than at a cliff, and one cold read after a long
  wait still costs less than the ticks it replaces. The added sentence says
  so without a duration, per the 2026-09-02 decision.
- **"Non-trivial" in the review rule now means risk, not size.** The Claude
  tail's independent-eyes rule names the risk conditions from the
  refute-first list and says a large mechanical change with CI and a bot
  reviewer relies on those. free-skills #262 makes the same change in the
  managed sections that agent-setup ships.

## Findings

Claude Code, 446 sessions on Fable from Aug 11 to Sep 10, about $1,940:

- Reading and exploration were already delegated to cheaper models when
  delegated at all; no Explore agent ran on Fable. Implementation was never
  delegated (1 of 205 spawns).
- Cache writes were about half of main-thread cost and 82 percent of
  review-conductor subagent cost. Conductor subagents get a 5-minute cache;
  32 percent of their cache-write tokens came from full rewrites after
  waits of 5 to 10 minutes. The worst run rewrote a 290k-token context ten
  times.
- Every Fable turn ran at high effort. Effort was not measured and is not
  a rule here.

Trial, two merged freeside issues rerun headless from their base commits,
Fable solo against Fable orchestrating an Opus or a Sonnet implementer:

- One-file doc edit (#1067): $2.52 solo, $2.72 with Opus, $2.71 with Sonnet;
  the delegated arms were 10 to 30 percent slower and tracked the merged PR
  more closely.
- 147-file rename (#986): $31.21 solo in 72 minutes, complete; $48.31 with
  Opus in 116 minutes, unfinished; about $33 with Sonnet in 101 minutes,
  unfinished. The Opus implementer spent about $29 re-reading its own
  context across 57M cache-read tokens. Fable's first pass did the whole
  rename for $13.35 in 32 minutes; the rest of its cost was a review round,
  a five-commit split, and a decision note.

Codex Desktop, 2,089 sessions over the same period, in tokens (no prices on
disk): 87 percent of top-level sessions spawned agents; exploration went to
`gpt-5.6-terra` at low effort and review conductors stayed on the session
model. Median context per call was 126k tokens with 110 calls per session.
Cached share stayed at 99 percent median under 10 minutes idle, then 31
percent of calls came back cold at 10 to 30 minutes and 66 percent past an
hour.

## Rejected Alternatives

- A cheaper implementation tier under a Fable orchestrator. The trial showed
  it costs more, takes longer, and finishes less on long work, and saves
  nothing on short work.
- Moving the review conductor to a cheaper model. Its per-run cost on Fable
  matched Opus (median $2.58 against $2.51) because its cost is context, not
  reasoning, and its triage needs session-model judgment.
- Naming the cache TTLs or prices in a payload. They are vendor values that
  change; the 2026-08-20 reasoning still holds.
- An effort-level rule. Untested; a week at medium effort on routine work is
  the next experiment, on both tools.

Revisit when Claude Code changes the subagent cache TTL, when either vendor
changes cache pricing, or when a later audit shows implementation delegation
costing less than main-thread work.
