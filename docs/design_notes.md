# Design Notes – Chipocalypse

This file records key design decisions, implementation constraints, and important insights from the development of the Chipocalypse emulator.

## Goals

- Fully functional CHIP-8 emulator written in Verilog
- Designed to run entirely in simulation (no FPGA/hardware required)
- Clean, modular architecture — each subsystem in its own file

## Key Decisions

- Used a **clock divider** to simulate CHIP-8's 60Hz timers
- **Timer logic** is now integrated inside `chip8_cpu.v` (no separate `chip8_timer.v` module)
- **Display output** is handled via a 2048-bit internal framebuffer (64 × 32)
- **ROMs** are preloaded into memory at address 0x200 using `$readmemh`
- **Sprite drawing** uses XOR and sets VF on pixel collision
- **Opcode decoding** is handled by a FSM-based CPU in `chip8_cpu.v`

## Future Considerations

- Add **VGA output** support for real hardware display
- Integrate a **keyboard input interface** (USB/PS2 or GPIO-based)
- Optionally support **super CHIP-8** extended instructions and resolutions
