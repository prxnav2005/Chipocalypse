#!/bin/bash
case "$(basename "$0")" in
  play)   set -- /play ;;
  exit)   set -- /exit ;;
  uptime) set -- /uptime ;;
  music)  set -- /music "$2" ;;
esac

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
UPTIME_FILE="/tmp/chip8_uptime"
MUSIC_ENABLED_FILE="/tmp/chip8_music_enabled"
MUSIC_PID_FILE="/tmp/chip8_music_pid"

# ASCII Art Banner
show_banner() {
  echo " ██████╗██╗  ██╗██╗██████╗  █████╗  ██████╗ █████╗ ██╗   ██╗██████╗ ███████╗███████╗"
  echo "██╔════╝██║  ██║██║██╔══██╗██╔══██╗██╔════╝██╔══██╗██║   ██║██╔══██╗██╔════╝██╔════╝"
  echo "██║     ███████║██║██████╔╝██║  ██║██║     ███████║██║   ██║██████╔╝███████╗█████╗  "
  echo "██║     ██╔══██║██║██╔═══╝ ██║  ██║██║     ██╔══██║╚██╗ ██╔╝██╔═══╝ ╚════██║██╔══╝  "
  echo "╚██████╗██║  ██║██║██║     ╚█████╔╝╚██████╗██║  ██║ ╚████╔╝ ██║     ███████║███████╗"
  echo " ╚═════╝╚═╝  ╚═╝╚═╝╚═╝      ╚════╝  ╚═════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝     ╚══════╝╚══════╝"
  echo "                           The Classic 8-bit Emulator                                "
  echo "--------------------------------------------------------------------------------"
}

# Function to show help message
show_help() {
  show_banner
  echo "CHIP-8 Emulator Commands:"
  echo "  ./play           - Launch game selector GUI"
  echo "  ./exit           - Close the emulator and any running processes"
  echo "  ./uptime         - Show how long the emulator has been running"
  echo "  ./music [on|off] - Enable/disable background music"
  echo "  ./help           - Show this help message"
}

# Music in bg 
handle_music() {
  if [ "$1" = "on" ]; then
    echo "Enabling background music..."
    echo "1" > "$MUSIC_ENABLED_FILE"
    
    # Kill any existing music process
    if [ -f "$MUSIC_PID_FILE" ]; then
      kill $(cat "$MUSIC_PID_FILE") 2>/dev/null
    fi
    
    if command -v mpg123 >/dev/null; then # make sure mpg123 is installed
      mpg123 -q --loop -1 "$SCRIPT_DIR/assets/background.mp3" &
      echo $! > "$MUSIC_PID_FILE"
    else
      echo "Warning: mpg123 not found. Cannot play music."
    fi
    
  elif [ "$1" = "off" ]; then
    echo "Disabling background music..."
    echo "0" > "$MUSIC_ENABLED_FILE"
    
    if [ -f "$MUSIC_PID_FILE" ]; then
      kill $(cat "$MUSIC_PID_FILE") 2>/dev/null
      rm "$MUSIC_PID_FILE"
    fi
    
  else
    if [ -f "$MUSIC_ENABLED_FILE" ] && [ "$(cat "$MUSIC_ENABLED_FILE")" = "1" ]; then
      echo "Music is currently enabled"
    else
      echo "Music is currently disabled"
    fi
    echo "Use './music on' or './music off' to change"
  fi
}

# Main shit
case "$1" in
  /play)
    show_banner
    if [ ! -f "$UPTIME_FILE" ]; then
      date +%s > "$UPTIME_FILE"
    fi
    
    if [ -f "$MUSIC_ENABLED_FILE" ] && [ "$(cat "$MUSIC_ENABLED_FILE")" = "1" ] && [ ! -f "$MUSIC_PID_FILE" ]; then
      handle_music "on"
    fi
    
    python3 "$SCRIPT_DIR/../gui/main.py" # gui 
    ;;
    
  /exit)
    echo "Closing CHIP-8 emulator..."
    
    if [ -f "$MUSIC_PID_FILE" ]; then
      kill $(cat "$MUSIC_PID_FILE") 2>/dev/null
      rm "$MUSIC_PID_FILE"
    fi
    
    rm -f "$UPTIME_FILE" "$MUSIC_ENABLED_FILE"
    
    pkill -f "python3.*main.py" 2>/dev/null
    
    echo "Emulator closed successfully"
    ;;
    
  /uptime)
    if [ -f "$UPTIME_FILE" ]; then
      start_time=$(cat "$UPTIME_FILE")
      current_time=$(date +%s)
      uptime_seconds=$((current_time - start_time))
      
      hours=$((uptime_seconds / 3600))
      minutes=$(( (uptime_seconds % 3600) / 60 ))
      seconds=$((uptime_seconds % 60))
      
      echo "CHIP-8 emulator has been running for: ${hours}h ${minutes}m ${seconds}s"
    else
      echo "CHIP-8 emulator is not currently running"
    fi
    ;;
    
  /music)
    handle_music "$2"
    ;;
    
  /help|*)
    show_help
    ;;
esac