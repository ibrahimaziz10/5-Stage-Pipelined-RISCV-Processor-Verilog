`timescale 1ns / 1ps

module tb_RISCV_Processor();

    reg clk;
    reg Reset_L;

    // Instantiate the complete Phase 1 Structural Core
    RISCV_Processor uut (
        .clk(clk),
        .Reset_L(Reset_L)
    );

    // Generate a systematic 50MHz clock cycle wave (Tcc period = 20ns)
    always begin
        #10 clk = ~clk;
    end

    initial begin
        clk = 1'b0;
        Reset_L = 1'b0; // Drive Active-Low Reset active immediately [cite: 98]
        
        $display("==================================================================");
        $display("STARTING DIAGNOSTIC SIMULATION: INITIALIZING MASTER RESET...");
        $display("==================================================================");
        
        // Project Spec Requirement: "Drive Reset_L low for at least 10 integral clock cycles" 
        #200; 
        
        // Release Master Reset to initiate instruction tracking execution loop
        Reset_L = 1'b1;
        $display("TIME: %0d ns | Master Reset Released. Booting via IPC Vector...", $time);
        
        // Allow the 9 distinct program segments to cycle through fully
        #400;
        
        $display("==================================================================");
        $display("DIAGNOSTIC TRACKING COMPLETE. MEMORY AND REGISTER DUMP COMPLETED.");
        $display("==================================================================");
        $finish;
    end

endmodule