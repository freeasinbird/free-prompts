# 2026-08-20 10:09 Context-efficient delegation

User request: apply a four-week local usage audit to the reusable system
payloads without turning durable prompts into storage for current model
preferences.

## Decisions

- **Minimize model re-entry in the shared core.** Each system payload now says
  to give delegates only task-relevant context and artifacts, batch independent
  reads and related verification, and use wait mechanisms that re-enter the
  model only when state changes, attention is needed, or the deadline arrives.
  It also avoids turns that report only unchanged state.
  This revises the 2026-07-07 decision that rejected tool-call batching as
  latency and cost rather than context: the new audit showed that every tool
  boundary replays the accumulated working context, so batching is directly a
  context-management rule. The wording remains mechanism-neutral and carries
  no context-window or timeout constants. A prompt-crafter pass placed these
  tool-neutral, agent-addressable rules in the shared core; chat payloads lack
  the required delegation surface.
- **Separate accountability from model selection.** The shared core says the
  main agent retains direction, evaluation, and final acceptance while cheaper
  delegates perform bounded mechanical work. It does not name the owner's
  current model choices: selection belongs in runtime routing configuration and
  would become stale prompt weight here. Existing Codex routing guidance from
  2026-08-02 is unchanged because revising that recorded policy is outside this
  usage-audit change.
- **Chat payloads stay untouched.** They expose neither tool-call batching nor
  delegated model ownership, so porting the rules there would be inert.

## Rejected Alternatives

- Recording current model assignments in either tool tail. Those are user-owned
  runtime choices, and prompt text cannot enforce them.
- Treating frontier-model share as an optimization target. The useful metrics
  are owner turn count, owner context size, batching, and delegate containment.
- Adding fixed context thresholds, wait durations, or user-side compaction
  commands to the payload. Those values rot or address controls the agent may
  not own.
- Encoding PR-review orchestration mechanics here. The general re-entry rule
  belongs in the prompt; watcher and closeout behavior belongs in the
  `await-pr-review` skill.

Revisit when model selection becomes an agent-controlled responsibility or when
measured tool boundaries stop replaying accumulated context.
