module instruction_cache_datapath(
    input logic clk,
    input logic [31:0] pc,
    input logic instr_cache_enable,
    input logic instr_in,
    output logic [31:0] pc_out,
    output logic instr_cache_processing,
    output logic [31:0] instr_out

);

    always_comb begin
        instr_cache_processing = 1'b0;
        if(instr_cache_enable)
            instr_cache_processing = 1'b1;
            pc_out = pc;
        instr_cache_processing = 1'b0;
        instr_out = instr_in;
    end

endmodule