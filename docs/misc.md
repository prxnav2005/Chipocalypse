# Miscellaneous Notes – Chipocalypse

This document contains definitions and explanations of common CHIP-8 terms and internal concepts used during emulator development.

---

## What is a Flag?

A **flag** is a special-purpose value (usually a single bit or register) that indicates the result or condition of an operation.

In CHIP-8:

- The **VF register** (V[15]) is used as a **flag register**.
- It is **not** used for general-purpose storage.
- It gets updated automatically during certain instructions like arithmetic or drawing.

### Examples of VF usage:
- **Carry Flag**: Set to 1 if a value overflows 8 bits (e.g., `8XY4`).
- **Borrow Flag**: Set to 0 or 1 based on underflow (e.g., `8XY5`, `8XY7`).
- **Collision Flag**: Set to 1 if a pixel is flipped from 1 to 0 when drawing (`DXYN`).

Programs typically read VF after these instructions to decide what to do next.

---

## Common CHIP-8 Terms

### Sprite

- A **sprite** is a small graphical image or pattern.
- In CHIP-8, sprites are up to 15 bytes (8 pixels wide × N pixels tall).
- Each byte represents a row of 8 pixels.
- Sprites are drawn using the `DXYN` instruction.

> Example: The hexadecimal digit `F` is drawn from the fontset using a 5-byte sprite.

### Draw

- The `DXYN` instruction draws a sprite at `(Vx, Vy)` onto the display.
- Drawing uses **XOR logic** — pixels are flipped.
- If any pixels are erased (1 → 0), VF is set to 1 (collision).
- Sprites wrap around screen edges if needed.

### Fontset

- A predefined set of sprites for hex digits 0–F.
- Each digit takes 5 bytes, stored in memory starting at 0x050.
- Used by `FX29` to point I to the sprite for digit Vx.

### Opcode

- A 16-bit instruction that tells the CPU what to do.
- Stored as two consecutive bytes in memory.
- Fetched and decoded every cycle.

Example:

```
6A 0F → 6A0F: Set VA = 0x0F
D0 15 → D015: Draw 5-byte sprite at (V0, V1)
```


### Index Register (I)

- A special 12-bit register used to store memory addresses.
- Used for sprite locations, memory operations (`FX55`, `FX65`), and drawing.

### Stack and SP

- CHIP-8 has a simple **stack** to support subroutine calls.
- The **stack pointer (SP)** tracks the current depth.
- Instructions `2NNN` (CALL) and `00EE` (RET) use the stack.

---

## Additional notes

- Always preserve VF behavior exactly as CHIP-8 expects — many games rely on it.
- Avoid treating VF as a general-purpose register.
- Sprite drawing should wrap around the screen, not clip.
