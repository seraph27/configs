#!/bin/bash
# Fires on SessionEnd. Auto-labels the FleetView job for this session:
#   - name : derived from the first real user prompt (only if not user-named)
#   - color: deterministic-random from the session id (only if unset)
# Never clobbers a name/color you set by hand (nameSource=user / existing color).
# No-op for sessions that have no FleetView job dir (e.g. headless `claude -p`).

set -u
LOG="$HOME/.claude/logs/label-session.log"
mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1

INPUT=$(cat)
SESSION=$(printf '%s' "$INPUT" | jq -r '.session_id // empty')
TRANSCRIPT=$(printf '%s' "$INPUT" | jq -r '.transcript_path // empty')
# UserPromptSubmit delivers the prompt text directly (transcript may not be flushed yet).
PROMPT=$(printf '%s' "$INPUT" | jq -r '.prompt // empty')
[ -z "$SESSION" ] && { echo "$(date): no session_id"; exit 0; }

# Find the job state.json. Fast path: dir named by the short session id. Else scan.
matches() { jq -e --arg s "$SESSION" '(.sessionId==$s) or (.resumeSessionId==$s)' "$1" >/dev/null 2>&1; }
STATE=""
FAST="$HOME/.claude/jobs/${SESSION:0:8}/state.json"
if [ -f "$FAST" ] && matches "$FAST"; then
  STATE="$FAST"
else
  for f in "$HOME"/.claude/jobs/*/state.json; do
    [ -f "$f" ] || continue
    matches "$f" && { STATE="$f"; break; }
  done
fi
[ -z "$STATE" ] && { echo "$(date): no job for $SESSION (skip)"; exit 0; }

CUR_NAMESRC=$(jq -r '.nameSource // empty' "$STATE")
CUR_COLOR=$(jq -r '.color // empty' "$STATE")

# Early exit: already user-named and colored — nothing this hook would change.
[ "$CUR_NAMESRC" = "user" ] && [ -n "$CUR_COLOR" ] && { echo "$(date): $SESSION already labeled (skip)"; exit 0; }

# --- name: derive from first real user prompt, unless user already named it ---
# Prefers the earliest substantive transcript prompt; falls back to the stdin
# prompt (UserPromptSubmit fires before the transcript is flushed on msg #1).
NEWNAME=""
if [ "$CUR_NAMESRC" != "user" ]; then
  NEWNAME=$(TRANSCRIPT="$TRANSCRIPT" PROMPT="$PROMPT" python3 <<'PY'
import json, os, re
SKIP = ("base directory for this skill", "this session is being continued",
        "caveman", "<command-", "<local-command", "<system-reminder>")
# Generic continuations that make useless names — skip and keep scanning.
GENERIC = {"is this done", "is this done?", "yes", "no", "ok", "okay", "go",
           "go on", "continue", "continue from where you left off", "thanks",
           "thank you", "yep", "yeah", "sure", "do it", "proceed", "test"}
def text(c):
    if isinstance(c, str): return c
    if isinstance(c, list):
        return " ".join(p.get("text","") for p in c
                         if isinstance(p, dict) and p.get("type")=="text")
    return ""
def clean(t):
    """Return a usable label, or None if the prompt is skip/generic/too short."""
    t = (t or "").strip()
    if not t: return None
    low = t.lower()
    if t.startswith("<") or any(s in low for s in SKIP): return None
    t = re.sub(r"^/[Uu]sers/\S*?\.(png|jpg|jpeg|gif)\s*", "", t)  # leading pasted-image path
    t = re.sub(r"\s+", " ", t).strip()
    if len(t) < 12 or t.lower().rstrip("?.! ") in GENERIC: return None
    s = t[:40]
    if len(t) > 40 and " " in s:
        s = s.rsplit(" ", 1)[0]
    return s.strip()
name = None
tp = os.environ.get("TRANSCRIPT", "")
if tp and os.path.isfile(tp):
    for line in open(tp):
        try: o = json.loads(line)
        except Exception: continue
        if o.get("type") != "user": continue
        name = clean(text(o.get("message", {}).get("content")))
        if name: break
if not name:                                           # transcript empty/unflushed
    name = clean(os.environ.get("PROMPT", ""))
if name: print(name)
PY
)
fi

# --- color: deterministic pick from session id, unless already colored ---
NEWCOLOR=""
if [ -z "$CUR_COLOR" ]; then
  PALETTE=(blue green purple orange cyan)
  IDX=$(printf '%s' "$SESSION" | cksum | cut -d' ' -f1)
  NEWCOLOR=${PALETTE[$((IDX % ${#PALETTE[@]}))]}
fi

[ -z "$NEWNAME" ] && [ -z "$NEWCOLOR" ] && { echo "$(date): nothing to set for $SESSION"; exit 0; }

# Atomic read-modify-write of just our fields.
TMP=$(mktemp)
jq \
  --arg name "$NEWNAME" \
  --arg color "$NEWCOLOR" \
  '
  (if $name  != "" then .name = $name | .nameSource = "user" else . end) |
  (if $color != "" then .color = $color else . end)
  ' "$STATE" > "$TMP" && mv "$TMP" "$STATE"

echo "$(date): $SESSION name=${NEWNAME:-<kept>} color=${NEWCOLOR:-<kept>}"
exit 0
