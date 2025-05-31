// Code your testbench here
// or browse Examples
module chip8_mem_tb;
  
  reg [11:0] addr;
  wire [7:0] data_out;
  
  chip8_mem mem(.addr(addr), .data_out(data_out));
  
  initial
    begin
      $display("Testing memory..");
      addr = 12'h200;
      #10;
      
      $display("Address 0x200 = %h", data_out);
      addr = 12'h201;
      #10;
      
      $display("Address 0x201 = %h", data_out);
      $finish;
    end
endmodule
