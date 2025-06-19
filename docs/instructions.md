# CHIP-8 Instructions Implemented – Chipocalypse

This document lists only the opcodes implemented in the Chipocalypse emulator.

## Core Execution

- `00E0` – Clear screen (CLS)
- `00EE` – Return from subroutine (RET)
- `1NNN` – Jump to address NNN
- `2NNN` – Call subroutine at NNN
- `3XNN` – Skip next if Vx == NN
- `4XNN` – Skip next if Vx != NN
- `5XY0` – Skip next if Vx == Vy
- `6XNN` – Set Vx = NN
- `7XNN` – Add NN to Vx
- `8XY0` – Set Vx = Vy
- `8XY1` – Set Vx = Vx OR Vy
- `8XY2` – Set Vx = Vx AND Vy
- `8XY3` – Set Vx = Vx XOR Vy
- `8XY4` – Vx += Vy, set VF on carry
- `8XY5` – Vx -= Vy, set VF on borrow
- `8XY6` – Vx >>= 1, VF = LSB before shift
- `8XY7` – Vx = Vy - Vx, set VF on borrow
- `8XYE` – Vx <<= 1, VF = MSB before shift
- `9XY0` – Skip next if Vx != Vy
- `ANNN` – Set I = NNN
- `BNNN` – Jump to NNN + V0

## Graphics

- `DXYN` – Draw N-byte sprite at (Vx, Vy), set VF on collision

## Input

- `EX9E` – Skip if key in Vx is pressed
- `EXA1` – Skip if key in Vx is not pressed
- `FX0A` – Wait for key press, store in Vx

## Timers

- `FX07` – Set Vx = delay timer
- `FX15` – Set delay timer = Vx
- `FX18` – Set sound timer = Vx

## Memory

- `FX1E` – Add Vx to I
- `FX29` – Set I = sprite location for hex digit Vx
- `FX33` – Store BCD of Vx at I, I+1, I+2
- `FX55` – Store V0 to Vx in memory at I
- `FX65` – Load V0 to Vx from memory at I


