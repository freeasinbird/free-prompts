# 2026-10-25 10:13 Classify every always-on payload rule; remove none without an eval set

Work contract: [#70](https://github.com/freeasinbird/free-prompts/issues/70).
This audit is the work the
[fold-in-delegation note](2026-10-25-1120-fold-in-delegation.md) deferred
under Rejected Alternatives. Scope: `system/claude/CLAUDE.md` and
`system/codex/AGENTS.md`. Chat payloads are out of scope.

## Decisions

- **Classify, propose, remove nothing.** Every rule in both payloads is
  classified below as always-relevant, situation-specific, or plausibly
  redundant. Twelve move, trim, or refresh candidates carry evidence; none meets this
  repository's bar for a safe cut, the donor rule from the
  [2026-07-24 audit](2026-07-24-1500-payload-audit-hardening.md): trim only
  what is literally restated in the same payload, because an inference ("the
  model does this anyway") is not evidence. The owner decided each one in
  the audit session; see Owner Decisions. The payloads are unchanged in this
  work unit; the three approved edits land in a follow-up PR.
- **"Redundant with model defaults" is unverifiable here, for every
  candidate.** The repository has no eval set, and the one measured case of
  an in-context hint overlapping a payload rule went the other way: the
  [2026-09-02 wait audit](2026-09-02-0956-codex-wait-once.md) found the
  `wait_agent` tool's own "prefer longer waits" hint and Codex's collab prompt
  both present and both ignored (2,431 of 3,571 waits returned nothing). So
  harness or vendor text that restates a rule is evidence that the rule is
  duplicated, not that the behavior is default. The eval set is filed as
  [#71](https://github.com/freeasinbird/free-prompts/issues/71).
- **The three named candidates.** The pinned model lineup is stale on both
  ends and has an official config home: move it. The Codex event-wait rule
  is situation-specific but stays until the host's completion-driven waits
  land. The sandboxed `gh` note's premise still holds on current `gh`, so it
  stays with a refreshed date. Details under "The Three Named Candidates".
- **Project config duplication is the strongest move evidence, and it is
  partial.** The agent-setup managed sections (this repository's root
  `AGENTS.md` carries them) restate the fresh-session, independent-review,
  self-review, review-triage, and context-discipline rules for every project
  set up with them. A tail rule duplicated there is dead weight in those
  projects and the only copy in every other repository, scratch directory, and
  one-off session. Dropping one trades coverage for length; the owner owns
  that trade.
- **Skills are pull, so only procedure can move.** The
  [2026-07-23 decision](2026-07-23-2228-recurring-check-scripts.md) stands:
  a skill fires on task match or invocation, so it cannot set a default
  disposition. A rule moves to a skill only when it is procedure attached to
  a situation the agent will recognize before acting. Most of the payload is
  disposition. Both vendors now document the pull mechanism: Claude Code
  loads a skill body only when used, and Codex loads skill names and
  descriptions first with implicit invocation on by default. Locally, Claude
  has eleven skills linked; `~/.codex/skills` is empty, so a Codex move has no
  delivery channel yet.
- **Length is inside both vendors' guidance, so trimming for length alone is
  not justified.** Claude Code's memory doc asks for under 200 lines; the
  Claude payload is 145 lines (core 134, tail 12). Codex's guide asks for a
  concise file with task-specific guidance in referenced files or skills and
  caps the combined instruction chain at 32 KiB by default; the byte check
  under Findings flags a possible truncation that is a separate question from
  trimming.

## Method

- **Rule granularity.** One bullet or one bold-lead paragraph is one rule.
  Sub-bullets are part of their rule unless one is independently classifiable
  (the lineup line inside the routing rule).
- **Classes.** _Always-relevant_ (AR): applies on nearly every turn, or is a
  gate that must be present at the moment of action. _Situation-specific_
  (SS): applies only in a recognizable situation; candidate for a skill or
  project config. _Plausibly redundant_ (PR): vendor guidance or harness text
  indicates the behavior is default or duplicated; always unverifiable here.
  A rule can carry two marks.
- **Evidence tiers.** E1: a recorded failure in this repository's notes that
  motivated the rule. E2: a vendor guide statement about default behavior,
  from the Anthropic prompting best practices, the Opus 5.5 guide, the Claude
  Code memory and skills docs, the fold-in-subagents article, the GPT-6 Astra
  guide, the Codex prompting guide, and the Codex AGENTS.md, config, skills,
  sandbox, subagents, and models pages, all read 2026-10-25. E3: overlap with
  the Claude Code system prompt observed in this session (desktop app,
  2026-10-25); other surfaces may differ, and the Codex harness text was not
  observable. E4: duplicated in agent-setup managed sections or a skill the
  owner ships. E5: a live check run for this audit.
- **Verdict column.** _Keep_ means no action proposed. _Owner_ means a move
  or trim is proposed for the owner's decision. Every PR mark is
  "unverifiable without an eval set" unless an E5 check says otherwise.

## Findings

- **The local Codex config contradicts the payload's lineup line.** The
  payload says frontier is `gpt-6-astra` and cheapest is `gpt-5.6-terra` as
  of 2026-09. `~/.codex/config.toml` runs `gpt-6.1-sol`; OpenAI's Codex
  models page recommends `gpt-6.1-sol` for complex coding and names
  `gpt-6-luna` as the cheap tier, and lists `gpt-5.6-terra` only as remaining
  available during rollout. The line's own re-check condition has fired. The
  Codex subagents page documents a precedence for model and effort: custom
  agent file, then explicit spawn value, then `[agents]` defaults, then the
  parent's value. Issue #26 (ship synced per-role agent definitions) is the
  open decision that would give the names a config home.
- **`gh auth status` still misreports a network failure as a bad token.**
  Live check, gh 2.99.0 (2026-09-01) with HTTPS routed to a closed port:
  `gh auth status` printed "The token in keyring is invalid"; `gh api user`
  and `gh pr list` printed the proxy connection error correctly. The false
  alarm arises when the agent runs `gh auth status` to diagnose a failed call,
  which is what an agent does. openai/codex issues #31017, #37235, #19262,
  and #21821 and cli/cli #12891 are open; Codex's sandbox docs still default
  network off under `workspace-write`, and no Codex doc page mentions the
  misreport.
- **Codex waits are moving toward completion-driven resumption at the host.**
  Issue #41875 (open) records the 30-second default `wait_agent` timeout and
  that each expiry re-enters the parent with full context; #24951 (open)
  records a timeout not enforced during a stall. The 0.164.0 changelog
  (2026-10-23) adds feature-flagged root-session wakeups on agent messages and
  suspends root turns while descendants live. #61 tracks this boundary. The
  owner's `await-pr-review` skill already carries the same wait mechanics for
  review-watch runs (`references/detection.md`, `references/conductor.md`).
- **Vendor guides describe the tail habits as current, not fixed.** The
  Astra guide says the model asks clarifying questions and stops where users
  expect it to proceed, is more sensitive to skill and AGENTS.md text, tends
  toward detailed formatted responses with reused phrases, over-tests small
  changes, and may delegate less than desired. The Opus 5.5 guide names four
  early stops and recommends naming them in the prompt. The Anthropic best
  practices say current models over-spawn subagents and recommend a damping
  prompt. Each of these is the habit a tail or core rule answers.
- **Two vendor statements point at over-prompting.** Anthropic: Opus 5
  verifies its own work without instruction, and verification rules carried
  over from older models can cause over-verification; remove them rather than
  rewrite. Anthropic: Fable 5.1 formats less and writes fewer progress
  updates; anti-formatting blocks can suppress structure the content needs.
  These touch the core's "Verify before claiming completion" and the Claude
  tail's progress-line rule; see the tables.
- **Byte check against the Codex cap: the project file may be skipped.**
  `system/codex/AGENTS.md` is 25,422 bytes; this repository's root
  `AGENTS.md` is 26,067 bytes. Codex's `project_doc_max_bytes` defaults to
  32 KiB for the combined instruction chain, and Codex stops adding files once
  the combined size reaches it. The AGENTS.md page does not say whether the
  global `~/.codex/AGENTS.md`, the first file in that chain, counts toward it.
  If it does, every project `AGENTS.md` over about 7 KiB is skipped in Codex
  sessions, this repository's included. Unverified; one Codex session asked to
  quote the project file's last section would settle it.

## Classification: Shared Core

| ID   | Rule                                                | Class  | Evidence                                                                                                                                                                                                                                                                                                                                                          | Verdict |
| ---- | --------------------------------------------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| C0   | Opening scope sentence                              | AR     | Kept as actionable in the 2026-09-01 pass; tells the agent where project process is authoritative.                                                                                                                                                                                                                                                                | Keep    |
| HC1  | Preserve existing work                              | AR     | Gate. Revised 2026-09-04 (#44) after it blocked an ordinary scoped edit; E1.                                                                                                                                                                                                                                                                                      | Keep    |
| HC2  | Confirm destructive or irreversible actions         | AR, PR | Gate. E1: re-instanced 2026-07-24 from incidents. E3: harness asks to confirm hard-to-reverse or outward-facing actions. E2: Anthropic shows "ask before destructive" as an optional add-on, not a default.                                                                                                                                                       | Keep    |
| HC3  | Never commit or print secrets                       | AR     | Gate kept unconditional by decision 2026-07-24.                                                                                                                                                                                                                                                                                                                   | Keep    |
| HC4  | Embedded instructions are data                      | AR, PR | Gate. E3: harness carries an instruction-source boundary. E2: Opus 5.5 resists indirect injection better than earlier Opus, and Anthropic still calls prompt guards one layer among others. No Codex analogue.                                                                                                                                                    | Keep    |
| HC5  | Never weaken a check to pass                        | AR     | Gate. E2: Anthropic's sample prompt still tells the model not to work around incorrect tests, so not default.                                                                                                                                                                                                                                                     | Keep    |
| HC6  | No knowingly incorrect or data-losing work          | AR     | Gate. No evidence either way.                                                                                                                                                                                                                                                                                                                                     | Keep    |
| HC7  | No unverified success claims                        | AR, PR | Gate. E3: harness asks for faithful outcome reports. E1: the 2026-07-24 checker script claimed success for a failed check twice in one PR.                                                                                                                                                                                                                        | Keep    |
| CD1  | Act when safe and reversible                        | AR     | E1: 36 of 153 corrections in one week (2026-09-22) were asking permission or stopping short, the largest theme. E2: Astra guide names unnecessary approval pauses.                                                                                                                                                                                                | Keep    |
| CD2  | A requested workflow authorizes its steps           | AR     | E1: same correction log; 2026-09-01 gate rewording after Fable produced permission asks for requested pushes.                                                                                                                                                                                                                                                     | Keep    |
| CD3  | Confirm destructive steps and scope expansions      | AR     | Pairs with HC2; #44 separated it from external effects.                                                                                                                                                                                                                                                                                                           | Keep    |
| CD4  | Otherwise confirm only on material ambiguity        | AR     | Pairs with CD1.                                                                                                                                                                                                                                                                                                                                                   | Keep    |
| CD5  | Scale watchfulness to risk                          | AR     | Calibrates CD3; no separate evidence.                                                                                                                                                                                                                                                                                                                             | Keep    |
| P1-5 | Priority order and the override sentence            | AR     | Fires whenever options compete. Priority 3 and 5 wording revised 2026-07-01 and 2026-07-24. No vendor statement.                                                                                                                                                                                                                                                  | Keep    |
| D1   | Simple over easy, separate concerns                 | AR     | Owner design stance; no vendor default stated.                                                                                                                                                                                                                                                                                                                    | Keep    |
| D2   | No premature abstraction                            | AR, PR | E2: Anthropic names over-engineering as an Opus 4.5 and 4.6 tendency and offers the counter-prompt conditionally ("if you're seeing this"); current status on Opus 5.5 and Fable not stated.                                                                                                                                                                      | Keep    |
| D3   | Reuse before building                               | AR     | Added 2026-06-27 to close a gap; dependency clause 2026-07-01.                                                                                                                                                                                                                                                                                                    | Keep    |
| D4   | Explicit over implicit; update the design           | AR     | Restored 2026-07-24 after an over-cut removed the duty to act.                                                                                                                                                                                                                                                                                                    | Keep    |
| D5   | Fail correctly                                      | AR     | Owner stance.                                                                                                                                                                                                                                                                                                                                                     | Keep    |
| CS1  | Idiomatic code first                                | PR     | Generic; no vendor statement; plausibly default for any current coding model. One line.                                                                                                                                                                                                                                                                           | Owner   |
| CS2  | Functional style where idiomatic                    | AR     | Owner taste, not a default anywhere; performance clause restored 2026-07-24.                                                                                                                                                                                                                                                                                      | Keep    |
| CS3  | Clear names over clever                             | PR     | Generic; no vendor statement. One line.                                                                                                                                                                                                                                                                                                                           | Owner   |
| CS4  | Direct control flow over abstraction                | AR     | Restored 2026-07-24; distinct from D2.                                                                                                                                                                                                                                                                                                                            | Keep    |
| CS5  | Types and tests make invalid states impossible      | AR     | Owner stance.                                                                                                                                                                                                                                                                                                                                                     | Keep    |
| CS6  | Least code that stays clear                         | AR     | Pairs with D2; no vendor default.                                                                                                                                                                                                                                                                                                                                 | Keep    |
| CS7  | Comment the why                                     | AR     | Owner stance.                                                                                                                                                                                                                                                                                                                                                     | Keep    |
| CS8  | No annotations outside the change                   | AR     | E2: Anthropic's sample scope block includes this exact line as a conditional fix for over-eagerness; E1: 2026-09-01 cites Anthropic's measurement that "report, don't fix" cut unrequested edits.                                                                                                                                                                 | Keep    |
| W1   | Stick to your task                                  | AR, PR | E1: 22 misread or scope-drift corrections in one week. E3: harness says the requested scope is the deliverable.                                                                                                                                                                                                                                                   | Keep    |
| W2   | Look before you ask or assert                       | AR     | E1: 21 corrections. E2: Opus 5.5 guide says the model gets to work quickly and a one-line explore instruction improved accuracy.                                                                                                                                                                                                                                  | Keep    |
| W3   | Finish the turn's work                              | AR, PR | E2: Opus 5.5 guide names the early stops as current behavior and says to name them. E3: harness carries a near-literal closing-paragraph check. E1: Codex stops at a report (2026-09-22), so the core needs it.                                                                                                                                                   | Keep    |
| W4   | Stop only when blocked                              | AR     | E2: Opus 5.5 guide's "deliberately protected" blocker; closes the `--no-verify` route.                                                                                                                                                                                                                                                                            | Keep    |
| W5   | Fix a miss once it's named                          | AR     | E1: about 8 corrections in one week.                                                                                                                                                                                                                                                                                                                              | Keep    |
| W6   | Scale effort to the task, with four sub-bullets     | AR     | E2: see W2. "Read the files" restored 2026-07-24. XT1 modulates the acceptance-criteria sub-bullet for Codex.                                                                                                                                                                                                                                                     | Keep    |
| W7   | Stay focused; extras are follow-ups                 | AR     | E1: Anthropic measurement cited 2026-09-01; effective, so not default.                                                                                                                                                                                                                                                                                            | Keep    |
| W8   | Keep judgment with the main agent                   | SS     | Delegation only, but a disposition: it must be present at spawn time, and skills are pull.                                                                                                                                                                                                                                                                        | Keep    |
| W9   | Default to the main thread; delegate by lifetime    | SS     | Revised 2026-10-25 (#69). E2: Anthropic says current models over-spawn and recommends a damping prompt; Astra guide says Astra under-delegates. Disposition.                                                                                                                                                                                                      | Keep    |
| W10  | Verify before claiming completion, three bullets    | AR, PR | E2: Opus 5 verifies without instruction and carried-over verification rules can over-verify; Anthropic says remove, not rewrite. Bullets 2 and 3 (check against criteria, say what wasn't verified) are reporting, not covered. Strongest E2 trim candidate in the core; Codex has the opposite habit (over-testing), so a core cut would need a Codex tail line. | Owner   |
| W11  | Self-review before handing off                      | AR, PR | E4: agent-setup "Self-review the full diff" restates it in agent-setup projects. Disposition for any change elsewhere.                                                                                                                                                                                                                                            | Keep    |
| W12  | Turn recurring checks into scripts                  | SS     | Applies when an analysis will recur. 2026-07-23 chose core over skill because skills are pull; revisit condition there stands.                                                                                                                                                                                                                                    | Keep    |
| W13  | Understand what you're fixing                       | AR     | No vendor statement.                                                                                                                                                                                                                                                                                                                                              | Keep    |
| W14  | Triage review findings on their merits, six bullets | SS, PR | Applies in review rounds. E4: agent-setup "Judge review comments on their merits" and `docs/agent-workflow.md` §review-convergence, plus `await-pr-review/references/review-response.md`, carry the detail. The lead sentence and the two-question test are disposition; bullets 3 to 6 are procedure.                                                            | Owner   |
| W15  | Don't thrash                                        | AR     | 2026-09-29 left the "stop" wording unchanged pending the owner's call on whether it ends the turn.                                                                                                                                                                                                                                                                | Keep    |
| L1   | Filter tool results at the source                   | AR, PR | Every tool call. E4: agent-setup Context Discipline restates it. Revised 2026-10-21.                                                                                                                                                                                                                                                                              | Keep    |
| L2   | Bulky results to files; truncation is incomplete    | AR     | E4: same section.                                                                                                                                                                                                                                                                                                                                                 | Keep    |
| L3   | Scratch files out of the project tree               | AR     | E1: 2026-07-07 review finding.                                                                                                                                                                                                                                                                                                                                    | Keep    |
| L4   | Deliverables go where the user can open them        | AR     | E1: 9 corrections in one week (2026-09-22).                                                                                                                                                                                                                                                                                                                       | Keep    |
| L5   | Don't re-read unchanged output                      | AR     | No vendor statement.                                                                                                                                                                                                                                                                                                                                              | Keep    |
| L6   | Brief, not inherited history                        | SS     | Delegation only; revised #69. Disposition.                                                                                                                                                                                                                                                                                                                        | Keep    |
| L7   | Batch independent reads                             | AR, PR | E3: harness asks for parallel independent calls. 2026-09-01 declined to add the vendor's batching nudge for that reason, then 2026-08-20 had already added this one on audit evidence.                                                                                                                                                                            | Keep    |
| L8   | Wait with a mechanism that re-enters on change      | SS     | Waiting only; stated mechanism-neutral by design (2026-08-20). The Codex tail carries the mechanics.                                                                                                                                                                                                                                                              | Keep    |
| L9   | One line when a delegate re-enters mid-task         | SS     | E1: 2026-09-20 user-observed recaps on host-created turns.                                                                                                                                                                                                                                                                                                        | Keep    |
| W17  | Persist decisions and progress                      | AR     | E2: Anthropic recommends state files for long-horizon work (harness-level). E4: agent-setup devlog convention is the project-level mechanism.                                                                                                                                                                                                                     | Keep    |
| Co1  | Direct, honest; don't agree to be agreeable         | AR, PR | E2: Anthropic describes current models as more direct and grounded; Anthropic also tracks sycophancy as an alignment concern.                                                                                                                                                                                                                                     | Keep    |
| Co2  | Concision and correctness                           | PR     | E2: Anthropic says current models are less verbose; Astra guide says Astra tends toward detailed responses. Redundant for Claude, not for Codex.                                                                                                                                                                                                                  | Owner   |
| Co3  | Bottom line first; whole-task recap                 | AR, PR | E1: 2026-07-27 research-based owner decision. E3: harness says lead with the answer. E2: no vendor prescribes the order.                                                                                                                                                                                                                                          | Keep    |
| Co4  | Write for a scanner                                 | AR, PR | E3: harness asks for short sentences and bold lead words.                                                                                                                                                                                                                                                                                                         | Keep    |
| Co5  | Show relationships visually                         | AR     | Owner preference. E2: Fable formats less, so the positive form is the vendor-recommended shape.                                                                                                                                                                                                                                                                   | Keep    |
| Co6  | Cap the open asks; act on your recommendation       | AR, PR | E1: about 10 corrections in one week. E3: harness asks for a recommendation, not a survey.                                                                                                                                                                                                                                                                        | Keep    |
| Co7  | Use warnings sparingly                              | AR     | E1: 2026-07-27 research basis.                                                                                                                                                                                                                                                                                                                                    | Keep    |
| Co8  | Reference code by path and line                     | AR, PR | E3: harness asks for `file_path:line_number`.                                                                                                                                                                                                                                                                                                                     | Keep    |
| Co9  | Avoid repetition                                    | PR     | E2: concision default (Claude). One line.                                                                                                                                                                                                                                                                                                                         | Owner   |
| Co10 | Title case for headings                             | AR     | Owner style; fires on every heading written.                                                                                                                                                                                                                                                                                                                      | Keep    |
| Co11 | Capitalize list items                               | AR     | Owner style.                                                                                                                                                                                                                                                                                                                                                      | Keep    |
| Co12 | No em dashes                                        | AR, PR | E1: 2026-07-01 dashes leaking into commits. E3: harness bans them in user-facing text only; the payload also covers commits, PR bodies, and comments. `check-payloads.sh` treats the ban as the payload's own style rule.                                                                                                                                         | Keep    |

## Classification: Claude Tail

| ID  | Rule                                       | Class  | Evidence                                                                                                                                                                                                                                                                | Verdict |
| --- | ------------------------------------------ | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| CT1 | Protect the main context; suggest `/clear` | SS, PR | E3: the harness's Agent tool text says to do a handful of tool calls yourself and not spawn when in doubt. E2: Anthropic says models over-spawn. E4: agent-setup Context Discipline. Revised #69.                                                                       | Keep    |
| CT2 | Set a return contract when delegating      | SS     | E3: harness brief guidance covers goal and scope, not return shape. E4: agent-setup asks for conclusions and `file:line`.                                                                                                                                               | Keep    |
| CT3 | Keep subagent waits short; long waits main | SS     | Only with long-lived subagents. The cache mechanics and the headless clause are procedure; `await-pr-review/references/cost-model.md` carries the numbers. Candidate: keep one sentence (long waits belong in the main thread), move the mechanics.                     | Owner   |
| CT4 | No quiet fan-out                           | SS, PR | E3: harness Agent text warns that several at once spend tokens the user didn't ask for. E4: agent-setup "Explain large parallel work first". A cost gate that must be present at spawn time.                                                                            | Keep    |
| CT5 | Suggest a fresh session for review rounds  | SS, PR | E4: agent-setup Context Discipline restates it, and `docs/agent-workflow.md` §handing-off tells the agent to leave the reminder out of the report. Only copy in non-agent-setup repositories.                                                                           | Owner   |
| CT6 | Say what you're doing on long runs         | PR     | E3: harness asks for an opening line and brief updates (desktop). E2: Fable 5.1 writes fewer updates; the 2026-09-29 note records that Opus 5.5 writes them unprompted. Model-conditional: redundant on Opus 5.5 and on the desktop harness, needed on Fable elsewhere. | Owner   |
| CT7 | Drop the Claude-isms                       | PR     | E1: 2026-07-01 leak into commits; the owner's recorded preference keeps the list. E2: Anthropic says current models are less self-celebratory and that naming specific patterns works where generic bans don't.                                                         | Keep    |
| CT8 | Get independent eyes on a risky diff       | SS, PR | E4: agent-setup "Use fresh eyes" plus §pre-push-review and §refute-first restate it. E3: harness Agent text says to delegate review for an unanchored read. Only copy in non-agent-setup repositories.                                                                  | Owner   |

## Classification: Codex Tail

| ID   | Rule                                                         | Class  | Evidence                                                                                                                                                                              | Verdict |
| ---- | ------------------------------------------------------------ | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| XT1  | Pre-work surfaces in the result                              | AR     | Resolves the core's acceptance-criteria sub-bullet against the vendor's trim-preamble tilt (2026-07-01). Without it the payload contradicts itself.                                   | Keep    |
| XT2  | Capability questions are requests to act                     | AR     | E2: Astra guide names the habit and supplies this prompt. E1: 2026-09-22 correction log.                                                                                              | Keep    |
| XT3  | User instructions outrank skills                             | AR     | E2: Astra guide states it and recommends the name-the-file prompt. Cannot live in a skill by construction.                                                                            | Keep    |
| XT4  | Edit surgically with one `apply_patch`                       | AR, PR | E2: the Codex prompting guide (pre-GPT-6 models) says batch logical edits, don't thrash with tiny patches; the Astra guide is silent.                                                 | Keep    |
| XT5  | Scale tests to the change                                    | AR     | E2: Astra guide says Astra over-tests and supplies this prompt.                                                                                                                       | Keep    |
| XT6  | Delegate read-heavy work only when filtering can't           | SS     | Revised #69. E2: Astra under-delegates; the owner's fan-out limit overrides the vendor's parallelize prompt (2026-09-05).                                                             | Keep    |
| XT7a | Routing mechanism: spawn args, agent files, fallback         | SS     | Procedure needed at spawn time. E2: Codex subagents page documents the precedence; `fork_turns` override behavior is an open issue (#20077), not a doc.                               | Keep    |
| XT7b | Role table: mechanical, review, adjudication, editing parity | SS     | Owner policy (2026-08-02); tier words, not names.                                                                                                                                     | Keep    |
| XT7c | Pinned lineup line (`gpt-5.6-terra`, `gpt-6-astra`)          | SS     | E5: stale, see Findings. 2026-08-20 recorded that model selection belongs in runtime config; 2026-08-02 pinned names for loud failure before a config home existed; #26 is that home. | Owner   |
| XT8  | Wait on events within the host's limits                      | SS     | E1: 2026-09-02 audit; revised 2026-10-21 (#60). E4: `await-pr-review` carries the same mechanics for review-watch runs. Host fix tracked in #61.                                      | Keep    |
| XT9  | No quiet fan-out                                             | SS     | Mirrors CT4; same gate logic.                                                                                                                                                         | Keep    |
| XT10 | Write plainly; vendor phrase list                            | AR     | E2: Astra guide says Astra over-formats and reuses phrases, and supplies the list.                                                                                                    | Keep    |
| XT11 | Sandboxed `gh` auth failures are false alarms                | SS     | E5: premise holds on gh 2.99.0; openai/codex issues open. Only on a `gh` auth error in a sandbox. No Codex skill channel exists locally.                                              | Keep    |

## The Three Named Candidates

- **Pinned model lineup (XT7c): move to config; refresh in the interim.**
  Chose "move" over "keep pinned" because the condition that justified pinning
  in 2026-08-02 (no config home, so names in the prompt failed loudly where
  tier words failed silently) no longer holds: the Codex subagents page gives
  model and effort an official precedence through custom agent files and
  `[agents]` defaults, and 2026-08-20 already recorded that model selection
  belongs there. Chose over "delete": the role table needs some binding to
  real models, and until #26 ships agent definitions the prompt is the only
  binding. The line is stale today (Findings), so the interim fix is a refresh
  to the current vendor lineup; the 2026-09-05 reason for keeping Terra over
  Luna for mechanical reading should be re-judged against the current models
  page, which now recommends Luna for narrow, high-volume work. Owner decides
  both the move and the interim names.
- **Codex event-wait mechanics (XT8): situation-specific, keep for now.**
  The rule applies only when spawned agents remain, which is a recognizable
  situation, and the review-watch skill already carries the same mechanics,
  so a split (one-sentence disposition in the tail, mechanics in the skill)
  is available. Chose "keep" over "split now" because the measured failure
  (2026-09-02) was an agent ignoring in-context hints during orchestration,
  which is exactly when skill pull is least reliable; because the rule covers
  spawns outside the review skill; and because the host is changing under it
  (0.164.0 wakeups, #61). Revisit when #61 closes: if the host resumes the
  agent on completion, the rule becomes a candidate for an E5 check (does the
  empty-wait share drop with the rule removed), which is the one removal here
  that could be verified without a full eval set.
- **Sandboxed `gh` auth note (XT11): situation-specific, keep, refresh the
  date.** The premise was verified live on current `gh` and the upstream
  issues are open, so the rule is not stale. Chose "keep in the tail" over
  "move to a skill" because the trigger is a misleading error the agent acts
  on immediately (re-authenticating), a Codex skill channel does not exist
  locally, and the rule is three lines. Chose over "delete as rare": rare but
  costly, since the failure mode is a destructive re-auth. The "as of
  2026-07" stamp should read 2026-10 with gh 2.99.0 named.

## Proposals for the Owner

Ranked by evidence strength. None is applied in this work unit; outcomes are
under Owner Decisions.

1. XT7c: move model names to agent definitions or `[agents]` defaults (#26);
   refresh the line now. E5.
2. CT5 and CT8: drop from the Claude tail if the owner accepts losing them in
   repositories without agent-setup sections. E4, literal duplication.
3. W14: keep the lead sentence and two-question test; move bullets 3 to 6 to
   the review skill or `docs/agent-workflow.md`. E4, partial duplication.
4. CT3: keep one sentence; move cache mechanics and the headless clause to
   `await-pr-review`. Procedure, no measured evidence either way.
5. XT11: refresh the date stamp. E5.
6. W10: consider cutting the first bullet for Claude per Anthropic's
   over-verification note, keeping bullets 2 and 3; Codex would need a tail
   line. E2 only; unverifiable without an eval set.
7. CT6: drop when the owner moves off Fable 5.1, or when running only on the
   desktop harness. E2 and E3; unverifiable.
8. CS1, CS3, Co2, Co9: one-line generic style rules with no E1. Unverifiable;
   the saving is four lines.
9. The remaining PR marks (HC2, HC4, HC7, W1, W3, W11, L1, L7, Co1, Co3, Co4,
   Co6, Co8, Co12, CT1, CT4, CT7, XT4) are duplicated by harness, vendor
   defaults, or project config but each has an E1 failure record or serves a
   surface without the duplicate. No action proposed.

## Owner Decisions

Decided by the owner on 2026-10-25, one proposal at a time, with the agent's
recommendation stated first each time.

- **XT7c: refresh now, move later.** The line reads cheapest `gpt-6-luna`,
  frontier `gpt-6.1-sol` (the main thread's model), stamped 2026-10. Chose Sol
  over keeping Astra as the review tier because judgment runs at the
  session's level and the session runs Sol; Astra costs five times Sol per
  token for a review delegate. Chose over tier words only because routing
  then falls back to the parent model until #26 ships definitions. The names
  move to agent definitions when #26 lands.
- **XT11: refresh the stamp** to 2026-10 and name gh 2.99.0; the rule is
  unchanged.
- **CT5: drop.** Chose the coverage loss in repositories without agent-setup
  over the duplicate, because the suggestion is tied to the PR handoff that
  agent-setup defines.
- **CT8: keep.** A review gate on destructive paths and credential surfaces
  is worth one bullet where agent-setup is absent.
- **W14, CT3, W10, CT6: keep as is.** W14's concrete bullets are what make
  the rule fire (the 2026-07-24 instancing rule). CT3's headless clause is a
  disposition no skill can supply. W10 already bounds verification to the
  smallest signal set, and Codex over-tests. CT6 exists for Fable 5.1;
  revisit on a model change.
- **CS1, CS3, Co2, Co9: keep.** Four lines are not worth an unverifiable
  cut, and Co2 and Co9 answer a documented Codex habit.
- **The approved edits land in a separate PR.** This work unit stays
  classification only, as #70 requires.

## Rejected Alternatives

- Removing any rule in this PR on the article's argument. The issue forbids
  it and the donor rule makes "the model does this" an inference.
- Treating harness overlap as evidence of model default. Weak by the
  2026-09-02 measurement, surface-specific, and version-volatile.
- Moving dispositions to skills. Skills are pull (2026-07-23); both vendors'
  skill docs confirm the load-on-use model.
- Trimming for length. Both payloads sit inside vendor length guidance.
- Running Claude Code's `/doctor prompt-audit`, which the memory doc says
  flags instructions written for older models. It is an interactive terminal
  command unavailable in this session; a cheap owner-side check.

## Follow-up

- Eval set for payload trims:
  [#71](https://github.com/freeasinbird/free-prompts/issues/71). It grades
  the proposals above, starting with W10, CT6, and the style rules, by
  rerunning the 2026-09-22 correction classifier over sessions with and
  without each rule.

Revisit when #61 closes (XT8 becomes checkable), when #26 ships agent
definitions (XT7c moves), when an eval set exists (every PR mark), or when a
Fable or Astra successor guide reports that a named habit changed.
