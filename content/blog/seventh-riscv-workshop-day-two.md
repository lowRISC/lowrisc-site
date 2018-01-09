+++
Description = ""
date = "2017-11-29T15:16:45+00:00"
title = "Seventh RISC-V Workshop: Day Two"

+++
The [seventh RISC-V 
workshop](https://riscv.org/2017/10/7th-risc-v-workshop-agenda/) is concluding 
today at Western Digital in Milpitas. I'll be keeping a semi-live blog of 
talks and announcements throughout the day.

## Celerity: An Open Source 511-core RISC-V Tiered Accelerator Fabric: Michael Taylor
* Built in only 9 months.
* Celerity is an accelerator-centric SoC with a tiered accelertor fabric.
* Implemented in TSMC 16nm FFC. 25mm2 die area, 385M transistors
* Why 511 RISC-V cores? 5 Linux-capable RV64G Rocket cores, 496-core RV32IM 
mesh tiled area "manycore", 10-core RV32IM mesh tiled array (low voltage).
* Used a flip-chip package.
* Of the 5 general purpose cores, 4 connect to the manycore array and 1 
interfaces with the Binary Neural Network accelerator. Each core executes 
independently within its own address space.
* The BaseJump manycore architecture implements the RV32IM with a 5-stage 
pipeline (full forwarded, in-order, single issue). It has 4KB+4KB instruction 
and data scratchpads.
* BaseJump Manycore Mesh Network: stores are routed based on the destination.
Simple XY-dimension routing.
* Each Rocket core has its own RoCC interface connecting to one of the routers 
in the mesh.
* Uses a remote store programming model, which enables efficent 
producer-consumer programming models. Offer extended instructions such as load 
reserved (load value and set the reservation address), 
load-on-broken-reservation (stall if the reserved address wasn't written by 
other cores), and a consumer instruction to wait on a given address/valud. No 
polling or interrupts are required.
* Currently working on CUDA support.
* Can fit 42 of the "manycore" cores per mm2 (vs 5 cores per mm2 for Rocket).
* 80% of the modules in the manycore are from the BaseJump library.
* For the backend, hardened each core and replicated across the die.
* Over 2/3rds of each manycore tile is memory.
* For the BNN: each core in the manycore tier executes a remote-load-store 
program to orchestrate sending weights to the specialization tier via a 
hardware FIFO.
* All code available at [opencelerity.org](http://opencelerity.org).
* Want to build the "DNA" for open source ASICs. i.e. the basic components 
needs for building a full system, spanneing RTL, IP cores, hardware emulation, 
packaging, PCBs. See [bjump.org](http://bjump.org).
* The BaseJump STL contains several hundred modules, all parameterised.

## The PULP Cores. A Set of Open-Source Ultra-Low-Power RISC-V Cores for Internet-of-Things Applications: Pasquale Davide Schiavone
* PULP: Parallel Ultra-Low Power.
* Designed for energy efficient hardware, e.g. near-sensor computation.
* Have a set of 3 32-bit cores currently available, and working on a 64-bit 
Linux-capable core.
* RISCY core has a 4-stage pipeline. RV32IM[F]C. 40.7-69.3kGE. 3.19 
CoreMark/MHz. Also has a number of extensions for packed SIMD, fixed point, 
bit manipulation and hardware loops.
* Zero-riscy has a 2-stage pipeline. RV32{I,E}[M]C. 11.6-18.9kGE. 2.44 
CoreMark/MHz for RV32IMC and 0.91 for RV32EC. Optimized for area.
* Arian core for Linux. 6-stage pipeline, RV64IMC, 185kGE, OoE execution and 
in-order commit. 2.01 CoreMark/MHz.
* Also have a set of software tools for PULP. Virtual platform, timing model.
Have 1MIPS simulation speed with timing accuracy between 20-20% of the target 
hardware. Can also profile using kcachegrind.
* How to verify these cores? Use constrained pseudo-random test generation in 
a perturbated environment (random interrupts, stalls). The program generator 
tries to maximise the code coverage, and the instruction simulation and RTL 
model are compared.
* Large number of companies using PULP/PULPino, e.g. Mentor, GreenWaves, NXP, 
Micron, Microsemi, Cadence, ST, Google, Intel.
* PULPissimo platform will be released Q12018, including the new microDMA 
subsystem, new interrupt controller, new SDK etc. Taping out on GF22 soon.

## BOOM v2. An open-source out-of-order RISC-V core: Chris Celio
* Out of order superscalar implementing RV64g. Open source and written in 
Chisel (~16kloc). Built on top of the rocket-chip ecosystem.

_Alex Bradbury_
