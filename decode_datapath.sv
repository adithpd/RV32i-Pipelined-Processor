module decode_datapath #(
    parameter INSTR_WIDTH = 32,
    parameter REG_FILE_ADDRESS_WIDTH = 5
)(
    input   logic                       clk,
    input   logic   [DATA_WIDTH-1:0]    instr_din,                  // From fetch_datapath
    input   logic                       decode_enable               // From fetch_controller
    input   logic                       decode_stall_external,      // From execute_datapath

    output  logic                       fetch_stall_external,       // To fetch_controller

    output  logic                       RegWriteD,                  // To execute_datapath 
    output  logic   [1:0]               ResultSrcD,                 // To execute_datapath 
    output  logic                       MemWriteD,                  // To execute_datapath
    output  logic                       JumpD,                      // To execute_datapath
    output  logic                       BranchD,                    // To execute_datapath
    output  logic   [3:0]               ALUControlD,                // To execute_datapath
    output  logic                       ALUSrcD,                    // To execute_datapath
    output  logic   [2:0]               ImmSrcD,                    // To execute_datapath
    output  logic                       JALRInstrD,                 // To execute_datapath
    output  logic   [2:0]               AddressingControlD          // To execute_datapath
    output  logic   [DATA_WIDTH-1:0]    RS1Data,                    // To execute_datapath
    output  logic   [DATA_WIDTH-1:0]    RS2Data,                    // To execute_datapath
    output  logic                       execute_enable              // To execute_datapath
);
    always_comb begin
        Rs1D = instrD [19:15];
        Rs2D = instrD [24:20];
        RdD = instrD[11:7];
    end

    logic [2:0] ImmSrcD;

    control_unit control_unit(
        // inputs 
        .op(instrD[6:0]),
        .funct3(instrD[14:12]),
        .funct7(instrD[30]),
        // outputs 
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD),
        .JALRInstrD(JALRInstrD),
        .AddressingControlD(AddressingControlD)
    );

    register_file register_file(
        // inputs
        .clk(clk),
        .ReadAddr1(instrD[19:15]),
        .ReadAddr2(instrD[24:20]),
        .WriteAddr(RdW),
        .WriteData(ResultW),
        .WriteEnable(RegWriteW),
        // outputs
        .ReadData1(RS1Data),
        .ReadData2(RS2Data)
    );

    sign_extend sign_extend(
        // inputs
        .Immediate(instrD[31:7]),
        .ImmSrcD(ImmSrcD),
        //outputs
        .ExtImmD(ExtImmD)
    );


endmodule