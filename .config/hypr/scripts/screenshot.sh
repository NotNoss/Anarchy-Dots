#!/bin/bash

image_format="jpeg"
name="screenshot_$(date +%d%m%Y_%H%M%S).jpg"
screenshot_folder="$HOME/Pictures"

send_notification() {
    notify-send -a "Screenshot" -i "$1" "Screenshot Saved" "$screenshot_folder/$name"
}

take_region() {
    local pid_picker region

    hyprpicker -r -z &
    pid_picker=$!
    trap 'kill "$pid_picker" 2>/dev/null' EXIT
    sleep 0.1

    region=$(slurp -b "#00000080" -c "#888888ff" -w 1) || exit 0
    [[ -z "$region" ]] && exit 0

    kill "$pid_picker" 2>/dev/null
    trap - EXIT

    mkdir -p "$screenshot_folder"
    grim -g "$region" -t "$image_format" "$screenshot_folder/$name"
    send_notification "$screenshot_folder/$name"
}

take_monitor() {
    monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
    mkdir -p "$screenshot_folder"
    grim -o "$monitor" -t "$image_format" "$screenshot_folder/$name"
    send_notification "$screenshot_folder/$name"
}

take_window() {
    geometry=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    [[ -z "$geometry" || "$geometry" == *null* ]] && exit 0
    mkdir -p "$screenshot_folder"
    grim -g "$geometry" -t "$image_format" "$screenshot_folder/$name"
    send_notification "$screenshot_folder/$name"
}

case "$1" in
    "region")
        take_region;;
    "monitor")
        take_monitor;;
    "window")
        take_window;;
    *)
        echo "Invalid argument";;
esac