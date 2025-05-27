# CHIP-8 Instruction Set - Chipocalypse

This file documents all standard CHIP-8 instructions, grouped by category and tracking implementation status.

## Legend

- [ ] Not implemented
- [x] Implemented
- [~] Partially implemented

---

### 0x0NNN - System Instructions

| Opcode     | Mnemonic      | Description                     | Status |
|------------|---------------|---------------------------------|--------|
| 00E0       | CLS           | Clear display                   | [ ]    |
| 00EE       | RET           | Return from subroutine          | [ ]    |
| 0NNN       | SYS addr      | Call RCA 1802 program at NNN    | [ ]    |

### 0x1NNN - Control Flow

| Opcode     | Mnemonic      | Description                     | Status |
|------------|---------------|---------------------------------|--------|
| 1NNN       | JP addr       | Jump to address NNN             | [ ]    |
| 2NNN       | CALL addr     | Call subroutine at NNN          | [ ]    |
| 3XNN       | SE Vx, NN     | Skip if Vx == NN                | [ ]    |
| 4XNN       | SNE Vx, NN    | Skip if Vx != NN                | [ ]    |

### 0x5–0x9 - Conditional / Arithmetic

| Opcode     | Mnemonic       | Description                   | Status |
|------------|----------------|-------------------------------|--------|
| 5XY0       | SE Vx, Vy      | Skip if Vx == Vy              | [ ]    |
| 6XNN       | LD Vx, NN      | Set Vx = NN                   | [ ]    |
| 7XNN       | ADD Vx, NN     | Vx += NN                      | [ ]    |
| 8XY0–8XYE  | Various logic  | AND, OR, XOR, shifts, etc.    | [ ]    |
| 9XY0       | SNE Vx, Vy     | Skip if Vx != Vy              | [ ]    |

### 0xANNN–0xBNNN - Addressing

| Opcode     | Mnemonic       | Description                   | Status |
|------------|----------------|-------------------------------|--------|
| ANNN       | LD I, NNN      | Set I = NNN                   | [ ]    |
| BNNN       | JP V0 + NNN    | Jump to NNN + V0              | [ ]    |

### 0xCXNN–0xDXYN - Random / Display

| Opcode     | Mnemonic       | Description                   | Status |
|------------|----------------|-------------------------------|--------|
| CXNN       | RND Vx, NN     | Vx = rand() & NN              | [ ]    |
| DXYN       | DRW Vx, Vy, N  | Draw N-byte sprite            | [ ]    |

### 0xEX9E / 0xEXA1 - Keypad

| Opcode     | Mnemonic       | Description                   | Status |
|------------|----------------|-------------------------------|--------|
| EX9E       | SKP Vx         | Skip if key Vx is pressed     | [ ]    |
| EXA1       | SKNP Vx        | Skip if key Vx not pressed    | [ ]    |

### 0xFX** - Timer / Memory / Input

| Opcode     | Mnemonic       | Description                   | Status |
|------------|----------------|-------------------------------|--------|
| FX07       | LD Vx, DT      | Vx = delay timer              | [ ]    |
| FX0A       | LD Vx, K       | Wait for key press            | [ ]    |
| FX15       | LD DT, Vx      | Set delay timer = Vx          | [ ]    |
| FX18       | LD ST, Vx      | Set sound timer = Vx          | [ ]    |
| FX1E       | ADD I, Vx      | I += Vx                       | [ ]    |
| FX29       | LD F, Vx       | Set I to sprite addr for Vx   | [ ]    |
| FX33       | LD B, Vx       | Store BCD of Vx at I          | [ ]    |
| FX55       | LD [I], Vx     | Store V0 to Vx in memory      | [ ]    |
| FX65       | LD Vx, [I]     | Load V0 to Vx from memory     | [ ]    |

---

> This list will be updated as instructions are implemented and tested.

