module fetch_datapath #(
    parameter PC_INITIAL = 32'h80000000,
)(
    input logic clk,
    input logic new_pc,
    input logic fetch_enable,
    input logic i_mem_dout,
    input logic memory_control,
    input logic i_mem_fetch_done_control,
    input logic fetch_stall_control,
    input logic fetch_busy_control,
    output logic i_dout
);
    // Program Counter Register
    logic pc;

    // Program Counter Chooser Logic
    always@(posedge clk) begin
        if(!reset_n)                // Active Low Reset
            pc <= PC_INITIAL;
        else if(fetch_stall)        // Fetch Stall
            pc <= pc;
        else if(fetch_busy)         // Fetch Busy
            pc <= pc;
        else if(fetch_enable)       // Fetch Unit Enabled
            pc <= new_pc;
        else
            pc <= pc;        // Default
    end

    // Instruction Fetch to Decode Stage
    assign i_dout = i_mem_dout;

endmodule