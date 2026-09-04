# Clarify Scope, Authorization, and Codex Routing

Work unit: [#44](https://github.com/freeasinbird/free-prompts/issues/44).

## Decisions

- **Keep the scope qualifier on existing work.** A requested fix may touch a
  file with uncommitted edits. The old instruction to leave "unrelated or
  uncommitted work alone" also prohibited that ordinary case. Explicitly allow
  scoped edits to those files while retaining the next bullet's concrete ban
  on discarding uncommitted work unless the action itself is explicitly
  requested.
- **Separate destructive actions from ordinary external effects.** An explicit
  request for a destructive action does not require repeat confirmation, but
  a requested workflow alone does not authorize destructive steps or scope
  expansion. External effects retain their implication-based boundary,
  including the existing exception for workflow-required pushes and PRs.
  This preserves the intent of the
  [September authorization decision](2026-09-01-1440-fable-51-adherence-pass.md).
  Rejected: "unless the request itself names it" for all external effects,
  because it would make an unnamed, workflow-required PR need confirmation.
  Both the hard gate and its confirmation default must require the action
  itself to be explicitly requested; otherwise "clearly requested" still lets
  a release-workflow request stand in for permission to perform destructive
  cleanup. A workflow request alone is not enough.
- **Scope completion without removing its examples.** Keep the concrete
  promise examples and blocked-work exception. A next step outside the task
  is a follow-up to report, so an assessment can end with recommendations
  without becoming an implementation assignment.
- **Use exposed routing arguments and preserve role policy.** The current
  host's spawn contract exposes `model` and `reasoning_effort`, and requires
  `fork_turns: "none"` or a partial fork for overrides. Agent-file TOML uses
  `model` and `model_reasoning_effort`. Keep the concrete names but make the
  fork instruction conditional on that field being exposed. Preserve the
  [August role and model decisions](2026-08-02-1703-codex-subagent-routing.md),
  including editing-delegate parity and the default-routing fallback.
- **Leave review triage and progress logging alone.** The existing task-scope
  rules and project note conventions provide a reasonable interpretation.
  The assessment did not establish enough additional benefit to add more
  qualifiers. One compliant run is not proof that wording cannot fail, but
  neither is an imagined failure enough to justify another guard.
- **Keep chat payloads unchanged.** Claude's chat prompt already scopes
  completion to the requested deliverable. The other corrections concern
  system-agent workspace, authorization, and spawn behavior; they do not add
  new chat behavior or reopen the capped ChatGPT alignment work.

## Routing Evidence and Limits

The current host tool contract directly establishes the spawn fields and fork
restriction. The
[official subagent page](https://learn.chatgpt.com/docs/agent-configuration/subagents)
documents the configured-agent keys. Issue reports
[#26948](https://github.com/openai/codex/issues/26948),
[#20077](https://github.com/openai/codex/issues/20077), and
[#32031](https://github.com/openai/codex/issues/32031) provide supporting reports
about schema visibility and full-history forks, not guarantees across hosts.

Do not prescribe hidden arguments or treat `hide_spawn_agent_metadata` as a
working workaround. Issue #32031 also reports that disabling it under
ChatGPT authentication can cause a reserved-tool-schema rejection.

Revisit when the exposed spawn schema or full-history override behavior
changes. Recheck the actual host contract before updating the instruction;
retain the existing role policy unless the owner changes it.
