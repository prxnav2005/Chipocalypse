# Chipocalypse

**Chipocalypse** is a CHIP-8 emulator implemented entirely in Verilog. It is designed to run purely in simulation, with no physical hardware required. The goal of this project is to build a working CHIP-8 system from scratch using digital design principles.

## About CHIP-8

CHIP-8 is a simple interpreted programming language developed in the 1970s, commonly used to teach emulation and low-level system design. It features:

- 4KB memory space
- 16 8-bit general purpose registers (V0–VF)
- A 16-bit index register (I)
- A program counter (PC) starting at 0x200
- Stack and stack pointer
- 64x32 monochrome display
- 16-key hexadecimal keypad
- Delay and sound timers (tick at 60Hz)

## Project Goals

- Implement a complete CHIP-8 emulator in Verilog
- Simulate the display, memory, registers, stack, and timers
- Load and run real CHIP-8 programs (ROMs) in simulation
- Create simple testbenches for each module

## Repository Structure

```
/Chipocalypse
├── src/
├── tb/
├── roms/ 
├── docs/
├── README.md 
```


## Tools Required

- Vivado, ModelSim, or any Verilog simulation tool
- A text editor or IDE for Verilog (e.g., VSCode + Verilog HDL plugin)
- GTKWave (optional) for waveform viewing

## Getting Started

1. Clone this repository.
2. Open your simulator of choice.
3. Compile the modules and testbenches under `/src` and `/tb`.
4. Run simulation with a sample ROM loaded into memory.
5. Observe register values, memory state, and framebuffer activity.

## Status

| Component       | Status       |
|----------------|--------------|
| Memory module  | Phase 1 complete |
| CPU            | Phase 1 complete |
| Display module | Not started  |
| Input handler  | Not started  |
| Timer module   | Not started  |
| Top-level module  | Phase 1 complete |
| Testbenches    | Phase 1 complete  |

> Work is ongoing. This repository will be updated regularly as modules are developed. “Phase 1 complete” indicates implementation of first 4 basic opcodes and basic functionality has been verified in simulation (e.g., CPU fetching, memory interface, minimal display toggle, etc.).

## Reference

- [Cowgod's CHIP-8 Technical Reference](https://devernay.free.fr/hacks/chip8/C8TECH10.HTM)
- [CHIP-8 Instruction Set Reference PDF](https://johnearnest.github.io/Octo/docs/chip8ref.pdf)

## License

This project is open source under the GPL License.

