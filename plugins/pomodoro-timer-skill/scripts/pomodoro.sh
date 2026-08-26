#!/usr/bin/env bash
# pomodoro.sh — minimal POSIX-shell Pomodoro timer
# Usage: pomodoro.sh [WORK_MIN=25] [BREAK_MIN=5] [CYCLES=4]

set -u

WORK_MIN="${1:-25}"
BREAK_MIN="${2:-5}"
CYCLES="${3:-4}"

if ! [[ "$WORK_MIN" =~ ^[0-9]+$ ]] || ! [[ "$BREAK_MIN" =~ ^[0-9]+$ ]] || ! [[ "$CYCLES" =~ ^[0-9]+$ ]]; then
  echo "error: WORK_MIN, BREAK_MIN, CYCLES must be non-negative integers" >&2
  exit 2
fi

WORK_SEC=$((WORK_MIN * 60))
BREAK_SEC=$((BREAK_MIN * 60))

run_phase() {
  local label="$1"; shift
  local total="$1"; shift
  local start_ts
  start_ts="$(date +%s)"
  local end_ts=$((start_ts + total))

  echo "==> ${label} (${total}s)"
  while [[ "$(date +%s)" -lt "$end_ts" ]]; do
    local now elapsed remaining pct bar_len filled
    now="$(date +%s)"
    elapsed=$((now - start_ts))
    remaining=$((total - elapsed))
    pct=$(( elapsed * 100 / total ))
    bar_len=20
    filled=$(( pct * bar_len / 100 ))
    bar=$(printf '%*s' "$filled" '' | tr ' ' '#')
    pad=$(printf '%*s' "$((bar_len - filled))" '' | tr ' ' '-')
    printf '\r  [%s%s] %3d%%  %02d:%02d remaining' "$bar" "$pad" "$pct" \
      $((remaining / 60)) $((remaining % 60))
    sleep 1
  done
  printf '\r  [%s] 100%%  done\n' "$(printf '%*s' 20 '' | tr ' ' '#')"
  printf '\a'  # system bell
}

for ((i = 1; i <= CYCLES; i++)); do
  echo "--- Cycle ${i}/${CYCLES} ---"
  run_phase "WORK" "$WORK_SEC"
  if [[ "$i" -lt "$CYCLES" ]]; then
    run_phase "BREAK" "$BREAK_SEC"
  fi
done

echo "All ${CYCLES} cycle(s) done. Great work!"
