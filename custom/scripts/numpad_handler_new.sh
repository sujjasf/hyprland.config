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
    KP_8) ydotool key up ;;        # up
    KP_2) ydotool key down ;;      # down
    KP_4) ydotool key left ;;      # left
    KP_6) ydotool key right ;;     # right
    KP_7) ydotool key home ;;
    KP_9) ydotool key pageup ;;
    KP_1) ydotool key end ;;
    KP_3) ydotool key pagedown ;;
    KP_5) ydotool key space ;;     # center - map to space as example
    KP_0) ydotool key 0 ;;
    KP_Decimal) ydotool key delete ;;
    KP_Enter) ydotool key enter ;;
  esac
}

do_mouse() {
  case "$key" in
    KP_8) ydotool mousemove -x 0 -y -${STEP} ;;   # up
    KP_2) ydotool mousemove -x 0 -y ${STEP} ;;    # down
    KP_4) ydotool mousemove -x -${STEP} -y 0 ;;   # left
    KP_6) ydotool mousemove -x ${STEP} -y 0 ;;    # right
    KP_7) ydotool mousemove -x -${STEP} -y -${STEP} ;; # up-left
    KP_9) ydotool mousemove -x ${STEP} -y -${STEP} ;;  # up-right
    KP_1) ydotool mousemove -x -${STEP} -y ${STEP} ;;  # down-left
    KP_3) ydotool mousemove -x ${STEP} -y ${STEP} ;;   # down-right
    KP_5) ydotool click -b left ;;    # left click
    KP_Enter) ydotool click -b right ;; # right click
    KP_0) ydotool mousemove -x 0 -y ${STEP} ;; # treat 0 as small down
    KP_Decimal) ydotool click -b middle ;;  # middle click
  esac
}

case "$mode" in
  1)
    # numbers: emit the numeric digit corresponding to keypad key
    case "$key" in
      KP_1) emit_number 1 ;; KP_2) emit_number 2 ;; KP_3) emit_number 3 ;;
      KP_4) emit_number 4 ;; KP_5) emit_number 5 ;; KP_6) emit_number 6 ;;
      KP_7) emit_number 7 ;; KP_8) emit_number 8 ;; KP_9) emit_number 9 ;;
      KP_0) emit_number 0 ;; KP_Decimal) emit_number . ;; KP_Enter) ydotool key enter ;;
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