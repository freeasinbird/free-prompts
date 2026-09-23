# 2026-09-22 22:01 Four core rules from a week of user corrections

User request: analyze the user's corrections to Claude Code and Codex over one
week of local logs (2026-09-15 to 09-22), then decide whether the system
prompts could prevent them. The user approved four of the five proposed edits
for a PR; the fifth is deferred below.

## Evidence

- **Volume.** 731 user messages (532 Claude, 199 Codex); 153 were corrections
  (116 Claude, 37 Codex). Two classifier agents labeled every message, one per
  provider, and the main agent reviewed every correction. Messages that added
  facts the agent couldn't have known counted as direction, not corrections.
- **Themes.** Asked permission or stopped short of authorized work: 36.
  Reasoning or content errors: 33. Misread the ask or drifted in scope: 22.
  Asked or asserted without checking reachable evidence: 21. Project
  bookkeeping: 11. Communication: 10. Deliverable left in a file: 9. Other: 11.
- **The two tools fail to finish differently.** In the freeside repo both
  failed to finish in about 7% of messages. Claude asked permission (16
  corrections against 1 for Codex); Codex stopped at a report or admission (8
  against 6 for Claude).

## Decisions

- **Look before you ask or assert (21 corrections, both tools).** Agents asked
  for facts in prior runs, issue state, or the running system, and stated
  device or run status without checking. The core's only related line, "Read
  the relevant files instead of guessing," sits inside the multi-file editing
  case and doesn't reach questions to the user or status claims.
- **Fix a miss once it's named (about 8, both tools).** "Did you commit?" drew
  "Want me to?", and an admitted tracker gap drew no fix until the user asked
  again. "Finish the turn's work" checks the closing paragraph for promises;
  an answer that admits a miss and stops has none to catch. The rule got its
  own paragraph instead of a fourth sentence in that one, because buried
  sentences are the first dropped. A destructive or irreversible fix still
  gets confirmed, and a deliberate choice gets its reason instead of a
  reversal, so a "why?" doesn't become agreeing to be agreeable. The
  Codex-tail capability-question rule (2026-09-05) covers first requests and
  stays as it is.
- **Sharpen "Cap the open asks" instead of adding a rule (about 10).** The user
  kept approving recommendations the agent had already made. The old sentence
  said to turn questions "a sensible default settles" into assumptions, and
  agents didn't treat their own recommendation as that default. The bullet now
  says so directly and names when to ask instead: the choice depends on the
  user's goals or taste, or a wrong guess would waste real work. Rejected: "a
  question gates only when a wrong guess is costly to undo," the first draft's
  test. A fresh-context review showed that on a branch almost everything is
  undoable, so the test would let an agent override a stated choice and burn
  the work. Also rejected: a new Confirmation-default bullet, which would have
  repeated the instruction in two sections. Remaining questions get a line of
  background, which the user asked for twice through /write-plainly.
- **Scope the context-lean file rules to working material (9).** The bullets
  "write large generated artifacts to a file" and "put scratch files in a
  session workspace" read as covering deliverables, so agents wrote handoff
  prompts and listening samples to the scratchpad and pointed at them. The new
  bullet sends text to the reply and deliverable files to a place the user can
  open, and says so when no such place is writable (a Codex sandbox or a cloud
  session). Scratch output still stays out of the project tree (2026-07-07).
  The examples leave out codes and keys so the bullet never reads as license
  to print a secret. Rejected: limiting the reply rule to "short" text, since
  the logged failure was a long handoff prompt. The one exception is text too
  long for one reply, which would be cut off; it goes to a file the user can
  open. A handoff prompt doesn't come near that limit.
- **Chat payloads unchanged.** Both already say to state a vetoable assumption
  and proceed, to verify changeable facts when tools allow, and not to end on
  a needless offer, which covers "Want me to?". The deliverable rule doesn't
  apply, since a chat reply is the deliverable. "Fix a miss" could apply in
  chat, but these logs were agent sessions only, so there's no chat evidence
  for it yet; port it if chat sessions show the same miss. The ChatGPT payload
  is also at its 1500-character cap.

## Rejected or Deferred

- **Claude-tail line naming the harness's commit and push default: deferred.**
  Claude Code's own instructions say to commit or push only when asked, which
  may explain Claude's higher permission-asking rate. The line would restate
  the core's "A push or PR the requested workflow calls for is already
  authorized," so it's worth adding only if the rules above don't close the
  gap.
- **No rules for reasoning errors or misreads.** "Stick to your task" already
  covers misreads, and the reasoning errors were model judgment in live
  debugging and a fiction-craft argument, not missing instructions.
- **Project fixes live in other repos.** 34 corrections came from five freeside
  exit-run sessions and 19 from freeside tracker upkeep; those call for a
  freeside skill and a check script. Commit misses in the
  reader-emotional-framework repo trace to that repo having no AGENTS.md.

Revisit when a later log pass still shows Claude asking before workflow steps
(commit, push, PR, issue filing, merge cleanup) at several times the Codex
rate. Then add the deferred Claude-tail line.
