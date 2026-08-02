# 2026-08-02 17:03 Codex tail: role-based subagent routing with pinned model names

User request: make Codex delegate correctly by routing subagent spawns to
an explicit model and reasoning effort per role, instead of the single
"cheapest tier that does the job reliably" clause the tail carried.

## Decisions

- **New routing bullet in the Codex tail** of `system/codex/AGENTS.md`,
  replacing the model clause inside the delegate bullet (a second rule
  beside it would have duplicated and conflicted; conflicting rules are
  the top Codex failure mode per the authoring guidance). Roles: mechanical
  reading at cheapest/low; refutation and security or correctness review at
  frontier/high; adjudication at frontier/high-or-xhigh.
- **Model names are pinned, revising 2026-07-02-1935's "no model-tier
  names" decision.** That decision was made for the Claude tail before
  Codex had subagents at all, and optimized for maintenance cost. The
  owner's stated priority here is routing determinism: tier-generic wording
  fails silently (the agent's knowledge cutoff predates the lineup, so it
  guesses, and a wrong guess produces no error), while a stale pinned name
  fails loudly at spawn. Mitigations: each name keeps its tier descriptor
  beside it so intent still routes approximately when stale, and the names
  carry a date stamp with a re-check condition, following the `gh` sandbox
  bullet's precedent. The Claude tail intentionally stays tier-generic;
  per-tool divergence in the tails is recorded policy (2026-07-14,
  2026-07-24).
- **No general "implementation" row.** Rejected: the user's initial
  proposal routed "conducting, implementation, and fixing" to a subagent
  tier. A routing table reads as an inventory of sanctioned roles, so a
  general row would license routine delegation of implementation and
  contradict "keep edits in the main thread."
- **Editing delegates get config parity, not a tier.** A review-watch's
  dominant activity is polling, so the mechanical row would otherwise
  capture it and its fixes would run at cheapest/low. Instead: a delegate
  that edits runs at the main thread's own model and effort (fixes are
  implementation arriving late, not a lesser role), stated relatively
  because the payload cannot set the main session's model. Generalized as:
  route a mixed-role delegate by the most demanding work it may do, not
  its dominant activity.
- **The main-thread-edits rule gains one scoped exception** (a delegate
  whose assigned job is applying fixes), because the review-watch workflow
  genuinely edits in a delegate; an absolute the agent watches being
  violated erodes the rules around it.
- **The routing mechanism is a three-branch decision rule, not a
  requirement** (two Codex review findings, both confirmed): some
  hosts' `spawn_agent` accepts only `task_name`/`message`/`fork_turns`,
  exposing neither model overrides nor a role selector, so an
  unconditional "pass on every spawn" is unexecutable there, and
  "use per-role agent files" alone still is when no definitions exist.
  Final shape: pass the fields where exposed; carry the routing in
  per-role agent files where the tool selects configured agents; where
  neither exists, spawn on `[agents]` defaults and say so rather than
  implying routed spawns. Whether this repo should ship synced per-role
  agent definitions is an owner design decision. Follow-up: #26.
- Codex tail only. Shared core untouched; Claude tail unchanged by the
  recorded divergence above; chat payloads have no subagents.

Revisit when the model lineup changes (the dated names go stale), or if
delegated implementation becomes routine in the Codex workflow (the
exception and parity clause would then need rethinking as a first-class
row).
