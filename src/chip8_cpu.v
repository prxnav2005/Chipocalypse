// Code your design here

// The lines in grey are debug statements that I added for my own clarity.


module chip8_cpu(input wire clk, reset, input wire [7:0] mem_data_in, input wire [15:0] keys, output reg mem_read, output reg [11:0] mem_addr_out, output reg [2047:0] display);
  
  reg [11:0] pc, I;
  reg [15:0] opcode;
  reg [2:0] state;
  reg [7:0] V [0:15];
  integer i;
  
  localparam FETCH1 = 0;
  localparam FETCH2 = 1;
  localparam DECODE = 2;
  localparam EXECUTE = 3;
  
  reg [7:0] opcode_hi;
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        begin
          pc <= 12'h200;
          state <= FETCH1;
          mem_read <= 1;
          I <= 12'd0;
          opcode <= 16'd0;
          for(i = 0; i < 16; i = i+1)
            V[i] <= 8'd0;
          display <= 2048'd0;
        end
      else
        begin
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
              mem_read <= 0;
              state <= EXECUTE;
            end
            
            EXECUTE: begin
              case(opcode[15:12])
                4'h0: begin
                  if(opcode == 16'h00E0)
                    begin
                      display <= 2048'd0; // Clear display all at once
                    end
                  pc <= pc + 2;
                end
                
                4'h1: begin
                  pc <= opcode[11:0]; // Jump to address NNN
                end
                
                4'h6: begin
                  V[opcode[11:8]] <= opcode[7:0]; // LD Vx, NN
                  pc <= pc + 2;
                end
                
                4'h7: begin
                  V[opcode[11:8]] <= V[opcode[11:8]] + opcode[7:0];
                  pc <= pc + 2;
                end
                
                4'hD: begin
                  display[0] <= ~display[0];
                  pc <= pc + 2;
                end
                
                default: begin
                  pc <= pc + 2;
                end
              endcase
              state <= FETCH1; 
            end
          endcase
        end
    end
endmodule

  