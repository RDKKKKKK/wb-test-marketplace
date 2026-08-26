---
name: pomodoro-timer
description: Pomodoro (番茄钟) focus timer skill — runs a 25-minute work / 5-minute break cycle using a shell script. Use this skill when the user says "start a pomodoro", "番茄钟", "focus timer", "25 min timer", or "pomodoro cycle".
agent_created: true
---

# Pomodoro Timer Skill

Lightweight Pomodoro focus-timer skill. Runs a 25-min work / 5-min break cycle using `pomodoro.sh` from the bundled `scripts/` directory.

## When to use this skill

Trigger phrases include:

- "start a pomodoro"
- "番茄钟"
- "focus timer 25 minutes"
- "pomodoro cycle"
- "begin a focus session"

## How WorkBuddy uses this skill

1. Load this `SKILL.md` to learn the script's CLI contract.
2. When the user asks to start a timer, execute the bundled script via `Bash`:

   ```bash
   ${CODEBUDDY_PLUGIN_ROOT}/scripts/pomodoro.sh 25 5
   ```

   Defaults: 25-minute work block, 5-minute break. Accepts custom durations in minutes.

3. Report the cycle count back to the user when the script finishes.

## Bundled resources

- `scripts/pomodoro.sh` — POSIX shell timer that ticks every second, plays an ASCII progress bar, and emits a system bell (`printf '\a'`) at the end of each phase.

## CLI contract

```text
pomodoro.sh [WORK_MIN=25] [BREAK_MIN=5] [CYCLES=4]
```

| Arg          | Default | Description                          |
|--------------|---------|--------------------------------------|
| `WORK_MIN`   | 25      | Length of the focus block (minutes)  |
| `BREAK_MIN`  | 5       | Length of the break block (minutes)  |
| `CYCLES`     | 4       | Number of work/break cycles to run   |

Exit code: `0` on normal completion, non-zero only if `WORK_MIN` or `BREAK_MIN` is negative.

## Notes

- The script is **non-blocking** only in the sense that it prints progress every second; it must run in the foreground (it will hold the Bash tool until cycles finish). For long sessions, recommend the user run it in a real terminal.
- macOS / Linux only — depends on `date`, `sleep`, and `printf`.
