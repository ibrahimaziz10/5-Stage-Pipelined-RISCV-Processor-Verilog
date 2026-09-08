`timescale 1ns / 1ps

module pc(
    input wire clock,
    input wire rst,
    input wire [31:0] pc_in_value,
    output reg [31:0] pc_reg
);

    always @(posedge clock or posedge rst) begin
        if (rst) begin
            pc_reg <= 32'b0;
        end else begin
            pc_reg <= pc_in_value;
        end
    end

endmodule