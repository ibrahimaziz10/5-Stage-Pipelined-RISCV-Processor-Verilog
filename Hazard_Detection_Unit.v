`timescale 1ns / 1ps

module Hazard_Detection_Unit(
    input [4:0] ID_rs1,          // Source register 1 from Instruction in Decode stage
    input [4:0] ID_rs2,          // Source register 2 from Instruction in Decode stage
    input [4:0] EX_WriteReg,     // Destination register of Instruction in Execute stage
    input EX_MemRead,            // 1 = Instruction in Execute is a load (lw)

    output reg PC_Write,         // 1 = Normal PC update, 0 = Freeze PC (Stall)
    output reg IF_ID_Write,      // 1 = Normal IF/ID update, 0 = Freeze IF/ID register
    output reg Stall_Mux_Sel     // 0 = Pass control signals, 1 = Force control signals to 0 (Bubble)
);

    always @(*) begin
        // Default values: Pipeline runs at full speed normally
        PC_Write      = 1'b1;
        IF_ID_Write   = 1'b1;
        Stall_Mux_Sel = 1'b0;

        // ====================================================================
        // LOAD-USE HAZARD CONDITION DETECTOR:
        // ====================================================================
        // If the instruction currently executing is a Load Word (EX_MemRead == 1)
        // AND its destination register matches either source register of the 
        // instruction currently standing in the Decode stage...
        if (EX_MemRead && ((EX_WriteReg == ID_rs1) || (EX_WriteReg == ID_rs2)) && (EX_WriteReg != 5'b0)) begin
            
            // A Load-Use hazard is caught! Pull the emergency handbrake:
            PC_Write      = 1'b0; // Freeze the Program Counter from advancing
            IF_ID_Write   = 1'b0; // Freeze the IF/ID register (holds the current instruction in place)
            Stall_Mux_Sel = 1'b1; // Wipe out control signals entering ID/EX (Injects a NOP Bubble)
        end
    end

endmodule