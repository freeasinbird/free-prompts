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

The final rule set carries three deliberate bounds: the bottom line
(a recommendation, answer, or gating ask) travels with any
assumption or caveat it stands or falls on, so a scanner never acts
on an unconditional headline; assumption-conversion is restricted
to questions a sensible default settles, with gating overflow
queued rather than assumed through; and rationing covers hedges and
warnings only below the threshold of changing the reader's decision
or trust, so material uncertainty stays surfaced, per the
over-reliance evidence.

## Rejected alternatives

- **A cap on questions total.** The owner flagged that real work
  often carries more than three questions; resolved as the per-round
  cap with the overflow split described above.
- **An unconditional uncertainty-disclosure rule.** The pre-existing
  "if unsure, say what would resolve it" contradicted flag
  rationing; both chat payloads now scope it to material (answer- or
  trust-changing) uncertainty.
- **Sharing text with the free-skills canonical section.** The
  parallel `communication` managed section in agent-setup governs
  durable project artifacts for any agent; this core governs the
  owner's agents' conversational output everywhere. Same principle,
  deliberately different text, no sync relationship.

## Chat payloads

Deferring the `chat/` payloads to the tracker was rejected against
the cross-cutting convention (chat prompts stay conceptually
aligned with a shared-core change in the same PR); the owner
directed the alignment to land here. Both chat payloads carry the
full rule set: bottom line first (recommendation or gating ask,
with its load-bearing assumptions), front-loaded key words, gating
questions a few at a time with suggested answers, and hedges and
warnings rationed to decision- or trust-changing content with rare
critical warnings kept distinct.

The ChatGPT payload sits at exactly 1,500/1,500 characters. Its
compression honors the 2026-07-24 payload-audit note's donor rule
(trim only content literally restated in the same payload;
inference-based cuts are unsafe) and that note's recorded
restorations, which this PR initially violated and then restored:
"or severity", the consequential/ambiguous/strategic triggers, the
"let me push back" example, and "without coaching" (the recorded
coverage substitute for the omitted fuller-structure guard) all
stand. Trims accepted as costs of the budget, pending owner
confirmation: "theatrics", "don't wait to be challenged", the
closing-position scope on needless offers/questions, the "For
files/data/code" scope, "real" in "the real problem", and "without
doing it" after "name out-of-scope decoupling".
Follow-up: #23.

Revisit when: the free-skills research reference upgrades or
contradicts a finding this rewrite leans on, the per-round ask cap
observably suppresses questions that should have been asked, or the
ChatGPT budget rises (restore the accepted-cost trims first, per
the 2026-07-24 note's restoration order).
