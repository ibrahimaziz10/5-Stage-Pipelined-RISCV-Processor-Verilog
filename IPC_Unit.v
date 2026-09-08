`timescale 1ns / 1ps
// ============================================================================
// Module Name: IPC_Unit
// Project: 5-Stage Pipelined RISC-V Processor (Phase 1 Baseline)
// Requirement: External unit providing the initial PC address post-reset
// ============================================================================

module IPC_Unit(
    input clk,
    input Reset_L,                  // Active-low master reset
    output reg [31:0] IPC_Value     // Target boot address fed to the PC register
);

    // Structural 32-bit register as required by project specifications
    always @(negedge clk or negedge Reset_L) begin
        if (!Reset_L) begin
            // On active reset, lock the initial boot vector address with gate delay
            #2 IPC_Value <= 32'h00000000; 
        end
        else begin
            // Maintain stable address during runtime execution
            IPC_Value <= IPC_Value;
        end
    end

endmodule