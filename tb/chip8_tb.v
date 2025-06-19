module chip8_tb;
  
  reg clk = 0;
  always #5 clk = ~clk;
  
  reg reset = 1;
  reg [15:0] keys_raw = 16'b0;
  wire [2047:0] display;
  
  chip8_top DUT(.clk(clk), .reset(reset), .keys_raw(keys_raw), .display(display));
  
  integer frame = 0;
  integer f, x, y, pixel_index;
  
  initial
    begin
      $dumpfile("chip8_tb.vcd");
      $dumpvars(0, chip8_tb);
      
      f = $fopen("display_dump.txt", "w");
      
      $fwrite(f, "Frame %0d (Time: %0t)\n", frame, $time);
      for (y = 0; y < 32; y = y + 1)
        begin
          for (x = 0; x < 64; x = x + 1)
            begin
              pixel_index = y * 64 + x;
              $fwrite(f, "%0d", display[2047 - pixel_index]);
            end
          $fwrite(f, "\n");
        end
      $fwrite(f, "\n");
      $fflush(f);
      frame = frame + 1;
      
      #20 reset = 0;
      
      #100 keys_raw = 16'b0000_0000_0000_0010; // fake keypresses 
      #100 keys_raw = 16'b0;
      
      repeat (50000)
        begin
          #10;
          $fwrite(f, "Frame %0d (Time: %0t)\n", frame, $time);
          $fwrite(f, "PC: %0h\n", DUT.cpu.pc);
          
          $display("[FRAME %0d] display first row = %b", frame, display[63:0]);
          
          $display("[DEBUG] First 8 pixels: %b", display[7:0]);
          
          for(y = 0; y < 32; y = y + 1)
            begin
              for (x = 0; x < 64; x = x + 1)
                begin
                  pixel_index = y * 64 + x;
                  $fwrite(f, "%0d", display[2047 - pixel_index]);
                end
              $fwrite(f, "\n");
            end
          $fwrite(f, "\n");
          $fflush(f);
          frame = frame + 1;
        end
      
      $fclose(f);
      $finish;
    end
  
  always @(posedge DUT.draw)
    begin
      $display("[DRAW_ACTIVE] Time=%0t, x=%0d, y=%0d, row_index=%0d, sprite=%02h", $time, DUT.draw_x, DUT.draw_y, DUT.draw_row_index, DUT.sprite_data);
    end
  
  reg [2047:0] last_display = 0;
  always @(posedge clk)
    begin
      if (display !== last_display)
        begin
          $display("[DISPLAY_CHANGED] Time=%0t", $time);
          last_display = display;
        end
    end
endmodule