`timescale 1ns / 1ps

module Data_Memory(
    input clk,
    input MemRead,
    input MemWrite,
    input [31:0] Address,
    input [31:0] WriteData,
    output [31:0] ReadData
);
    reg [31:0] ram [63:0];

    assign ReadData = (MemRead) ? ram[Address >> 2] : 32'b0;

    always @(posedge clk) begin
        if (MemWrite) begin
            ram[Address >> 2] <= WriteData;
        end
    end
endmodule