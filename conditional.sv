module conditional(input  logic [3:0] Cond,
                   input  logic [3:0] Flags,
                   input  logic [3:0] ALUFlags,
                   input  logic [1:0] FlagsWrite,
                   output logic       CondEx,
                   output logic [3:0] FlagsNext);

  always_comb begin
    case (Cond)
      4'b0000: CondEx = Flags[2];  // Z flag
      4'b0001: CondEx = ~Flags[2];  // !Z flag
      4'b0010: CondEx = Flags[1];  // C flag
      4'b0011: CondEx = ~Flags[1];  // !C flag
      4'b0100: CondEx = Flags[3];  // N flag
      4'b0101: CondEx = ~Flags[3];  // !N flag
      4'b0110: CondEx = Flags[0];  // V flag
      4'b0111: CondEx = ~Flags[0];  // !V flag
      4'b1000: CondEx = Flags[1] & ~Flags[2];  // C & !Z
      4'b1001: CondEx = ~(Flags[1] & ~Flags[2]);  // !(C & !Z)
      4'b1010: CondEx = ~(Flags[3] ^ Flags[0]);  // N == V
      4'b1011: CondEx = Flags[3] ^ Flags[0];  // N != V
      4'b1100: CondEx = ~(Flags[3] ^ Flags[0]) & ~Flags[2];  // (N == V) & !Z
      4'b1101: CondEx = ~(~(Flags[3] ^ Flags[0]) & ~Flags[2]);  // !(N == V & !Z)
      4'b1110: CondEx = 1'b1;  // Always true
      default: CondEx = 1'bx;  // Undefined
    endcase
  end

 assign FlagsNext[3:2] = (FlagsWrite[1] & CondEx) ? ALUFlags[3:2] : 
Flags[3:2]; 
 assign FlagsNext[1:0] = (FlagsWrite[0] & CondEx) ? ALUFlags[1:0] : 
Flags[1:0]; 

endmodule