#!/usr/bin/env bash
# Handle keypad keys according to current numlock mode (1..3)
# Usage: numpad_handler.sh KP_1

MODE_FILE="$HOME/.config/hypr/numlock_mode"
if [ ! -f "$MODE_FILE" ]; then
  echo 1 > "$MODE_FILE"
fi
mode=$(cat "$MODE_FILE")
key="$1"

# Add debug logging
exec 1> >(tee -a "/tmp/numpad_handler.log")
exec 2>&1
echo "[$(date)] Called with key=$key mode=$mode"

# Movement step (adjust to taste)
STEP=20

# Make sure we're using the socket
export YDOTOOL_SOCKET=/tmp/.ydotool_socket

do_mouse() {
  echo "[$(date)] Executing mouse movement for $key"
  case "$key" in
    KP_8) 
      echo "Moving up"
      YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool mousemove -x 0 -y -${STEP}
      ;;
    KP_2) 
      echo "Moving down"
      YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool mousemove -x 0 -y ${STEP}
      ;;
    KP_4) 
      echo "Moving left"
      YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool mousemove -x -${STEP} -y 0
      ;;
    KP_6) 
      echo "Moving right"
      YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool mousemove -x ${STEP} -y 0
      ;;
    KP_7) 
      echo "Moving up-left"
      YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool mousemove -x -${STEP} -y -${STEP}
      ;;
    KP_9) 
      echo "Moving up-right"
      YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool mousemove -x ${STEP} -y -${STEP}
      ;;
    KP_1) 
      echo "Moving down-left"
      YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool mousemove -x -${STEP} -y ${STEP}
      ;;
    KP_3) 
      echo "Moving down-right"
      YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool mousemove -x ${STEP} -y ${STEP}
      ;;
    KP_5) 
      echo "Left click"
      YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool click -b left
      ;;
    KP_Enter) 
      echo "Right click"
      YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool click -b right
      ;;
    KP_0) 
      echo "Small down"
      YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool mousemove -x 0 -y ${STEP}
      ;;
    KP_Decimal) 
      echo "Middle click"
      YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool click -b middle
      ;;
  esac
}

case "$mode" in
  1)
    echo "[$(date)] Mode 1: Numbers"
    # numbers mode
    ;;
  2)
    echo "[$(date)] Mode 2: Navigation"
    # navigation mode
    ;;
  3)
    echo "[$(date)] Mode 3: Mouse movement"
    do_mouse
    ;;
  *)
    echo "[$(date)] Unknown mode: $mode"
    ;;
esac