// Code your testbench here
// or browse Examples
module chip8_tb;
  
  reg clk = 0;
  reg reset = 1;
  reg [15:0] keys = 0;
  wire [2047:0] display;
  
  chip8_top DUT(.clk(clk), .reset(reset), .keys_raw(keys), .display(display));
  
  integer frame_file;
  integer frame_count = 0;
  reg [2047:0] last_display = 0;
  
  always 
    #5 clk = ~clk;
  
  always @(posedge clk)
    begin
      if (DUT.cpu.draw)
        begin
          $display("[DRAW] @ %0dns → x=%0d, y=%0d, sprite=%b",$time, DUT.cpu.draw_x, DUT.cpu.draw_y, DUT.cpu.sprite_data);
        end
    end
  
  initial
    begin
      $display("Starting simulation...");
      
      $dumpfile("chip8.vcd");
      $dumpvars(0, chip8_top_tb);
      
      $monitor("T=%0dns | PC=%h | Opcode=%h | mem_data=%h | draw=%b | X=%d Y=%d | sprite=%h",$time, DUT.cpu.pc, DUT.cpu.opcode, DUT.mem_data_out, DUT.cpu.draw, DUT.cpu.draw_x, DUT.cpu.draw_y, DUT.cpu.sprite_data);
      
      #1;
      $display("ROM Check:");
      for (int i = 0; i < 10; i = i + 1)
        $display("mem[%03x] = %02h", 12'h200 + i, DUT.mem.mem[12'h200 + i]);
      
      #20
      reset = 0;
      #500;
      
      frame_file = $fopen("display_dump.txt", "w");
      
      repeat(300)
        begin
          @(posedge clk);
          #1;
          
          $display("Dumping frame %0d...", frame_count);
          
          if(display !== last_display)
            begin
              $fwrite(frame_file, "%h\n", display);
              $display("[INFO] Display updated at frame %0d", frame_count);
            end
          else
            begin
              $display("[WARN] Display unchanged at frame %0d", frame_count);
            end
          
          last_display = display;
          frame_count = frame_count + 1;
          
          repeat (16666)
            @(posedge clk);
        end
      
      $fclose(frame_file);
      $display("Simulation complete. %0d frames dumped.", frame_count);
      $finish;
    end
  
endmodule