#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
ROM_FILE="$1"                         # accept absolute OR relative path

if [ -z "$ROM_FILE" ]; then
  echo "[ERROR] No ROM file given!"
  echo "Usage: launch_sim.sh <path_to_rom.mem>"
  exit 1
fi

if [ ! -f "$ROM_FILE" ]; then
  echo "[ERROR] ROM file '$ROM_FILE' does not exist!"
  exit 1
fi

TCL_SCRIPT="$SCRIPT_DIR/run_sim.tcl"

vivado -mode batch -source "$TCL_SCRIPT" -tclargs "$ROM_FILE"