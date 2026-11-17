#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="$ROOT/out/songroom"
for name in caption lipsync collector; do
  pidfile="$OUT/$name.pid"
  [[ -f "$pidfile" ]] || continue
  pid="$(<"$pidfile")"
  case "$name" in
    caption) script="tools/caption_printer.py" ;;
    lipsync) script="tools/songroom_lipsync.py" ;;
    collector) script="tools/songroom_overlay.py" ;;
  esac
  if kill -0 "$pid" 2>/dev/null && ps -p "$pid" -o command= | grep -F "$script" >/dev/null; then
    kill -TERM "$pid" 2>/dev/null || true
    echo "$name stopped (PID $pid)."
  fi
  rm -f "$pidfile"
done
