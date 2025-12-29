module sign_extend #(
    parameter DATA_WIDTH = 32
) (
    input logic [31:7] Immediate, // From decode_datapath
    input logic [2:0] ImmSrcD, // From control_unit (choose which format the imm is in)
    output logic [31:0] ExtImmD // To execute_datapath
);


always_comb begin
    case(ImmSrcD)
        3'b000: ExtImmD = {{20{Immediate[31]}}, Immediate[31:20]}; // type I
        3'b001: ExtImmD = {{20{Immediate[31]}}, Immediate[31:25], Immediate[11:7]}; // type Store
        3'b010: ExtImmD = {{20{Immediate[31]}}, Immediate[7], Immediate[30:25], Immediate[11:8], 1'b0};// type Branch
        3'b011: ExtImmD = {{12{Immediate[31]}},  Immediate[19:12], Immediate[20], Immediate[30:21], 1'b0}; // type Jump
        3'b100: ExtImmD = {Immediate[31:12], 12'b0}; // U instruction
        default: ExtImmD = {DATA_WIDTH{1'b0}};
    endcase
end

endmodule