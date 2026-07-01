# 2026-07-01 09:44 — Warn Codex about the gh sandbox auth-probe gotcha

User hit a recurring Codex failure: `gh` commands run `gh auth status` first,
which needs the network. In the default sandbox the probe fails and reports a
bogus invalid-token / auth failure, so Codex mis-reads a healthy login as
broken. Running `gh` with network escalation works. Wanted the synced Codex
system prompt to warn about it.

## Decisions

- Added one bullet to the `## Codex specifics` tail of `system/codex/AGENTS.md`
  (Codex tilt: terser, rule + check). Rule: a sandboxed `gh` auth failure is
  usually a false alarm, so don't re-authenticate; retry with network escalation
  only when the sandbox is what's blocking the call and policy permits, and run
  `gh` normally when network is already available. (This scoping came out of the
  first review round — see Review feedback; the section below is the authoritative
  rule.)
- **Tail only, not the SHARED core, and no `system/claude/CLAUDE.md` edit.**
  The gotcha is specific to the Codex sandbox's network-escalation model, not a
  cross-cutting operating principle — so it's genuinely tool-specific, and the
  shared core stays byte-identical. Not a cross-cutting prompt edit.
- Used a decision rule, not a hard absolute — it's a judgment/operational note,
  not a safety invariant.

## Verification

- Passed: prettier --check on `system/codex/AGENTS.md`; markdownlint 0 errors.
- Noted: repo-wide `npm run lint` flags `.claude/settings.local.json`, which is
  gitignored (won't exist in CI checkout) and unrelated to this change — left
  untouched.

## Review feedback

- Accepted (Codex P2): the first draft said "run `gh` with escalated
  permissions" unconditionally. When the sandbox already has network, or the
  session runs `approval_policy=never`, a blanket escalation request is
  auto-denied and breaks the `gh` workflow even with valid credentials. Rescoped
  the bullet: don't re-authenticate on a sandboxed auth failure, and escalate
  only when the sandbox is what's blocking the call and policy permits — run
  `gh` normally when network is already available. Folded into the original
  commit (feature branch, PR unmerged).

## To promote

- Nothing outstanding; this PR is itself the promotion of the gotcha into the
  Codex payload.
