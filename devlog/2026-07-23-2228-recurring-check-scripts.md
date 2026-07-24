# Recurring-checks-into-scripts principle: shared-core placement

Work unit: add a principle telling agents to encode repeatable analyses
as reusable scripts (usable by agents, CI, humans) rather than doing
one-off manual passes. User-requested behavior change.

Decisions (user choice on the goal; agent judgment on placement and
wording, reviewed and approved by the user):

- Chose the `system/` shared core over a skill because skills are
  pull, not push: they fire on task match or explicit invocation, so
  they cannot shift the agent's default behavior on an arbitrary
  "analyze these files" request. A persistent config payload is the
  layer that sets defaults. A skill remains the right later home for a
  checker-authoring craft (structure, exit codes, output format), not
  for the disposition itself.
- Chose the shared core over project-level config because the
  disposition is tool-neutral; only the mechanism (where scripts live,
  whether they join CI, naming) is project-specific, and the rule
  explicitly delegates that to the project.
- Keyed the rule on recurrence ("will plausibly run again", "second
  hand-inspection") rather than a blanket "prefer scripts" so it does
  not contradict the existing "No premature abstraction" and "least
  code" core principles; a blanket form would be an internal
  contradiction, the top adherence failure mode.
- Added "a script meant to ship is deliverable code, held to the same
  bar as any other" to prevent the rule's expected failure mode:
  half-tested scratch scripts committed into project trees.
- Rejected porting the rule to the `chat/` variants: consumer chat
  sessions have no repo or CI for a script to compound into, so the
  behavioral-alignment test fails.

Revisit when: a repeatable checker-authoring craft emerges across
projects (conventions for script structure, CI wiring, output format)
that would justify a dedicated skill layered on top of this default.
