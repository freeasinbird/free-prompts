# 2026-11-20 15:26 Gemini (Antigravity) system payload

Added a third system payload, `system/gemini/AGENTS.md`, linked to
`~/.gemini/AGENTS.md` so Antigravity sessions get the shared core. The owner
assigned the work in #75.

## Decisions

- **Chose one `~/.gemini/AGENTS.md` file over `GEMINI.md` or rule files
  under `~/.gemini/config/rules/`.** Antigravity loads all of these
  together, and none replaces another. `AGENTS.md` needs no frontmatter, is
  always on, and fits the linker's one-file-per-tool map. A split across rule
  files would need frontmatter and a second map entry for no gain while the
  payload fits one file.
- **Capped the payload at 24,000 bytes in `scripts/check-payloads.sh`.**
  Antigravity truncates any rule file past that size. The core with its
  markers is 20,489 bytes, so the Gemini tail has about 3,500 bytes and the
  core about 1,600 bytes of room once the tail is in. A core edit that grows
  past that fails lint. Then shorten the Gemini tail, shorten the core, or
  split the Gemini payload across two rule files.
  The cap has no override because Antigravity has one limit.
- **Wrote the tail for Gemini but kept every rule true for any model.** The
  same file loads for every Antigravity session, and Antigravity also runs
  Claude models. So the tail states Antigravity behavior and wording rules,
  not claims about one model's habits.
- **Took the wording tilts from Gemini 3 guidance.** Google has no prompting
  guide for Gemini 4 Neon, Antigravity's default model, as of 2026-11-20. The
  newest model-specific guidance is the Gemini 3 section of Google's
  prompting strategies page, plus the Neon page's warning against raw-text
  tool calls.
- **Dropped two planned claims that no page supports.** The rules page
  doesn't say which end of an oversized file is cut, and the permissions page
  doesn't say how long a plain MCP Allow lasts.

## Evidence

- `agy` 1.5.13 follows a symlinked `~/.gemini/AGENTS.md`. With the link in
  place, `agy --mode plan -p` quoted the tail's `## Gemini Specifics`
  heading. Without it, the same prompt reported no global rules.
- The combined 20,000-token budget for global and always-on rules is
  unmeasured. Past it, Antigravity replaces the largest rule files with
  pointers, so a large project `AGENTS.md` could push this payload out of
  inline context.

Revisit when Google publishes a Gemini 4 Neon prompting guide, when the core
outgrows the cap, or when Antigravity changes its rule paths, size limit, or
symlink handling.
