# Chipocalypse Architecture

This document outlines the overall system design of the CHIP-8 emulator implemented in Verilog.

## Overview

CHIP-8 is a simple, bytecode-based virtual machine originally designed for 1970s microcomputers. This project replicates the entire CHIP-8 system in Verilog — including memory, instruction decoding, control flow, timers, and display — all for simulation.

## Block Diagram

    +-----------------+
    |   ROM Loader    |  <-- Loads .hex files to memory
    +-----------------+
            |
    +-----------------+
    |     Memory      |  <-- 4KB (0x000 to 0xFFF)
    +-----------------+
            |
    +-----------------+
    |      CPU        |  <-- Fetch-Decode-Execute loop
    |                 |
    | - Registers V0–VF
    | - Index Reg (I)
    | - Program Counter (PC)
    | - Stack + SP
    +-----------------+
      |    |     |    |
      v    v     v    v
    Timers ALU  Display  Keypad

## Module Descriptions

### `chip8_memory.v`
- 4KB memory (`reg [7:0] mem [0:4095]`)
- Fontset stored at 0x050–0x09F
- ROMs are loaded starting at address 0x200

### `chip8_cpu.v`
- Controls the fetch-decode-execute cycle
- Handles all CHIP-8 opcodes
- Interfaces with memory, timers, display, and keypad

### `chip8_display.v`
- 64×32 monochrome frame buffer
- Draws sprites using XOR logic
- Collision detection sets the VF register

### `chip8_keypad.v`
- 16-key hex keypad (0–F)
- Inputs triggered through simulation or GUI

## Execution Flow

1. ROM is loaded into memory at address 0x200
2. CPU begins execution from PC = 0x200
3. On each clock tick:
   - Fetch a 2-byte opcode from memory
   - Decode the opcode
   - Execute the instruction (may affect memory, timers, display, or input)
