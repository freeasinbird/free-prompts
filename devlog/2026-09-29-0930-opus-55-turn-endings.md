# 2026-09-29 09:30 Opus 5.5 guide: name the early stops and the wanted stops

User request: read the "Prompting Claude Opus 5.5" guide and find what the
payloads should change to get the most from Opus 5.5 without hurting Fable
5.1 or the GPT models. Review lenses: main-agent taxonomy pass plus one
fresh-context adversarial reviewer given the payloads, the guide, the
authoring constraints, and the prior-decision list.

## Findings

The guide says Opus 5 prompts carry over unchanged, and most of its advice
is API or harness level (effort, `max_tokens`, thinking display, time
budgets, pasted-text tags). Three points reach a prompt payload:

- Opus 5.5 ends turns early in four named ways, and it responds to prompts
  that name those stops and the stops that are wanted. The core's
  "Finish the turn's work" (2026-09-01) named only the first.
- Its wanted-stop example includes a blocker that "is deliberately
  protected". The core's "an obstacle you cannot work around" could be read
  as license to route around a denied permission or a hook.
- A progress note sent as text with no tool call ends the turn. The Claude
  tail's progress line (2026-09-01) didn't say where the line goes.

## Decisions

- **Name the other three early stops in the shared core.** An offer to
  continue unless the user objects, a list of decisions none of which blocks
  the remaining work, and a pause at a milestone or after a long turn. The
  rule is tool-neutral: the 2026-09-22 correction log found Codex stopping at
  a report as often as Claude asked permission. Rejected: the guide's full
  unattended paragraph. The guide says to leave it out where a human is in
  the loop, and the 2026-09-01 pass declined a multi-sentence rule of that
  shape.
- **Deliberate protections are blockers, not obstacles.** The stop conditions
  get their own paragraph, "Stop only when blocked", because a buried sentence
  is the first one dropped (2026-09-22). A protection is one that forbids the
  operation itself: a denied permission, a policy, a hook. A hook that rejects
  a fixable defect (failing lint or tests) is not a block; the agent fixes and
  retries. Asking to lift a protection through the harness's own channel (a
  permission prompt, an escalation the policy allows) is not routing around
  it; the block holds once the ask is denied or unavailable. The examples stay
  generic so the core never names a Codex-only mechanism; the sandbox case
  lives in the Codex tail. Rejected: naming sandboxes in the core; dropping
  hooks from the list, which would reopen the `--no-verify` route the hard
  constraints close; and an exception for a policy that leaves a compliant
  route open, since a compliant route is ordinary work, not a block.
- **The Claude-tail progress line goes in the same message as the tool
  call.** This keeps the 2026-09-01 rule and removes its one defect. The rule
  stays Claude-only; Opus 5.5 writes such updates on its own, and Fable 5.1
  is the reason the line exists.
- **Delete the chat/claude "fuller structure" line.** "Analysis, then review,
  then answer" put the answer last, contradicting the same file's
  bottom-line-first rule, and it asked for reasoning written into the reply,
  which the guide says to remove now that thinking is always on. The
  paragraph above it already asks for reasoning, counter-case, and next steps
  on consequential questions.

## Rejected

- "Treat earlier answers as settled" (chat). Conflicts with "revise rather
  than defend" and "Fix a miss once it's named"; the guide warns it
  suppresses self-correction.
- "Explore broadly before any action" (multi-app). Conflicts with "small,
  well-scoped change: act" and widens injection exposure; "Look before you
  ask or assert" covers the useful part.
- Time budgets and "Time matters here". The harness must supply elapsed time,
  and the sentence pushes parallelism against the fan-out cap (2026-07-02).
- A pasted-text rule in the core or in chat/claude. Claude Code already tags
  pasted text and adds the guide's note; Codex and claude.ai don't tag it, so
  the rule would have nothing to work with. The user declined the chat
  version.
- Effort and model settings. User-side; a rule naming them is inert.
- Rewording "Don't thrash ... stop." to "stop patching, then take the changed
  approach". The current text can be read as "end the turn and report after
  two failures", which sits oddly beside the new early-stop list, but the
  user is unsure whether they want that check-in. Left unchanged.
- ChatGPT payload. At its 1500-character cap; nothing in the guide earns a
  trim there (#23).

## Revisit when

- A later Opus or Fable guide reports that the early-stop behavior changed,
  making the named list over-prompting.
- Transcripts show an agent treating a denied permission as an obstacle and
  routing around it despite the new wording; then the fix is a hook, not more
  prose.
- The user decides whether "Don't thrash" should end the turn.
