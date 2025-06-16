#!/bin/bash

ROM_NAME="$1"

if [ -z "$ROM_NAME" ]; then
  echo "Usage: ./scripts/play.sh <ROM_NAME>"
  exit 1
fi

# Force lowercase to match ROM filenames
ROM_NAME_LOWER=$(echo "$ROM_NAME" | tr '[:upper:]' '[:lower:]')

# Resolve paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
ROM_PATH="$ROOT_DIR/roms/${ROM_NAME_LOWER}.mem"

if [ ! -f "$ROM_PATH" ]; then
  echo "[ERROR] ROM not found: $ROM_PATH"
  exit 1
fi

echo "[INFO] Launching simulation with ROM: $ROM_PATH"
vivado -mode batch -source "$SCRIPT_DIR/sim.tcl" -tclargs "$ROM_PATH"
if [ $? -ne 0 ]; then
  echo "[ERROR] Vivado simulation failed."
  exit 1
fi
echo "[INFO] Vivado simulation completed successfully."