// Code your design here

module chip8_display(input wire clk, reset, draw, input wire [5:0] x, input wire [4:0] y, input wire [3:0] row_index, input wire [7:0] sprite_data, input wire [2047:0] display_in, output reg [2047:0] display_out, output reg collision);
  
  integer i, pos_x, pos_y, pixel_index;
  reg [2047:0] next_display;
  reg collision_next;
  
  always @(*)
    begin
      next_display = display_out;
      collision_next = 0;
      
      for(i = 0; i < 8; i = i + 1)
        begin
          pos_x = (x + i) % 64;
          pos_y = (y + row_index) % 32;
          pixel_index = pos_y * 64 + pos_x;
          
          if(sprite_data[7 - i])
            begin
              if(display_out[pixel_index])
                collision_next = 1;
              
              next_display[pixel_index] = display_in[pixel_index] ^ 1'b1;
            end
        end
      
      $display("[DISPLAY] Updated at x=%0d, y=%0d, row=%0d, sprite=%h", x, y, row_index, sprite_data);
    end
  
  always @(posedge clk)
    begin
      if(reset)
        begin
          display_out <= 0;
          collision <= 0;
        end
      else if(draw)
        begin
          display_out <= next_display;
          collision <= collision_next;
        end
   end
endmodule