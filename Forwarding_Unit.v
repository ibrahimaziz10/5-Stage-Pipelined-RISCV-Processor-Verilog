`timescale 1ns / 1ps

module Forwarding_Unit(
    input [4:0] EX_rs1,           // Source register 1 in EX stage
    input [4:0] EX_rs2,           // Source register 2 in EX stage
    input [4:0] MEM_WriteReg,     // Destination register in MEM stage
    input [4:0] WB_WriteReg,      // Destination register in WB stage
    input MEM_RegWrite,           // Does the instruction in MEM write to a register?
    input WB_RegWrite,            // Does the instruction in WB write to a register?
    
    output reg [1:0] ForwardA,    // Control signal for ALU input A mux
    output reg [1:0] ForwardB     // Control signal for ALU input B mux
);

    always @(*) begin
        // Default: No forwarding (use normal values from ID/EX register)
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // ====================================================================
        // 1. FORWARDING FOR OPERAND A (rs1)
        // ====================================================================
        
        // EX/MEM Hazard (Prioritized because it's the most recent instruction)
        if (MEM_RegWrite && (MEM_WriteReg != 5'b0) && (MEM_WriteReg == EX_rs1)) begin
            ForwardA = 2'b10; // Forward from EX/MEM register (ALU output)
        end
        // MEM/WB Hazard
        else if (WB_RegWrite && (WB_WriteReg != 5'b0) && (WB_WriteReg == EX_rs1)) begin
            ForwardA = 2'b01; // Forward from MEM/WB register (Writeback data)
        end

        // ====================================================================
        // 2. FORWARDING FOR OPERAND B (rs2)
        // ====================================================================
        
        // EX/MEM Hazard (Prioritized because it's the most recent instruction)
        if (MEM_RegWrite && (MEM_WriteReg != 5'b0) && (MEM_WriteReg == EX_rs2)) begin
            ForwardB = 2'b10; // Forward from EX/MEM register (ALU output)
        end
        // MEM/WB Hazard
        else if (WB_RegWrite && (WB_WriteReg != 5'b0) && (WB_WriteReg == EX_rs2)) begin
            ForwardB = 2'b01; // Forward from MEM/WB register (Writeback data)
        end
    end

endmodule