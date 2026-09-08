`timescale 1ns / 1ps

module ID_EX_Reg(
    input clk,
    input Reset_L,
    
    // Control Inputs
    input ID_ALUSrc, input ID_RegWrite, input ID_MemRead, input ID_MemWrite, input ID_Branch,
    input [1:0] ID_ALUOp, input [1:0] ID_ShiftOp, input [1:0] ID_WritebackSel,
    // Data Inputs
    input [31:0] ID_ReadData1, input [31:0] ID_ReadData2, input [31:0] ID_ImmExt,
    input [4:0]  ID_Shamt, input [2:0] ID_funct3, input ID_funct7, input [4:0] ID_WriteReg,
    
    // Control Outputs
    output reg EX_ALUSrc, output reg EX_RegWrite, output reg EX_MemRead, output reg EX_MemWrite, output reg EX_Branch,
    output reg [1:0] EX_ALUOp, output reg [1:0] EX_ShiftOp, output reg [1:0] EX_WritebackSel,
    // Data Outputs
    output reg [31:0] EX_ReadData1, output reg [31:0] EX_ReadData2, output reg [31:0] EX_ImmExt,
    output reg [4:0]  EX_Shamt, output reg [2:0] EX_funct3, output reg EX_funct7, output reg [4:0] EX_WriteReg
);

    always @(negedge clk or negedge Reset_L) begin
        if (!Reset_L) begin
            EX_MemRead      <= 1'b0;
            EX_RegWrite     <= 1'b0;
            EX_ALUSrc       <= 1'b0;
            EX_MemWrite     <= 1'b0;
            EX_Branch       <= 1'b0;
            EX_ALUOp        <= 2'b0;
            EX_ShiftOp      <= 2'b0;
            EX_WritebackSel <= 2'b0;
            EX_ReadData1    <= 32'b0;
            EX_ReadData2    <= 32'b0;
            EX_ImmExt       <= 32'b0; // Ensures 'Z' turns to '0' on reset
            EX_Shamt        <= 5'b0;
            EX_funct3       <= 3'b0;
            EX_funct7       <= 1'b0;
            EX_WriteReg     <= 5'b0;
        end else begin
            EX_ALUSrc       <= ID_ALUSrc;
            EX_RegWrite     <= ID_RegWrite;
            EX_MemRead      <= ID_MemRead;
            EX_MemWrite     <= ID_MemWrite;
            EX_Branch       <= ID_Branch;
            EX_ALUOp        <= ID_ALUOp;
            EX_ShiftOp      <= ID_ShiftOp;
            EX_WritebackSel <= ID_WritebackSel;
            EX_ReadData1    <= ID_ReadData1;
            EX_ReadData2    <= ID_ReadData2;
            EX_ImmExt       <= ID_ImmExt; // Correctly pass it!
            EX_Shamt        <= ID_Shamt;
            EX_funct3       <= ID_funct3;
            EX_funct7       <= ID_funct7;
            EX_WriteReg     <= ID_WriteReg;
        end
    end
endmodule