`timescale 1ns / 1ps

module Imm_Gen(
    input [31:0] Instruction,
    output reg [31:0] ImmExt
);

    always @(*) begin
        case(Instruction[6:0])
            7'b0000011, // lw
            7'b0010011: begin // I-type math (addi)
                #2 ImmExt = {{20{Instruction[31]}}, Instruction[31:20]};
            end
            7'b0100011: begin // sw
                #2 ImmExt = {{20{Instruction[31]}}, Instruction[31:25], Instruction[11:7]};
            end
            7'b1100011: begin // B-type branches (beq, bne)
                #2 ImmExt = {{20{Instruction[31]}}, Instruction[7], Instruction[30:25], Instruction[11:8], 1'b0};
            end
            default: #2 ImmExt = 32'b0;
        endcase
    end

endmodule