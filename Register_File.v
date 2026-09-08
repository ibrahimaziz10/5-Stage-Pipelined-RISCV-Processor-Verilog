`timescale 1ns / 1ps

module Register_File(
    input clk,
    input Reset_L,          // Active-low master reset required by project spec
    input RegWrite,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
);
    reg [31:0] registers [31:0];
    integer i;

    // Project Requirement: Storage elements must be negative edge triggered
    always @(negedge clk or negedge Reset_L) begin
        if (!Reset_L) begin
            // Synchronous/Asynchronous active-low reset initialization loop
            for(i = 0; i < 32; i = i + 1) begin
                registers[i] <= i; // Pre-fill with indices for diagnostics
            end
        end 
        else if (RegWrite && WriteReg != 5'b0) begin
            // Incorporating a reasonable gate propagation write delay
            #4 registers[WriteReg] <= WriteData;
        end
    end

    // Combinational read tracking with reasonable read propagation delays
    assign #2 ReadData1 = (ReadReg1 == 5'b0) ? 32'b0 : registers[ReadReg1];
    assign #2 ReadData2 = (ReadReg2 == 5'b0) ? 32'b0 : registers[ReadReg2];

    // Diagnostic tracking: Automatic display to STDOUT when writes occur
    always @(posedge clk) begin
        if (RegWrite && WriteReg != 5'b0 && Reset_L) begin
            $display("TIME: %0d ns | RegFile Write | Reg[%0d] updated to Hex: %h", $time, WriteReg, WriteData);
        end
    end

endmodule