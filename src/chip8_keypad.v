// Code your design here
module chip8_keypad(input wire clk, reset, input wire [15:0] keys_raw, output reg key_pressed, output reg [3:0] key_index, output reg [15:0] key_state);
  
  reg [15:0] prev_key_state;
  integer i;
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        begin
          key_state <= 16'd0;
          key_pressed <= 0;
          key_index <= 4'd0;
          prev_key_state <= 16'd0;
        end
      else
        begin
          key_state <= keys_raw;
          key_pressed <= 0;
          key_index <= 4'd0;
          
          for(i = 0; i < 16; i = i + 1)
            begin
              if(keys_raw[i] && !prev_key_state[i] && !key_pressed)
                begin
                  key_index <= i;
                  key_pressed <= 1;
                end
            end
          
          prev_key_state <= keys_raw;
        end
    end
endmodule