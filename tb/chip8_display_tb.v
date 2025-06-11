// Code your testbench here
// or browse Examples
module chip8_display_tb;
  
  reg clk = 0;
  always
    #5 clk = ~clk;
  
  reg draw;
  reg [5:0] x;
  reg [4:0] y; 
  reg [3:0] row_index;
  reg [7:0] sprite_data;
  reg [2047:0] display_in;
  wire [2047:0] display_out;
  wire collison;
  
  
  chip8_display DUT(.clk(clk), .draw(draw), .x(x), .y(y), .row_index(row_index), .sprite_data(sprite_data), .display_in(display_in), .display_out(display_out), .collision(collision));
  
  task print_row;
    input [2047:0] disp;
    input integer row;
    integer i;
    begin
      $write("Row %0d: ", row);
      for(i = 0; i < 64; i = i + 1)
        $write("%s", disp[2047 - (row * 64) - i] ? "#" : ".");
      $display("");
    end
  endtask
  
  initial
    begin
      $display("Starting CHIP-8 Display Test...");
      clk = 0;
      draw = 0;
      display_in = 2048'd0;
      
      // First Draw
      
      x = 6'd4;
      y = 5'd0;
      row_index = 4'd0;
      sprite_data = 8'b11110000;
      
      @(posedge clk);
      draw = 1;
      @(posedge clk);
      draw = 0;
      $display("Display after first draw:");
      print_row(display_out, 0);
      $display("Collision signal: %b (Expected: 0)", collision);
      
      // Second Draw
      
      display_in = display_out; 
      x = 6'd4;
      sprite_data = 8'b11110000;
      
      @(posedge clk);
      draw = 1;
      @(posedge clk);
      draw = 0;
      $display("Display after second draw (should clear same 4 pixels):");
      print_row(display_out, 0);
      $display("Collision signal: %b (Expected: 1)", collision);
      
      $finish;
    end
endmodule