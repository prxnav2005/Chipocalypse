// Code your design here

module chip8_display(input wire clk, draw, input wire [5:0] x, input wire [4:0] y, input wire [3:0] row_index, input wire [7:0] sprite_data, input wire [2047:0] display_in, output reg [2047:0] display_out, output reg collision);
  
  integer i;
  reg [63:0] row, updated_row, sprite_shifted;
  reg [2047:0] temp_display;
  wire [10:0] row_start_bit;
  
  assign row_start_bit = ((y + row_index) % 32) * 64;
  
  always @(*)
    begin
      sprite_shifted = 64'd0;
      for(i = 0; i < 8; i = i + 1)
        begin
          sprite_shifted[(x + i) % 64] = sprite_data[7 - i];
        end
    end
  
  always @(posedge clk)
    begin
      if(draw)
        begin
          row <= display_in[row_start_bit +: 64];
          updated_row <= row ^ sprite_shifted;
          collision <= |(row & sprite_shifted);
          
          temp_display = display_in;
          temp_display[row_start_bit +: 64] = updated_row;
          display_out <= temp_display;
        end
      else
        begin
          collision <= 0;
          display_out <= display_in;
        end
    end
endmodule
