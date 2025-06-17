// Code your design here
module chip8_top(input wire clk, reset, input wire [15:0] keys_raw, output wire [2047:0] display);
  
  wire [11:0] mem_addr;
  wire [7:0] mem_data_in, mem_data_out, sprite_data, delay_in, sound_in, delay_out, sound_out;
  wire [3:0] key_index, draw_row_index;
  wire [15:0] key_state;
  wire [5:0] draw_x;
  wire [4:0] draw_y;
  wire [2047:0] display_next;
  reg [2047:0] display_current;
  wire mem_read, key_pressed, draw, collision, load_delay, load_sound, mem_write;
  
  chip8_mem mem(.clk(clk), .addr(mem_addr), .data_out(mem_data_out));
  
  chip8_keypad keypad(.clk(clk), .reset(reset), .keys_raw(keys_raw), .key_pressed(key_pressed), .key_index(key_index), .key_state(key_state));
  
  chip8_display display_unit(.clk(clk), .reset(reset), .draw(draw), .x(draw_x), .y(draw_y), .row_index(draw_row_index), .sprite_data(sprite_data), .display_in(display_current), .display_out(display_next), .collision(collision));
  
  chip8_timer timer(.clk(clk), .reset(reset), .load_delay(load_delay), .load_sound(load_sound), .delay_in(delay_in), .sound_in(sound_in), .delay_out(delay_out), .sound_out(sound_out));
  
  chip8_cpu cpu(.clk(clk), .reset(reset), .mem_data_in(mem_data_out), .keys(key_state), .mem_read(mem_read), .mem_addr_out(mem_addr), .mem_data_out(mem_data_in), .mem_write(mem_write), .draw(draw), .draw_x(draw_x), .draw_y(draw_y), .draw_row_index(draw_row_index), .sprite_data(sprite_data), .collision(collision), .display_current(display_current));
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        display_current <= 2048'd0;
      else if(draw)
        display_current <= display_next;
    end
	
  assign mem_data_in = mem_data_out;
  assign display = display_current;

endmodule