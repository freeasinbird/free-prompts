#!/usr/bin/env bash
#
# check-payloads.sh — verify the prompt payloads under system/ and chat/.
#
# Scope: PAYLOADS ONLY. These are the checks that would otherwise be re-run by
# hand on every audit, so they live here instead of in a reviewer's memory:
#
#   1. Shared-core parity. The system/ payloads carry a byte-identical
#      tool-agnostic core between the SHARED markers. An empty extraction is
#      itself a failure: it means a file has no core, not that it matches.
#   2. Self-referential style bans. Each payload bans em dashes for its own
#      prose, so each payload must contain none.
#   3. ChatGPT character budget. chat/chatgpt/custom-instructions.md is pasted
#      into a hard-capped field. The cap is 1500 for Free/Go; paid tiers were
#      raised to 5000 on 2026-07-15, but the payload deliberately targets 1500
#      so it stays portable. Override with CHATGPT_CAP to check another tier.
#
# Exit status is the verdict, so this composes in CI and under `set -e`.
#
# Usage:
#   scripts/check-payloads.sh
#   CHATGPT_CAP=5000 scripts/check-payloads.sh

set -uo pipefail

# Convention for this script: every external command's exit status is either
# checked, or its failure is caught by a downstream emptiness guard. A checker
# that fails open is worse than no checker, because it also hands you a green
# verdict to point at.
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd) || exit 1
REPO=$(cd "$SCRIPT_DIR/.." && pwd) || exit 1
cd "$REPO" || exit 1

# A count, not a flag. A boolean saturates: once an earlier section has set
# it, a later section's before/after comparison sees no change and reports
# success for a check that just failed. A monotonic counter cannot saturate.
failures=0
fail() {
  echo "FAIL: $*" >&2
  failures=$((failures + 1))
}

# A section's "ok:" line is a success claim, so it may only print when that
# section actually passed: an unconditional success line contradicts its own
# FAIL on stderr and gives line-oriented log readers a green signal for a
# check that failed.
section_start() { echo "$failures"; }
section_passed() { [ "$failures" -eq "$1" ]; }

TMPDIR_CHECK=$(mktemp -d) || {
  echo "FAIL: could not create a temporary directory" >&2
  exit 1
}
trap 'rm -rf "$TMPDIR_CHECK"' EXIT

# Every numeric comparison below runs through this first. `[ x -gt y ]` on a
# non-integer emits an error and returns nonzero, which an `if` reads as
# "not over the cap": the gate would fail open on exactly the malformed
# input it should reject.
is_positive_int() {
  case "${1:-}" in
  '' | *[!0-9]*) return 1 ;;
  *) [ "$1" -gt 0 ] 2>/dev/null ;;
  esac
}

CHATGPT_CAP=${CHATGPT_CAP:-1500}
if ! is_positive_int "$CHATGPT_CAP"; then
  echo "FAIL: CHATGPT_CAP must be a positive base-10 integer, got '$CHATGPT_CAP'" >&2
  exit 1
fi
# Normalize at the validation boundary, not at each use. `[ x -gt y ]` reads
# a digit string as decimal but `$((x - y))` reads a leading zero as octal,
# so an unnormalized "01480" compares as 1480 and then fails the subtraction.
# Validating the format without collapsing it to one representation leaves
# the same string parsed by two grammars; every later use gets the same value.
CHATGPT_CAP=$((10#$CHATGPT_CAP))

# Payloads are discovered, not listed. A hardcoded manifest silently skips a
# newly added tool, and for a checker the dangerous failure is under-coverage:
# a payload nobody added to the list looks like a payload with no defects.
# (link-system-prompts.sh takes the opposite trade on purpose, since there the
# dangerous failure is linking something never meant to ship.) READMEs
# document a directory; they are not payloads.
#
# Discovery runs into a file rather than a process substitution, whose exit
# status the shell discards: a `find` that cannot traverse a directory then
# reports fewer payloads and the gate passes on a partial input, which is the
# under-coverage this discovery exists to prevent. Both status and stderr are
# treated as failures, since implementations differ on which one they use.
PAYLOAD_LIST="$TMPDIR_CHECK/payloads.txt"
PAYLOAD_ERR="$TMPDIR_CHECK/find.err"
if ! find system chat -type f -name '*.md' ! -name 'README.md' \
  >"$PAYLOAD_LIST" 2>"$PAYLOAD_ERR"; then
  echo "FAIL: could not enumerate payloads under system/ or chat/" >&2
  cat "$PAYLOAD_ERR" >&2
  exit 1
fi
if [ -s "$PAYLOAD_ERR" ]; then
  echo "FAIL: payload discovery reported errors, so its list may be partial" >&2
  cat "$PAYLOAD_ERR" >&2
  exit 1
fi

PAYLOAD_SORTED="$TMPDIR_CHECK/payloads-sorted.txt"
if ! sort "$PAYLOAD_LIST" >"$PAYLOAD_SORTED" 2>"$PAYLOAD_ERR"; then
  echo "FAIL: could not sort the discovered payload list" >&2
  cat "$PAYLOAD_ERR" >&2
  exit 1
fi

PAYLOADS=()
while IFS= read -r f; do
  PAYLOADS+=("$f")
done <"$PAYLOAD_SORTED"

if [ "${#PAYLOADS[@]}" -eq 0 ]; then
  echo "FAIL: no payloads found under system/ or chat/" >&2
  exit 1
fi

# The shared-core family: every system/ payload carries the same core.
CORE_FAMILY=()
for f in "${PAYLOADS[@]}"; do
  case "$f" in
  system/*) CORE_FAMILY+=("$f") ;;
  esac
done

if [ "${#CORE_FAMILY[@]}" -lt 2 ]; then
  echo "FAIL: expected 2 or more shared-core payloads under system/, found ${#CORE_FAMILY[@]}" >&2
  exit 1
fi

# 1. Shared-core parity ------------------------------------------------------
# The marker lines themselves differ per tool (each names the other file), so
# the extraction drops them and compares only the core body.
#
# Extracts land in files and are compared with `cmp`, never through a shell
# variable: command substitution strips every trailing newline, so drift that
# is purely blank lines before the END marker would compare equal and the
# byte-identical invariant would go unenforced. They share the temporary
# directory created at the top of the script.

extract_core() {
  sed -n '/^<!-- SHARED/,/^<!-- END SHARED/p' "$1" | sed '1d;$d'
}

parity_start=$(section_start)
# Extract paths are indexed rather than derived from the payload path: `tr / _`
# is lossy, so `system/a/b_c.md` and `system/a_b/c.md` would collide and the
# second extraction would overwrite the reference the first is compared against.
core_index=0
ref_file=""
ref_core=""
for f in "${CORE_FAMILY[@]}"; do
  [ -f "$f" ] || {
    fail "missing payload: $f"
    continue
  }
  core_index=$((core_index + 1))
  core="$TMPDIR_CHECK/core-$core_index"
  # Status first: a `sed` that errors after emitting output leaves a nonempty
  # but partial core, which the emptiness guard below happily accepts.
  if ! extract_core "$f" >"$core"; then
    fail "could not extract the shared core from $f"
    continue
  fi
  if [ ! -s "$core" ]; then
    fail "no shared core found in $f (check the SHARED markers)"
    continue
  fi
  if [ -z "$ref_file" ]; then
    ref_file=$f
    ref_core=$core
    continue
  fi
  if ! cmp -s "$ref_core" "$core"; then
    fail "shared-core drift: $f differs from $ref_file"
    diff "$ref_core" "$core" >&2 || true
  fi
done
if [ -n "$ref_file" ] && section_passed "$parity_start"; then
  echo "ok: shared core identical across ${#CORE_FAMILY[@]} payloads"
fi

# 2. Self-referential style bans ---------------------------------------------
# Spelled in bytes so this script does not trip its own check.
EM_DASH=$(printf '\xe2\x80\x94')
style_start=$(section_start)
for f in "${PAYLOADS[@]}"; do
  [ -f "$f" ] || {
    fail "missing payload: $f"
    continue
  }
  # grep exits 0 on match, 1 on none, 2+ on error. Branch on all three: a
  # bare `if grep` would read an unreadable file as a clean one, which is
  # the fail-open shape this whole section exists to avoid.
  grep -n "$EM_DASH" "$f" >&2
  case $? in
  0) fail "em dash in $f (payloads ban them for their own prose)" ;;
  1) ;;
  *) fail "could not scan $f for banned styles" ;;
  esac
done
if section_passed "$style_start"; then
  echo "ok: no em dashes in ${#PAYLOADS[@]} payloads"
fi

# 3. ChatGPT character budget ------------------------------------------------
CHATGPT=chat/chatgpt/custom-instructions.md
if [ -f "$CHATGPT" ]; then
  # Same shape: `wc` or `tr` can emit a plausible number and still fail, and
  # the numeric guard alone would accept it.
  if ! chars=$(wc -m <"$CHATGPT" | tr -d ' '); then
    fail "could not measure $CHATGPT"
    chars=""
  fi
  if ! is_positive_int "$chars"; then
    fail "could not measure $CHATGPT (got '$chars')"
  elif [ "$chars" -gt "$CHATGPT_CAP" ]; then
    fail "$CHATGPT is $chars chars, over the $CHATGPT_CAP cap"
  else
    echo "ok: $CHATGPT is $chars/$CHATGPT_CAP chars ($((CHATGPT_CAP - chars)) spare)"
  fi
else
  fail "missing payload: $CHATGPT"
fi

if [ "$failures" -ne 0 ]; then
  echo "payload checks failed ($failures)" >&2
  exit 1
fi
echo "All payload checks passed."
