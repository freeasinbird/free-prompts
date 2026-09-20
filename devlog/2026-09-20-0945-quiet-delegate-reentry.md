# 2026-09-20 09:45 One line when a delegate re-enters the agent mid-task

User request: Claude writes a full status report each time a subagent's
message or completion notice starts a new turn, which wastes tokens. The user
supplied draft wording and asked for it to be assessed against the payloads
and added where it fits, covering Codex too.

## Decisions

- **The rule is new coverage, not a duplicate.** The 2026-08-20 re-entry
  bullet stops the agent from creating a turn to report unchanged state. It
  says nothing about a turn the host creates, and three existing rules pull
  toward a recap there: "Finish the turn's work" asks the agent to say what is
  blocked, "Bottom line first" asks the final message to open with the whole
  outcome, and the Claude tail asks for a line before long runs. An agent that
  treats each host-created turn as a final message writes the full report
  every time.
- **It lives in the shared core, beside the re-entry bullet.** The principle
  reads the same for both tools: a delegate's message or a completion notice
  is input to act on, not a reporting point. Rejected: a Claude-tail rule plus
  a Codex-tail rule. The mechanisms differ (Claude Code starts a new turn,
  Codex returns from `wait_agent` inside one), but the wording covers both
  without naming either, and two tail copies of one principle would drift.
- **"End the turn" was cut from the user's draft.** The draft said "act on it
  and end the turn in one line at most." Read literally, that tells the agent
  to yield. The Claude tail forbids yielding to gating background work in a
  headless run, and the Codex wait-once rule says to handle the return and
  wait again. The shipped wording caps what the agent writes ("write one line
  at most") and leaves whether the turn ends to the rules that already own it.
- **"Blocked" joined the full-report cases.** The draft allowed a full report
  when the task is done or a decision is the user's. "Finish the turn's work"
  also ends a turn on a blocker and asks the agent to say what is blocked, so
  the new rule names that case to avoid contradicting it.
- **"Ledgers" became "progress, plans".** "Ledger" is a term from the
  `await-pr-review` skill, not from these payloads, so an agent outside that
  skill has nothing to map it to.
- **One line stays allowed.** A cap of zero would contradict the Claude tail's
  "note when the plan changes" and hide a changed plan from a user watching
  the run.

Revisit when transcripts still show recaps on host-created turns after this
ships. The next lever is then the skill that drives the run (`await-pr-review`
keeps a disposition ledger and says when to surface it) or a hook, not more
core text.
