#!/usr/bin/env bash
# keepawake — block systemd sleep/suspend + X screen blanking (DPMS) for this
# session. Runs until you Ctrl-C it (or close the terminal), then restores the
# normal X screensaver/DPMS settings.
set -euo pipefail

# Disable X screensaver + DPMS, restore on exit.
xset s off -dpms
trap 'xset s on +dpms' EXIT

echo "keepawake: sleep + screen-blanking inhibited. Press Ctrl-C to stop."

# Block systemd idle/sleep/lid handling until this process is killed.
exec systemd-inhibit \
  --what=idle:sleep:handle-lid-switch \
  --who="keepawake" \
  --why="manual keep-awake" \
  --mode=block \
  sleep infinity
