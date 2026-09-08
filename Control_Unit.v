`timescale 1ns / 1ps
// ============================================================================
// Module Name: Control_Unit
// Project: 5-Stage Pipelined RISC-V Processor (Phase 1 Baseline)
// Constraint: Mandatory worst-case propagation delay of exactly 207 time units
// ============================================================================

module Control_Unit #(
    parameter WORD_LEN = 32 // Structured using parameter upper bounds
)(
    input [6:0] Opcode,
    output reg ALUSrc,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg [1:0] ALUOp,
    output reg [1:0] ShiftOp,       // 00: SLL, 01: SRL, 10: SRA
    output reg [1:0] WritebackSel   // 00: ALU, 01: Mem, 10: Shifter, 11: SLT
);

    // Internal registers to hold values before applying the mandatory gate delay
    reg ALUSrc_temp;
    reg RegWrite_temp;
    reg MemRead_temp;
    reg MemWrite_temp;
    reg Branch_temp;
    reg [1:0] ALUOp_temp;
    reg [1:0] ShiftOp_temp;
    reg [1:0] WritebackSel_temp;

    always @(*) begin
        // Default safe baseline state assignments
        ALUSrc_temp       = 1'b0;
        RegWrite_temp     = 1'b0;
        MemRead_temp      = 1'b0;
        MemWrite_temp     = 1'b0;
        Branch_temp       = 1'b0;
        ALUOp_temp        = 2'b00;
        ShiftOp_temp      = 2'b00;
        WritebackSel_temp = 2'b00;

        case(Opcode)
            7'b0110011: begin // Standard Signed/Unsigned R-Type (add, sub, slt, sll, srl, sra)
                RegWrite_temp     = 1'b1;
                ALUOp_temp        = 2'b10;
                // Note: We will expand this in the ALU_Control to differentiate 
                // between standard ALU math, external shifting, and external SLT.
            end
            
            7'b0000011: begin // Load Word (lw) [cite: 114]
                ALUSrc_temp       = 1'b1;
                RegWrite_temp     = 1'b1;
                MemRead_temp      = 1'b1;
                WritebackSel_temp = 2'b01; // Routes Data Memory output to Register File
            end
            
            7'b0100011: begin // Store Word (sw) [cite: 114]
                ALUSrc_temp       = 1'b1;
                MemWrite_temp     = 1'b1;
            end
            
            7'b1100011: begin // Branch instructions (beq, bne) [cite: 114]
                Branch_temp       = 1'b1;
                ALUOp_temp        = 2'b01;
            end
            
            7'b0010011: begin // I-Type Arithmetics (addi, andi, ori, xori) [cite: 112]
                ALUSrc_temp       = 1'b1;
                RegWrite_temp     = 1'b1;
                ALUOp_temp        = 2'b11; // Unique state for immediate ALU lookups
            end

            default: begin
                // Retains default safe parameters on unhandled instructions
            end
        endcase
    end

    // ========================================================================
    // CRITICAL PROJECT SPECIFICATION REQUIREMENT: 
    // "For the datapath controller you should use a delay of 207."
    // ========================================================================
    always @(*) begin
        #207 ALUSrc       = ALUSrc_temp;
        #207 RegWrite     = RegWrite_temp;
        #207 MemRead      = MemRead_temp;
        #207 MemWrite     = MemWrite_temp;
        #207 Branch       = Branch_temp;
        #207 ALUOp        = ALUOp_temp;
        #207 ShiftOp      = ShiftOp_temp;
        #207 WritebackSel = WritebackSel_temp;
    end

endmodule