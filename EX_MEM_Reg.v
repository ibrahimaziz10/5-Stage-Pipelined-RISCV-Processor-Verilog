`timescale 1ns / 1ps

module EX_MEM_Reg(
    input clk,
    input Reset_L,
    
    // Control Signals from EX stage
    input EX_RegWrite,
    input EX_MemRead,
    input EX_MemWrite,
    input [1:0] EX_WritebackSel,
    
    // Data from EX stage
    input [31:0] EX_ALUResult,
    input [31:0] EX_WriteDataIn, // Data to store in memory (from x2 register)
    input [4:0]  EX_WriteReg,    // Target destination register (rd)
    
    // Outputs to MEM stage
    output reg MEM_RegWrite,
    output reg MEM_MemRead,
    output reg MEM_MemWrite,
    output reg [1:0] MEM_WritebackSel,
    
    output reg [31:0] MEM_ALUResult,
    output reg [31:0] MEM_WriteDataOut,
    output reg [4:0]  MEM_WriteReg
);

always @(negedge clk or negedge Reset_L) begin
        if (!Reset_L) begin
            MEM_RegWrite     <= 1'b0;
            MEM_MemRead      <= 1'b0;
            MEM_MemWrite     <= 1'b0;
            MEM_WritebackSel <= 2'b00;
            MEM_ALUResult    <= 32'b0;
            MEM_WriteDataOut <= 32'b0;
            MEM_WriteReg     <= 5'b0;
        end else begin
            MEM_RegWrite     <= EX_RegWrite;
            MEM_MemRead      <= EX_MemRead;
            MEM_MemWrite     <= EX_MemWrite;
            MEM_WritebackSel <= EX_WritebackSel;
            MEM_ALUResult    <= EX_ALUResult;
            MEM_WriteDataOut <= EX_WriteDataIn;
            MEM_WriteReg     <= EX_WriteReg;
        end
    end
endmodule