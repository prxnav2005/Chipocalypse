// Code your design here
// Code your design here

// The lines in grey are debug statements that I added for my own clarity.

module chip8_cpu(input wire clk, reset, input wire [7:0] mem_data_in, input wire [15:0] keys, output reg mem_read, output reg [11:0] mem_addr_out, output reg [2047:0] display, output reg [7:0] mem_data_out, output reg mem_write);
  
  reg [11:0] pc, I, pixel_index;
  reg [15:0] opcode;
  reg [2:0] state;
  reg [7:0] V [0:15];
  reg [7:0] rand_val, delay_timer, sprite_byte;
  reg [11:0] stack [0:15];
  reg [3:0] sp;
  reg [20:0] clk_divider;
  reg [3:0] draw_row;
  reg [2047:0] new_display;
  reg [5:0] x,y,bit_pos;
  reg collision_flag;
  wire clock_tick;
  integer i;
  
  localparam FETCH1 = 0;
  localparam FETCH2 = 1;
  localparam DECODE = 2;
  localparam EXECUTE = 3;
  localparam STORE_BCD_1 = 4;
  localparam STORE_BCD_2 = 5;
  localparam STORE_BCD_3 = 6;
  localparam DRAW_SPITE = 7;
  localparam FETCH_SPRITE_BYTE = 8;
  
  reg [7:0] opcode_hi, bcd_value;
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        begin
          pc <= 12'h200;
          state <= FETCH1;
          mem_read <= 1;
          I <= 12'd0;
          opcode <= 16'd0;
          mem_write <= 0;
          sp <= 0;
          collision_flag <= 0;
          new_display <= 2048'd0;
          for(i = 0; i < 16; i = i+1)
            V[i] <= 8'd0;
          display <= 2048'd0;
        end
      else
        begin
          mem_read <= 0;
          mem_write <= 0;
          rand_val <= rand_val + 1;
          
          case(state)
            FETCH1: begin
              mem_addr_out <= pc;
              mem_read <= 1;
              // $display("FETCH1: pc = %h", pc);
              state <= FETCH2;
            end
            
            FETCH2: begin
              opcode_hi <= mem_data_in;
              // $display("FETCH2: opcode_hi = %h", mem_data_in);
              mem_addr_out <= pc + 1;
              mem_read <= 1;
              state <= DECODE;
            end
            
            DECODE: begin
              opcode <= {opcode_hi, mem_data_in};
              // $display("DECODE: opcode = %h", {opcode_hi, mem_data_in});
              state <= EXECUTE;
            end
            
            EXECUTE: begin
              case(opcode[15:12])
                4'h0: begin
                  if(opcode == 16'h00E0)
                    begin
                      display <= 2048'd0;
                      pc <= pc + 2;
                    end
                  else if(opcode == 16'h00EE)
                    begin
                      sp <= sp - 1;
                      pc <= stack[sp];
                    end
                  else
                    begin
                      pc <= pc + 2;
                    end
                  state <= FETCH1;
                end
                
                4'h1: begin
                  pc <= opcode[11:0];
                  state <= FETCH1;
                end
                
                4'h6: begin
                  V[opcode[11:8]] <= opcode[7:0];
                  pc <= pc + 2;
                  state <= FETCH1;
                end
                
                4'h7: begin
                  V[opcode[11:8]] <= V[opcode[11:8]] + opcode[7:0];
                  pc <= pc + 2;
                  state <= FETCH1;
                end
                
                4'hD: begin
                  draw_row <= 0;
                  collision_flag <= 0;
                  new_display <= display;
                  state <= DRAW_SPRITE;
                end

                4'hA: begin
                  I <= opcode[11:0];
                  pc <= pc + 2;
                  state <= FETCH1;
                end
                
                4'hF: begin
                  case(opcode[7:0])
                    8'h33: begin
                      bcd_value = V[opcode[11:8]];
                      mem_addr_out <= I;
                      mem_data_out <= V[opcode[11:8]] / 100;
                      mem_write <= 1;
                      state <= STORE_BCD_1;
                    end
                    
                    8'h1E: begin
                      I <= I + V[opcode[11:8]];
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    8'h29: begin
                      I <= V[opcode[11:8]] * 5;
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    8'h07: begin
                      V[opcode[11:8]] <= delay_timer;
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    default: begin
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                  endcase
                end
                
                4'h3: begin
                  if (V[opcode[11:8]] == opcode[7:0])
                    pc <= pc + 4;
                  else
                    pc <= pc + 2;
                  state <= FETCH1;
                end
                
                4'h4: begin
                  if (V[opcode[11:8]] != opcode[7:0])
                    pc <= pc + 4;
                  else
                    pc <= pc + 2;
                  state <= FETCH1;
                end
                
                4'h5: begin
                  if (opcode[3:0] == 4'h0)
                    begin
                      if (V[opcode[11:8]] != V[opcode[7:4]])
                        pc <= pc + 4;
                      else
                        pc <= pc + 2;
                    end
                  else 
                    begin
                      pc <= pc + 2;
                    end
                  state <= FETCH1;
                end
                
                4'h8: begin
                  case(opcode[3:0])
                    4'h0: begin
                      V[opcode[11:8]] <= V[opcode[7:4]];
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    4'h1: begin
                      V[opcode[11:8]] <= V[opcode[11:8]] | V[opcode[7:4]];
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    4'h2: begin
                      V[opcode[11:8]] <= V[opcode[11:8]] & V[opcode[7:4]];
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    4'h3: begin
                      V[opcode[11:8]] <= V[opcode[11:8]] ^ V[opcode[7:4]];
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    4'h4: begin
                      {V[15], V[opcode[11:8]]} = V[opcode[11:8]] + V[opcode[7:4]];
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    4'h5: begin
                      if (V[opcode[11:8]] >= V[opcode[7:4]])
                        begin
                          V[15] = 1;
                          V[opcode[11:8]] = V[opcode[11:8]] - V[opcode[7:4]];
                        end
                      else
                        begin
                          V[15] = 0;
                          V[opcode[11:8]] = V[opcode[11:8]] - V[opcode[7:4]];
                        end
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    4'h6: begin
                      V[15] = V[opcode[11:8]][0];
                      V[opcode[11:8]] = V[opcode[11:8]] >> 1;
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    4'h7: begin
                      if(V[opcode[7:4]] > V[opcode[11:8]])
                        begin
                          V[15] = 1;
                        end
                      else
                        begin
                          V[15] = 0;
                        end
                      V[opcode[11:8]] = V[opcode[7:4]] - V[opcode[11:8]];
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    4'hE: begin
                      V[15] = (V[opcode[11:8]] & 8'h80) >> 7;
                      V[opcode[11:8]] = V[opcode[11:8]] << 1;
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    default: begin
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                  endcase
                end
                
                4'h2: begin
                  stack[sp] <= pc + 2;
                  sp <= sp + 1;
                  pc <= opcode[11:0];
                  state <= FETCH1;
                end
                
                4'hC: begin
                  V[opcode[11:8]] <= rand_val & opcode[7:0];
                  pc <= pc + 2;
                  state <= FETCH1;
                end
                
                4'hE: begin
                  case(opcode[7:0])
                    8'h9E: begin
                      if(keys[V[opcode[11:8]]])
                        pc <= pc + 4;
                      else
                        pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    8'hA1: begin
                      if(~keys[V[opcode[11:8]]])
                        pc <= pc + 4;
                      else
                        pc <= pc + 2;
                      state <= FETCH1;
                    end
                    
                    default: begin
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                  endcase
                end
                
                4'h9: begin
                  if(opcode[3:0] == 4'h0)
                    begin
                      if(V[opcode[11:8]] != V[opcode[7:4]])
                        pc <= pc + 4;
                      else
                        pc <= pc + 2;
                    end
                  else
                    begin
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                
                  4'hB: begin
                    pc <= opcode[11:0] + V[0];
                    state <= FETCH1;
                  end
                
                STORE_BCD_1: begin
                  mem_addr_out <= I + 1;
                  mem_data_out <= (V[opcode[11:8]] % 100) / 10;
                  mem_write <= 1;
                  state <= STORE_BCD_2;
                end
                
                STORE_BCD_2: begin
                  mem_addr_out <= I + 2;
                  mem_data_out <= V[opcode[11:8]] % 10;
                  mem_write <= 1;
                  state <= STORE_BCD_3;
                end
                
                STORE_BCD_3: begin
                  pc <= pc + 2;
                  state <= FETCH1;
                end
                  
                DRAW_SPRITE: begin
                  mem_addr_out <= I + draw_row;
                  mem_read <= 1;
                  mem_write <= 0;
                  state <= FETCH_SPRITE_BYTE;
                end
                  
                FETCH_SPRITE_BYTE: begin
                  mem_read <= 0;
                  sprite_byte <= mem_data_in;
                  for(bit_pos = 0; bit_pos < 8; bit_pos = bit_pos + 1)
                    begin
                      if(sprite_byte[7 - bit_pos])
                        begin
                          x = (V[opcode[11:8]] + bit_pos) % 64;
                          y = (V[opcode[7:4]] + draw_row) % 32;
                          pixel_index = y * 64 + x;
                          
                          if(new_display[pixel_index]) 
                            collision_flag <= 1;
                          
                          new_display[pixel_index] <= new_display[pixel_index] ^ 1;
                        end
                    end
                  
                  if(draw_row == opcode[3:0] - 1)
                    begin
                      display <= new_display;
                      V[15] <= collision_flag ? 1 : 0;
                      pc <= pc + 2;
                      state <= FETCH1;
                    end
                  else
                    begin
                      draw_row <= draw_row + 1;
                      state <= DRAW_SPRITE;
                    end
                end
                
                default: begin
                  pc <= pc + 2;
                  state <= FETCH1;
                end
              endcase
            end
            
            default: begin
              state <= FETCH1;
            end
          endcase
        end
    end
endmodule