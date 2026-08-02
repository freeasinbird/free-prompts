# AGENTS.md

`free-prompts` is a synced store of reusable agent prompts — system-level
configuration files for AI coding agents and pasteable chat-interface
instructions kept under version control so the same canonical prompts apply
across every machine.
See [README.md](README.md) for what the repo holds and how it is synced.

This file is the single source of truth for development conventions —
branch naming, commits, pull requests, and the lint/format workflow — for
both human contributors and automated agents.

**Naming caution:** the `CLAUDE.md` and `AGENTS.md` at the repo _root_
govern work on _this_ repository. The reusable prompts you edit and ship are
the payloads under `system/<tool>/` and `chat/<tool>/` — never confuse the
root pointer with a stored prompt.

Agent-setup profile: Decision-log (selective decision notes; see
`devlog/README.md`).

<!-- agents-md:managed:devlog -->

## Decision notes (devlog)

`devlog/` holds selective decision records, not session logs: at most
one note per work unit or PR in the ordinary case, named
`YYYY-MM-DD-HHMM-slug.md`. `devlog/README.md` is the protocol; most
work needs no note.

- **Write or update a note only when** the work involves at least one
  of: a consequential, non-obvious decision that rejects a plausible
  alternative; an investigation or verification result that materially
  changes the model, policy, risk, or implementation direction; a
  durable owner choice that would otherwise exist only in chat;
  cross-session context the work unit's PR or issue genuinely doesn't
  carry; or a change on the project's mandatory-note list, where it
  keeps one. Routine implementation, formatting, ordinary docs,
  dependency maintenance, mechanical syncs, and uncomplicated fixes
  need no note unless they reveal something consequential.
- **Content**: final rationale, rejected alternatives, changed
  assumptions, significant verification findings, and a "Revisit
  when ..." condition where one is useful; not commit diffs, test
  transcripts, or PR status. A note may evolve while its work unit or
  PR is active; it freezes on merge.
- **Retrieval**: read the notes linked from the issue or PR at hand;
  otherwise search by affected path, topic, contract, or decision
  name. Read the latest note only when resuming the work unit it
  describes. Prior notes are evidence, not prohibitions: do not
  silently overturn an explicit owner decision; if new evidence
  conflicts with one, identify the prior decision, state which
  assumption or condition changed, and surface the proposed revision.
- **Actionable deferred work goes to the issue tracker**, not the
  note. When an issue originates from a note, link the note from the
  issue; the note may carry a plain historical `Follow-up: #N` link,
  never a second source of status. An observation that is not yet
  actionable becomes a "Revisit when ..." statement, not open work.

<!-- /agents-md:managed:devlog -->

<!-- agents-md:managed:finish-line -->

## Default agent finish line

For any user request that asks you to change code, docs, assets, or project
state, the default endpoint is **an open, review-ready PR with required
checks green**, not a merged branch. Merging is a human decision; do not
merge your own PR unless the user explicitly asks, or the project has adopted
an opt-in self-merge workflow.

Before implementation, establish a lightweight work contract: objective,
testable acceptance criteria, scope, dependencies and blockers, and explicit
non-goals. Direct user-assigned work needs no issue; the prompt and
eventual PR may carry the contract together. Persist that same contract
in a tracker issue when the work must survive a session boundary,
coordinate concurrent workers, or join a backlog. Actionable work
deferred out of the unit's scope gets a tracker issue before handoff.

By default, begin work only through explicit user assignment. An issue, label,
backlog entry, satisfied dependency, or claim is not authorization to select
and start work. Agent self-selection requires an explicit project-specific
opt-in policy.

Use this checklist for each work session:

1. Read the README and, when resuming an existing work unit, its issue or
   PR and any decision note it links. Resolve the repository's
   default branch explicitly, update it from its remote, and start ordinary
   work from that exact tip, not from whichever branch is currently checked
   out. Only an intentionally declared stacked PR may start from another open
   PR's branch (see Stacked PRs under Pull requests).
2. Create one correctly named branch explicitly from that starting tip.
3. Make the scoped change, including the docs/tests/assets that keep it
   complete and, where the project keeps decision notes, a note when
   the work meets its triggers.
4. Run the relevant verification plus the standard lint/build/test checks
   before PR; if any check cannot run, record the exact gap in the PR.
5. Commit one concern at a time with a body that says why.
6. Push, open the PR with the template, and remove sections that do not apply.
7. Hand off per "Handing off the PR" (under Pull requests): start the
   review-watch, complete the base-freshness pass, wait out required checks,
   handle reviewer activity, self-review the PR files view, and leave the PR
   open for a human to review and merge.

For changes on a **destructive path** (delete/cleanup), a
**credential-leak surface**, or a **returned-object-trust boundary**
(trusting fields of a value handed back by an external call or
deserializer), add a refute-first verification pass before committing
(independent lenses whose job is to _disprove_ the fix) and record
which findings were confirmed, rejected-by-verification (so they're
not re-raised), and accepted-by-decision: in the work unit's decision
note where the project keeps one, otherwise in the PR or issue. For a
behavior-preserving refactor on one of these paths, where the platform
can execute code, have a lens reconstruct the
old implementation (`git show <base>:<file>`) and compare old against new
decision-for-decision over a fuzzed corpus; a diff-read can only assert
equivalence, a harness measures it. Scope all of this to those risk
classes; a docs typo or a refactor off these paths shouldn't trigger it.

<!-- /agents-md:managed:finish-line -->

<!-- agents-md:managed:context -->

## Context discipline

The working context is finite, and everything held in it is re-sent
with every later tool call, so transient bulk pulled in early taxes
every step after it. Durable state belongs in files (the PR body, the
issue, a decision note where the project keeps one); keep the working
context to what the current step needs.

- **Keep raw bulk out.** Prefer targeted, bounded reads and searches
  (a file region, a match list, a filtered log tail) over whole-file
  dumps and unfiltered search output; don't page a large artifact into
  context when a bounded query answers the question.
- **Delegate broad exploration.** Where your platform and session
  support delegation, offload broad exploration and mechanical sweeps
  to a delegate that returns conclusions (findings, `file:line`
  pointers, a short digest), never its raw output. Where they don't,
  fall back to the bounded reads and searches above. Scale to size
  either way: for a question a couple of targeted reads can answer,
  spawning a delegate costs more than it saves.
- **Right-size delegated work.** Where the platform exposes a model
  class or effort level for delegated work, send mechanical scanning
  and digesting to the cheapest class that handles it reliably;
  frontier capability spent on rote reading is waste. Where it
  doesn't, skip this.
- **No quiet fan-out.** One delegate for exploration or review is
  normal. Parallel multi-agent fan-outs multiply cost invisibly;
  before launching one, state the expected scale and proceed with the
  user's go-ahead or within a budget they already set.
- **Prefer a fresh session over a bloated one.** The PR body (plus a
  decision note when one exists) carries the durable state, so at a
  natural boundary (a PR handed off, a review round closed, a new work
  unit) in a long session, suggest continuing in a fresh session
  seeded with the PR number rather than pushing on; the accumulated
  context adds little to the next unit and dominates its cost.

<!-- /agents-md:managed:context -->

## Repository layout

Stored prompts live under `system/<tool>/` and `chat/<tool>/`, one directory
per agent tool:

```text
system/
  claude/CLAUDE.md     # → synced to ~/.claude/CLAUDE.md
  codex/AGENTS.md      # → synced to ~/.codex/AGENTS.md
chat/
  claude/instructions.md
  chatgpt/custom-instructions.md
```

- **One real file per tool, hand-authored not generated.** `system/` payloads
  pair a byte-identical tool-agnostic core (between the `SHARED` markers) with
  a per-tool tail; the cores are kept identical by hand across files, not
  produced from a generator. `chat/` payloads are conceptually aligned but not
  byte-identical, because chat UI limits and model behavior differ.
- **Top-level scopes describe prompt kind.** `system/` is for agent
  configuration files that can be symlinked into local tool config. `chat/` is
  for pasteable consumer chat instructions. If project-level prompt templates
  appear later, add a sibling scope (e.g. `project/`) then — don't pre-build
  the nesting now.
- The repo's own `AGENTS.md` / `CLAUDE.md` sit at the root and are not synced
  anywhere; they configure work on this repo.

## Lint, format

There is no build step — this is a prose/prompt repository. The checks are
prose formatting + markdown lint + the payload checks, plus shellcheck for
the shell scripts. Run `npm install` once, then:

```sh
npm run format          # prettier --write .                    (apply formatting)
npm run lint            # prettier + markdownlint + payloads    (verify)
npm run check:payloads  # payload checks alone                  (fast)
```

- **prettier** owns formatting; `proseWrap` defaults to `preserve`, so it
  keeps your line breaks rather than rewrapping prose.
- **markdownlint-cli2** catches structural issues (heading jumps, list
  style) via `.markdownlint.jsonc`.
- **`scripts/check-payloads.sh`** gates the payload invariants that were
  previously re-checked by hand: shared-core parity between the `system/`
  files, zero em dashes in any payload, and the ChatGPT character budget
  (`CHATGPT_CAP` overrides the default 1500). It runs as the last step of
  `npm run lint`, so CI already covers it.
- **shellcheck** gates `scripts/*.sh` in CI; run `shellcheck scripts/*.sh`
  locally before pushing script changes (install via your package manager,
  e.g. `brew install shellcheck`).
- Node is required; `node_modules/` is gitignored, `package-lock.json` is
  committed.
- CLAUDE.md is a pointer that imports AGENTS.md — edit AGENTS.md, never the
  pointer.

## Conventions & gotchas

- **Cross-cutting prompt edits land together.** When a shared-core principle
  changes, edit every affected `system/<tool>/` file on one branch and ship
  them in a single PR, so the change is reviewed side by side and the history
  reads as one change. For `chat/` prompts, keep behavior conceptually aligned
  across affected tools in the same PR, while preserving tool-specific length
  and structure constraints. Keep the system core byte-identical across files;
  per-tool divergence belongs in each file's tail. See
  [Per-tool prompt authoring](#per-tool-prompt-authoring) for how.
- **Root vs. payload.** The root `CLAUDE.md`/`AGENTS.md` are this repo's
  config; `system/<tool>/*` and `chat/<tool>/*` are reusable prompt payloads.
  Don't apply repo conventions to the payloads or vice versa.
- **Payloads ship verbatim.** Whatever lands under `system/<tool>/` is what
  reaches each linked machine; whatever lands under `chat/<tool>/` is what gets
  pasted into that chat interface. If you want a payload kept byte-exact, add
  it to `.prettierignore` rather than letting the formatter normalize it.
- **Payloads are em-dash-free.** The prompts ban em dashes and models mimic
  their config's own prose, so every `system/` and `chat/` payload must itself
  contain none; check with `grep -c '—'` (expect 0) before shipping.
- **Syncing is scoped to system prompts.** `scripts/link-system-prompts.sh`
  symlinks the `system/<tool>/` payloads into their live config locations
  (idempotent; `--dry-run` / `--adopt`, which backs up a real file before
  replacing it). It links only the explicit map inside the script — other
  prompt kinds would get their own helper, never a generic linker.
- **ChatGPT has a small prompt budget.** Keep
  `chat/chatgpt/custom-instructions.md` under the current Custom Instructions
  character limit and verify with `wc -m` before shipping.

## Per-tool prompt authoring

Each `system/` payload pairs a byte-identical tool-agnostic core with a
per-tool tail (see **Cross-cutting prompt edits land together** above). Most
operating principles are genuinely tool-neutral: write them once and place the
identical text in the SHARED core of both files — no per-tool variant. The
per-tool tilts below govern the tails (the genuinely agent-specific guidance)
and the rare principle that must be worded differently per tool; when a rule
does diverge, the variants differ in **wording and emphasis, not intent** —
the same rule, tuned to how each agent reads its config file.

These authoring rules hold for both files, before any per-tool tilt:

- **Be clear and specific.** Neither `CLAUDE.md` nor `AGENTS.md` is enforced
  configuration — each is context the agent weighs, so concision and clarity
  raise adherence more than volume or shouting. A hard guarantee needs a real
  gate (e.g. a hook or CI check), not louder wording.
- **Keep instructions internally consistent.** Both agents follow their config
  closely and resolve contradictions _unpredictably_ — Claude "may pick one
  arbitrarily," GPT-5/Codex oscillates and wastes reasoning. Conflicting rules
  are the most-cited failure mode in both vendors' guidance; audit for them.
- **Reserve hard absolutes for genuine invariants.** Save `ALWAYS`/`NEVER`/
  `MUST` for safety rules and true never-actions; use decision rules ("prefer
  X unless Y") for judgment calls.

Per-tool tilts, from current vendor guidance (sources below):

| Axis      | `claude/CLAUDE.md`                                                                                                                | `codex/AGENTS.md`                                                                                        |
| --------- | --------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| Emphasis  | Bold and `IMPORTANT:` register, but newer Claude _over_-triggers on aggressive caps / "You MUST" — prefer normal phrasing.        | Same restraint; reserve `ALWAYS`/`NEVER` for true invariants, decision rules for everything else.        |
| Structure | Markdown headers + bullets to group related rules — Claude scans structure the way a reader does. (XML tags are for API prompts.) | Plain hierarchical Markdown; keep rules non-conflicting (Codex concatenates files, closer ones winning). |
| Rationale | Give the "why" — Claude generalizes from the explanation, so motivation beats a bare directive.                                   | State the rule and its check; trim narration.                                                            |
| Verbosity | Concise but explanatory; favor sectioning over dense paragraphs.                                                                  | Biased to action — terser than the Claude variant; cut preamble/scaffolding, set explicit length limits. |

Procedure for a cross-cutting edit:

1. State the principle once, tool-neutral: what, and why. Decide its home — if
   it reads the same for every agent, it belongs in the SHARED core.
2. Tool-neutral principle: write it once and place the identical text in the
   SHARED core of every file, keeping the cores byte-identical.
3. Genuinely tool-specific guidance: draft it in each file's tail along the
   tilts above — the `CLAUDE.md` variant with rationale and section structure,
   the `AGENTS.md` variant terser and more directive, neither conflicting with
   the shared core.
4. Read each as its own agent would, run `npm run lint`, and ship both in one
   PR.

## Chat prompt authoring

`chat/` prompts are pasteable chat-interface instructions, not local agent
config files. Keep the Claude and ChatGPT versions behaviorally aligned, but
do not force a byte-identical core. Claude can use headings and a little more
rationale; ChatGPT should be compressed, direct, and verified under the current
Custom Instructions character limit with `wc -m`.

Sources (verified current): Anthropic —
[prompt best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
and [Claude Code memory](https://code.claude.com/docs/en/memory); Anthropic
also explicitly tracks sycophancy as an alignment concern in its
[Claude Sonnet 4.5 release](https://www.anthropic.com/news/claude-sonnet-4-5).
OpenAI —
[GPT-5.1 prompting guide](https://cookbook.openai.com/examples/gpt-5/gpt-5-1_prompting_guide),
[Codex prompting guide](https://developers.openai.com/cookbook/examples/gpt-5/codex_prompting_guide),
and [AGENTS.md guide](https://developers.openai.com/codex/guides/agents-md);
OpenAI also explicitly discusses sycophancy in
[GPT-4o](https://openai.com/index/sycophancy-in-gpt-4o/) and the
[GPT-5 system card](https://arxiv.org/abs/2601.03267).
ChatGPT —
[Custom Instructions](https://help.openai.com/en/articles/8096356-custom-instructions-for-chatgpt).
Deliberately omitted as unconfirmed by primary docs: GPT "over-literal
compliance" as a named, promptable failure mode.

## Automated reviewer

This repo has an automated PR reviewer — record kept here (outside the
managed blocks) so agent-setup updates don't overwrite it, and so later
sessions can filter its review activity by login:

- **Codex** (OpenAI code review). Review author login
  **`chatgpt-codex-connector`** in GraphQL (`author.login`); the REST
  `pulls/N/reviews` form is **`chatgpt-codex-connector[bot]`** — match the
  form to the API or the login filter silently matches nothing. Triggered
  on **every push** to a PR branch, as well as when a PR is **opened or
  marked ready-for-review** or by a **`@codex review`** comment. **Status
  signal (clean pass):** on a pass with nothing to raise, Codex posts **no
  review at all**; the only artifact is a **`+1` (thumbs-up) reaction on
  the PR description**, authored `chatgpt-codex-connector[bot]` (the
  REST-style form, even via GraphQL), landing minutes after the
  open/push (observed on PR #20: reaction at ~3 min, zero reviews). A
  review-watch must read PR-description reactions, matching the
  reaction's `created_at` against its baseline, or a clean pass looks
  like no run and burns the full wait cap — no findings is not the same
  as no run. So expect a fresh pass on each push: advance the
  review-watch baseline to the new push rather than treating the prior
  review as final. Filter its review activity by that login.

Evaluate its findings on their merits (see Pull requests → "Responding to
automated review"): fix real issues, decline contrived ones with a one-line
reason, and sweep the whole class, not just the cited line.

<!-- agents-md:managed:branches -->

## Branches

All work lands through a PR. Resolve and freshly update the repository's
default branch (`main` below), then create each ordinary work-unit branch
explicitly from that tip. Never create an ordinary branch from the currently
checked-out feature branch; a non-default starting point is allowed only for
an intentionally declared stacked PR. Do the work as atomic commits (see
Commits), then open a PR; the work merges with a real merge commit, a human's
call per the finish line. Never commit directly to `main`. No triviality
exception: every bypass erodes the `--first-parent` narrative.

Name branches `<type>/<short-kebab-slug>`: type from the Conventional
Commits vocabulary (`feat`, `fix`, `refactor`, `docs`, `chore`), slug
2–4 kebab-case words naming the work unit:

```text
feat/worksheet-promotion
fix/pane-focus-race
chore/swift-format-sweep
```

Exactly one slash: refs are path-like, so `feat/x` and a branch named
just `feat` can't coexist. No ticket numbers, dates, or owner prefixes;
prepend an owner segment (`bnw/feat/…`) only if multiple people or
agents start pushing in parallel. Merged branches auto-delete where
that repo setting is on (delete them after merge where it isn't); the
merge commit carries the narrative.

**Break down concurrency before isolating it.** Keep coupled work in one work
unit, an explicit dependency chain, or an intentionally declared stack; a
worktree separates checkouts but cannot make logically dependent work safe in
parallel. Before substantive work, an assigned concurrent unit uses the
project's forge-visible claim mechanism, when one is defined. The claim
advertises active occupancy, not authorization; its form is project-specific.

**Isolate concurrent work units.** Concurrent work units must use separate
worktrees or checkouts. Where your platform and session support a second
checkout (a native worktree tool or session flag, or plain
`git worktree add <path> -b <type>/<slug> <default-branch>`), create each
worktree explicitly from the freshly updated default-branch tip, not from
whatever branch is checked out; prefer the same isolation for a single work
unit. Remove the worktree once its branch merges, standing outside the one
being removed (`git worktree remove <path>`): git does not stop a session
from unlinking its own working directory. Where isolated checkouts are
unavailable (no multi-checkout support, or a sandbox pinned to one
directory), serialize the work units and use one correctly based branch at
a time in the primary checkout. Never run concurrent work units in one
checkout.

Follow-up work that depends on an open PR can stack on its branch instead
of waiting; see the Stacked PRs pattern under Pull requests.

<!-- /agents-md:managed:branches -->

<!-- agents-md:managed:pull-requests -->

## Pull requests

A PR is one work unit, reviewed as a whole and merged with a real merge
commit. Commits carry the atomic why (see Commits); the PR carries the
arc.

- **Title**: imperative, ≤ 72 chars, names the outcome, no type prefix
  or ticket noise ("Fix missing menu bar on unbundled launch"). In the
  intended repo setup the PR title (plus its number) is the _entire_
  merge commit message: merges are title-only, so the body's review
  material (screenshots, verification, review notes) never lands in
  history, and `git log --first-parent` reads as the list of PR
  titles; write the title for that log either way.
- **Body**: scaffolded by the repo's PR template (on GitHub:
  `.github/pull_request_template.md`):
  - **Why**: prose, one to three short sentences. State the problem or
    motivation. Link the decision note when one exists; don't duplicate it.
    Where the template's comment spells out issue keywords, follow it
    exactly: a close keyword per issue the PR fully resolves, a plain
    `Refs #N` for related-but-unfinished issues that are left for a
    human to close.
  - **What**: required bullets. Describe work-unit outcomes, not
    file-by-file churn. For multi-commit PRs, use a compact commit map
    (one bullet per commit or concern), referencing each commit by its
    subject, not its SHA: folding a review fix into its commit (see
    Commits) rewrites every downstream SHA, so a SHA-keyed map forces a
    body rewrite each round, while subjects don't go stale. Say rejected
    alternatives live in the decision note when they do.
  - **Screenshots**: required for PRs with visible UI changes; delete it
    for non-visual work. Replace the section with actual forge-hosted,
    reviewer-visible image or recording attachments before handing off,
    and in every case before merge; local paths, textual descriptions,
    and "checked locally" notes do not satisfy it. If you cannot attach
    the artifacts yourself, say so at handoff and ask the user to add
    or confirm them before merge. Show the changed surfaces,
    important states, and every theme or appearance mode the change
    affects. Keep captions short and name the state shown. Verification
    still belongs in Verification.
  - **Review Notes**: optional bullets; delete the section when it adds
    no routing value. Use it to point reviewers at important files, review
    order, mechanical commits, or risky edges.
  - **Verification**: required bullets. Start each with `Passed:`,
    `Checked:`, `Attempted:`, or `Not run:`. Say what was actually run and
    observed: tests, lint, fixture/screenshot checks (every affected theme
    for UI), round-trips for schema changes. Facts only, never
    "should work"; verification gaps are explicit `Not run:` bullets.
    Factual doc claims ship under the same discipline: counts, flags,
    behaviors, and runtime guarantees are checked against the code and
    scoped to the surface they describe, stated without marketing or
    competitor put-downs.
- **Self-review the diff in the PR files view before handing off**: seeing
  the whole change as one artifact catches stray hunks, leftover debug code,
  scope creep, and accidental files the editor hid. This is a
  _mechanical-hygiene_ pass; it does **not** substitute for substantive
  critique.
- **Integration evidence belongs to one base commit.** CI results, a
  full-diff self-review, and a ready-for-handoff claim are valid only for the
  base commit they were checked against. A base-branch change invalidates all
  three, even when the earlier PR diff looked clean.
- **Substantive critique needs fresh, ideally non-self eyes.** Same-context
  self-review shares the blind spots that produced the code. Independence
  ladder, weakest to strongest: self-in-context < same-model fresh-context
  subagent < different-vendor bot / human. An automatic bot reviewer or a
  human is the load-bearing substantive pass; the default finish line
  already stops at an open PR for one.
- **Optional, risk-gated: a fresh-context pre-push review.** For non-trivial
  changes, or any repo without an external bot reviewer, get fresh eyes
  before pushing. **Where your platform and tools support delegation** (and
  it is allowed without asking), spawn a fresh-context reviewer: prompt it
  to _refute_, give it only the diff plus the PR's stated intent (not your
  reasoning trail), and let it hunt correctness, security, and edge-case
  failures. **Where they don't** (no subagent concept, or delegation needs
  explicit permission), skip it and lean on the external bot / human review,
  or ask the user first; never emit steps the running agent can't perform.
  A same-model subagent is only _partially_ independent and costs tokens;
  scale to risk, skip trivial or mechanical work.
- **Record a noticed automated reviewer.** When you observe a bot-authored
  review on a recent PR, or a reviewer status signal (a bot reacting on PR
  descriptions shortly after they open, recurring across PRs: a reviewer
  whose passes have all been clean may never post a review), and the project
  hasn't recorded the reviewer, add a compact
  record (an "Automated reviewer" entry; the required fields below usually
  take a short paragraph) to an unmanaged, project-specific section of
  AGENTS.md
  (outside `agents-md:managed:*` blocks, so syncs don't overwrite it) with
  enough identity to match its future reviews: the reviewer's **name**, its
  **login/account identity** (including the API-specific form when it
  differs, e.g. a `[bot]` suffix in one API but not another), how it is
  **triggered** (automatic on PR events, a manual command, or a CI job), and
  any **status signals** it posts out of band (an in-progress or clean-pass
  indicator, e.g. a reaction on the PR description; some reviewers post no
  review at all on a clean pass, so the recorded clean-pass signal is what
  lets a later watch finish instead of timing out). Later sessions filter
  review activity by that login, so the identity, not a bare "a reviewer
  exists", is the point. An existing record is not a reason to skip: when
  you observe status signals (or a changed trigger) the record lacks,
  augment it in place, since a name/login/trigger-only record still forces
  the full wait cap on clean passes. Record only a reviewer and signals you
  actually observed, never an absence.
- **Responding to automated review.** Evaluate each comment on its merits:
  fix real findings; push back, _with a one-line reason_, on contrived,
  speculative, or already-fixed ones; never reflexively comply. Reply
  inline with the disposition and the fixing commit SHA ("Fixed in
  `<sha>`" / a reasoned decline), then resolve the thread; where review
  fixes fold into their commits, the fold and push come first (the
  fold-then-reply gate in Commits), so the cited SHA is the final,
  pushed one, and a round that accepts several findings folds them all
  and pushes once before any reply, since a later fold in the round
  rewrites an already-cited SHA. Resolving every
  thread is _not_ a hard merge gate; evaluate-on-merits is.
- **Fix the class, not just the cited line.** When a finding names one
  location, sweep the file and repo mechanically (grep for the finding's
  pattern, don't just eyeball nearby lines) and fix every instance in the
  same push: the class routinely recurs in sibling sentences or files the
  citation never named, and each miss costs another review round. For
  validation or parsing code, the mechanical sweep is an adversarial
  enumeration of the input space (case, spacing, indentation,
  prefix/suffix, order, duplication, nesting), run once as tests, not a
  widening of the cited pattern: pattern-widening spent eight review
  rounds on one class before the enumeration closed it.
- **Converge on a bar that rises with the rounds.** A reviewer whose
  findings stay individually valid can sustain an unbounded exchange,
  so severity, not validity, sustains the loop: blocking findings
  (correctness, security, data-loss, broken invariants, red CI) always
  earn another round. Judge that severity yourself against those
  categories, treating the reviewer's own tag as input, not verdict,
  and when unsure whether a finding blocks, treat it as blocking:
  uncertainty buys a round, not an exit. Past the early rounds a valid
  but non-blocking finding gets a disposition instead of a round:
  fixed in a final push when the fix is verifiable locally before
  pushing, deferred to a tracked follow-up issue that quotes the
  finding when it needs real work, or declined with a one-line reason;
  a round the loop pays for anyway dispositions every finding it
  raised on those same merits, never silently carrying one forward and
  never force-fixing one that rightly earns a decline. Don't
  under-converge: never declare a PR "addressed" while blockers are
  still arriving, and a finding that recurs from your _own_ incomplete
  fix is a miss to sweep, not a stop. What ends a blocker-sustained
  exchange is thrash, not a round count: the same finding recurring
  after a correct, complete fix, or fixes spawning new problems
  without net progress, means the change or the loop is broken, so
  pause and bring in the human with what is stuck; a long run of
  blocker-sustained rounds earns explicit, recorded
  continue-or-escalate calls, renewed as the run stretches, rather
  than a silent stop or autopilot continuation. Hand off with every
  finding dispositioned (fixed,
  declined, deferred, or explicitly outstanding) and any no-blocker
  call that ended the exchange stated for audit; the human arbitrates
  outstanding non-blockers at merge.
- **Keep the body current as review evolves the PR.** The body is the
  work unit's durable record on the forge (the merge commit carries only
  the title), so when review adds commits or shifts scope, update What,
  the commit map (flag which commits resolve review findings, by subject as
  above), and Verification before re-handing-off. The inline disposition +
  fixing SHA on each resolved thread (above) is the located per-finding
  record (that reply is written once, post-fold, so its SHA doesn't churn);
  don't duplicate it into a standing "feedback" section that would drift.
- The intended repo settings enforce the Commits rules: merge commits
  only (squash and rebase disabled), title-only merge messages, and
  auto-delete of merged branches. Don't re-enable around them; where
  they aren't set, hold the same rules manually (merge-commit merges
  only, the merge message kept to the PR title, delete the remote
  branch after merge).

### Handing off the PR

An open PR, not a merged one, is the agent's finish line; leave it
open for a human to review, approve, and merge, unless the user
explicitly asks you to merge or the project has adopted a self-merge
workflow. Done means open, green, threads handled, self-reviewed, and
no new review activity outstanding. Once the PR is up:

- **Start one review-watch per PR/reviewer as soon as the PR is open**,
  where the project records an automated reviewer or you have observed
  one, before waiting on checks, so the checks wait can't defer it.
  Prefer a dedicated review-watch skill, tool, or automation that can
  report back without manual polling; otherwise, if
  your platform can watch non-blockingly (a backgrounded poll or scheduled
  wake-up) and policy permits that mechanism, use it; don't pause to ask
  whether to watch. If a non-blocking mechanism would need permission not
  already granted, take the next permitted path. Where non-blocking support
  is absent, use a bounded foreground poll when it fits the current turn;
  otherwise hand back with the baseline and don't silently skip the review.
- **Anchor the watch baseline to the event that should produce the next
  reviewer pass**, not the moment the watch starts: the PR open/ready or
  actual push event for open/push-triggered reviews; the request time for a
  no-push recheck (marking ready, manually requesting review). Reviewer
  activity after that event is in-scope and must be handled, never absorbed
  into the baseline as already-seen. On a new push, advance or replace the
  baseline rather than leaving duplicate watchers running.
- **Validate against the current base before final handoff.** Resolve the
  current base tip, update the PR branch using the project's merge or rebase
  convention, rerun the relevant verification, and self-review the complete
  refreshed diff. Record the base commit used for that final validation in
  the PR's Verification section or the handoff. If the base advances again
  after handoff but before merge, the PR is stale and needs another
  integration pass. If you do not own the branch or lack permission to
  update it, report the stale state instead of silently rewriting it.
- **Wait for required checks**: poll them until they complete (on
  GitHub: `gh pr checks <n>`); fix any red check on the branch, never
  hand off a known-red PR.
- **Self-review the diff** (above) so it's ready for a reviewer.
- **Close out the watch before handoff**: poll for _both_ new review
  comments and CI, address in-scope findings on the branch, or record the
  bounded timeout / no-review result with the baseline; only then declare
  done. One exception: when the convergence rule above ends the exchange
  with a final triage push, don't wait out the re-review that push
  triggers; record with the baseline that it is intentionally left for
  the human to glance at during merge, and that satisfies this closeout.
- **Stop and summarize**: say the PR is open and green, and surface
  anything the reviewer should focus on. Leave merging, branch cleanup, and
  the `main` resync to whoever approves it.

If the user does ask you to merge, merge with a real merge commit (on
GitHub: `gh pr merge <n> --merge`; where the repo's title-only
merge-message settings aren't confirmed set, pass the message
explicitly instead of inheriting the forge default:
`gh pr merge <n> --merge --subject '<PR title> (#<n>)' --body ''`),
delete the remote branch if the
auto-delete setting didn't, then resync the base branch, delete the
local branch (`git branch -d <branch>`), and `git fetch --prune`.

In a single checkout, fetch the base first
(`git fetch <remote> refs/heads/main`), then land on the branch: with a
local `main` present (`git show-ref --verify --quiet refs/heads/main`)
that is `git checkout --no-overwrite-ignore main`, and without one
`git checkout --no-overwrite-ignore -b main FETCH_HEAD`, because a bare
checkout detaches `HEAD` at a same-named tag. Fast-forward with
`git merge --ff-only --no-overwrite-ignore FETCH_HEAD`. Not
`git checkout main && git pull --ff-only`: a plain checkout and pull's
merge step both overwrite an ignored file the base has started tracking
rather than aborting (`git pull` rejects `--no-overwrite-ignore`), and a
bare pull follows the configured upstream, which in a fork clone can be
the fork's stale copy.

When the work ran in a dedicated worktree (see Branches)
`git checkout main` refuses with "already used by worktree", so resync
`main` in the primary checkout and `git worktree remove <path>` the
feature worktree before deleting its branch. Run that removal from the
primary checkout too, never from inside the worktree being removed: git
has no self-target check, so a removal that would otherwise succeed
unlinks the directory the session is standing in and exits 0, leaving
every later command on a path that no longer exists.

### Reviewing a PR

The mirror of "Responding to automated review": hold the bar you'd want
held for you. Use the project's review tooling for the bug-hunting
pass where it has any, otherwise read the full diff yourself; these
are the conventions for the comments the pass produces.

- **Calibrate to severity, and tag it.** Separate blocking findings
  (correctness, security, data-loss, red tests/CI, broken invariants) from
  non-blocking ones (naming, style, optional simplification). Only blockers
  gate the merge. Don't manufacture speculative or contrived findings; the
  author convention is to decline those with a one-line reason.
- **Every comment carries evidence and a concrete ask.** Point at
  `file:line`, name the failure it causes, and propose a fix or ask a
  question. Mark uncertainty as uncertainty ("possible:"), never assert it;
  the Verification facts-only discipline applies to review too.
- **Review against intent, not just the diff.** Read the PR's Why/What and
  any linked decision note; check the change does what it claims, that
  Verification matches reality, and that docs/tests moved with behavior.
  Recorded decisions are evidence, not prohibitions: don't silently
  overturn an explicit owner decision; if the diff conflicts with one,
  name the decision and which assumption or condition changed.
- **Stay in scope.** Out-of-scope improvements are non-blocking nits or a
  follow-up issue, not merge-blockers; don't grow the PR through review.
- **Scale depth to risk.** Routine PRs get a normal pass; destructive /
  credential-leak / trust-boundary changes get the refute-first lens (see the
  finish line). A docs typo doesn't.
- **Resolve explicitly.** State what would unblock; let the author
  fix-or-decline. Resolving every thread isn't the gate; agreement on
  blockers is.

### Stacked PRs

Dependent docs or cleanup work can proceed without waiting for its base as an
intentionally declared stacked PR. A non-default base is an explicit
dependency: name the open PR's branch when creating both the follow-up branch
or worktree and the PR, never inherit it from the current checkout. On GitHub,
use `gh pr create --base <feature-branch>`; it auto-retargets to `main` when
the base merges, while other forges may require manual retargeting. Two
gotchas: while the base is open the stacked PR's diff shows only its own
commits; and if the base is force-pushed (the fold-review-fixes rule in
Commits), `rebase --onto` the stack onto the new base tip.

<!-- /agents-md:managed:pull-requests -->

<!-- agents-md:managed:commits -->

## Commits

History is optimized for three uses: diagnostics (blame/bisect lead to a
cause), reviewability (a PR reads commit-by-commit), and learning (the
log tells the project's evolution). Rules:

- **One concern per commit, every commit green.** If the body wants
  labeled sections (Correctness:/Performance:/…), it's more than one
  commit; split it. Each commit must build and pass tests on its own;
  never leave red intermediate states (it breaks bisect).
- **Body says why, not just what.** Write dense, specific bodies,
  wrapped ≤ 72 columns. Reference the work unit's decision note
  when one exists. State change deltas ("27 → 36 tests") if meaningful;
  never absolute status ("36 tests green"); CI asserts that, and it
  goes stale.
- **Never commit secrets** (credentials, tokens, keys, `.env`
  contents); reference them by name and use placeholders in examples.
- **Mechanical churn commits alone.** Reformats, renames, and moves get
  their own commit, added to `.git-blame-ignore-revs` in the same change
  (activate locally with
  `git config blame.ignoreRevsFile .git-blame-ignore-revs`).
- **Fold review fixes into the commit they belong to.** When a review
  comment or self-review turns up a fix for code in an already-pushed
  commit, fold it into that commit rather than appending an "address
  review" commit; the merged PR keeps its clean, bisectable structure.
  Guardrails: every commit still builds and passes tests after the fold;
  `--force-with-lease`, **feature branch only, never force-push `main`**;
  only while the PR is unmerged (once merged, a fix is a new commit);
  update the matching decision note, when one exists, in the same
  operation. The mechanism (reset/amend/rebase) is your judgement. The
  fold-then-reply order is a gate: fold and push before writing the
  inline reply to the review thread, so the reply cites the final
  commit SHA, verified reachable from the pushed head; a standalone
  review-fix commit still on the branch at handoff is an unfinished
  fold, not a done round.
- **Never squash-merge multi-commit work**: it destroys the atomic
  structure above. Merge with a real merge commit so
  `git log --first-parent` reads as the work-unit narrative and the full
  log holds the atoms. Narrative subjects ("Walking skeleton: end-to-end
  flow") belong at that merge/PR level.

<!-- /agents-md:managed:commits -->

<!-- agents-md:managed:done -->

## Definition of done for an increment

Each increment is something actively used by the end of the work session:
not "code complete" or "tests pass" alone, but running and exercised.
Before calling work done:

The build succeeds, tests pass, and lint and formatting are clean.

<!-- agents-md:project:done-checks -->

- The generic build and test expectation is conditional here: this prose
  repository has no build step or automated test suite; use the checks below.
- `npm run lint` clean (prettier + markdownlint)
- Cross-cutting prompt edits applied to every affected tool, not just one
- A changed payload reads correctly and the PR names which destination it
  syncs to

<!-- /agents-md:project:done-checks -->

<!-- /agents-md:managed:done -->
