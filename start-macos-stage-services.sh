#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"
PYTHON="$ROOT/.venv/bin/python"
OUT="$ROOT/out/songroom"
mkdir -p "$OUT"

if [[ ! -x "$PYTHON" ]]; then
  echo "Environment not found. Run ./setup-macos.sh first."
  exit 1
fi

start_service() {
  local name="$1" script="$2" pidfile="$OUT/$1.pid"
  if [[ -f "$pidfile" ]] && kill -0 "$(<"$pidfile")" 2>/dev/null; then
    local pid="$(<"$pidfile")"
    if ps -p "$pid" -o command= | grep -F "$script" >/dev/null; then
      echo "$name already running (PID $pid)."
      return
    fi
  fi
  nohup "$PYTHON" -u "$script" >>"$OUT/$name.stdout.txt" 2>>"$OUT/$name.stderr.txt" </dev/null &
  echo "$!" > "$pidfile"
  echo "$name started (PID $!)."
}

start_service caption tools/caption_printer.py
start_service lipsync tools/songroom_lipsync.py
start_service collector tools/songroom_overlay.py
