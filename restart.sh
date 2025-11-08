#!/bin/bash
# Kill existing processes
killall ags agsv1 gjs ydotool qs quickshell

# Export necessary environment variables
export qsConfig=ii
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland

# Start QuickShell
qs -c $qsConfig &

# Reload Hyprland config
hyprctl reload