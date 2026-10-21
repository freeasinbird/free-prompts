# Bound Codex Event Waits by Host Instructions

Chose host-aware event waits over the unconditional maximum-timeout rule.
The desktop supplies a higher-priority short-wait instruction, so the payload
cannot enforce the tool's larger maximum. The owner requested this revision
after a usage assessment found repeated empty returns in parent and conductor
chats. The shared core already states the desired event-driven behavior.

This revisits the September 2 wait-once decision and September 10 cache-cost
rationale. Keep explicit timeouts and handling of remaining agents, but bound
them by the active host limits and any work deadline. Remove the assertion
that one cold continuation always costs less than cached polling: that depends
on usage, retention, and pricing.

Chose to name process polls and outer execution-cell waits because changing
only the parent wait leaves conductor continuations in place. A supported
long-lived process does not establish model-silent waiting or automatic
resumption after the turn ends.

Rejected stronger prompt wording or undocumented configuration keys. Neither
can change the host's wait implementation. The companion free-skills change
adapts the review workflow; the runtime work is tracked separately.

Work contract: [#60](https://github.com/freeasinbird/free-prompts/issues/60).
Follow-up: [#61](https://github.com/freeasinbird/free-prompts/issues/61).

Revisit when Codex exposes completion-only waits or changes its injected
short-wait instruction. Production savings remain unmeasured.
