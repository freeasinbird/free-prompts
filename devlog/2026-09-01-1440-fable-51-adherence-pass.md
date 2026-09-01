# 2026-09-01 14:40 Fable 5.1 adherence pass

User request: review the four payloads against the newly published
"Prompting Claude Fable 5.1" guide and the defect taxonomy, then ship the
fixes as one PR. Review lenses: main-agent taxonomy pass plus one
fresh-context adversarial reviewer given only the payloads, the authoring
constraints, the prior-decision list, and the vendor guides.

## Decisions

- **Gate wording follows the failure mode, not the action.** The
  destructive-action gate no longer lists "anything that leaves the
  workspace"; it names "reaching an audience the request did not imply" and
  says a push or PR the requested workflow calls for is already authorized.
  Fable 5.1 and Opus 4.8 follow instructions literally, and the vendor's own
  sample gate list names "pushing code", so the old wording produced
  permission asks for steps the user had already requested. This keeps the
  2026-07-24 rule (gates name the failure mode) and the observed-incident
  example list.
- **Finish-the-turn rule enters the shared core.** Fable 5.1's guide names
  ending a turn on "Next, I'll..." as a distinct failure from asking
  permission. The rule is tool-neutral and two sentences, so it meets the
  coverage-gap bar. Mid-task questions now wait until the work that doesn't
  depend on the answer is done, matching the guide's "deliver progress with
  the question" pattern.
- **Extras are follow-ups, not changes.** Anthropic measured that an
  explicit "report it, don't fix it" instruction cut unrequested fixes and
  extra committed tests with no loss in task success. The recurring-checks
  rule (2026-07-23) is tightened in the same direction: the "second
  hand-inspection" trigger is dropped (it read as a two-use threshold against
  the ~3-use abstraction bar) and a script enters the project only when the
  task's scope covers it. The recurrence key is unchanged.
- **Progress updates are Claude-only; the whole-task recap is shared.** The
  guide says to remove narration-suppressing lines before adding an update
  request. The Claude tail's "Let me..." ban is now scoped to the filler
  phrase and paired with a one-line update request. The Codex tail keeps
  "without narrating it" because OpenAI's guidance trims preamble; the
  recap rule (open with the outcome of the whole task, not the last step)
  is tool-neutral and joins the core's bottom-line bullet.
- **The agent runs `/code-review` itself.** The 2026-07-24 note reworded
  that reference to suggest-only because the agent could not invoke it. In
  current Claude Code the skill is agent-invocable; only the `ultra` mode
  is user-triggered and billed. The changed assumption is invokability,
  so the wording now says run it when available, with the
  fresh-context reviewer subagent as the alternative.
- **Mannered-prose definition precedes the Claude-isms list.** The Fable
  5.1 guide recommends defining the anti-pattern; the Opus 4.8 guide prefers
  positive wording over a blacklist; the Fable 5 guide says a brief
  instruction steers as well as enumeration. The list stays, per the user's
  recorded preference (2026-06-27 chat-prompts note); the definition is
  added in front of it in both Claude payloads.
- **Self-consistency fixes.** Headings now match the payload's own
  title-case rule; "load-bearing" is gone from the core because the Claude
  tail bans it. Dense paragraphs (confirmation default, triage, Codex
  routing) become bullets with no rule change.

## Rejected

- Adding the guide's tool-call batching nudge or "act when you have enough
  information" line. The Claude Code harness injects both per turn.
- A whole-file-rewrite rule in the Claude tail. The harness's Write tool
  already directs partial changes to Edit; the line would be inert there.
- Porting the new chat/claude guards (don't stop at a plan; check the result
  against the request) to ChatGPT. The file is at its 1500-character cap
  and no literal restatement was found to trim. Still tracked in #23.
- The reviewer's proposed multi-sentence "narrate the run" core rule. Too
  prescriptive for Fable 5.1 (its guide warns that over-specified
  instructions degrade output) and it conflicts with the Codex tilt.
- Cutting the core's opening "project-specific facts live in each project's
  own config" sentence as inert. It tells the agent where project process
  is authoritative, which is actionable.
- Merging the two "suggest a fresh session" bullets. Distinct triggers.

## Revisit when

- A Fable 5.x guide reports that the update or finish-the-turn behavior
  has changed, making either rule over-prompting.
- Claude Code makes `/code-review ultra` agent-invocable, or removes the
  `/code-review` skill.
- The ChatGPT cap decision (portability at 1500) changes; then restore the
  chat/claude guards there.
