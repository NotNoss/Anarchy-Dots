#!/bin/bash

WALLPAPER_LOG="$HOME/.config/anarchy/cache/change-wallpaper.log"
CACHE_DIR="$HOME/.config/anarchy/cache/"

if [ -f $WALLPAPER_LOG ]; then
  "$HOME/.config/quickshell/scripts/change-wallpaper.sh" "$HOME/.config/anarchy/Wallpapers/montagna.png"
fi

if [ -d $CACHE_DIR ]; then
  echo "cache exists"
else
  echo "cache does not exist"
fi
