// Code your design here

module chip8_keypad(input wire clk, reset, input wire [15:0] keys_raw, output reg key_pressed, output reg [3:0] key_index, output reg [15:0] key_state);
  
  integer i;
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        begin
          keys_state <= 16'd0;
          keys_pressed <= 0;
          key_index <= 4'd0;
        end
      else
        begin
          keys_state <= keys_raw;
          key_pressed <= (keys_raw != 16'd0);
          
          key_index <= 4'd0;
          for(i = 0; i < 16; i = i + 1)
            begin
              if(keys_raw[i])
                begin
                  key_index <= i[3:0];
                end
            end
        end
    end
endmodule