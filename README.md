# 5-Stage Pipelined RISC-V Processor in Verilog

A 32-bit 5-stage pipelined RISC-V CPU core implemented in Verilog HDL for a Computer Organization and Architecture Lab project[cite: 1]. This design transitions from an initial single-cycle architecture to a high-performance pipelined core featuring automated hazard detection, load-use stalling, and early branch flushing[cite: 1].

---

## System Specifications

| Parameter | Specification |
| :--- | :--- |
| **Data Path Width** | 32-bit internal data paths and registers[cite: 1] |
| **Instruction Memory (I-Mem)** | 2K-words deep, 32-bit wide SRAM pre-loaded with machine instructions[cite: 1] |
| **Data Memory (D-Mem)** | 4K-words deep, 32-bit wide SRAM (single clock cycle access budget)[cite: 1] |
| **Clocking Trigger** | Negative-edge triggered (`negedge clk`) for register file and pipeline registers[cite: 1] |
| **Reset Mechanism** | Active-Low Master Reset (`Reset_L`), held low $\ge 10$ full clock cycles[cite: 1] |
| **External Units** | Multi-bit 32-bit shifter unit and `slt` hardware external to the main ALU[cite: 1] |

---

## Supported Instruction Set Architecture (ISA)

* **Arithmetic (Unsigned):** `addu`, `subu`, `addiu`[cite: 1]
* **Arithmetic (Signed):** `add`, `sub`, `addi`[cite: 1]
* **Logical Operations:** `and`, `andi`, `or`, `ori`, `xor`, `xori`[cite: 1]
* **Shift Operations:** `sll` (Shift Left Logical), `sra` (Shift Right Arithmetic), `srl` (Shift Right Logical)[cite: 1]
* **Comparison Operations:** `slt`, `slti`, `sltu`[cite: 1]
* **Control Flow (Branching):** `beq`, `bne`, `blez`[cite: 1]
* **Data Transfer (Memory):** `lw` (Load Word), `sw` (Store Word)[cite: 1]

---

## Architecture & Pipeline Stages

Execution is divided across five concurrent stages, separated by four sets of pipeline isolation registers[cite: 1]:

1. **IF (Instruction Fetch):** Accesses 2K-word I-Mem using the Program Counter (PC) to fetch the 32-bit instruction[cite: 1].
2. **ID (Instruction Decode):** Decodes opcodes/fields, reads operands from the dual-read register file, evaluates branch conditions early, and computes target branch addresses[cite: 1].
3. **EX (Execute):** Computes arithmetic/logical results via the 32-bit ALU, runs shift operations via the external shifter, and calculates memory target addresses for `lw`/`sw`[cite: 1].
4. **MEM (Data Memory Access):** Reads from or writes to the 4K-word D-Mem[cite: 1].
5. **WB (Write Back):** Writes ALU, shift, or memory load results back into the destination register file[cite: 1].

### Pipeline Isolation Registers
* **IF/ID:** Stores fetched 32-bit instruction and PC[cite: 1].
* **ID/EX:** Stores register read data, sign-extended immediates, target register addresses, and control bits for EX, MEM, and WB[cite: 1].
* **EX/MEM:** Stores ALU/shifter outputs, store data, target register addresses, and MEM/WB control signals[cite: 1].
* **MEM/WB:** Stores memory output values, ALU results, target register addresses, and WB control signals[cite: 1].

---

## Hazard Handling Mechanisms

### 1. Data Hazards (Load-Use Stalling)
Occurs when an instruction in the ID stage attempts to read a register that is currently being fetched by an active `lw` instruction in the EX stage[cite: 1]:
* **Freeze PC:** De-asserts `PCWrite` to keep the IF stage on the current instruction[cite: 1].
* **Freeze IF/ID Register:** Disables write-enable on the IF/ID register to hold the dependent instruction in Decode[cite: 1].
* **Inject Bubble:** Clears control signals in the ID/EX register to insert a `NOP` (bubble), granting the `lw` instruction enough time to access memory[cite: 1].

### 2. Control Hazards (Branch Flushing)
Branches are evaluated early in the **ID Stage** using dedicated comparators[cite: 1]:
* If a branch condition is met (**Branch Taken**), the speculative instruction fetched in the IF/ID register is flushed to zero (converted to a bubble)[cite: 1].
* The calculated branch target address is forced into the PC, resulting in a 1-cycle branch penalty[cite: 1].

---

## Performance & Speedup Results

The design performance was evaluated by benchmarking the pipelined core against the initial single-cycle execution model[cite: 1]:

$$S = \frac{\text{Single-Cycle Active Execution Time}}{\text{Pipelined Active Execution Time}} = \frac{2040\text{ ns}}{250\text{ ns}} = 8.16\times$$

* **Single-Cycle Execution Time:** $2040\text{ ns}$ active time ($2200\text{ ns} - 160\text{ ns}$ reset period)[cite: 1].
* **Pipelined Execution Time:** $250\text{ ns}$ active time ($281\text{ ns} - 31\text{ ns}$ reset period)[cite: 1].
* **Speedup Achieved:** **$8.16\times$ performance improvement**[cite: 1].

---

## Authors
* **Ibrahim**[cite: 1]
* **Abdur Rab**[cite: 1]
