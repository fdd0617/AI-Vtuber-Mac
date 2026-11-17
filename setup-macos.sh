#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This setup script is for macOS."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Install Homebrew first: https://brew.sh/"
  exit 1
fi
if ! brew list --versions portaudio >/dev/null 2>&1; then
  echo "Install the PortAudio build dependency with: brew install portaudio"
  exit 1
fi

PYTHON="${PYTHON:-python3}"
if ! "$PYTHON" -c 'import sys; raise SystemExit(not ((3, 10) <= sys.version_info[:2] <= (3, 12)))'; then
  echo "Python 3.10 through 3.12 is supported by the current dependency set."
  exit 1
fi

if [[ ! -x .venv/bin/python ]]; then
  "$PYTHON" -m venv .venv
fi
.venv/bin/python -m pip install --upgrade pip wheel
.venv/bin/python -m pip install -r requirements/core.txt -r requirements/platform.txt -r requirements/macos.txt
echo "Setup complete. Start with ./start-macos.sh"
