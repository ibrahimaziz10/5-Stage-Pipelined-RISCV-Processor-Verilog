`timescale 1ns / 1ps

module RISCV_Processor(
    input clk,
    input Reset_L // Project Spec: Active-low master reset
);
    // ========================================================================
    // 1. WIRE & REG DECLARATIONS
    // ========================================================================
    reg [31:0] PC;
    wire [31:0] IPC_Value; // Sourced from external initialization unit
    wire [31:0] PC_Plus4;
    wire [31:0] Instruction;
    wire [31:0] ReadData1, ReadData2, WriteData;
    wire [31:0] ImmExt;
    wire [31:0] ALU_B_Input;
    wire [31:0] ALUResult;
    wire [31:0] ShifterResult;
    wire [31:0] MemReadData;
    
    // Status Flags from ALU for External Processing
    wire Zero, Negative, Overflow;
    
    // Control Signals
    wire ALUSrc, RegWrite, MemRead, MemWrite, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;
    wire [1:0] ShiftOp;
    wire [1:0] WritebackSel; // Selects between ALU, Shifter, SLT, or Memory

    // ========================================================================
    // 2. EXTERNAL STRUCTURAL INTERCONNECTS (SLT Mechanism outside ALU)
    // ========================================================================
    wire [31:0] SLT_Signed_Result;
    wire [31:0] SLT_Unsigned_Result;

    // Project Spec: slt must have effect OUTSIDE the ALU using status flags
    assign #2 SLT_Signed_Result   = (Negative ^ Overflow) ? 32'b1 : 32'b0;
    assign #2 SLT_Unsigned_Result = (ReadData1 < ALU_B_Input) ? 32'b1 : 32'b0;

    // ========================================================================
    // 3. PROGRAM COUNTER LOGIC (Negative Edge Triggered)
    // ========================================================================
    always @(negedge clk or negedge Reset_L) begin
        if (!Reset_L)
            PC <= #2 IPC_Value; // Loads initial PC from external unit on reset
        else
            PC <= #2 PC_Plus4;
    end

    assign #2 PC_Plus4 = PC + 4;

    // ========================================================================
    // 4. SUB-MODULE INSTANTIATIONS
    // ========================================================================
    
    // Project Spec: External unit containing the IPC register for post-reset boot address
    IPC_Unit External_IPC_Reg (
        .clk(clk),
        .Reset_L(Reset_L),
        .IPC_Value(IPC_Value)
    );
    
    Instruction_Memory IMem (
        .Address(PC),
        .Instruction(Instruction)
    );

    // Main Control Unit featuring the strict 207 delay spec
    Control_Unit CU (
        .Opcode(Instruction[6:0]),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp),
        .ShiftOp(ShiftOp),
        .WritebackSel(WritebackSel)
    );

    // NEW PATCH: Dedicated Immediate Generation Block
    Imm_Gen IG (
        .Instruction(Instruction),
        .ImmExt(ImmExt)
    );

    // NEW PATCH: Local ALU Decoder driving the secondary function fields
    ALU_Control ALUCtrl (
        .ALUOp(ALUOp),
        .funct3(Instruction[14:12]),
        .funct7(Instruction[30]),
        .ALUControl(ALUControl)
    );

    Register_File RegFile (
        .clk(clk),
        .Reset_L(Reset_L),
        .RegWrite(RegWrite),
        .ReadReg1(Instruction[19:15]),
        .ReadReg2(Instruction[24:20]),
        .WriteReg(Instruction[11:7]),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // ALU Input Multiplexer
    assign #1 ALU_B_Input = (ALUSrc) ? ImmExt : ReadData2;

    ALU Core_ALU (
        .A(ReadData1),
        .B(ALU_B_Input),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow)
    );

    // Project Spec: Shifter must be completely external to the ALU
    Shifter External_Shifter (
        .A(ReadData1),
        .Shamt(Instruction[24:20]), // Raw shift amount field
        .ShiftOp(ShiftOp),
        .ShOut(ShifterResult)
    );

    Data_Memory DMem (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Address(ALUResult),
        .WriteData(ReadData2),
        .ReadData(MemReadData)
    );

    // ========================================================================
    // 5. EXTENDED WRITEBACK SELECTION MULTIPLEXER
    // ========================================================================
    // 2'b00: Standard ALU Math
    // 2'b01: Data Memory (lw)
    // 2'b10: External Shifter Output
    // 2'b11: External SLT Logic Output
    assign #1 WriteData = (WritebackSel == 2'b00) ? ALUResult :
                          (WritebackSel == 2'b01) ? MemReadData :
                          (WritebackSel == 2'b10) ? ShifterResult : 
                                                    SLT_Signed_Result;

endmodule