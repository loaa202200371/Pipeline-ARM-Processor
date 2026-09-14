module alu(input  logic [31:0] a, b,
           input  logic [2:0]  ALUControl,
           output logic [31:0] Result,
           output logic [3:0]  Flags);

 logic N, Z, C, V;
 logic [31:0] condinvb;
 logic [32:0] sum;
 assign condinvb = ALUControl[0] ? ~b : b;
 assign sum = a + condinvb + ALUControl[0];

 always_comb
 casex (ALUControl[2:0])
 3'b00?: Result = sum;
 3'b010: Result = a & b;
 3'b011: Result = a | b;
 3'b100: Result = a ^ b;
 3'b110: Result = a & ~b;
 endcase

 assign N = Result[31];
 assign Z = (Result == 32'b0);
 assign C = (ALUControl[2:1] == 2'b00) & sum[32];
 assign V = (ALUControl[2:1] == 2'b00) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
 assign Flags = {N, Z, C, V};
  
endmodule