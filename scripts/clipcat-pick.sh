#!/usr/bin/env bash
#
# Clipboard history picker for clipcat.
#
# Works around a clipcat 0.25 regression: `clipcat-menu` moves the selected
# clip to the top of the history but no longer asserts the X clipboard
# selection, so pasting (Ctrl+V) still returns the previous contents. Driving
# the finder ourselves and using `clipcatctl promote` reliably replaces the
# clipboard, so a subsequent paste yields the chosen clip.

set -uo pipefail

# clipcatctl list prints "<id>: <preview>" per clip (ids are colon-free hex).
sel=$(clipcatctl list | dmenu -i -l 30 -p Clipcat ${DMENU_OPTIONS:-}) || exit 0

id=${sel%%:*}
[ -n "$id" ] && exec clipcatctl promote "$id"
