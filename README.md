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
├── docs/
├── gui/
├── misc/
├── roms/
├── src/ 
├── tb/
├── README.md 
```


## Tools Required

- Vivado, ModelSim, or any Verilog simulation tool
- A text editor or IDE for Verilog (e.g., VSCode + Verilog HDL plugin)
- GTKWave (optional) for waveform viewing


## Status

| Component       | Status        |
|----------------|---------------|
| Memory module  | Complete      |
| CPU            | Complete      |
| Display module | Complete      |
| Input handler  | Complete  |
| Timer module   | Complete      |
| Top-level module  | Complete   |
| Testbenches    | Complete      |

## Reference

- [Cowgod's CHIP-8 Technical Reference](https://devernay.free.fr/hacks/chip8/C8TECH10.HTM)
- [CHIP-8 Instruction Set Reference PDF](https://johnearnest.github.io/Octo/docs/chip8ref.pdf)
- [CHIP-8 Wikipedia](https://en.wikipedia.org/wiki/CHIP-8)

## License

This project is open source under the GPL License.

