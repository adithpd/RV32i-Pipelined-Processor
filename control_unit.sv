module control_unit #(
    parameter DATA_WIDTH = 32
)(
    input  logic [6:0]      op,
    input  logic [2:0]      funct3,
    input  logic            funct7,
    
    output logic            RegWriteD,              // Register File Write Enable
    output logic [1:0]      ResultSrcD,             // Writeback source mux selector
    output logic            MemWriteD,              // Data Memory Write Enable
    output logic            JumpD,                  // Jump Control
    output logic            BranchD,                // Conditional branch instruction
    output logic [3:0]      ALUControlD,            // Exact ALU operation
    output logic            ALUSrcD,                // ALU operand-B select
    output logic [2:0]      ImmSrcD,                // Immediate format selector
    output logic            JALRInstrD,             // Distinguishes JAL vs JALR
    output logic [2:0]      AddressingControlD      // Load/store width and sign control
);
    always_comb begin
        case(op)            
            // R type instructions
            7'b0110011: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                ALUSrcD = 1'b0;
                JALRInstrD = 1'b0;
                
                case(funct3)
                    3'b000: begin
                        case(funct7)
                            1'b0: ALUControlD = 4'b0000; // add
                            1'b1: ALUControlD = 4'b0001; // sub
                        endcase
                    end
                    3'b001: ALUControlD = 4'b0111; // sll
                    3'b010: ALUControlD = 4'b0101; // slt
                    3'b011: ALUControlD = 4'b0110; // sltu
                    3'b100: ALUControlD = 4'b0100; // xor
                    3'b110: ALUControlD = 4'b0011; // or
                    3'b111: ALUControlD = 4'b0010; // and
                    3'b101: begin
                        case(funct7)
                            1'b0:  ALUControlD = 4'b1000; // srl
                            1'b1:  ALUControlD = 4'b1011; // sra 
                        endcase
                    end
                    default: ALUControlD = 4'b0000;
                endcase
            end

            // B-type instruction
            7'b1100011: begin
                RegWriteD = 1'b0;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b1;
                
                case(funct3) 
                    3'b000 : ALUControlD = 4'b0001;   // beq
                    3'b001 : ALUControlD = 4'b1100;   // bne
                    3'b100 : ALUControlD = 4'b0101;   // blt
                    3'b101 : ALUControlD = 4'b1001;   // bge
                    3'b110 : ALUControlD = 4'b0110;   // bltu
                    3'b111 : ALUControlD = 4'b1010;   // bgeu
                endcase

                ALUSrcD = 1'b0;
                ImmSrcD = 3'b010;
                JALRInstrD = 1'b0;
            end

            // I-type instruction
            7'b0010011: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b000;
                JALRInstrD = 1'b0;

                case(funct3)
                    3'b000: ALUControlD = 4'b0000; // addi
                    3'b001: ALUControlD = 4'b0111; // slli
                    3'b100: ALUControlD = 4'b0100; // xori
                    3'b101: 
                        case(funct7)
                            1'b0: ALUControlD = 4'b1000; // srli
                            1'b1: ALUControlD = 4'b1011; // srai 
                        endcase
                    3'b110: ALUControlD = 4'b0011; // ori
                    3'b111: ALUControlD = 4'b0010; // andi
                    default: ALUControlD = 4'b0000;
                endcase
            end

            // J-type instruction
            // JAL
            7'b1101111: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b10;
                MemWriteD = 1'b0;
                BranchD = 1'b0;
                ImmSrcD = 3'b011;
                JumpD = 1'b1;
                JALRInstrD = 1'b0;
            end

            // I-type instruction (lb, lh, lw, lbu, lhu)
            7'b0000011: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b01;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                ALUControlD = 4'b0000;
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b000;   
                JALRInstrD = 1'b0;
                AddressingControlD = funct3;
            end

            // S-type instruction (sb, sh, sw)
            7'b0100011: begin
                RegWriteD = 1'b0;
                MemWriteD = 1'b1;
                JumpD = 1'b0;
                BranchD = 1'b0;
                ALUControlD = 4'b0000;
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b001;
                JALRInstrD = 1'b0;
                AddressingControlD = funct3;
            end

            // I-type instruction 
            // JALR
            7'b1100111: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b10;
                MemWriteD = 1'b0;
                JumpD = 1'b1;
                BranchD = 1'b0;
                ALUControlD = 4'b0000;
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b000;
                JALRInstrD = 1'b1;
            end

            // U-type instruction
            // LUI
            7'b0110111: begin
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                ALUControlD = 4'b1111;
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b100;
                JALRInstrD = 1'b0;
            end    

            default: begin
                RegWriteD = 1'b0;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                ALUControlD = 4'b0000;
                ALUSrcD = 1'b0;
                ImmSrcD = 3'b000;
                JALRInstrD = 1'b0;
            end
        endcase
    end
endmodule