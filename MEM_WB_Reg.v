`timescale 1ns / 1ps

module MEM_WB_Reg(
    input clk,
    input Reset_L,
    
    // Control Signals from MEM stage
    input MEM_RegWrite,
    input [1:0] MEM_WritebackSel,
    
    // Data from MEM stage
    input [31:0] MEM_MemReadData,
    input [31:0] MEM_ALUResult,
    input [4:0]  MEM_WriteReg,
    
    // Outputs to WB stage
    output reg WB_RegWrite,
    output reg [1:0] WB_WritebackSel,
    
    output reg [31:0] WB_MemReadData,
    output reg [31:0] WB_ALUResult,
    output reg [4:0]  WB_WriteReg
);

    always @(negedge clk or negedge Reset_L) begin
        if (!Reset_L) begin
            WB_RegWrite     <= 1'b0;
            WB_WritebackSel <= 2'b00;
            WB_MemReadData  <= 32'b0;
            WB_ALUResult    <= 32'b0;
            WB_WriteReg     <= 5'b0;
        end else begin
            WB_RegWrite     <= MEM_RegWrite;
            WB_WritebackSel <= MEM_WritebackSel;
            WB_MemReadData  <= MEM_MemReadData;
            WB_ALUResult    <= MEM_ALUResult;
            WB_WriteReg     <= MEM_WriteReg;
        end
    end
endmodule