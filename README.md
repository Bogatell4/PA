# PD_LAB
Main goal of this repo is to develop an implementation in hardware of the Crystal-kyber algorithm.  
Will be inserted in the execution stage of a RISC-V core when fully developed.


## PA_core
This project also contains the verilog files of a custom core developed in the PA subject with test benches able to test single stages of the pipeline and the full pipeline itself.
Try to implement each feature on a separate branch :)

It is a 5 stage pipeline:

1.-FETCH
Tasked with the PC counter and retrieving the instructions from the i-registers

2.-DECODE
Tasked with the decoding of said instruction and retrieving the values from the data registers and giving the values to he ALU

3.-EXECUTION
Takes the opcode, r1, r2 and performs said operation passing the result

4.-MEMORY
stores the result in rd or performs a load/store operation

5.-WRITEBACK
Tasked with writing if needed data back to the data registers of stage 2


OPTIONAL CORE FEATURES:
Will be developed on a separate branch  
-full set of bypasses  
-instruction cache and data cache  
-virtual memory and tlb's   