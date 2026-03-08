#!/usr/bin/env bash
# Adjust brightness on all monitors via DDC/CI
# Usage: ddcutil-brightness.sh + (increase) or ddcutil-brightness.sh - (decrease)
step=10
for bus in 11 12; do
  ddcutil setvcp 10 "$1" "$step" --bus "$bus" --noverify
done
