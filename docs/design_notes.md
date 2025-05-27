# Design Notes - Chipocalypse

This file records key design decisions, constraints, and implementation insights.

## Goals
- Fully functional CHIP-8 emulator in Verilog
- Simulatable entirely without hardware
- Clean modular design (each subsystem in its own file)

## Key Decisions
- Clock divider used to simulate 60Hz timers
- Display output done via internal framebuffer
- ROM is preloaded into memory using `$readmemh`

## Future Considerations
- VGA output (for real hardware version)
- Real keyboard input interface
