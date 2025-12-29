module register_file #(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 5
)(
    input   logic                              clk,
    input   logic [DATA_WIDTH-1:0]             ReadAddr1,
    input   logic [DATA_WIDTH-1:0]             ReadAddr2
    input   logic [ADDRESS_WIDTH-1:0]          WriteData,
    input   logic [DATA_WIDTH-1:0]             WriteAddr,
    input   logic                              WriteEnable,
    output  logic [ADDRESS_WIDTH-1:0]          ReadData1,
    output  logic [ADDRESS_WIDTH-1:0]          ReadData2,

);
    logic [DATA_WIDTH-1:0] reg_file [2**ADDRESS_WIDTH-1:0];  

    always_ff @(posedge clk) begin
        if(WriteEnable) 
            reg_file[WriteAddr] <= (WriteAddr == 5'd0) ? 32'd0 : WriteData;
    end 

    always_comb begin
        ReadData1 = reg_file[ReadAddr1];
        ReadData2 = reg_file[ReadAddr2];
    end
endmodule