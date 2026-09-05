# 2026-09-05 09:04 Codex tail: apply the GPT-6 Astra prompting guide

User request: read OpenAI's "Using GPT-6 Astra" guide
(<https://developers.openai.com/api/docs/guides/latest-model>) and make sure
the Codex payload uses it well. The local Codex config already runs
`gpt-6-astra` at high effort as the main model.

## Findings

The guide names five habits of the model that prompting can change. Here is
how the payload covered each before this change:

- **Initiative.** Astra asks a question more often where older models made an
  assumption and kept going, and it may answer "can you..." by saying that it
  could. The shared core already says to do the work that doesn't depend on
  the answer before asking, and to treat a requested workflow as permission.
  It didn't say that a capability question is a request to do the work, or
  that the result should be ready before an approval is requested.
- **Instruction following.** Astra reacts more strongly to skills and
  instruction files, and unclear or conflicting guidance there can make it
  stop early. Nothing in the payload said the user outranks a skill, or asked
  the model to name the instruction that made it stop.
- **Writing style.** Astra over-formats and repeats stock phrases. The Claude
  tail has carried its own phrase list since 2026-07-01; the Codex tail had
  none.
- **Delegation.** Astra may delegate less than wanted. The vendor's prompt
  says to parallelize whenever it could save time or improve quality, whether
  root or subagent. Messages between agents can lose the spaces between words.
- **Testing.** Astra writes broader tests than a small change needs and
  repeats checks.
- **Lineup.** The dated model names in the routing bullet still called
  `gpt-5.6-sol` the frontier. The line's own re-check condition had fired.

## Decisions

- **Every addition goes in the Codex tail, not the shared core.** Each rule
  answers a habit the vendor documents for this model family. The Claude tail
  got its phrase list on the same basis (2026-07-01), and its
  progress-update rule likewise (2026-09-01). The core is byte-identical to before, and the Claude tail is
  untouched. Rejected: moving the skill-precedence and plain-writing rules
  into the core. Both read as tool-neutral, but the 2026-09-01 pass declined
  to add rules to the core that Claude's harness already covers, and there is
  no evidence that Claude needs either. Revisit if it does.
- **Four new rules, each short, each stating the rule and how to check it.**
  A capability question is a request to act, with approval as the last step
  and no approval flows for hypothetical risk. The user outranks a skill, and
  when a skill makes the model stop, it names the skill file and quotes the
  line. Tests match the size of the change and aren't repeated
  once green without a new reason. Prose is the default, with the vendor's
  stock-phrase list. One more clause asks for legible messages between agents.
- **The vendor's parallelization prompt is not adopted.** "Parallelize
  whenever it could save time or improve quality, root or subagent" conflicts
  with the recorded fan-out limit (2026-07-02, confirmed by the 2026-09-02
  usage audit, where the longest sessions were subagents spawning
  subagents). The existing "delegate read-heavy work" bullet already asks for
  delegation in the roles the owner wants delegated. Revisit if Astra visibly
  under-delegates exploration.
- **The vendor's phrase list is trimmed to habits the payload itself avoids.**
  Dropped: "genuinely" (the core uses it), hyphenated descriptors and
  "invented compound labels" (the payload uses "read-heavy" and
  "review-fix"), the nested-list clause (the routing bullet is a nested
  list), and the bans on "X, not Y" framing and on saying what you won't do. The core deliberately asks for explicit
  non-goals and for saying what was left out, and the payload's own headings
  use the contrast form. A payload that bans a habit it practices reads as a
  contradiction, which is the top Codex failure mode.
- **Frontier is `gpt-6-astra`; cheapest stays `gpt-5.6-terra`.** The vendor's
  subagent guidance sends exploration and read-heavy scans to Terra and
  limits the cheaper `gpt-5.6-luna` to clear, repeatable tasks such as
  extraction, so Luna isn't the tier for mechanical reading. That reason
  lives here rather than on the line, which stays terse. Astra costs about twice Sol per token for review delegates. The
  owner's 2026-08-02 priority was predictable routing at the main thread's
  own level, and the main thread now runs Astra.
- **Wording that keeps the new rules clear of the core.** The
  capability-question rule fires on a request for action phrased that way,
  not on the literal words, so "can you tell me whether X is feasible" stays
  a question. The name-the-file rule covers skills only, as in the vendor's
  text; widened to instruction files, it would make every confirmation this
  file itself requires owe a citation. "For hypothetical risk" attaches to
  the approval clause alone, so the core's "say so and recommend a safer
  path" still applies to real risk. The test rule points at the core's
  regression-test rule and keeps its "when reasonable" qualifier, so the
  low-impact-change exemption reads as a carve-out, not a blanket test
  mandate. The legibility clause sits in the writing bullet rather than the
  delegation bullet, so it applies when nothing is delegated.
- **Rejected: the guide's "don't settle for a partial or helpful-enough
  solution to save time, effort, or tokens".** The core's first priority
  (the requested level of robustness, polish, and completeness) and its
  finish-the-turn rule already say this.
- **Not addressed.** Async tool calling, mid-turn steering, and
  `configuration_update` are harness features that a prompt can't control.
  The `ultra` effort setting delegates automatically; it's a user-side
  setting, and if the owner selects it, the fan-out rule and the model's own
  delegation will compete. The ChatGPT chat payload is at its 1500-character
  cap and already prefers prose and bans stock prefaces; no trim was found to
  fund an addition (#23).

Revisit when a later Astra or GPT-6 guide reports that these habits changed,
when the model lineup changes, or when a usage audit shows Astra still
stopping on skill files despite the precedence rule. At that point the fix is
to audit the skills themselves, as the guide recommends.
