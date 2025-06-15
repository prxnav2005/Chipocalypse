rom_path = "/home/prawns/Desktop/Pong.ch8"
mem_path = "/home/prawns/Desktop/pong.mem"

with open(rom_path, "rb") as f_in, open(mem_path, "w") as f_out:
    byte = f_in.read(1)
    while byte:
        f_out.write(f"{int.from_bytes(byte, 'big'):02x}\n")
        byte = f_in.read(1)

print(f"ROM converted to memory format and saved to {mem_path}")