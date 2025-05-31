module chip8_display(input wire clk, draw, input wire [5:0] x, input wire [4:0] y, input wire [3:0] row_index, input wire [7:0] sprite_data, input wire [2047:0] display_in, output reg [2047:0] display_out, output reg collision);
  
  integer i;
  reg [63:0] row, updated_row, sprite_shifted;
  wire [10:0] row_start_bit;
  
  assign row_start_bit = (31 - ((y + row_index) % 32)) * 64;
  
  always @(*)
    begin
      collision = 0;
      display_out = display_in;
      
      if(draw)
        begin
          row = display_in[row_start_bit +: 64];
          
          sprite_shifted = 64'd0;
          for(i = 0; i < 8; i = i + 1)
            sprite_shifted[(x+i) % 64] = sprite_data[7-i];
          
          updated_row = row ^ sprite_shifted;
          
          collision = |(row & sprite_shifted);
          display_out[row_start_bit +: 64] = updated_row;
        end
    end
endmodule