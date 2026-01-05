#!/usr/bin/env bash

# Auto-detect and configure monitors
# - Largest resolution = primary (center)
# - 2560x1080 monitors = rotated right (vertical)
# - Others = normal orientation, placed to the right

set -euo pipefail

get_connected_monitors() {
    xrandr --query | grep " connected" | awk '{print $1}'
}

get_resolution() {
    local monitor=$1
    xrandr --query | grep -A1 "^${monitor} connected" | tail -1 | awk '{print $1}'
}

get_resolution_width() {
    local res=$1
    echo "$res" | cut -d'x' -f1
}

get_resolution_height() {
    local res=$1
    echo "$res" | cut -d'x' -f2
}

main() {
    local monitors=($(get_connected_monitors))
    
    if [[ ${#monitors[@]} -eq 0 ]]; then
        echo "No monitors detected"
        exit 1
    fi

    local primary=""
    local primary_width=0
    local primary_res=""
    
    declare -A resolutions
    
    for mon in "${monitors[@]}"; do
        res=$(get_resolution "$mon")
        resolutions[$mon]=$res
        width=$(get_resolution_width "$res")
        
        if [[ $width -gt $primary_width ]]; then
            primary_width=$width
            primary=$mon
            primary_res=$res
        fi
    done

    local xrandr_cmd="xrandr"
    local x_offset=0

    xrandr_cmd+=" --output $primary --primary --mode $primary_res --rate 60 --pos 0x0 --rotate normal"
    x_offset=$(get_resolution_width "$primary_res")

    for mon in "${monitors[@]}"; do
        if [[ "$mon" == "$primary" ]]; then
            continue
        fi
        
        local res=${resolutions[$mon]}
        local width=$(get_resolution_width "$res")
        local height=$(get_resolution_height "$res")
        local rotate="normal"
        
        # 2560x1080 ultrawide as vertical monitor
        if [[ "$res" == "2560x1080" ]]; then
            rotate="right"
        fi
        
        xrandr_cmd+=" --output $mon --mode $res --rate 60 --pos ${x_offset}x0 --rotate $rotate"
        
        if [[ "$rotate" == "right" || "$rotate" == "left" ]]; then
            x_offset=$((x_offset + height))
        else
            x_offset=$((x_offset + width))
        fi
    done

    # Turn off disconnected outputs
    local all_outputs=$(xrandr --query | grep -E "connected|disconnected" | awk '{print $1}')
    for output in $all_outputs; do
        if [[ ! " ${monitors[*]} " =~ " ${output} " ]]; then
            xrandr_cmd+=" --output $output --off"
        fi
    done

    echo "Applying: $xrandr_cmd"
    eval "$xrandr_cmd"
}

main "$@"
