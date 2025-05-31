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
  wire collision;
  
  chip8_display display(.clk(clk), .draw(draw), .x(x), .y(y), .row_index(row_index), .sprite_data(sprite_data), .display_in(display_in), .display_out(display_out), .collision(collision));
  
  initial
    begin
      $display("Starting CHIP-8 Display Test...");
      display_in = 2048'd0;
      
      x = 6'd4;
      y = 5'd0;
      row_index = 4'd0;
      sprite_data = 8'b11110000;
      draw = 1;
      
      #10 draw = 0;
      
      #10;
      $display("Display Row 0 after draw:");
      $write("  ");
      for(int i = 0; i < 64; i = i + 1)
        $write("%s", display_out[2047 - i] ? "#" : ".");
      $display("");
      
      display_in = display_out;
      draw = 1;
      #10 draw = 0;
      
      #10;
      
      $display("Collision on second draw: %b (expecting 1)", collision);
      
      $finish;
    end
endmodule