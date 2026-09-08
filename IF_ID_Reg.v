`timescale 1ns / 1ps

module IF_ID_Reg(
    input clk,
    input Reset_L,
    input IF_ID_Write,          // 1 = Write/Update normally, 0 = Freeze/Hold data
    input [31:0] IF_PC,
    input [31:0] IF_Instruction,
    output reg [31:0] ID_PC,
    output reg [31:0] ID_Instruction
);

    always @(negedge clk or negedge Reset_L) begin
        if (!Reset_L) begin
            ID_PC          <= 32'b0;
            ID_Instruction <= 32'b0;
        end else if (IF_ID_Write) begin // Only update if Hazard Unit says it's safe!
            ID_PC          <= IF_PC;
            ID_Instruction <= IF_Instruction;
        end
        // If IF_ID_Write is 0, it implicitly holds its previous value (stalls)
    end

endmodule