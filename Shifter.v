`timescale 1ns / 1ps

module Shifter(
    input [31:0] A,          // Value to be shifted
    input [4:0] Shamt,       // Shift amount (rs2 value or immediate bits)
    input [1:0] ShiftOp,     // 00: SLL, 01: SRL, 10: SRA
    output reg [31:0] ShOut  // Shifted result output
);

    always @(*) begin
        case(ShiftOp)
            2'b00: #3 ShOut = A << Shamt;                          // SLL (Logical Left)
            2'b01: #3 ShOut = A >> Shamt;                          // SRL (Logical Right)
            2'b10: #4 ShOut = $signed(A) >>> Shamt;                 // SRA (Arithmetic Right)
            default: #1 ShOut = A;
        endcase
    end

endmodule