#!/usr/bin/env bash
# Cycle NumLock modes: 1 = numbers, 2 = navigation, 3 = mouse keys
STATE_FILE="$HOME/.config/hypr/numlock_mode"
mkdir -p "$(dirname "$STATE_FILE")"
if [ ! -f "$STATE_FILE" ]; then
    echo "1" > "$STATE_FILE"
fi

cur=$(cat "$STATE_FILE")
next=$(( (cur % 3) + 1 ))
echo "$next" > "$STATE_FILE"

case "$next" in
  1)
    notify-send "NumLock" "Mode: 1 — Numpad (numbers)"
    ;;
  2)
    notify-send "NumLock" "Mode: 2 — Navigation (Home/PgUp/PgDn)"
    ;;
  3)
    notify-send "NumLock" "Mode: 3 — Mouse keys (numpad moves cursor)"
    ;;
esac

# If keyd is available, attempt to notify/reload it so it can switch maps (user must create keyd maps).
if command -v keyd >/dev/null 2>&1; then
  # Try to reload keyd (user should set up keyd maps named for the modes and a small controller to switch)
  systemctl --user try-restart keyd 2>/dev/null || true
fi

echo "$next"
