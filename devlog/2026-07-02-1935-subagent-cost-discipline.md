# 2026-07-02 19:35 Subagent cost discipline + session splitting (Claude tail)

Request F from the user's reflection-notes.md addendum (outside this repo):
add subagent cost discipline and stronger session splitting to the global
working-principles payload. Motivation, quantified there: one session pushed
157M cache-read tokens through 1,596 nested subagent messages (58% of all
subagent spend); the longest single session was ~14% of all measured spend.

## Decisions

- **Three new bullets in the Claude Code specifics tail** of
  `system/claude/CLAUDE.md`: Right-size subagent models / No quiet fan-out /
  Suggest a fresh session for review rounds. "Protect the main context"
  stays verbatim (preserves the agent-actionable /clear wording decided in
  2026-07-01-1505).
- **Wording assessed via prompt-crafter** (taxonomy pass + independent
  fresh-context critique agent). Accepted findings:
  - Fan-out gate got a scope floor ("a single subagent for exploration or
    review is normal"); without it the gate contradicted the exploration
    and independent-review bullets.
  - Gate license is budget-or-go-ahead, not budget-only (user choice):
    "explicit token budget" as the sole license would make the agent nag
    for budgets. Agent states expected scale first either way.
  - Three bullets instead of one packed bullet (user choice): one rule per
    bullet; the buried review-fix clause would otherwise drop.
  - Session-splitting scoped to the next round at handoff, with an explicit
    "feedback before handoff is handled in-session" clause, so it can't be
    read as license to refuse in-scope review fixes.
  - "Cheapest model that can do it" -> "cheapest model that handles it
    reliably"; no model-tier names (they rot across generations).
- **Claude tail only, by design.** Codex CLI has no subagent fan-out or
  per-subagent model selection to govern, so no Codex-tail equivalent; the
  critique flagged a terse Codex port as an option, deferred as
  out-of-scope for this request. Chat payloads unaffected (no
  subagents/sessions in chat UIs). Shared core untouched; cores verified
  byte-identical.
- Quantified motivation lives here and in the commit body, not the payload.

## To promote

- Nothing outstanding.
