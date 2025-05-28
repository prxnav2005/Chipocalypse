# Miscellaneous notes

### What is a flag?

A flag is a special-purpose value (often stored in a register or bit) that indicates the outcome or condition resulting from the execution of an instruction (or) A flag shows the result or condition (like carry, borrow, zero, collision, etc.) caused by executing an instruction.

In the case of CHIP-8 and many other architectures:

- Flags do not hold data for computation or logic.

- They are automatically set by the CPU/emulator as a side effect of certain instructions.

- Programs can read flags to make decisions, but usually shouldn't write to them directly.

