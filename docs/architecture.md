# Chipocalypse Architecture

This document outlines the overall system design of the CHIP-8 emulator implemented in Verilog.

## Overview

CHIP-8 is a simple, bytecode-based virtual machine originally designed for 1970s microcomputers. This project replicates the entire CHIP-8 system in Verilog, including memory, instruction decoding, control flow, timers, and display — all for simulation.

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
- Initial font data (0x050 to 0x09F)
- ROMs are loaded starting at 0x200

### `chip8_cpu.v`
- Controls the fetch-decode-execute cycle
- Handles all CHIP-8 instructions
- Interfaces with memory, timers, and display

### `chip8_display.v`
- 64×32 monochrome frame buffer
- Draws sprites using XOR
- Collision detection sets VF register

### `chip8_timer.v`
- Delay and sound timers (8-bit, decrement at 60Hz)
- Countdown tick triggered by simulation clock divider

### `chip8_keypad.v`
- Simulated 16-key hex keypad
- Input can be triggered through simulation testbench

## Execution Flow

1. ROM is loaded into memory at 0x200
2. CPU starts at PC = 0x200
3. On each clock tick:
   - Fetch 2-byte opcode from memory
   - Decode opcode type
   - Execute instruction (may access memory, display, or timers)

