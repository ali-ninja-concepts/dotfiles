#!/bin/bash
# Get the current display configuration
current_config=$(xrandr --query | grep " connected")
# Check if HDMI-0 is connected
if echo "$current_config" | grep -q "HDMI-0 connected"; then
    # HDMI-0 is connected
    if echo "$current_config" | grep -q "HDMI-0 connected primary"; then
        # HDMI-0 is already primary, switch to eDP-1-0
        xrandr --output eDP-1-0 --auto --primary --output HDMI-0 --off
        echo "Switched to eDP-1-0"
    elif echo "$current_config" | grep -q "eDP-1-0 connected primary"; then
        # eDP-1-0 is primary, switch to HDMI-0
        xrandr --output HDMI-0 --auto --primary --output eDP-1-0 --off
        echo "Switched to HDMI-0"
    else
        # Both are active (mirroring), switch to HDMI-0 only
        xrandr --output HDMI-0 --auto --primary --output eDP-1-0 --off
        echo "Switched to HDMI-0 only"
    fi
else
    # HDMI-0 is not connected, ensure eDP-1-0 is active
    xrandr --output eDP-1-0 --auto --primary --output HDMI-0 --off
    echo "HDMI-0 not connected. Using eDP-1-0"
fi
