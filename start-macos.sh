#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This launcher is for macOS."
  exit 1
fi

if [[ ! -x .venv/bin/python ]]; then
  echo "Environment not found. Run ./setup-macos.sh first."
  exit 1
fi

./start-macos-stage-services.sh
exec .venv/bin/python webui.py
