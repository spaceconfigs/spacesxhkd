#!/bin/bash

get_window_ids() {
    bspc query --nodes --node .window
}

get_window_name() {
    local id=$1
    xprop -id "$id" | awk -F '"' '/_NET_WM_NAME/ {print $2}'
}

window_ids=$(get_window_ids)
windows=()

if [ -z "$window_ids" ]; then
    echo "No other windows found"
    exit 1
fi

for id in $window_ids; do
    name=$(get_window_name "$id")
    windows+=("$id | $name")
done

windows_string=$(printf "%s\n" "${windows[@]}")
chosen=$(echo "$windows_string" | cut --delimiter='|' --fields=2- | rofi -dmenu -i --prompt="Select window")
if [ -z "$chosen" ]; then
    exit 1
fi


window_id=$(echo "$windows_string" | grep --fixed-strings "|$chosen" | awk '{print $1}')
bspc node "$window_id" --flag hidden=off
bspc node --focus "$window_id"
