module decode_datapath (
    input logic clk,
    input logic decode_enable,
    input logic i_din,
    input logic decode_stall_control,
);
    // Program Counter Register
    logic instr;

    // Program Counter Chooser Logic
    always@(posedge clk) begin
        if(decode_stall)            // Decode Stall
            instr <= instr;
        else if(decode_enable)      // Fetch Unit Enabled
            instr <= i_din;
        else
            instr <= instr;         // Default
    end

    

endmodule