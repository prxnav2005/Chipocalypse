module chip8_mem(input wire clk, input wire [11:0] addr, output reg [7:0] data_out);
  
  reg [7:0] mem [0:4095];
  
  initial
    begin
      $readmemh("chip8_font.hex",mem);
      
      $readmemh("rom.hex", mem, 12'h200);
    end
  
  always @(posedge clk)
    begin
      data_out <= mem[addr];
    end
endmodule