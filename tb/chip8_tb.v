module chip8_tb;
  
  reg clk = 0;
  reg reset = 1;
  reg [15:0] keys = 0;
  wire [63:0] display_row [31:0];
  
  always
    #5 clk = ~clk;
  end
  
  chip8_top DUT(.clk(clk), .reset(reset), .keys(keys), .display_row(display_row));
  
  initial
    begin
      $display("Starting simulation..");
      #20 reset = 0;
      
      #10000;
      $finish;
    end
endmodule