# Pipeline-ARM-Processor

# 5-Stage Pipelined ARM Processor (SystemVerilog)

An implementation and verification of a 32-bit 5-Stage Pipelined ARM Processor written in SystemVerilog. This design includes full hazard resolution (forwarding, stalls, and pipeline flushing) to handle data and control dependencies.

---

## Technical Specifications & Architecture

* **Architecture:** 32-bit ARM ISA (5-stage classic pipeline).


* **Pipeline Stages:**
1. **IF (Instruction Fetch):** Fetches instructions using the Program Counter (PC).


2. **ID (Instruction Decode):** Decodes ARM instructions, reads the Register File, and extends immediate values.


3. **EX (Execute):** Computes results using the ALU and evaluates branch/flag conditions.


4. **MEM (Memory Access):** Reads from or writes to Data Memory (`LDR`/`STR`).


5. **WB (Write Back):** Writes computation or load results back into the Register File.




* **Language:** SystemVerilog.


* **Simulation Tool:** Siemens EDA ModelSim / QuestaSim.



---

## Core Features & Hazard Management

* **Data Forwarding Unit:** Resolves Read-After-Write (RAW) hazards dynamically by forwarding ALU/MEM output stages directly to the EX stage operands, preventing performance-degrading stalls.


* **Pipeline Stalling Unit:** Detects Load-Use data dependencies (`LDR` followed by dependent execution) and dynamically freezes the IF/ID stages for 1 cycle.


* **Control Hazard Handling:** Flushes speculative instructions in the pipeline upon branch execution or condition check mismatches.


* **Conditional Execution Support:** Integrates a dedicated condition check block evaluating System Flags ($N, Z, C, V$) across execution conditions.



---

## Directory Structure & System Modules

```text
.
├── rtl/
│   ├── top.sv              # System integration wrapper connecting Core, IMEM, and DMEM
│   ├── arm.sv              # Core CPU wrapper housing Controller, Datapath, and Hazard Unit
│   ├── controller.sv       # Instruction decoding logic and pipeline control generation
│   ├── datapath.sv         # Pipelined data flow hardware across IF, ID, EX, MEM, WB
│   ├── hazard.sv           # Forwarding, stalling, and flushing detection logic
│   ├── conditional.sv      # Flag evaluation (N, Z, C, V) for conditional execution
│   ├── regfile.sv          # 16 x 32-bit Register File (R0-R15, R15 = PC + 8)
│   ├── alu.sv              # Arithmetic/Logic Unit generating ALU signals & flags
│   ├── extend.sv           # Immediate sign/zero extension logic
│   ├── imem.sv             # Instruction Memory module (loads nano.dat)
│   ├── dmem.sv             # Data Memory module
│   └── utility_modules.sv  # Auxiliary modules (flopr, flopenr, floprc, mux2, mux3, adder, eqcmp)
├── sim/
│   ├── testbench_final.sv  # Verification testbench monitoring execution & memory writes
│   └── nano.dat            # Machine code memory initialization file
└── docs/
    └── project_report.pdf  # Design documentation and architecture diagrams

```

---

## Verification & Test Plan

The system includes a machine-code program test suite (`nano.dat`) loaded during initialization. The testbench verifies processor functional correctness by evaluating memory write-backs and register flag transitions under real structural hazards:

### Validated Test Cases

1. **RAW Data Hazards:** Back-to-back arithmetic instructions requiring multi-stage forwarding (e.g., `ADD` $\rightarrow$ `SUB` $\rightarrow$ `ORR` $\rightarrow$ `AND`).


2. **Flag Dependency Hazards:** Arithmetic flag updating (`SUBS`) followed directly by conditional jumps (`BEQ`, `BGE`, `SUBLT`).


3. **Control Hazards:** Taken branch operations verifying pipeline instruction flushes.


4. **Load-Use Hazards:** Memory load operations immediately referenced by execution instructions (`LDR` followed by `ADD`), forcing stall cycle insertion.


5. **Memory Store Verification:** Memory write validation checking target memory addresses upon simulation termination.



---

## Simulation Instructions

### ModelSim / QuestaSim GUI Execution

1. Open ModelSim/QuestaSim and navigate to your project directory:
```tcl
cd path/to/project

```


2. Create and map the work library:
```tcl
vlib work
vmap work work

```


3. Compile all SystemVerilog modules:
```tcl
vlog rtl/*.sv sim/testbench_final.sv

```


4. Load the simulation:
```tcl
vsim work.testbench_final

```


5. Run the testbench:
```tcl
run -all

```



Upon successful execution, the testbench confirms valid execution via system notes and stops at designated memory write checks.



* Bassma Mohamed (202201697)
