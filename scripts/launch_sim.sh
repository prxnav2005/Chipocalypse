#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
ROM_FILE="$(realpath "$SCRIPT_DIR/../$1")"

if [ -z "$1" ]; then
  echo "[ERROR] No ROM file given!"
  echo "Usage: ./play.sh <relative_path_to_rom_inside_project>"
  exit 1
fi

if [ ! -f "$ROM_FILE" ]; then
  echo "[ERROR] ROM file '$ROM_FILE' does not exist!"
  exit 1
fi

TCL_SCRIPT="$SCRIPT_DIR/run_sim.tcl"

vivado -mode batch -source "$TCL_SCRIPT" -tclargs "$ROM_FILE"