// Code your design here
module chip8_display(input wire clk, reset, input wire [5:0] x, input wire [4:0] y, input wire [3:0] row_index, input wire [7:0] sprite_data, input wire [2047:0] display_in, output reg [2047:0] display_out, output reg collision);
  
  integer i;
  reg [63:0] current_row, sprite_row, updated_row;
  reg [2047:0] next_display;
  reg collision_next;
  wire [10:0] row_start;
  
  assign row_start = ((y + row_index) % 32) * 64;
  
  always @(*)
    begin
      for(i = 0; i < 8; i = i + 1)
        sprite_row[63 - ((x + i) % 64)] = sprite_data[7 - i]; 
      
      updated_row = current_row ^ sprite_row;
      collision_next = |(current_row & sprite_row);
      
      next_display = display_in;
      for(i = 0; i < 64; i = i + 1)
        next_display[2047 - (row_start + i)] = updated_row[63 - i];
    end
  
  always @(posedge clk)
    begin
      if(draw)
        begin
          display_out <= next_display;
          collision <= collision_next;
        end
      else
        begin
          display_out <= display_in;
          collision <= 0;
        end
    end
endmodule