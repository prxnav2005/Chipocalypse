module chip8_mem(input wire clk, input wire [11:0] addr, output reg [7:0] data_out);
  
  reg [7:0] mem [0:4095];
  reg [7:0] fontset [0:79];
  integer i;
  
  initial
    begin
      fontset[0] = 8'hF0; fontset[1] = 8'h90; fontset[2] = 8'h90; fontset[3] = 8'h90; fontset[4] = 8'hF0; // 0
      fontset[5] = 8'h20; fontset[6] = 8'h60; fontset[7] = 8'h20; fontset[8] = 8'h20; fontset[9] = 8'h70; // 1
      fontset[10] = 8'hF0; fontset[11] = 8'h10; fontset[12] = 8'hF0; fontset[13] = 8'h80; fontset[14] = 8'hF0; // 2
      fontset[15] = 8'hF0; fontset[16] = 8'h10; fontset[17] = 8'hF0; fontset[18] = 8'h10; fontset[19] = 8'hF0; // 3
      fontset[20] = 8'h90; fontset[21] = 8'h90; fontset[22] = 8'hF0; fontset[23] = 8'h10; fontset[24] = 8'h10; // 4
      fontset[25] = 8'hF0; fontset[26] = 8'h80; fontset[27] = 8'hF0; fontset[28] = 8'h10; fontset[29] = 8'hF0; // 5
      fontset[30] = 8'hF0; fontset[31] = 8'h80; fontset[32] = 8'hF0; fontset[33] = 8'h90; fontset[34] = 8'hF0; // 6
      fontset[35] = 8'hF0; fontset[36] = 8'h10; fontset[37] = 8'h20; fontset[38] = 8'h40; fontset[39] = 8'h40; // 7
      fontset[40] = 8'hF0; fontset[41] = 8'h90; fontset[42] = 8'hF0; fontset[43] = 8'h90; fontset[44] = 8'hF0; // 8
      fontset[45] = 8'hF0; fontset[46] = 8'h90; fontset[47] = 8'hF0; fontset[48] = 8'h10; fontset[49] = 8'hF0; // 9
      fontset[50] = 8'hF0; fontset[51] = 8'h90; fontset[52] = 8'hF0; fontset[53] = 8'h90; fontset[54] = 8'h90; // A
      fontset[55] = 8'hE0; fontset[56] = 8'h90; fontset[57] = 8'hE0; fontset[58] = 8'h90; fontset[59] = 8'hE0; // B
      fontset[60] = 8'hF0; fontset[61] = 8'h80; fontset[62] = 8'h80; fontset[63] = 8'h80; fontset[64] = 8'hF0; // C
      fontset[65] = 8'hE0; fontset[66] = 8'h90; fontset[67] = 8'h90; fontset[68] = 8'h90; fontset[69] = 8'hE0; // D
      fontset[70] = 8'hF0; fontset[71] = 8'h80; fontset[72] = 8'hF0; fontset[73] = 8'h80; fontset[74] = 8'hF0; // E
      fontset[75] = 8'hF0; fontset[76] = 8'h80; fontset[77] = 8'hF0; fontset[78] = 8'h80; fontset[79] = 8'h80; // F
      
      for(i = 0; i < 80; i = i + 1)
        mem[i] = fontset[i];
      
      $display("[INFO] Loading ROM from: rom.mem");
      $readmemh("rom.mem", mem, 12'h200);  // Load at 0x200
    end
  
  always @(posedge clk)
    data_out <= mem[addr];
endmodule