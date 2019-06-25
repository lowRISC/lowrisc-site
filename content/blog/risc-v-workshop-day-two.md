+++
Description = ""
date = "2015-06-30T17:00:45+01:00"
title = "Second RISC-V Workshop: Day Two"

+++

It's the second day of the [second RISC-V 
workshop](https://riscv.org/2015/06/preliminary-agenda-for-the-2nd-risc-v-workshop-is-posted/) today in Berkeley,
California.  I'll be keeping a semi-live blog of talks and announcements 
throughout the day.

## Z-scale. Tiny 32-bit RISC-V Systems: Yunsup Lee

* Z-Scale is a family of tiny cores, similar in spirit to the ARM Cortex-M 
family. It integrates with the AHB-Lite interconnect.
* Contrast to Rocket (in-order cores, 64-bit, 32-bit, dual-issue options), and 
BOOM (a family of out-of-order cores).
* Z-Scale is a 32-bit 3-stage single-issue in-order pipeline executing the 
RV32IM ISA.
* The instruction bus and data base are 32-bit AHB-Lite buses
* There is a plan to publish a microarchitecture specification to make it easy 
for others to implement an equivalent design in the language of their choice.
* The Zscale is slightly larger than the Cortex-M0 due to having 32 vs 16 
registers, 64-bit performance counters, and a fast multiply and divide. The 
plan is to add an option to generate a Zscale implementing RV32E (i.e. only 
having 16 registers).
* Zscale is only 604 loc in Chisel. 274 lines for control, 267 for the 
datapath, and 63 for the top-level. Combine with 983loc borrowed from Rocket.
* A Verilog implementation of Z-scale is being implemented. It's currently 
1215 lines of code.
* The repo is [here](https://github.com/ucb-bar/zscale), but Yunsup needs to 
do a little more work to make it easily buildable. There will be a blog post 
on the RISC-V site soon.
* All future Rocket development will move to the public 
[rocket-chip](https://github.com/ucb-bar/rocket-chip) repo!
* Memory interfaces:
  * TileLink is the Berkeley cache-coherent interconnect
  * NASTI (Berkeley implementation of AXI4)
  * HASTI (implementation of AHB-lite)
  * POCI (implementation of APB)
* The plan is to dump HTIF in Rocket, and add a standard JTAG debug interface.
* Future work for Z-Scale includes a microarchitecture document, improving 
performance, implementing the C extensions, adding an MMU option, and adding 
more devices.

## BOOM. Berkeley Out-of-order-Machine: Chris Celio

* BOOM is a (work in progress) superscalar, out-of-order RISC-V processor 
written in Chisel.
* Chris argues there's been a general lack of effort in academia to build and 
evaluate out-of-order designs. As he points out, much research relies on 
software simulators with no area or power numbers.
* Some of the difficult questions for BOOM are which benchmarks to use, and 
how many cycles you need to run. He points out that mapping to FPGA running at 
50MHz, it would take around a day for the SPEC benchmarks for a cluster of 
FPGAs.
* The fact that rs1, rs2, rs3 and rd are always in the same space in the 
RISC-V ISA allows decode and rename to proceed in parallel.
* BOOM supports the full RV64G standard. It benefits from reusing Rocket as a 
library of components.
* BOOM uses explicit renaming, with a unified register file holding both 
x-regs and f-regs (floating point). A unified issue window holds all 
instructions.
* BOOM is synthesisable and hits 2GHz (30 FO4) in TSMC 45nm.
* BOOM is 9kloc of its own code, and pulls in 11.5kloc from other libraries 
(rocket, uncore, floating poing)
* BOOM compares well to an ARM Cortex-A9 and A15 in terms of CoreMark/MHz. A 
4-wide BOOM gives a similar CoreMark/MHz to the A15.
* Future work will look at new applications, a ROCC interface, new 
microarchitecture designs. The plan is to open source by this winter.

## Fabscalar RISC-V: Rangeen Basu Roy Chowdhury

* A FabScalar RISC-V version should be released in the next few days
* FabScalar generates synthesisable RTL for arbitrary superscalar cores with a 
canonical superscalar template.
* FabScalar uses a library of pipeline stages, providing many different 
designs for each canonical pipeline stage.
* Two chips have been built with FabScalar so far (using PISA).
* The RISC-V port was built on the previous PIA 'Superset Core'. This had 
64-bit instructions and 32-bit address and data.
* For RISC-V FabScalar they have a unified physical register file and unified 
issue queue for floating point (so the FP ALU is treated like just another 
functional unit).
* FabScalar RISC-V will be released as an open source tool complete with 
uncore components and verification infrastructure. It will be available on 
GitHub in the fall.
* The license isn't yet decided, but there's a good chance it will be BSD.

## Aristotle. A Logically Determined (Clockless) RISC-V RV32I: Matthew Kim

* Two logical values are defined. Data and null (not data). Then define 
threshold operators to produce 'null convention logic'.
* See [here](https://users.soe.ucsc.edu/~scott/papers/NCL2.pdf) for more on 
Null Convention Logic
* This results in a system built entirely of combinational logic. I couldn't 
hope to accurately summarise the work here. I'm afraid you might be best off 
waiting for the recording.
* Current executing compiled quicksort at approximately 400mips (without 
serious optimisation).

## RISC-V(erification): Prashanth Mundkur

* Current architectures e.g. those from Intel and ARM have large errata sheets 
published semi-regularly. Can we do better for RISC-V?
* Need an unambiguous formal ISA specification which should be coupled to a 
processor implementation amenable to the two, with a formal link between the 
two.
* Currently specifying RISC-V in the [L3 
DSL](http://www.cl.cam.ac.uk/~acjf3/l3/). The interpreter is used as a 
reference oracle for processor implementations.
* The current state of the spec is [available on 
Github](https://github.com/pmundkur/l3riscv).
* The work has already helped to highlight some areas where clarification is 
needed in the written specification
* Next steps would involve support for the compressed instruction set and 
floating point, booting Linux, and using for tandem-verification (e.g. with 
Flue from Bluespec).
* Hope to export usable HOL4 formal definitions, and use that to prove 
information properties (e.g. non-interference and information flow in 
low-level privileged code).
* The talk is now moving to the second half, where Prashanth is presenting 
Nirav Dave's work
* This work is looking at rapidly verifying architectural and 
micro-architectural variants of RISC-V. Rely on translating between 
microarchitectural-states and ISA-level states.

## Towards General-Purpose Tagged Memory: Wei Song

* Wei Song is presenting his [work on tagged memory support in 
lowRISC](https://www.lowrisc.org/blog/2015/04/lowrisc-tagged-memory-preview-release/).
I'll post the slides shortly.

## Raven3, a 28nm RISC-V Vector Processor with On-Chip DC/DC Convertors: Brian Zimmer

* Support dynamic voltage and frequency scaling on-chip with no off-chip 
components.
* Want to switch all converters simultaneously to avoid charge sharing. The 
clock frequency adapts to track the voltage ripple.
* Raven has a RISC-V scalar core, vector accelerator. 16KB scalar instruction 
cache, 32KB shared data cache, and 8KB instruction cache. This has a 1.19mm^2 
area.
* The converter area is 0.19mm^2
* The chip was wire-bonded on to a daughter-board, which was then connected to 
a larger motherboard connected to a Zedboard
* Converter transitions are less than 20ns, which allows extremely 
fine-grained DVFS.
* Raven3 showed 80% efficiency across a wide voltage range and achieved 
26GFLOPS/W using the on-chip conversion.

## Evaluating RISC-V Cores for PULP. An Open Parallel Ultra-Low-Power Platform : Sven Stucki

* Approximately 40 people working on PULP in some way
* Ultimate (ambitious) goal is one 1GOPS/mW (or 1pJ/op). Also hope to achieve 
energy proportionality.
* Plan is to be open source on GitHub
* PULP has been silicon-proven in 28nm, 65nm, 130nm and 180nm. The team have 
tape-outs planned through to 2016.
* Sven has replaced the OpenRISC frontend with a RISC-V decoder, hoping to 
take advantage of the more active community and compressed instruction set 
support.
* PULP is a simple 4-stage design supporting RV32IC as well as the mul 
instruction from the M extension.
* Synthesising for UMC65, they see 22kilo-gate equivalent per core
* The OR10N core was a new OpenRISC implementation with support for hardware 
loops, pre/postincrement memory access and vector instructions.
* Heading for a GlobalFoundries 28nm tapeout in Q4 2015
* See more on PULP [at the 
website](http://iis-projects.ee.ethz.ch/index.php/PULP).

_Alex Bradbury_
