# 2026-09-02 09:56 Codex waits once at the maximum timeout

User request: a local usage audit found Codex orchestrators polling
`wait_agent` with short timeouts (2,431 of 3,571 waits returned nothing; 60s
was the most common timeout) and calling `list_agents` for status. Add the
lever to the Codex payload.

## Decisions

- **Concrete wait mechanics live in the Codex tail, not the shared core.** The
  core already carries the tool-neutral re-entry rule from 2026-08-20. The
  audit shows Codex does not turn that principle into tool calls, and the fix
  names Codex tools (`wait_agent`, `timeout_ms`, `list_agents`) that Claude
  Code lacks, since its harness re-invokes the model when a subagent finishes.
  Rejected: rewording the core. It is already correct and Claude follows it.
- **No numeric timeouts in the payload.** Upholds the 2026-08-20 decision that
  fixed wait durations rot. Verified from the openai/codex source on
  2026-09-02: the default is 30s, the minimum 10s, the maximum 3600s, all
  configurable under `multi_agent_v2`; the v1 `wait_agent` takes agent ids
  and v2 waits on any mailbox update. The rule says "the tool's stated
  maximum" and "where the tool takes one" so it survives both tool versions
  and config changes.
- **A nonfinal return earns another full-length wait.** A v2 wait returns on
  any mailbox update, and the maximum timeout can expire under a long-running
  agent. "Once" means one call per wait, not one wait per agent: after an
  intermediate message or an expired timeout the orchestrator handles what
  came back and waits again at the same length. Raised by the automated
  review on PR #43; the first draft read as forbidding the second wait.
- **The condition covers several pending agents.** A permitted fan-out
  leaves two or more delegates running, and a singular "a spawned agent"
  read as excluding that case. The rule now says "spawned agents, one or
  several", passes every pending id where the tool takes them, and treats
  one agent's completion as a nonfinal return while others run. Also raised
  by the PR #43 review.
- **The tool's own hint is not enough.** The `timeout_ms` description already
  says "Prefer longer waits (minutes) to avoid busy polling," and Codex's
  experimental collab prompt says "Do not repeatedly wait by reflex." The
  audit shows neither lands, so the payload states the rule with its check
  (one call, explicit timeout at the maximum, on the agent) instead of
  repeating the principle.
- **Nested-orchestrator finding deferred.** The three largest sessions were
  subagents spawning subagents over 15 to 18 hours. "No quiet fan-out" already
  requires a go-ahead for a delegating subagent, and whether those spawns were
  approved is unknown, so no rule change now.

Revisit when Codex's wait tool changes shape, or when a later audit shows the
empty-wait share unchanged. At that point the lever is a config gate
(`agents.max_depth` or the wait defaults in `config.toml`), not more prompt
text.
