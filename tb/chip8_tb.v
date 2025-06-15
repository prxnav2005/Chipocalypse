// Code your testbench here
// or browse Examples
module chip8_tb;
  
  reg clk = 0;
  reg reset = 1;
  reg [15:0] keys = 0;
  wire [2047:0] display;
  integer frame_file;
  integer frame_count = 0;

  always
    #5 clk = ~clk;
  
  chip8_top DUT(.clk(clk), .reset(reset), .keys_raw(keys), .display(display));
  
  initial
    begin
      $display("Starting simulation..");
      $dumpfile("chip8.vcd");
      $dumpvars(0, chip8_tb);
      $monitor("T=%0dns | PC=%h | Opcode=%h | mem_data=%h | draw=%b | X=%d Y=%d | sprite=%h",
         $time, DUT.cpu.pc, DUT.cpu.opcode, DUT.mem_data_out, DUT.cpu.draw,
         DUT.cpu.draw_x, DUT.cpu.draw_y, DUT.cpu.sprite_data);

      $display("mem[12'h200] = %h", DUT.mem.mem[12'h200]);
      $display("mem[12'h201] = %h", DUT.mem.mem[12'h201]);
      $display("mem[12'h202] = %h", DUT.mem.mem[12'h202]);


      #20 reset = 0;
      #500;
      
      frame_file = $fopen("display_dump.txt", "w");
      
      repeat(100)
        begin
          @(posedge clk);
          #1;
          $display("Dumping frame %0d", frame_count); 
          $fwrite(frame_file, "%h\n", display);
          
          repeat (16666)
            @(posedge clk);
          frame_count = frame_count + 1;
        end
      
      $fclose(frame_file);
      $display("Dumped %0d frames to display_dump.txt", frame_count);
      $finish;
    end
endmodule