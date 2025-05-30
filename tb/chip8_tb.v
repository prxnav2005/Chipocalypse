module chip8_tb;
  
  reg clk = 0;
  reg reset = 1;
  reg [15:0] keys = 0;
  wire [2047:0] display_row;
  
  always
    #5 clk = ~clk;
  
  chip8_top DUT(.clk(clk), .reset(reset), .keys(keys), .display(display));
  
  initial
    begin
      $display("Starting simulation..");
      #20 reset = 0;
      
      #10000;
      $finish;
    end
endmodule