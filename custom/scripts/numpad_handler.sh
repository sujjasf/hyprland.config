#!/usr/bin/env bash
# Handle keypad keys according to current numlock mode (1..3)
# Usage: numpad_handler.sh KP_1

MODE_FILE="$HOME/.config/hypr/numlock_mode"
if [ ! -f "$MODE_FILE" ]; then
  echo 1 > "$MODE_FILE"
fi
mode=$(cat "$MODE_FILE")
key="$1"

# Movement step (adjust to taste)
STEP=20

# helper: emit a numeric key via ydotool
emit_number() {
  # arg is digit (0-9)
  digit="$1"
  if command -v ydotool >/dev/null 2>&1; then
    # ydotool key can accept simple digits; if this fails on your system, change to KEY_1 etc.
    ydotool key "$digit"
  fi
}

do_navigation() {
  case "$key" in
    KP_8) ydotool key Up ;;        # up
    KP_2) ydotool key Down ;;      # down
    KP_4) ydotool key Left ;;      # left
    KP_6) ydotool key Right ;;     # right
    KP_7) ydotool key Home ;;
    KP_9) ydotool key Page_Up ;;
    KP_1) ydotool key End ;;
    KP_3) ydotool key Page_Down ;;
    KP_5) ydotool key Space ;;     # center - map to space as example
    KP_0) ydotool key 0 ;;
    KP_Decimal) ydotool key Delete ;;
    KP_Enter) ydotool key Return ;;
  esac
}

do_mouse() {
  case "$key" in
    KP_8) ydotool mousemove_relative -- 0 -${STEP} ;;   # up
    KP_2) ydotool mousemove_relative -- 0 ${STEP} ;;    # down
    KP_4) ydotool mousemove_relative -- -${STEP} 0 ;;   # left
    KP_6) ydotool mousemove_relative -- ${STEP} 0 ;;    # right
    KP_7) ydotool mousemove_relative -- -${STEP} -${STEP} ;; # up-left
    KP_9) ydotool mousemove_relative -- ${STEP} -${STEP} ;;  # up-right
    KP_1) ydotool mousemove_relative -- -${STEP} ${STEP} ;;  # down-left
    KP_3) ydotool mousemove_relative -- ${STEP} ${STEP} ;;   # down-right
    KP_5) ydotool click 1 ;;    # left click
    KP_Enter) ydotool click 3 ;; # right click
    KP_0) ydotool mousemove_relative -- 0 ${STEP} ;; # treat 0 as small down
    KP_Decimal) ydotool key Delete ;;
  esac
}

case "$mode" in
  1)
    # numbers: emit the numeric digit corresponding to keypad key
    case "$key" in
      KP_1) emit_number 1 ;; KP_2) emit_number 2 ;; KP_3) emit_number 3 ;;
      KP_4) emit_number 4 ;; KP_5) emit_number 5 ;; KP_6) emit_number 6 ;;
      KP_7) emit_number 7 ;; KP_8) emit_number 8 ;; KP_9) emit_number 9 ;;
      KP_0) emit_number 0 ;; KP_Decimal) emit_number . ;; KP_Enter) emit_number Enter ;;
    esac
    ;;
  2)
    # navigation
    do_navigation
    ;;
  3)
    # mouse movement
    do_mouse
    ;;
  *)
    # default to numbers
    emit_number 0
    ;;
esac
