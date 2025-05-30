// Code your design here

// The lines in grey are debug statements that I added for my own clarity.

module chip8_mem(input wire clk, input wire [11:0] addr, output reg [7:0] data_out);
  
  reg [7:0] mem [0:4095];
  
  initial
    begin
      $display("Loading memory...");
      $readmemh("chip8_program.mem", mem, 12'h200, 12'h209);
      // $display("Memory at 0x200 = %h", mem[12'h200]);
      // $display("Memory at 0x201 = %h", mem[12'h201]); 
    end
  
  always @(*)
    begin
      data_out = mem[addr];
    end
endmodule

  