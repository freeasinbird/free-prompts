# 2026-10-19 19:07 Landing record: label-based landing with template defaults

Added a landing record beside the forge and reviewer records so
`land-approved-prs` can run a landing batch here. Without one the skill
stops `no-landing-record`. The agent-setup forge-record audit offered the
record; the owner accepts or drops it with this PR. Codex (P1) asked for
this note so the defaults can be revisited with their reasons known.

## Decisions

- **Chose the `label` mechanism over review approval or armed auto-merge**
  because `land-approved-prs` lands only `label`; the other two stop
  `unsupported-mechanism` until they get their own contract. Labels
  `approved` and `needs-human` are the template names. They do not exist on
  the repository yet; creating them is an owner action outside the PR.
- **Chose the `write` Approver permission over `maintain` or `admin`**
  because a user-owned repository has no `maintain` role, so `write` is the
  floor that lets every collaborator approve. Approval rests on repository
  role, never on a named person, so the record needs no edit when a
  collaborator joins or leaves. The owner is the only collaborator today, so
  the floor changes nothing in practice.
- **Kept the template's `240` minute stale lock age** because no landing
  batch has run here yet, so there is no evidence to tune it. A stale lock
  means a run is suspected dead, not known dead, and the owner releases it
  by hand; a longer default risks blocking a batch, a shorter one risks
  double-landing.
- **Set Base-advance checks to `none`** because this is a prose repository
  with no build or test step beyond `npm run lint`, and the landing engine
  already waits for CI (`lint`, `shellcheck`) on the exact commit after the
  base advances. A repeated lint run there would add nothing.
- **Copied Reviewer and completion marker from the Codex record** above it
  (`chatgpt-codex-connector`, `codex-pull-request-review-summary`) rather
  than restating them, so the two records cannot drift apart silently.

Revisit when a second collaborator with write access joins (decide whether
the floor should rise to `admin`), when the repository gains a build or test
step that CI does not already cover (add it as a base-advance check), or
when a landing batch hits the stale-lock guard (tune the age from that
evidence).
