#!/bin/bash

ROM_NAME="$1"

if [ -z "$ROM_NAME" ]; then
  echo "Usage: ./scripts/play <ROM_NAME>"
  exit 1
fi

ROM_PATH="./roms/${ROM_NAME}.mem"
DEST_PATH="./roms/pong.mem"

if [ ! -f "$ROM_PATH" ]; then
  echo "ROM not found: $ROM_PATH"
  exit 1
fi

cp "$ROM_PATH" "$DEST_PATH"
echo "[INFO] Loaded $ROM_NAME → pong.mem"

vivado -mode batch -source ./scripts/sim.tcl
