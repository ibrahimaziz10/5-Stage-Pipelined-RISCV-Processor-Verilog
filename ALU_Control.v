`timescale 1ns / 1ps

module ALU_Control(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7,
    output reg [3:0] ALUControl
);

    always @(*) begin
        case(ALUOp)
            2'b00: #2 ALUControl = 4'b0010; // Load/Store (Requires ADD calculation)
            2'b01: #2 ALUControl = 4'b0110; // Branch Equal (Requires SUB calculation)
            2'b10: begin                    // R-Type Instructions
                case(funct3)
                    3'b000: begin
                        if(funct7) #2 ALUControl = 4'b0110; // sub
                        else       #2 ALUControl = 4'b0010; // add
                    end
                    3'b111: #2 ALUControl = 4'b0000;        // and
                    3'b110: #2 ALUControl = 4'b0001;        // or
                    3'b100: #2 ALUControl = 4'b0011;        // xor
                    default: #2 ALUControl = 4'b0010;
                endcase
            end
            2'b11: begin                    // I-Type Immediate Instructions
                case(funct3)
                    3'b000: #2 ALUControl = 4'b0010;        // addi
                    3'b111: #2 ALUControl = 4'b0000;        // andi
                    3'b110: #2 ALUControl = 4'b0001;        // ori
                    default: #2 ALUControl = 4'b0010;
                endcase
            end
            default: #2 ALUControl = 4'b0010;
        endcase
    end

endmodule