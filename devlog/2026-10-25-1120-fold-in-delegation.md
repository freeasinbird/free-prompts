# 2026-10-25 11:20 Main loop by default; delegate only when filtering can't bound the read

User request: assess Anthropic's article "Building agents: when to fold
subagents into your main agent loop" (claude.com, 2026) and change the stored
system payloads where it warrants.

## Decisions

- **Make the main thread the default and put the burden of proof on the
  delegate.** The shared core's "Delegate by context lifetime" rule now
  states that the main thread does the work, and that a delegate is justified
  only when no filtered read bounds the output to what the step needs, when
  independence from this thread is the point (a review or refutation), or when
  a tool-specific tail rule assigns the work to a delegate. The previous wording listed
  what to delegate without stating the default, so the Claude tail's
  "Protect the main context" bullet read as "exploration goes to a subagent"
  and the Codex tail sent test runs to subagents. Both tails now say filter
  first, delegate second. Chose this over leaving the rules as they were
  because the article's quality argument, not only its cost argument, applies
  to a coding agent: an agent that saw each result can connect them, and a
  summary handed back cannot be connected to what it left out.
- **Add the lossy-handoff rationale beside the cost rationale.** The core's
  "why" previously gave only turns-times-context cost. It now names the
  quality loss first. The return-contract rule mitigates that loss but does
  not remove it, so the default matters.
- **Fork conversation history only for a session the user will talk to.**
  The core's brief bullet now states this test, and the Codex tail passes
  `fork_turns: "none"` with overrides instead of offering a partial fork. A
  delegate whose report returns to the main agent gets a brief.
- **Keep the fresh-context reviewer and the fan-out cap.** The article names
  the generator-verifier pair as the simplest acceptable multi-agent pattern,
  and the reviewer's justification is independence from the author's blind
  spots, not a problem-type split. Nothing in it argues against the cap.
- **Leave test runs in the main thread (Codex tail).** The 2026-08-02 routing
  note recorded the role table but took no decision on test runs; the line
  was incidental. A test run's output is filterable at the source and its
  result feeds the next edit, so delegating it is lossy and unnecessary.
  "Checks" leaves the routing table's mechanical-reading row accordingly.

## Rejected Alternatives

- Dropping delegation guidance entirely in favor of "one loop". The article
  keeps subagents for disposable parallel contexts and measured context
  degradation, which is what the retained rule covers.
- Trimming the always-on payloads under the article's progressive-disclosure
  argument (moving situation-specific procedure such as Codex event-wait
  mechanics into skills, or removing rules redundant with current model
  behavior). Deferred as its own work unit: many rules exist because model
  defaults failed, and this repository has no eval set to check a removal
  against.
- Porting any of this to the chat payloads. They expose no delegation
  surface, so the text would be inert.

Revisit when the platforms expose a measured context-degradation signal, or
when a repository eval set exists that can grade a payload trim.
