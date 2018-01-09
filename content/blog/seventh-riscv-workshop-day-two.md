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
* Uses a remote store programming model, which enables efficient 
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
needs for building a full system, spanning RTL, IP cores, hardware emulation, 
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
* Advanced branch prediction. Loads can issue out-of-order with regard to 
other loads and stores.
* Parameterised, just a few lines to instantiate a 2-wide vs 4-wide BOOM.
* BOOM has now been taped out! Taped out with a 2 person team in 4 months.
* Total LoC for the SiFive U54 Rocket is 34kloc, vs 50kloc for BOOMv2, vs 
1.3mloc (Verilog) for the UltraSPARC T2.
* Boomv2 achieves 3.92 CoreMark/MHz (on the taped out BOOM), vs 3.71 for the 
Cortex-A9.
* BOOMv1 had a short pipeline inspired by R10K, 21264, Cortex-A9 and a unified 
issue window.
* BOOMv2: broke critical paths in the frontend. Put the BTB into SRAM. Also 
moved hashing to its own stage.
* The first place+route for register file resulted in huge area. Ended up 
splitting the unified issue window, splitting the physical register file, 
moving issue and register read into separate stages. Then implemented 2-stage 
rename and 3-stage fetch.
* Didn't have the resources to support a customised register file. A 
synthesised register file resulted in huge congestion when routing the wires 
from the flip-flops. Instead, black-boxed the register file and hand-wrote 
some Verilog to instantiate specific flip-flops, muxes, and tri-state buffers.
Effectively hand-crafting their own bit block out of standard cells.
* Saw about a 25% decrease in clock period, and 20% decrease in CoreMark/MHz 
(due to increased load-use delay, fixable in the future). A lot of the work 
was about fixing design rule check and geometry errors.
* Physical design is a bottleneck for agile hardware development. RTL hacking 
can be rapid, but it takes 2-3 hours for synthesis results and 8-24 hours for 
P+R results. Additionally, manual intervention is often required and reports 
are difficult to reason about.
* Future directions for BOOM: further IPC and QoR improvements. Chris is 
joining Esperanto Technologies, but is committed to maintain the BOOM 
open-source repository.

## Rocket Engines. Easy, custom RISC-V cores through reuse: Albert Magyar
* Why are there so many RISC-V cores (or: why not reuse rocket?). Often a 
desire to match interface to be a "drop in" replacement for an existing core, 
or want to tailor microarchitecture for custom extensions. Also, may find 
Rocket is over-featured for the desired design point.
* Less good reasons: not invented here, fear of Chisel.
* There are a number of pitfalls for customized cores. e.g. introducing bugs 
that have long since been avoided in Rocket.
* Avoid reusing either too little or too much. Can reuse individual components 
without using the top-level rocket-chip framework at all. Stitch together 
individual components.
* The "big 3" components: CSR file, decoder, RISC-V compressed (RVC) expander.
* produced a new RISC-V core IP: "BottleRocket". This has a classic 
three-stage pipeline with a similar microarchitecture to Z-Scale and V-Scale.
Implements RV32IMC. The generator produces a single, easy to connect tile.
* Supports debug, test, platform features: 0.13 debug spec, RVFI trace port, 
external interrupt controller.
* The open sourcing effort is underway, as is the integration with 
riscv-formal.

## A Perspective on the Role of Open-Source IP in Government Electronic Systems: Linton Salmon
* The USD Department of Defence (DoD) needs custom SoCs. Custom ICs are 
necessary to reach the target GOps/W. Computation requirements keep growing, 
and real-time results are often required.
* Current DoD architectures often use older technology nodes. Now moving 
towards newer technology nodes (28nm and below).
* Most of the cost for DoD custom SoCs is in design. Typically low volume (1k 
parts). For small volume, find design costs 92%, fab NRE 7%, 1% production 
costs.
* Design cost are skyrocketing, increasingly dramatically with each technology 
node. This is a huge problem for the low volume DoD designs.
* Is open source IP the answer? The good news is that it can sharply reduce 
resources, time and complexity or a DoD custom SoC design. Open source IP 
permits increased use of unique DoD security approaches.
* The not so good news: the open source community needs to develop a complete 
infrastructure, needs to e more robust than it is today, the community needs a 
model to fund infrastructure, and the support model must assure long term 
support and continued development of open source IP.
* Unique differentiation doesn't require development of the entire platform.
Want to put all the effort into the differentiating "secret sauce".
* Open source IP can address both the cost and availability of standard IP.
Open source IP macros are a critical first step, but integration IP is also 
needed.
* Open source IP enables specialisation. It provides the blocks and standard 
infrastructure that can then be specialised.
* Open source IP enables greater scrutiny by the DoD to ensure trust: 
assurance it will only do as specified.
* Hardware security requires the ability to modify the SoC, including 3d party 
IP. Added security capabilities require a robust base and infrastructure.
* RISC-V is an adaptable open standard. RISC-V processors can be built in a 
way that can be trusted, and RISC-V can be used to enable increased security 
(easy to add security extensions).
* Need a full ecosystem infrastructure. Need to cover the entire 
infrastructure, be robust, and easy to use.
* DoD requires robustness and dependability of the open-source infrastructure.
Need complete verification, clear documentation, robustness validated through 
to silicon implementation and test. This is not the role or the strength of 
universities.
  * Savings requires the ability to depend on the open source IP.
  * Savings require the robustness of the IP across extended performance 
  ranges.
* Need a model to fund long-term infrastructure. This isn't the role of DARPA, 
which funds projects rather than infrastructure. Much of the work is 
difficult, but not exciting.
* Need continual maintenance and improvement. Regular updates in terms of 
performance, architecture, and fabrication technology.
* DARPA programs driving open source IP: PERFECT, CRAFT, SSITH, POSH, IDEA.
* CRAFT's goal is to enable more efficient custom IC design/fabrication to 
enable high performance electronic solutions faster and with more flexibility.
* SSITH: develop hardware design tools and IP to provide inherent security 
against hardware vulnerabilities that are exploited through software in DoD 
and commercial electronic systems.
* IDEA: no "human in the lop" 24-hour layout generation for mixed signal ICs, 
systems in package, and PCBs. Machine generated layout of electrical circuits 
and systems.
* POSH: an open source System on Chip design and IP ecosystem.

## Boosting RISC-V ISA with Open Source Peripherals. An SoC for Low Power Sensors: Elkim Roa
* Challenges: ready-to-plug IP and expensive licenses.
* Been working with SiFive, providing IP blocks for the always-on domain.
* The power management unit is a state machine running a microcode program 
that triggers events as necessary.
* Have implemented a wide range of IP: low-noise bandgap voltage reference, 
LDO, biasing control, crystal low-frequency driver (XTAL-RF), RC Oscillator, 
brownout detector, power-on reset, multi-resolution DAC and ADC, fully 
synthesized true random number generator
* Finally, integrated these always-on domain blocks in a TSMC180nm SoC using 
Chisel at the top level.
* Deliverables: releasing Verilog models, FSM Verilog RTL, documentation etc 
through the freechips project. Schematics and layout available through the 
SiFive Designshare program.
* Taping out at the end of the year with SiFive, also want to include PHYs 
like SATA, PCIe, USB next year. Hope to have a qualified range of IP in 2019.

## PicoSoC: How we created a RISC-V based ASIC processor using a full open source foundry-targeted RTL-to-GDS flow, and how you can, too!: Tim Edwards
* Created an ASIC version of a RISC-V core (PicoRV32) using an entirely open 
source toolflow.
* Targeting a 180nm process.
* Open source synthesis toolchain: qflow is built using yosys/ABC, vesta, 
graywolf, qrouter, magic, netgin, iverilog, ngspice.
* PicoSoC includes a UART, SPI memory controller, scratchpad SRAM, and SPI 
flash. Started the SoC targeting the open source Lattice ice40 flow, and add 
padframe, power-on-reset, and generated SRAM to target ASIC.
* Can perform cosimulation using iverilog and ngspice.
* The PicoSoC core is 1mm2, with analog+SRAM+padframe, 2mm x 1.5mm.
* Can reproduce this yourself using the efabless IP catalog and the efablass 
CloudV-based design environment.
* This is brought together in the efabless Open Galaxy Design Environment.

## TileLink. A free and open-source, high-performance scalable cache-coherent fabric designed for RISC-V: Wesley Terpstra
* Requirements for a RISC-V bus: Open standard, easy to implemented, 
cache-coherent block motion, multiple cache layers, reusable on and off-chip, 
and high performance.
* What about AMBA CHI/ACE?
  * "Open standard? CHI is not open!". Can't get hold of the spec.
  * Not easy to implement: 10 probe message types, split control/data, narrow 
  bursts, ...
  * No support for multiple cache layers.
  * Don't want to depend on a standard controlled by a RISC-V competitor
* TileLink was a clean slate project out of UC Berkeley. Featured a reduced 
message protocol, assumed all connected hardware is trusted (do security 
checking at the source, not in the network), and only supports power-of-2 
block transfers.
* TileLink is a master-slave point-to-point protocol. It's message based with 
5 priorities. Out-order design with optional ordering. It's designed for 
composability and deadlock freedom.
* TileLink is open source and in production. Over 30 public modules including 
cores, crossbars and adapters. Has a coherency manager similar to how ACE does 
snooping. Also have bridges to AXI/AHB/APB
* SiFive chips use a banked directory-based wormhole MESI L2$.
* There are a few simplifying assumptions that make the protocol easier to 
work with.
  * Require there are no agent loops, i.e. the bus participants (agents) form 
  a directed acyclic graph.
  * There are strict priorities. Messages have one of five priorities, and 
  lower priority messages never block higher priority messages. Responses have 
  a higher priority than requests.
* The on-chip TileLink wire protocol uses an independent channel for each 
message priority. Messages are transmitted using multi-beat bursts. Use 
ready-valid.

## The RISC-V Vector ISA: Roger Espasa
* Why a vector extension? Reduce instruction bandwidth, reduce memory 
bandwidth, lower energy, exposes DLP, masked execution, gather/scatter.
Scalable from small to large vector processing unit.
* The vector ISA in a nutshell
  * 32 vector registers. Each can hold either a scalar, vector, or a matrix 
  (shape). Each has an associated type (polymorphic encoding). There are a 
  variable number of registers (dynamically changeable).
  * Vector instruction semantics: all instructions are controlled by the 
  Vector Length (VL) register and can be executed under mask. Precise 
  exceptions are supported.
* Suppose you're adding two vector registers: `vadd v1, v2 -> v0`. If the 
vector length is less than maximum vector length, the remaining values must be 
zeroed.
* You could implement this how you like. Might choose to have a 2-lane 
implementation (two FP adders), or 4-lane, or even 8-lane (SIMD, doing all in
one cycle). The number of lanes is transparent to the programmer and the same 
code runs independent of the number of lanes.
* Data inside a VREG could be a single scalar value, a vector, or a matrix 
(optionally). The current shape is held in the per-vreg type field.
  * e.g. `vadd v1, v2.s -> v0`. This adds the scalar value in v2 to every 
  value in vector v1.
* Masks are stored in regular vector registers (i.e. there will not be 
separate mask registers). Masks are computed with compare operations, and 
instructions use 2 bits of encoding to select masked execution.
  * e.g. `vadd v3, v4, v1.t -> v5`.
  * v1 is the only register used as mask source.
* Vector load (unit stride). `vld 80(x3) -> v5` will Vector Length elements.
* Stride vector load. `vlds 80(x3, x9) -> v5` performs a strided load.
* Gather (indexed vector load). `vldx 80(x3, v2) -> v5`. This uses a vector to 
hold offsets. Repeated addresses are legal.
* Vector store: `vst v5 -> 80(x3)`. Note that zeroes won't be written when MVL 
is larger than the vector length.
* Scatter (indexed vector store). `vstx v5 -> 80(x3, v2)`. Will probably have 
two version of scatter, where one has guarantees about the ordering or stores 
to repeated addresses.
* Ordering:
  * From the point of view of a given hart, vector loads and stores happen in 
  order. You don't need any fences to see your own stores.
  * From the point of view of other harts, see the vector memory accesses as 
  if done by a scalar loop. This means they can be seen out-of-order by other 
  harts.
* Typed vector registers:
  * Each vector register has an associated type, which can be different for 
  different registers.
  * Types can be mixed in an instruction under certain rules.
  * Register types enable a "polymorphic" encoding an is also more scalable 
  for the future.
* vcvt is used for type and data conversions.
* In some cases, types can be mixed in an instruction. e.g. adding `v1_i8, 
v2_i64 -> v0_i64`. When any source is smaller than the destination, the source 
is promoted to the destination size.
* The size of the vector register file is not set by the ISA. It is configured 
by writing to the vdcfg CSR. When doing this, the hardware computes the 
maximum vector length. This configuration can be done in user mode.
  * One implementation choice is to always return the same MVL, regardless of 
  config. Alternatively, split storage across logical registers, perhaps 
  losing some space.
* E.g the hardware has 32 registers, 4 elements per vector, each 4 bytes = 512 
bytes. If the user asks for 32 F32 registers, `MVL = 512B / (32 * 4) = 4`. If 
the user asked for only 2 F32 registers, `MVL = 512B / (4+4) = 64`. But it 
would be legal for the implementation to return something smaller, e.g. 4 as 
in the previous example.
* If the user asks for 2 F16 regs and 2 F32 registers, `MVL = 512B / (12B + 
4B) = 32`.
* MVL is transparent to software, meaning code can be portable across 
different number of lanes and different values of MVL.
* Not covered today: exceptions, kernel save + restore, custom types, or 
matrix shapes.
* Goal is to be the best vector ISA ever! Expect LLVM and GCC to support it.
* Current spec on GitHub is out-of-date.

## Security task group update and RISC-V security extension: Richard Newell
* The security working group works in two main areas. Trusted execution / 
isolation and cryptographic extensions. Recently had changes in direction for 
trusted execution / isolation.
* This talk will focus on the cryptographic extensions status. Hope to have a 
written spec for the next workshop.
* Want to rely heavily on the vector extensions for crypto.
* Use vector functional units to perform modular and Galois Field arithmetic 
needed for existing popular and promising post-quantum asymmetric cryptography 
schemes. Also accelerate symmetric block ciphers and digest algorithms taking 
advantage of the wide vector registers, using specialized VFUs (e.g. AES, 
SHA-2).
* Asymmetric crypto acceleration: use hardware support for modular arithmetic, 
but software for group operations and point multiplication.
* Propose vector element widths up to 4096, as well as an escape mechanism to 
allow larger widths or non-power-of-two widths.
* Intend to use just one major opcode for the cryptographic extension.
* Richard presented a handy slide summarising the algorithms used in crypto 
suites / libraries. Be sure to check it out once the slides become available!
* Proposing to define profiles that define the required crypto algorithms.
e.g. a profile for "internet", "finance", and "cellular".

## Using proposed vector and crypto extensions for fast and secure boot: Richard Newell
* Richard is giving a great summary of implementing various crypto algorithms 
using the proposed crypto extensions, but unfortunately it's difficult to 
summarise the information presented in these diagrams.
* Expect a huge speedup vs the ARM Cortex-M3 for an appropriate RV32IVY 
implementation (though very dependent on the hardware that is implemented).
* Performed a case study using WalnutDSA signature verification, developed by 
SecureRF. Saw a 3x speedup with crypto extensions vs without crypto 
extensions.

## Using RISC-V as a security processor for DARPA CHIPS and Commercial IoT: Mark Beal
* This talk is about leveraging RISC-V to deliver integrated hw/sw silicon IP.
* The Intrinsix secure execution environment contains a tiny RISC-V core, 
crypto engines, secure fabric, as well as software.
* Add a security CPU to provide an isolated execution environment. It's easier 
to verify the separation between secure and non-secure actions. Costs less 
than 1% of silicon area (20K gates).
* Implement RV32IC with machine and user modes. 2-stage pipeline with a local 
ROM And RAM. The IRAM can only hold signed code, is fetch-only, and is locked 
after authentication.
* Security RV32 runs signed firmware in user mode, and only executes from 
hardwired ROM in machine mode.
* Suppose you have Zephyr running on Rocket, using TinyCrypt as the crypto 
API. Replace TinyCrypt on Rocket with a call to an API running on the Secure 
RV32.

## ISA Formal Task Group Update: Rishiyur Nikhil
* A formal spec is a key requirement to be able to definitively answer 
questions about compiler correctness and implementation correctness. e.g. will 
executing this RISC-V program on this implementation produce correct results?  
For all RISC-V programs?
* Clifford Wolf has demonstrated the value of formal spaces in identifying 
bugs in most publicly available RISC-V implementations.
* The formal spec must be clear and understandable to the human reader, 
precise and complete, machine readable, executable, and usable with a variety 
of formal tools.
  * English-text specs and instruction set simulators can be regarded as 
  specs, but typically do not meet many of these goals.
* Our approach is to use a very minimal subset of Haskell to define a spec 
that is directly executable in Haskell. Then provide parsers to connect to 
other formal tools and formats.
* See the current prototype 
[here](https://github.com/mit-plv/riscv-semantics).
* Done: RV32I/RV64I, M, priv spec M. Currently ignoring memory model issues.
Soon want to implement privilege spec supervisor mode, then A, C, F, D, 
integration with the memory model.

## Strong formal verification for RISC-V: Adam Chlipala
* Simplify: start by proving a shallow property, proving some straight-forward 
invariants.
* Simplify: analyze isolated components and build larger components by 
composing them.
* Want to avoid starting over for each design. Instead prove a property once 
for all parameters.
* Kami is a framework to support implementing, specifying, formally verifying, 
and compiling hardware designs. It is based on the Bluespec high-level 
hardware design language and the Coq proof assistant.
* The big ideas (from Bluespec):
  * Program modules are objects with mutable private state accessed via 
  methods.
  * Every method call appears to execute atomically. So any step is summarized 
  by a trace of calls.
* Object refinement is inclusion of all possible traces.
* Composing objects hides internal method calls.
* Use standard Coq ASCII syntax for mathematical proofs. These are checked 
automatically, just like type checking. Also benefit from streamlined IDE 
support for Coq.
* Implement a design, which can be refined to check it against the spec (Coq 
tactics are used to prove the refinements). The design is also used to 
generate the RTL.
* We are building a translator for the formal RISC-V ISA spec into the 
language of Coq/Kami.
* Building an open library of formally verified components. Built a 
microcontroller-class RV32I. Working on desktop-class RV64IMA. Also have a 
cache-coherent memory system.
* Reuse our proofs when composing our components with your own formally 
verified accelerators.

## GRVI Phalanz Update: Jan Gray
* The industry is looking to FPGAs to help accelerate cloud workloads.
* Software challenge is how to map you multithreaded C++ app to your 
accelerator. On the hardware side, you want to avoid endless tapeouts as you 
tweak your algorithm.
* GRVI Phalanx Accelerator Kit is a parallel processor overlay for 
software-first accelerators. Recompile your application and run on hundreds of 
RISC-V cores.
* GRVI: FPGA-efficient RISC-V processing element. No CSRs or exceptions, but 
does implement mul and lr/sc.
  * 3-stage pipeline with some resources shared by a pair of cores. Fits in 
  320 LUTs.
  * Take 8 of these and connect to form a cluster (8PEs, shared RAM). Takes 
  approximately 3500 LUTs.
* Compose cores using message passing on the FPGA-optimised Hoplite NoC.
* Use a partitioned global address space (PGAS).
* Phalanx: fabric of clusters of PEs, memories, IOs
* FPGAs used in the AWS F1 are huge, over 1.3M LUTs. Last December, fit 1680 
RISC-V cores on that FPGA. 250MHz, 420GIPS, 2.5TB/s cluster memory bandwidth, 
...
* Working on a GRVI Phalanx SDK. Bridge the Phalanx and AX4 system interfaces 
with message passing bridges.
* 8-80 cores on the Pynq.
* Can fit 884 cores on the FPGA on the F1 with 3 DDR controllers, 1240 with 1 
DDR controller.
* Currently program using bare metal multithreaded C++ and message. Working on 
an OpenCL-based solution. Use the new 'SDAccell for RTL'.
* SDK coming, allowing 8-80-800-10000 core designs. All enabled by the 
excellent RISC-V ecosystem.

## A tightly-coupled light-weight neural network processing unit with RISC-V Core: Lei Zhang
* Neural networks can be used to replace computation-intensive but 
error-resilient code.
* Connected a tightly-coupled neural accelerator to a Rocket core through the 
RoCC interface.
* Extended the instruction set. Added NPE instructions for neural accelerator 
initialisation and invocation. Also DMA instructions for data initialization 
in a buffer. Finally, AGU instructions for data streaming from buffer to 
processing elements.
* The Neural Accelerator is a one-dimensional systolic array.

## Lacore: A RISC-V based linear algebra accelerator for SoC designs: Samuel Steffi
* Linear algebra is a foundation of high performance computing.
* Most HPC apps can be reduced to a handful of computation classes: 
sparse/dense linear algebra, FFT, structured/unstructured grids. These all 
have overlap with linear algebra.
* LACore targets a wide range of applications and tries to overcome hardware 
issues of other approaches (GPU, fixed-function accelerators).
* Five main pieces in the LACore additions to the scalar SCPU
  * LAExecUnit: mixed-precision systolic datapath connected to LAMemUnits with 
  FIFOs. 3 inputs and 1 output, dual precision (32 and 64-bit). Datapath 
  consists of a vector unit and a reduction unit.
  * LAMemUnits: read and write data-streams to the datapath FIFOs and 
  LACache/Scratchpad. Can read or write scalars, vectors, matrices, and sparse 
  matrices.
  * LAcfg provides configuration to LAMemUnits. These registers hold all info 
  about data-stream type, precision, location etc.
  * 64kb scratchpad (3r1w).
  * 64kb LACache with 4 ports (3r1w) and 16 banks
* Adding 68 new instructions, broadly split into 3 classes: configuration, 
data movement, and execution.
* The LACoreAPI allows the accelerator to be programmed.
* Started by implementing in gem5. This was ~25kloc of C++ and Python.
* Implemented the HPC Challenge (HPCC) benchmark suite. Compared versus a 
in-order RISC-V core, superscalar x86 core with SSE2, and equivalent Fermi GPU 
with 2 streaming multiprocessors. LACore saw a speedup of 3.43x over x86, 
10.72x vs baseline RISC-V, and 12.04 vs the GPU baseline.
* Estimated area is only 2.53x the area of a single RISC-V scalar CPU and 
0.60x the area of the equivalent GPU.
* Freely available [here](https://github.com/scale-lab/la-core).
* Currently working a LACore multi-core design and evaluation, as well as an 
ASIC implementation and eventual tapeout.

## Packet manipulation processor. A RISC-v VLIW core for networking applications: Salvatore Pontarelli
* Network "softwareization" is seen as the optimal solution to design next 
generation network infrastructures, services, and applications.
* Want high speed: 100-200Gbps (as achievable with FPGAs and network 
processors) and beyond, 5Tbps as achievable with programmable forwarding 
dataplanes.
* Propose an architecture where programmable forwarding dataplanes are 
augmented with a PMP (packet manipulation processor)
* Design a small, efficient CPU for packet manipulation. Deploy the PMP at the 
output port. Want to process packets at 10/40Gbps.
* Possible programmable actions: inband packet reply, custom tunneling, 
NAT/PNAT.
* The PMP has a small instruction memory (typically need less than 8K 
instructions). Small data memory (8KB). Flat memory, no cache hierarchy.
* PMP throughput: 10Gbps is 14.88Mpps, 67 clock cycles at 1GHz. A multi-core 
CPU is one approach, but has challenges regarding the reordering of packets.
Pursue a VLIW solution instead.
* The PMP is a static 8-issue VLIW RISC-V core with the RV32I instruction set.
Has a 32-bit dataplane (to be upgraded). Written in VHDL. Features branch 
prediction, lane forwarding.
* Implemented in a NetFPGA based programmable dataplane.
* Synthesized at 250MHz on FPGA.

## Adding a Binarized CNN Accelerator to RISC-V for Person Detection: Guy Lemieux
* This talk uses VectorBlox Vector instructions, which are not the same as the 
vector instructions proposed in the RISC-V vector working group.
* Prototyped in the Lattice iCE40 UltraPlus FPGA (5280 LUTs, 1Mb SRAM).
* Inspired by BinaryConnect. Built a custom database, performed other 
optimisations, and managed 98% accuracy.
* Use Orca (open source, BSD licensed). Written in VHDL, 200MHz fully 
pipelined, less than 2000 4LUTs.
* Added streaming vector extensions and binary CNN accelerator.
* The streaming vector instructions (SVE) operate only on stream memory. Add 
streaming version of all the base RV32 integer operations, multiply 
instructions. Add in some extra instructions such as mov, conditional move, 
comparisons, and vector control instructions. Packed SIMD can be supported 
naturally with this approach to vectors.
* Would also like to add an extra SVE extension for DMA.
* SVE has a base 32-bit encoding, as well an extended 64-bit encoding.
* Can redirect the data to a domain-specific streaming pipeline.
* 4852 4-input LUTs for the whole solution.
* Releasing the VectorBlox instruction set as an open specification, and 
joining the RISC-V vector working group to discuss it as a potential 
alternative.
* SVE vs the RISC-V vector extension
  * A "memory-to-memory" architecture, challenging the conventional wisdom of 
  RISC.
  * No named vector registers in the ISA (no register allocation, no compiler 
  changes needed)
  * High performance. Free loop unrolling, no saving/restoring of vector data.
  * No storage wasted with streaming memory. Free software scratchpad if 
  vectors aren't used.
  * Easier/simpler hardware. Double-buffered DMA instead of prefetching + 
  vector register renaming.

## RISC5. Improving support for RISC-V in gem5: Alex Roelke
* gem5 is a popular cycle approximate simulator, which can be very useful in 
RISC-V hardware development.
* RISC-V in gem5 supports RV64GC. It uses syscall emulation and doesn't yet 
support the privileged ISA.
* Implemented the release consistency memory model for atomics.
* Floating point support was verified against spike and a hardware design.
* The main challenge when implementing the compressed instruction was 
interfacing with gem5's existing decode logic.
* In the future, want to support multithreaded workloads in syscall emulation 
mode, enable full system mode (privileged ISA), and correct minor differences 
(e.g. floating point rounding).

## Renode. A flexible open-source simulation for RISC-V system development: Michael Gielda
* AntMicro was founded in 2009 and has been developing Renode since 2010.
* Why did we build Renode? Observed data workflows for embedded development.
Needed a fast simulator for software developers, as close to production as 
possible. Must support multi-node simulation, easy reuse of models, and be 
extensible.
* It is an instruction set simulator, mostly written in C#. It supports fully 
deterministic execution, transparent debugging, integration with familiar 
tools (e.g. GDB).
* Renode is open source, has a flexible structure and is constructed out of 
modular building blocks.
* The platform description format is human readable, modular, and extendible.
* Worked with Microsemi to support the Mi-V platform, integrate with 
SoftConsole IDE, and support Windows as a first-class platform.
* Renode supports a range of handy features, such as fault injection, 
record/replay, and more.

## QEMU-based hardware modelling of a multi-hard RISC-V SoC: Daire McNamara
* Wanted to explore have separate execution contexts on the same SoC that are 
free from interference (e.g. one core running an RTOS, while others run a 
general purpose OS).
* In the SiFive Unleashed platform, the E51 provides services for other U54 
harts.
* E51 services/peripheral drivers are implemented as event-driven state 
machines. These are describes via a structure and states are named.
* Needed an emulator to model all of this.
* Modified RISC-V QEMU:
  * Updated privileged spec support.
  * Hart synchronisation (IPIs)
  * Modelling physical memory protection
  * PLIC, CLINT, local interrupts
  * Support for managing contexts of multiple harts
  * Modelling L1/L2 cache configuration register writes/reads
  * ...
* U54-MC QEMU hasn't yer been upstreamed to the main RISC-V QEMU github repo 
yet.
* Can boot Linux to console and interact, but it's a little slow (takes about 
15 minutes).
* Future plans: improve speed, add vectorisation for local interrupts, device 
tree support, QOM, remote control of real hardware. Finally, clean up and 
upstream.

## FireSim. Cycle-Accurate Rack-Scale System Simulation using FPGAs in the Public Cloud: Sagar Karandikar
* Why simulate datacenters? Next-gen datacenters won't be built only from 
commodity components, and custom hardware is changing faster than ever.
* Our simulator needs to model hardware at scale (CPUs down to 
microarchitecture, fast networks and switches, novel accelerators), run real 
software, and be usable.
* One way to test would be to build the hardware, get the chips back, then 
network together into a datacenter. This has obvious disadvantages.
* Alternatively, use a software simulator. Easy to prototype new hardware this 
way, but also easy to model something that you can't build. Additionally, it 
can be very slow to run, requiring the use of small microbenchmarks or 
sampling.
* Or, build a hardware-accelerated simulator (see DIABLO). You need to 
hand-write RTL models, which in many ways is harder than "tapeout-ready" RTL.
* How do we improve? Harness useful hardware trends such as the open RISC-V 
SoC, open silicon designs, high productivity hardware design languages 
(Chisel), FPGAs in the cloud.
* FireSim target design: server blades, each with quad-core RISC-V Rocket at 
3.2GHz, 16KiB I+D cache, 256KiB L2, 16Gb DRAM, 200Gbps Ethernet NIC, optional 
accelerators. The network has parameterisable bandwidth/link latency and a 
configurable topology.
* Transform the RTL to simulate on the FPGA. For the network simulation, use 
CPUs and the host network (one thread per port).
* FAME-1 transforming RTL: given RTL, want to automatically transform it into 
decoupled cycle-accurate simulator RTL that we can run on the FPGA.
* Can pack four quad-core server simulations per FPGA, meaning 32 server 
simulations per f1.16xlarge (128 simulated cores). Use a 32-port 200Gbps 
per-port top of rack switch model. The simulation runs at 5MHz (~400 million 
instructions/second). $13.20/hr on-demand, ~$2.60/hr on the spot market.
* Can scale to simulating a 1024 node RISC-V datacenter. Ran across 32 
f1.16xlarge instances. In aggregate, runs at 3.4MHz (13 billions insts/s 
across the simulated datacenter).
* Can also achieve "functional" network simulation. e.g. allowing all of 
SPECInt06-ref to run on Rocket Chip at 150MHz (completing in less than one 
day).

_Alex Bradbury_
