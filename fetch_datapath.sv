module fetch_datapath #(
    parameter PC_INITIAL = 32'h80000000,
)(
    input logic clk,
    input logic [31:0] new_pc,              // From Testbench

    input logic fetch_enable_control,       // From fetch_controller
    input logic fetch_stall_control,        // From fetch_controller
    input logic instr,                      // From instruction_cache_datapath

    output logic [31:0] pc_out,             // To instruction_cache_datapath

    output logic [31:0] instr_dout          // To decode_datapath
);
    // Program Counter Register
    logic [31:0] pc;

    // Program Counter Chooser Logic
    always@(posedge clk) begin
        if(fetch_stall_control)             // Fetch Stall
            pc <= pc;
        else if(fetch_enable_control)       // Fetch Unit Enabled
            pc <= new_pc;
        else
            pc <= pc;                       // Default
    end

    // Program Counter to Cache
    assign pc_out = pc;

    // Instruction Fetch to Decode Stage
    assign instr_dout = i_mem_dout;

endmodule