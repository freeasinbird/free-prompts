# Communication core rewritten for how humans actually read

## Decision

Rewrite the shared-core Communication section around
reading-behavior research: bottom line first, scanner-oriented
front-loading, a per-round cap on open asks (about three, each with
a recommended default), and rationed flags. This flips the prior
conclusion-last ordering (assumptions, reasoning, weak points, then
recommendation), which put the load-bearing line where readers
statistically stop reading.

Basis, from a research pass on 2026-07-27: humans have time to read
only ~20-28% of on-screen words (NN/g, a page-view duration model)
and scan the first lines and line-starts (NN/g eye-tracking);
working memory holds ~4 chunks (Cowan 2001); neural
response to repeated warnings drops by the second exposure and
clinical alert override rates run high, 46.2-96.2% across a
systematic review's studies (habituation and alert fatigue); humans
over-rely on AI output, and engagement-forcing interventions reduce
that where explanations and a displayed confidence prompt did not
(Bucinca et al. 2021). The sourced synthesis with
evidence grades lives in free-skills at
`skills/agent-setup/references/writing-for-humans.md` (PR
freeasinbird/free-skills#108); it is deliberately not duplicated
here.

## Rejected alternatives

- **A cap on questions total.** The owner flagged that real work
  often carries more than three questions; resolved as a per-round
  cap. Overflow splits by kind (a Codex review finding tightened
  this): questions a sensible default settles become vetoable stated
  assumptions, while gating questions queue for a later round, never
  silently assumed through. The same review bounded flag-rationing:
  uncertainty that changes how much to trust a result stays
  surfaced, per the over-reliance evidence. A second round moved
  load-bearing assumptions and caveats into the opening bottom line
  itself, so a scanner never acts on an unconditional headline.
- **Sharing text with the free-skills canonical section.** The
  parallel `communication` managed section in agent-setup governs
  durable project artifacts for any agent; this core governs the
  owner's agents' conversational output everywhere. Same principle,
  deliberately different text, no sync relationship.

## Deferred

`chat/` payloads (Claude chat instructions, ChatGPT custom
instructions) stay on the old ordering for now; aligning them within
their per-product constraints is tracked in the follow-up issue.
Follow-up: #23.

Revisit when: the free-skills research reference upgrades or
contradicts a finding this rewrite leans on, or the per-round ask
cap observably suppresses questions that should have been asked.
