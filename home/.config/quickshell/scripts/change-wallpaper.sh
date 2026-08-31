#!/bin/sh
set -eu

CACHE_FOLDER="$HOME/.config/anarchy/cache"
LOG_FILE="$CACHE_FOLDER/change-wallpaper.log"

mkdir -p "$CACHE_FOLDER"
exec >"$LOG_FILE" 2>&1

HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"
case "$1" in
"$HOME"/*) WALL_DISPLAY="\$HOME${1#"$HOME"}" ;;
*) WALL_DISPLAY="$1" ;;
esac
{
  printf '%s\n' "\$wall = $WALL_DISPLAY"
  tail -n +2 "$HYPRLOCK_CONF"
} >"$HYPRLOCK_CONF.tmp"
mv "$HYPRLOCK_CONF.tmp" "$HYPRLOCK_CONF"

qs ipc call wallpaper toggle
awww img "$1"
matugen image "$1" --source-color-index 0 -m "dark"
