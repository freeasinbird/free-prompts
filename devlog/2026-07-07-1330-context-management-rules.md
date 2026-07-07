# 2026-07-07 13:30 Context-management rules (shared core + Claude tail)

User asked which system-payload additions would be large wins for context
management. Candidates were pressure-tested per the prompt-crafter review
workflow (my taxonomy pass plus an independent fresh-context critique
agent); the user approved all four shipped items via question.

## Decisions

- **Two new shared-core Workflow paragraphs** (byte-identical in both
  `system/` files): "Keep the working context lean" (constrain tool output
  at the source; large generated artifacts to files; no re-reading
  unchanged output) and "Persist load-bearing state" (record decisions and
  progress in files on long work). Shared-core placement deliberately gives
  the Codex tail its first context guidance without a tail bullet.
- **One shared-core Communication bullet**: reference code by path and
  line instead of quoting long excerpts, with a load-bearing-text
  carve-out.
- **One Claude-tail bullet** ("Set a return contract when delegating")
  directly after "Protect the main context", which governs when to offload
  but not what returns. Claude-only: Codex CLI has no subagent fan-out
  (same ground as 2026-07-02-1935).
- **Guards against misreading**: the lean-context paragraph ends with
  "Trim noise, never evidence: this governs how output enters the
  transcript, not what you examine or verify", and the no-re-read clause is
  qualified to "unchanged output" (added over the critique draft) so
  neither can be read as license to under-read or skip re-verification
  after an edit. "Persist load-bearing state" is worded mechanism-neutral
  ("a transcript can be condensed") so it doesn't rot with compaction
  behavior.
- **Folded, not separate**: large-artifacts-to-files became a sentence of
  the lean-context paragraph rather than its own bullet (output-side twin
  of the same rule).
- **Scratch files constrained to approved locations** (Codex review
  finding, accepted): the first draft directed output redirection,
  artifact files, and progress notes to "files" with no location
  constraint, which in repos without a devlog or scratch convention
  licensed leaving unrequested files in the project tree, against the
  preserve-user-work and minimal-diff rules. Both core paragraphs now
  route scratch output to a temporary or session workspace unless the
  project designates a place or the user asked for the file. The first
  sweep half-fixed the class ("scratch notes outside the project tree" in
  the persist-state paragraph kept an unconstrained destination) and Codex
  re-raised it; the class is any file-destination phrase without a
  temporary/session-workspace constraint, and both paragraphs, the
  payloads' only file-creating directives, now carry it.
- **Rejected by review** (don't re-raise): tool-call batching (latency and
  cost, not context); a run-the-targeted-test-subset rule (an instance of
  "relevant slice", would duplicate); any compaction-mechanism or
  context-window-size rule (vintage-bound, inert).
- **Chat payloads untouched** (no tools, sessions, or subagents in chat
  UIs; same scoping as 2026-07-02-1935). Decided bullets from
  2026-07-01-1505 and 2026-07-02-1935 untouched; these are additions
  beside them.

## To promote

- Nothing outstanding.
