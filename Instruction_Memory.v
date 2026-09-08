`timescale 1ns / 1ps

module Instruction_Memory(
    input [31:0] Address,
    output reg [31:0] Instruction
);
    reg [31:0] mem [0:2047]; // 2K-word deep memory array [cite: 78]

    initial begin
        // Hand-coded Machine Language Hex Formats matching standard RISC-V definitions [cite: 116]
        mem[0] = 32'h00a00093; // addi x1, x0, 10
        mem[1] = 32'h00f00113; // addi x2, x0, 15
        mem[2] = 32'h002081b3; // add x3, x1, x2
        mem[3] = 32'h40110233; // sub x4, x2, x1
        mem[4] = 32'h0020f2b3; // and x5, x1, x2
        mem[5] = 32'h0020e333; // or  x6, x1, x2
        mem[6] = 32'h0020a3b3; // slt x7, x1, x2 (External processing verified!)
        mem[7] = 32'h00302023; // sw  x3, 0(x0)
        mem[8] = 32'h00002403; // lw  x8, 0(x0)
        
        // Fill remaining instruction slots with safe NOP blocks
        default_fill();
    end

    integer i;
    task default_fill;
        for (i = 9; i < 2048; i = i + 1) begin
            mem[i] = 32'h00000013; // NOP (addi x0, x0, 0)
        end
    endtask

    always @(*) begin
        // Word alignment address division (Right-shifting by 2 to map byte addresses to word indices)
        Instruction = mem[Address >> 2]; 
    end

endmodule