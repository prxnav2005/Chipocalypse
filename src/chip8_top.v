// Code your design here
module chip8_top(input wire clk, reset, input wire [15:0] keys, output wire [63:0] display_row [31:0]);
  
  wire [11:0] pc, mem_addr;
  wire [15:0] opcode;
  wire [7:0] memory_out;
  wire mem_read;
  
  chip8_mem mem(.clk(clk), .addr(mem_addr), .data_out(memory_out));
  
  chip8_cpu cpu (.clk(clk), .reset(reset), .mem_data_in(memory_out), .mem_addr_out(mem_addr), .mem_read(mem_read), .keys(keys), .display(display_row)); 
  
endmodule

