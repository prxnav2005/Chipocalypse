// Code your design here
module chip8_timer(input wire clk, reset, load_delay, load_sound, input wire [7:0] delay_in, sound_in, output reg [7:0] delay_out, sound_out);
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        begin
          delay_out <= 8'd0;
          sound_out <= 8'd0;
        end
      else
        begin
          if(load_delay)
            delay_out <= delay_in;
          else if(delay_out > 0)
            delay_out <= delay_out - 1;
          
          if(load_sound)
            sound_out <= sound_in;
          else if(sound_out > 0)
            sound_out <= sound_out - 1;
        end
    end
endmodule