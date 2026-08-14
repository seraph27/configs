#!/usr/bin/env bash
# Claude Code status line — branch · model/effort · context gauge · weekly quota
# Catppuccin Mocha. Degrades cleanly without jq, git, truecolor, or UTF-8.
set -u

input=$(cat)
[ -n "$input" ] || exit 0

# --- palette ----------------------------------------------------------------
# Truecolor where available, 256-color approximations elsewhere, plain if NO_COLOR.
if [ -n "${NO_COLOR:-}" ] || [ "${TERM:-dumb}" = "dumb" ]; then
  blue= mauve= green= yellow= red= dim= rst=
elif [ "${COLORTERM:-}" = "truecolor" ] || [ "${COLORTERM:-}" = "24bit" ]; then
  blue=$'\033[38;2;137;180;250m'   mauve=$'\033[38;2;203;166;247m'
  green=$'\033[38;2;166;227;161m'  yellow=$'\033[38;2;249;226;175m'
  red=$'\033[38;2;243;139;168m'    dim=$'\033[38;2;108;112;134m'
  rst=$'\033[0m'
else
  blue=$'\033[38;5;111m'  mauve=$'\033[38;5;183m'
  green=$'\033[38;5;151m' yellow=$'\033[38;5;223m'
  red=$'\033[38;5;211m'   dim=$'\033[38;5;243m'
  rst=$'\033[0m'
fi

# --- glyphs -----------------------------------------------------------------
case "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" in
  *[Uu][Tt][Ff]*) full="█" empty="░" pipe="│" dot="·" ell="…" ;;
  *)              full="#" empty="-" pipe="|" dot=":" ell=".." ;;
esac
sep="${dim}${pipe}${rst}"

# --- field extraction -------------------------------------------------------
if command -v jq >/dev/null 2>&1; then
  # One jq pass, so the status line costs a single subprocess. Fields are joined
  # with US (\037) rather than a tab: bash collapses runs of IFS *whitespace*,
  # which would silently shift every field left whenever one comes back empty.
  IFS=$'\037' read -r cwd model effort ctx_size ctx_pct rl7 <<EOF
$(printf '%s' "$input" | jq -r '[
    .cwd // "",
    (.model.id // "" | sub("^claude-";"") | sub("\\[.*$";"")),
    (.effort.level // .effort_level // .effortLevel // ""),
    (.context_window.context_window_size // 0),
    (.context_window.used_percentage // 0),
    (.rate_limits.seven_day.used_percentage // -1)
  ] | map(tostring) | join("\u001f")' 2>/dev/null)
EOF
else
  cwd=$(printf '%s' "$input" | sed -n 's/.*"cwd":"\([^"]*\)".*/\1/p')
  model=$(printf '%s' "$input" | sed -n 's/.*"id":"claude-\([^"[]*\).*/\1/p' | head -1)
  effort="" ctx_size=0 ctx_pct=0 rl7=-1
fi
[ -z "${effort:-}" ] && effort=$(sed -n 's/.*"effortLevel"[[:space:]]*:[[:space:]]*"\([a-z]*\)".*/\1/p' \
  "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json" 2>/dev/null | head -1)

# --- segments ---------------------------------------------------------------
branch=""
if command -v git >/dev/null 2>&1; then
  # symbolic-ref works on a repo with no commits yet; fall back to a short SHA
  # so a detached HEAD shows where it is instead of the word "HEAD".
  branch=$(git -C "${cwd:-.}" --no-optional-locks symbolic-ref --short -q HEAD 2>/dev/null) ||
    branch=$(git -C "${cwd:-.}" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  [ ${#branch} -gt 22 ] && branch="${branch:0:21}${ell}"
fi

id=""
[ -n "${model:-}" ] && id="${mauve}${model}${rst}"
[ -n "${effort:-}" ] && id="${id:+$id${dim}${dot}${rst}}${dim}${effort}${rst}"

ctx=""
if [ "${ctx_size:-0}" -gt 0 ] 2>/dev/null; then
  pct=${ctx_pct%%.*}; [ -z "$pct" ] && pct=0
  cells=10
  filled=$(( (pct * cells + 50) / 100 ))
  [ "$filled" -gt "$cells" ] && filled=$cells
  [ "$filled" -lt 0 ] && filled=0
  if   [ "$pct" -ge 80 ]; then col=$red
  elif [ "$pct" -ge 55 ]; then col=$yellow
  else                        col=$green; fi
  bar=""
  i=0
  while [ "$i" -lt "$cells" ]; do
    if [ "$i" -lt "$filled" ]; then bar="$bar$full"; else bar="$bar$empty"; fi
    i=$((i + 1))
  done
  size=$(awk -v n="$ctx_size" 'BEGIN {
    if (n >= 1000000) printf "%gM", n/1000000; else printf "%gk", n/1000 }')
  ctx="${col}${bar}${rst} ${col}${pct}%${rst} ${dim}${size}${rst}"
fi

limits=""
if [ "${rl7%%.*}" -ge 0 ] 2>/dev/null; then limits="${dim}7d ${rl7%%.*}%${rst}"; fi

out=""
for part in "${branch:+${blue}${branch}${rst}}" "$id" "$ctx" "$limits"; do
  [ -n "$part" ] && out="${out:+$out $sep }$part"
done

printf "%s" "$out"
