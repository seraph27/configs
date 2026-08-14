#!/usr/bin/env bash
# PreToolUse(Bash) guard — blocks cross-project footguns deterministically,
# so instruction-following no longer depends on the model remembering rules.
# Exit 2 + stderr = block (reason is fed back to the model). Exit 0 = allow.
# One-off escape hatch: run the session with CLAUDE_GUARD_OFF=1.
#
# Command-shaped patterns are matched against a QUOTE-STRIPPED copy of the
# command, so prose inside commit messages / PR titles ("never git reset
# --hard") does not false-positive. Known limitation: heredoc bodies are not
# stripped — put long prose in a file and pass --body-file / -F instead.
set -u
[ "${CLAUDE_GUARD_OFF:-0}" = "1" ] && exit 0
command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat 2>/dev/null || true)
[ -n "$INPUT" ] || exit 0
TOOL=$(printf '%s' "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
[ "$TOOL" = "Bash" ] || exit 0
CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
[ -n "$CMD" ] || exit 0

RAW=$(printf '%s' "$CMD" | tr '\n\t' '  ')
# Quoted segments are data (messages, titles), not commands.
CODE=$(printf '%s' "$RAW" | sed -E "s/'[^']*'//g; s/\"[^\"]*\"//g")

block() { printf 'guard-bash: BLOCKED — %s\n' "$1" >&2; exit 2; }

# 1. Shared-process murder (other agents/worktrees share this machine)
printf '%s' "$CODE" | grep -Eq '(^|[;&|[:space:]])(sudo[[:space:]]+)?(pkill|killall)([[:space:]]|$)' \
  && block "pkill/killall kills other agents' shared dev processes. Signal only PIDs you spawned: kill <pid>."

# 2. Secrets must stay off the transcript
printf '%s' "$CODE" | grep -Eq '(^|[;&|[:space:]])printenv([[:space:]]|$)' \
  && block "printenv dumps secrets into the transcript. Read the one var you need in-process instead."
SCRUBBED=$(printf '%s' "$CODE" | sed -E 's/\.env\.(example|sample|template|test)[A-Za-z0-9._-]*//g')
printf '%s' "$SCRUBBED" | grep -Eq '(^|[;&|[:space:]])(cat|bat|head|tail|less|more|strings|xxd|od|base64|cut|grep|rg|sed|awk)[^;&|]*\.env' \
  && block ".env holds live secrets (including commented prod lines). Never print it. Load with 'set -a; source .env; set +a' or read it in-process in a script."
printf '%s' "$RAW" | grep -Eq '(^|[;&|[:space:]])(echo|printf)[^;&|]*\$\{?[A-Za-z_]*(SECRET|TOKEN|PASSWORD|API_KEY|_KEY|DATABASE_URL)' \
  && block "echoing secret-bearing env vars puts them in the transcript. Use them in-process."

# 3. Destructive git (no destructive recovery — explain broken state instead)
printf '%s' "$CODE" | grep -Eq 'git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+reset[[:space:]]+--(hard|merge)' \
  && block "git reset --hard destroys uncommitted work. Explain the broken state instead."
printf '%s' "$CODE" | grep -Eq 'git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+clean[[:space:]]+-[a-zA-Z]*f' \
  && block "git clean -f deletes untracked files. List them first; delete specific files if truly needed."
printf '%s' "$CODE" | grep -Eq 'git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+(checkout|restore)[[:space:]]+(--[[:space:]]+)?\.([[:space:]]|$)' \
  && block "broad checkout/restore discards local changes. Restore specific files only."
printf '%s' "$CODE" | grep -Eq 'git[^;&|]*push[^;&|]*[[:space:]]--force([[:space:]]|$)' \
  && block "plain --force overwrites remote history. Use --force-with-lease, only on your own task branch."

# 4. Recursive rm outside temp/scratch areas
# Detect the rm on CODE (so quoted prose can't trigger it), but scan targets on
# RAW (so a quoted absolute path still counts as a target).
if printf '%s' "$CODE" | grep -Eq '(^|[;&|[:space:]])rm[[:space:]]+(-[a-zA-Z]+[[:space:]]+)*-[a-zA-Z]*[rR]'; then
  if printf '%s' "$RAW" | grep -Eq '(~|\$HOME|/Users/|/home/|[[:space:]]"?/[a-zA-Z]|[[:space:]]\.\.?([[:space:]]|$|/)|[[:space:]]\*)' \
     && ! printf '%s' "$RAW" | grep -Eq '(/tmp/|/private/tmp|/var/folders|scratchpad)'; then
    block "recursive rm on home/absolute/wildcard paths. Delete specific files, or work in the scratchpad."
  fi
fi

exit 0
