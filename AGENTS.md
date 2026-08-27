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

## Decision Notes (devlog)

`devlog/` holds selected decision records, not session logs. Most work needs
no note. In the ordinary case, keep at most one note per work unit or PR. Name
it `YYYY-MM-DD-HHMM-slug.md`. Follow the protocol in `devlog/README.md`.

- **Write a note only for a lasting decision or discovery.** A note is
  warranted when the work includes at least one of these:

  - A significant, non-obvious decision that rejects a reasonable option.
  - A finding that materially changes the model, policy, risk, or direction.
  - An owner decision that would otherwise exist only in chat.
  - Essential cross-session context that the issue or PR doesn't carry.
  - A change on the project's mandatory-note list, when it has one.

- **Skip notes for routine work.** Implementation, formatting, ordinary docs,
  dependency updates, mechanical syncs, and simple fixes need no note unless
  they reveal a lasting decision or discovery.
- **Record the final reasoning.** Include rejected options, changed
  assumptions, important verification findings, and a "Revisit when ..."
  condition where one is useful. Do not include diffs, test logs, chronology,
  or PR status.
- **Let an active note evolve.** Update it while its work unit or PR is open.
  Freeze it when the PR merges.
- **Find notes from the work first.** Read notes linked from the current issue
  or PR. Otherwise, search by path, topic, contract, or decision name. Read
  the latest note only when resuming the work unit it describes.
- **Treat old notes as evidence, not rules.** Do not silently overturn an
  explicit owner decision. When new evidence conflicts with one, name the old
  decision, explain which assumption or condition changed, and propose the
  revision.
- **Track deferred work in issues.** Link the note from an issue that starts
  there. The note may keep a historical `Follow-up: #N` link, but never a
  second status record. Put non-actionable observations in "Revisit when ...".

<!-- /agents-md:managed:devlog -->

<!-- agents-md:managed:finish-line -->

## Default Agent Finish Line

For changes to code, docs, assets, or project state, finish with an open,
review-ready PR and green required checks. Leave the PR unmerged. Merge only
when the user asks or the project has an explicit self-merge policy.

Before implementation, define a small work contract:

- Objective.
- Testable acceptance criteria.
- Scope.
- Dependencies and blockers.
- Explicit non-goals.

A direct user request needs no issue. The request and PR carry its contract.
Use a tracker issue when the work must:

- Continue in a later session.
- Pass between agents or sessions, even during one short session.
- Coordinate concurrent workers.
- Enter a backlog.

When one agent or session hands work to another, use the issue and its
comments. Put there what the next one needs and what the previous one produced,
not only chat. Before handoff, create an issue for actionable work deferred
beyond the current scope.

A project may define optional work-unit stages in a project-specific section
outside the managed blocks. An active stage controls what may change and where
to stop:

- An implementation stage runs only its allowed checklist steps and stops
  where the active stage says to stop.
- A non-implementation stage follows its own record.
- Finishing one stage hands work off. It doesn't authorize the next stage.
- Work outside a declared stage runs the full checklist, except actions owned
  by another declared stage.

Start work only from an explicit user assignment. An issue, label, backlog
entry, satisfied dependency, completed plan, or claim isn't authorization.
An agent may choose work for itself only when an explicit project policy
allows it.

The implementation checklist:

1. Read the README. When resuming work, also read its issue or PR and linked
   decision notes. Resolve the default branch and update it from its remote.
   Start from that exact tip. Only a declared stacked PR may start elsewhere;
   see Branches.
2. Create a correctly named branch in a dedicated worktree or equivalent
   isolated checkout. See Branches for the primary-checkout exception.
3. Make the scoped change. Include the docs, tests, and assets needed to keep
   it complete. Add a decision note only when its triggers apply.
4. Run relevant verification and the standard lint, build, and test checks.
   Record any check you could not run in the PR.
5. Commit one concern at a time. Explain why in each commit body.
6. Push and open the PR with the template. Remove sections that don't apply.
7. Follow "Handing Off the PR" under Pull Requests. Leave the PR open for a
   human to review and merge.

Before committing work on a destructive path, credential-leak surface, or
returned-object trust boundary, read `docs/agent-workflow.md` §refute-first and
run its verification pass. A destructive path includes delete or cleanup. A
returned-object trust boundary is where code trusts fields returned by an
external call or deserializer. This extra pass doesn't apply to a docs typo or
unrelated refactor.

<!-- /agents-md:managed:finish-line -->

<!-- agents-md:managed:context -->

## Context Discipline

Working context is limited. Content added now is sent again with later tool
calls, so early noise makes every later step more expensive. Keep durable
state in files, such as the issue, PR body, or decision note. Keep only what
the current step needs in working context.

- **Keep raw bulk out.** Prefer a relevant file section, match list, or
  filtered log tail over a whole file or unfiltered output.
- **Delegate broad reading when supported.** Use a delegate for large searches
  or mechanical sweeps only when the platform and session permit it. Ask for
  conclusions, `file:line` references, and a short summary, never raw output.
- **Use bounded reads when delegation is unavailable.** A few targeted reads
  are also better than a delegate for a small question.
- **Match the delegate to the task.** When you can choose a model or effort
  level, use the cheapest capable option for mechanical reading. Skip this when
  the platform offers neither choice.
- **Explain large parallel work first.** One delegate for exploration or
  review is normal. Before using more, state the expected scale and get the
  user's approval or stay within a budget they already set.
- **Suggest a fresh session at a natural boundary.** After a PR handoff,
  review round, or work unit, a long session adds little value. Suggest a new
  session seeded with the PR number. The PR and decision note carry the state.

<!-- /agents-md:managed:context -->

<!-- agents-md:managed:communication -->

## Writing for Humans

People scan human-facing work such as handoffs, PRs, issues, plans, reviews,
and questions. Make the important point clear without requiring them to
translate agent jargon or search for the conclusion.

- **Lead with the bottom line.** Start with the conclusion, decision, or ask.
  Include any assumption or caveat that could change it. Put support below in
  order of importance.
- **Front-load each unit.** Begin every heading, bullet, and paragraph with
  its key words.
- **Layer detail.** Keep the decision in the skim layer. Put evidence,
  options, and detail below it or in a linked issue or note. Do not remove
  needed evidence just to make the text shorter.
- **Ask about three questions per round.** Start with questions that block the
  work. Give each a recommended answer and one-line reason. Turn questions
  with a safe default into visible assumptions the reader can reject. Save
  remaining blocking questions for the next round.
- **Reserve flags for meaningful risk.** Label severity when useful. Flag
  facts that change the decision or confidence in the result. Make rare,
  critical warnings easy to notice.
- **State uncertainty plainly.** Say what was not verified and what remains
  uncertain. Clear writing must not make weak evidence look conclusive.

<!-- /agents-md:managed:communication -->

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

All work lands through a PR. Resolve the default branch (`main` in the
examples) and update it from its remote. Then create an ordinary work-unit
branch from that exact tip. Never start from the current feature branch. Only
a declared stacked PR may use another base.

Use atomic commits and a real merge commit. Let a human decide when to merge.
Never commit directly to `main`, even for a small change. Direct commits break
the `--first-parent` history.

Name a branch `<type>/<short-kebab-slug>`:

- Choose a Conventional Commits type: `feat`, `fix`, `refactor`, `docs`, or
  `chore`.
- Use two to four kebab-case words for the work unit.
- Use exactly one slash. A bare `feat` can't coexist with `feat/x`.
- Omit ticket numbers, dates, and owner prefixes.
- Add an owner segment, such as `bnw/feat/...`, only when several people or
  agents work in parallel.

Examples:

```text
feat/worksheet-promotion
fix/pane-focus-race
chore/swift-format-sweep
```

Merged branches may auto-delete. If the repository doesn't do that, delete
the branch after merge.

**Plan concurrency before creating worktrees.** Keep coupled work in one work
unit, an explicit dependency chain, or a declared stack. Separate worktrees do
not make dependent changes safe to run in parallel. Before substantive work,
use the project's claim visible on the code host for an assigned concurrent
unit, when one exists. A claim only tells others that someone is already
working; it isn't permission to start.

**Isolate every implementation work unit.** Use a dedicated worktree or an
equivalent separate checkout when the platform and session support one. Create
it from the freshly updated default-branch tip. For example:

```sh
git worktree add <path> -b <type>/<slug> <default-branch>
```

Use the primary checkout only when the user or project requires it, or the
platform can't create another checkout. This can happen with no multi-checkout
support or a sandbox pinned to one directory. In that case, serialize work on
one correctly based branch, report the exception, and never run concurrent work
units in that checkout.

After merge, remove the worktree while standing outside it:
`git worktree remove <path>`.

Work that depends on an open PR may stack on its branch. See Stacked PRs under
Pull Requests.

<!-- /agents-md:managed:branches -->

<!-- agents-md:managed:pull-requests -->

## Pull Requests

One PR represents one work unit. Review it as a whole and merge it with a real
merge commit. Commits explain each atomic decision; the PR explains the full
change.

- **Write an imperative title of at most 72 characters.** Name the outcome,
  without a type prefix, ticket number, or other tracking text. The title and
  PR number become the whole merge-commit message in the intended setup. Write
  it for `git log --first-parent`.
- **Use the PR template for the body.** Include Why, What, Screenshots for UI
  changes, optional Review Notes, and Verification. Key the commit map by
  subject, not SHA. Start verification bullets with `Passed:`, `Checked:`,
  `Attempted:`, or `Not run:`. Before writing or updating the body, read
  `docs/agent-workflow.md` §pr-body. For a UI change, meet its Screenshots
  requirements.
- **Self-review the full diff in the PR files view.** Look for stray changes,
  debug code, scope creep, and accidental files. This catches accidental
  changes; it doesn't check whether the solution is correct.
- **Repeat integration checks when the base moves.** CI, final diff review,
  and readiness count only for the base commit you checked. Repeat all three
  if the base changes.
- **Use fresh eyes for substantive review.** Reviewing your own work in the
  same conversation shares the author's blind spots. A review in a fresh
  conversation is more independent. A bot from another provider or a human is
  stronger. Rely on a bot or human before handoff. For non-trivial work, or
  without a bot reviewer, read `docs/agent-workflow.md` §pre-push-review before
  pushing.
- **Record an automated reviewer you observe.** If the project has no record
  for that reviewer or signal, read `docs/agent-workflow.md` §reviewer-record
  and update the project record before handoff.
- **Judge review comments on their merits.** Fix real findings. Decline
  speculative, contrived, or already-fixed findings with a one-line reason.
  Do not comply automatically.
- **Reply after the fix is final and pushed.** Reply inline with the outcome:
  the final commit SHA for a fix, or the reason for a decline. Then resolve the
  thread. Fold all fixes from one round into their owning commits and push once
  before replying. Resolving every thread isn't a merge gate; a reasoned
  outcome is.
- **Fix the whole defect class.** Search the file and repository for the same
  pattern and fix every instance in one push. For validation or parsing code,
  read `docs/agent-workflow.md` §review-convergence before widening a pattern.
- **Keep reviewing while blockers remain.** Correctness, security, data loss,
  broken invariants, and red CI always require another round. Decide severity
  yourself; the reviewer's label is only evidence. When unsure, treat the
  finding as blocking.
- **Raise the bar as rounds continue.** After the early rounds, or when a
  finding recurs, read `docs/agent-workflow.md` §review-convergence before
  deciding on another round. Before handoff, mark every finding fixed,
  declined, deferred, or explicitly outstanding.
- **Keep the PR body current.** When review adds commits or changes scope,
  update What, the subject-based commit map, and Verification. Mark commits
  that resolve review findings. Keep each finding's outcome in its inline
  reply, not a permanent feedback section.
- **Keep the intended repository rules.** Use merge commits only, disable
  squash and rebase merges, use title-only merge messages, and auto-delete
  merged branches. Do not re-enable a disabled method. Enforce these rules
  manually where repository settings don't.

### Handing Off the PR

A PR is ready to hand off when it's open, green, self-reviewed, has no
unhandled threads, and has no outstanding review activity. After opening the
PR, read `docs/agent-workflow.md` §handing-off and follow its sequence:

1. Start the review watch from the PR open or push event. Only reviewer
   activity after that event counts as new. After another push, start counting
   from that push.
2. Refresh from the current base and record the base commit.
3. Wait for required checks. Never hand off known-red work.
4. Self-review the final diff.
5. Close the watch by handling findings or recording its bounded timeout.
6. Stop and summarize for the human reviewer.

If the user asks you to merge, read
`docs/agent-workflow.md` §merge-and-resync first and follow it step by step.
Do not merge or resync from memory.

### Reviewing a PR

Before reviewing a PR, read `docs/agent-workflow.md` §reviewing-a-pr and use
its review bar.

### Stacked PRs

Before creating a branch or PR that depends on another open PR, read
`docs/agent-workflow.md` §stacked-prs. Name the base explicitly; never inherit
it from the current checkout.

<!-- /agents-md:managed:pull-requests -->

<!-- agents-md:managed:commits -->

## Commits

History supports diagnosis, review, and learning. Keep each commit useful for
all three.

- **Keep one concern in each commit, and keep every commit green.** Split a
  commit whose body needs separate labels such as Correctness and Performance.
  Each commit must build and pass tests on its own. Never leave a red
  intermediate state that breaks `git bisect`.
- **Explain why in the body.** Use specific body text wrapped at 72
  characters. Link the work unit's decision note when one exists. Report a
  meaningful change as a delta, such as "27 to 36 tests", not an absolute
  claim such as "36 tests green" that will go stale.
- **Never commit secrets.** Keep credentials, tokens, keys, and `.env` values
  out of commits. Name the secret and use a placeholder in examples.
- **Separate mechanical churn.** Put formatting, renames, and moves in their
  own commit. Add that commit to `.git-blame-ignore-revs` in the same change,
  then enable it locally with
  `git config blame.ignoreRevsFile .git-blame-ignore-revs`.
- **Fold review fixes into the commit that caused them.** This includes issues
  found by review or self-review. Do not append an "address review" commit.
- **Keep every folded commit green.** Fold only on an unmerged feature branch.
  After merge, use a new commit. Update the matching active decision note in
  the same operation when one exists.
- **Force-push safely after a fold.** Use `--force-with-lease` on the feature
  branch. Never force-push `main`. The reset, amend, or rebase mechanism is
  your choice.
- **Push before replying to review.** The inline reply must cite the final,
  pushed SHA that contains the fix. A separate review-fix commit left on the
  branch means the fold is unfinished.
- **Never squash-merge multi-commit work.** Use a real merge commit so
  `git log --first-parent` shows the work-unit story and the full log preserves
  its atomic commits. Put narrative subjects such as "Walking skeleton:
  end-to-end flow" at the merge or PR level.

<!-- /agents-md:managed:commits -->

<!-- agents-md:managed:done -->

## Definition of Done for an Increment

An increment is done only when it's running and exercised by the end of the
work session. "Code complete" or passing tests alone isn't enough.

Before calling the work done, confirm that the build succeeds, tests pass,
and lint and formatting are clean.

<!-- agents-md:project:done-checks -->

- The generic build and test expectation is conditional here: this prose
  repository has no build step or automated test suite; use the checks below.
- `npm run lint` clean (prettier + markdownlint)
- Cross-cutting prompt edits applied to every affected tool, not just one
- A changed payload reads correctly and the PR names which destination it
  syncs to

<!-- /agents-md:project:done-checks -->

<!-- /agents-md:managed:done -->
