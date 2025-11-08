#!/usr/bin/env bash
## flameshot-capture-and-exit.sh
##
## Run a Flameshot interactive capture and ensure no Flameshot daemon remains after capture.
## Use this if you prefer Flameshot to exit automatically when the capture completes.
##
## Usage:
##   ./flameshot-capture-and-exit.sh [flameshot-args]
## Examples:
##   ./flameshot-capture-and-exit.sh            # runs `flameshot gui`
##   ./flameshot-capture-and-exit.sh -p /tmp/shot.png
##
set -euo pipefail

# Collect args and decide whether to call `flameshot gui` explicitly when no args given.
if [ "$#" -eq 0 ]; then
  ARGS=(gui)
else
  ARGS=("$@")
fi

# Helper to kill any running flameshot processes (ignore errors)
_kill_flameshot() {
  if command -v pkill >/dev/null 2>&1; then
    pkill -x flameshot || true
  else
    # fallback: try killall
    killall flameshot 2>/dev/null || true
  fi
}

# 1) Kill any existing daemon so the capture runs as a standalone process.
#    This prevents the tray/daemon from intercepting the activation and leaving a
#    persistent process behind.
_kill_flameshot

# 2) Run the requested flameshot command and wait for it to exit.
flameshot "${ARGS[@]}"

# 3) Ensure no leftover flameshot process remains.
_kill_flameshot

# Optional desktop notification
if command -v notify-send >/dev/null 2>&1; then
  notify-send "Flameshot" "Capture finished and Flameshot exited"
fi

exit 0
