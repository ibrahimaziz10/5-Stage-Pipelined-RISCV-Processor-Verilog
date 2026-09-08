`timescale 1ns / 1ps

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUControl,
    output reg [31:0] ALUResult,
    output Zero,
    output reg Negative,      // Extra status flag needed for external SLT handling
    output reg Overflow       // Extra status flag for signed comparisons
);

    always @(*) begin
        case(ALUControl)
            4'b0000: #2 ALUResult = A & B;                  // AND / ANDI
            4'b0001: #2 ALUResult = A | B;                  // OR / ORI
            4'b0010: #4 ALUResult = A + B;                  // ADD / ADDI / ADDU
            4'b0110: #4 ALUResult = A - B;                  // SUB / SUBU
            4'b0011: #2 ALUResult = A ^ B;                  // XOR / XORI
            default: #1 ALUResult = 32'b0;
        endcase
        
        // Generate status flags for external target blocks after computation delay
        #1;
        Negative = ALUResult[31];
        Overflow = ((A[31] == B[31]) && (ALUResult[31] != A[31]) && (ALUControl == 4'b0110)) ? 1'b1 : 1'b0;
    end

    assign #1 Zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;

endmodule