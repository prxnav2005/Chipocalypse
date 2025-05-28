// Code your design here
module chip8_cpu(input wire clk, reset, input wire [7:0] mem_data_in, output reg [11:0] mem_addr_out, output reg mem_read, input wire [15:0] keys, output reg [63:0] display [31:0]);
  
  reg [11:0] pc;
  reg [15:0] opcode;
  reg [2:0] state;
  
  // FSM States
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
        end
      else
        begin
          case(state)
            FETCH1: begin
              mem_addr_out <= pc;
              mem_read <= 1;
              state <= FETCH2;
            end
            
            FETCH2: begin
              opcode_hi <= mem_data_in;
              mem_addr_out <= pc + 1;
              mem_read <= 1;
              state <= DECODE;
            end
            
            DECODE: begin
              opcode <= {opcode_hi, mem_data_in};
              mem_read <= 0;
              state <= EXECUTE;
            end
            
            EXECUTE: begin
              // --- PLACEHOLDER ---
              // We will be decoding opcode[15:12], opcode[11:8], etc.
              // Let's just try incrementing PC rn xd
              pc <= pc + 2;
              state <= FETCH1;
            end
          endcase
        end
    end
endmodule
