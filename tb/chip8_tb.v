// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module chip8_top_tb;

  // Clock and reset signals
  reg clk = 0;
  reg reset = 1;

  // Inputs
  reg [15:0] keys = 0;

  // Outputs
  wire [2047:0] display;

  // File and frame count
  integer frame_file;
  integer frame_count = 0;

  // Clock generation (100 MHz)
  always #5 clk = ~clk;

  // Instantiate DUT
  chip8_top DUT (
    .clk(clk),
    .reset(reset),
    .keys_raw(keys),
    .display(display)
  );

  // Optional: hook internal draw signal for debug
  always @(posedge clk) begin
    if (DUT.cpu.draw) begin
      $display("[DRAW] @ %0dns → x=%0d, y=%0d, sprite=%b",
        $time, DUT.cpu.draw_x, DUT.cpu.draw_y, DUT.cpu.sprite_data);
    end
  end

  initial begin
    $display("Starting simulation...");

    // Waveform dump
    $dumpfile("chip8.vcd");
    $dumpvars(0, chip8_top_tb);

    // Monitor key CPU state
    $monitor("T=%0dns | PC=%h | Opcode=%h | mem_data=%h | draw=%b | X=%d Y=%d | sprite=%h",
      $time, DUT.cpu.pc, DUT.cpu.opcode, DUT.mem_data_out,
      DUT.cpu.draw, DUT.cpu.draw_x, DUT.cpu.draw_y, DUT.cpu.sprite_data);
    
    always @(posedge clk)
      begin
        if(DUT.cpu.draw)
          $display("[DRAW] PC=%h | x=%d y=%d | sprite_data=%b", 
             DUT.cpu.pc, DUT.cpu.draw_x, DUT.cpu.draw_y, DUT.cpu.sprite_data);
      end

    // Check ROM contents (first few bytes)
    #1;
    $display("ROM Check:");
    $display("mem[200] = %h", DUT.mem.mem[12'h200]);
    $display("mem[201] = %h", DUT.mem.mem[12'h201]);
    $display("mem[202] = %h", DUT.mem.mem[12'h202]);

    // Reset logic
    #20 reset = 0;
    #500;  // Let CPU settle after reset

    // Open file to dump display frames
    frame_file = $fopen("display_dump.txt", "w");

    // Simulate 100 frames
    repeat (300) begin
      @(posedge clk);
      #1;

      // Log frame header
      $display("Dumping frame %0d...", frame_count);

      // Write display state to file
      $fwrite(frame_file, "%h\n", display);

      // Sanity check: display non-zero?
      if (display !== 0)
        $display("[INFO] Non-zero display found at frame %0d", frame_count);
      else
        $display("[WARN] Display still all zero at frame %0d", frame_count);

      // Wait ~1 frame (assuming 60Hz = ~16,666 clocks at 100 MHz)
      repeat (16666) @(posedge clk);
      frame_count = frame_count + 1;
    end

    // Wrap up
    $fclose(frame_file);
    $display("Dumped %0d frames to display_dump.txt", frame_count);
    $finish;
  end

endmodule