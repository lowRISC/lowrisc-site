+++
Description = ""
date = "2016-07-14T16:08:07+01:00"
title = "Notes from the fourth RISC-V workshop"

+++
Many of the lowRISC team (Robert Mullins, Wei Song, and Alex Bradbury) have 
been in Boston this week for the fourth RISC-V workshop. By any measure, this 
has been a massive success with over 250 attendees representing 63 companies 
and 42 Universities. Wei presented our most recent work on integrating trace 
debug, which you'll soon be able to read much more about here (it's worth 
signing up to our [announcement list]({{< ref "about.md" >}}) if you want to 
be informed of each of our releases).

## RISC-V Foundation update: Rick O'Connor
* Next RISC-V Workshop will be Nov 29th-30th at Google's Mountain View, CA
* The RISC-V ISA and related standards shall remain open and license-free to 
all parties, and the member agreement with RISC-V Foundation will include a 
license for the trademark
* Trademark license for commercial use is part of being a silver, gold, or 
platinum member
* Founding member status has now finished.
* You don't have to be a member to participate in specifications - each task 
group must include at least one round of public consultation.
* Question: any plans for workshops outside of the USA? Answer: yes, we would 
like to do that

## RISC-V interrupts: Krste Asanović
* Want a standard that is useful in high performance Unix-like systems (fast 
cores, smart devices), low/mid embedded systems (slow cores, dumb devices),
and high-performance realtime systems (can't waste time on interrupt overhead)
* Design goals: simplicity, support all kinds of platforms, allow tradeoffs 
between performance and implementation cost, be flexible to support 
specialised needs
* Interrupts are either local or global.
  * Local interrupts are directly connected to one hardware thread (hart) with 
  no arbitration. On RISC-V, there is currently only two of these: software 
  and timer.
  * For global (external) interrupts, they are routed via the memory-mapped 
  Platform-Level Interrupt Controller (PLIC)
* A new CSR, the Machine Interrupt Pending (mip) register is added. It has 
separate interrupts for each supported privilege level.
* User-level interrupt handling is an optional feature. This may be used in 
secure embedded systems.
* Software interrupts
  * MSIP (machine software interrupt) can only be written in machine mode via 
  a memory-mapped control register. This is used for inter-hart interrupts.
  Also have HSIP, SSIP, USIP. A hart can only write its own HSIP, SSIP, USIP.
  * The App/OS/Hypervisor can only perform inter-hart interrupts via 
  ABI/SBI/HBI calls
* Timer interrupts: MTIP is a single 64-bit real-time hardware timer and 
comparator in M-mode. You want this because due to frequency scaling etc, just 
going by cycle count is not useful. HTIP, STIP, UTIP are set up by M-mode 
software.
* When running at a given privilege level, all interrupts for lower levels are 
disabled.
* All interrupts trap to M-mode by default, and M-mode software can redirect 
to the other privilege level as necessary. mideleg can be used to 
automatically delegate interrupts to the next privilege level.
* Conceptually, when interrupts come in to the PLIC they are handled by the 
gateway. This abstracts away differences between different interrupt sources.
e.g. level-triggered, edge-triggered etc. A new request isn't forwarded to the 
PLIC core unless the previous request's handler has signaled completion.
* Each interrupt has an ID and priority. These priorities can be fixed or 
variable. The PLIC stores per-target information
* An interrupted hart will try to claim an interrupt from the PLIC with a read 
of the memory-mapped register. It could have been claimed by someone else, and 
the PLIC core is responsible for ensuring the interrupts it received by only 
one hart.
* If you want to add more levels of nested interrupt handling, add more harts 
to your system.
* The position of the PLIC in the memory map isn't defined by the 
specification because many people will have existing memory maps.
* Question: would you have multiple PLICs on a multi-core system? Answer: 
conceptually, there is only one PLIC though it could be implemented in a 
distributed fashion.

## Formal specification of RISC-V uniprocessor consistency: Arvind
* Joint project with Adam Chlipala. The slogan is "chips with proofs". These 
are multicore chips that satisfy the RISC-V ISA specifications and are capable 
of booting Linux.
* Both the design and the proofs must be modular and amenable to modular 
refinement.
* Mostly concerned about microarchitecture and memory system correctness.
* Specs and designs are expressed in Bluespec.
* See also [Kami](http://plv.csail.mit.edu/kami/), a framework for Coq for 
performing proofs about Bluespec programs.
* A specification should avoid using concepts such as partially executed 
instructions or "a store was been performed with respect to...".
Non-determinism is necessary, but unspecified behaviour should be avoided.
* Semantics are defined in terms of 'I2E', the Instantaneous Instruction 
Execution framework. Simply, an instruction executes instantaneously ensuring 
the processor state is always up to date. Data moves between processors and 
memory asynchronously according to some background rules. Memory 
model-specific buffers are placed between the processor state and memory.
* WMM is a possible memory model for RISC-V, where both loads and stores can 
be re-ordered. Conceptually, invalidation buffers are added alongside the 
store buffer in order to make stale values visible. Whenever a stale value is 
removed from the invalidation buffer, any values that are older (more stale) 
must also be removed.
* Memory issues arise even within a uniprocessor, due to self-modifying code 
and page table access and the TLB. The fundamental issue is with multiple 
paths to the same memory.
* Arvind is concerned that when defining formal semantics, a very weak memory 
model may become very (too?) complex.

## Heterogeneous Multicore RISC-V Processors in FD-SOI Silicon: Thomas Peyret
* Want to build a large ecosystem around FD-SOI in Europe, including IP and 
chipset libraries.
* PULSAR is a RISC-V big.LITTLE-style heterogeneous multicore. Two small cores 
(rocket without FPU, 8KB L1 caches) and two big cores (3-way super-scalar BOOM 
and 32KB L1 caches). It features an AMBA interconnect generated by Synopsys 
CoreAssembler and has multiple body-bias zones.
* Currently looking to use it in the context of a pedestrian navigation 
system.
* 128-bit link to DDR5 controller, plus 4+4GTX SERDES to a separate FPGA.
* Also features the AntX processor, which is a very small 32-bit RISC Harvard 
design from CEA Tech.
* Used hardware emulation with ZeBu (Synopsys)
* Also used SESAM for virtual prototyping (based on SystemC/TLM 2.0). This is 
up to 90% accurate compared to RTL. Have also developed SCale, a new parallel 
SystemC kernel.
* Synthesis results show 2.64mm2, 0.6W, 700MHz.
* Question: will the work be open-sourced? Answer: Don't know yet.

## NVidia RISC-V evaluation story: Joe Xie
* Want to reproduce the existing NVIDIA falcon CPU with a new ISA
* Falcon - FAst Logic CONtroller. Introduced over 10 years ago and used in 
more than 15 different hardware engines today. Low area, secure, flexible. 6 
stage pipeline, variable length instructions (proprietary NVIDIA ISA).
* The next generation for Falcon is needed for higher performance and rich OS 
support. Old Falcon is 0.67 DMIPS/MHz, 1.4 Coremark/Mhz
* Options were to buy access to a current architecture (MIPS, ARM, others) or 
build (move to RISC-V or improve Falcon). Obviously, they elected to move to 
RISC-V. The fact the ISA is extensible is a key advantage. Want an area of 
less than 0.1mm2 at 16FF.
* NV-RISCV is 5 stage in-order issue, out-of-order execution. It has a 
in-order write buffer. No FPU. Makes use of an MPU with base and bound 
protection. It will initially be added to the Falcon as a 2nd core to provide 
easy backwards compatibility.
* Area for 16FF: Falcon 0.03mm2 vs Rocket 0.055mm2 vs NV-RISC-V 0.05-0.06mm2.
* Did a lot of cache optimisations to tolerate large latency. Store buffer, 
write merging, line-fill buffer, victim buffer, stream buffer.
* Areas of interest include toolchain (for automotive, debug, performance 
tuning, flexibility, ilp32/ilp64). Also security (crypto instructions and 
extensions), and adding cache manipulation instructions.
* Question: why design your own core rather than use an existing one? Answer: 
after evaluating the options, it made the most sense. The motivation to go to 
RISC-V was technical as well as influenced by cost.

## ISA Shootout – a Comparison of RISC-V, ARM, and x86: Chris Celio
* Recently released a new tech report [The renewed case for the Reduced 
Instruction Set Computer](http://arxiv.org/abs/1607.02318).
* The conventional wisdom is that CISC ISAs are more expressive and dense than 
RISC ISAs, while RISC ISAs map well to high-performance pipelines. Of course, 
a number of designs have CISC instructions translating to RISC-like micro-ops.
* Chris' contention is that a well designed RISC ISA can be very competitive 
with CISC ISAs. It can be denser and higher performance.
* `ldmiaeq sp!, {r4-r7, PC}` is an ARMv7 instruction (load 
multiple-increment-address) which will write to 7 registers and perform 6 
loads. This is a common idiom for stack pop and return from a function call.
* Goal is to get a baseline to measure the current code generation quality of 
the RISC-V gcc port. Given a fixed ISA, what can the compiler do to improve 
performance? What can the programmer do? What can the micro-architect do? A 
specific non-goal is to lobby for more instructions (CISC or otherwise).
* Dynamic instruction count can be very misleading due to the possibility it 
decodes to many micro-ops. Conversely, macro-op fusion may take multiple 
instructions and fuse them on the fly.
* Looking at 6 ISAs, using 12 benchmarks from SpecINT 2006.
* Average 16% more instructions for RISC-V vs x86-64, though roughly even in 
terms of micro-ops. With the compressed instruction set extension, RISC-V wins 
in terms of instruction bytes fetched on many of the benchmarks. Overall, 28% 
fewer instruction bytes than ARMv7 and 8% fewer than x86-64.
* Adding array indices is the most common idiom, so why not add an indexed 
load instruction to match x86? But with the compressed ISA, a pair of 
compressed instructions can be treated as an indexed load by the decoder.
* Proposed macro-op fusion pairs: load effective address, indexed load, clear 
upper word. These idioms provide 5.4% fewer "effective" instructions for RV64.
* Fusion isn't just for superscalar out-of-order cores. Chris believes it 
should be used by all RISC-V cores. For instance, Rocket (single issue) can be 
modified to perform this.
* Better code generation is possible if the compiler knows fusion is 
available.
* RISC can be denser, faster, and stay simple!
* Question: will compressed become standard? Answer: it may become part of the 
de-facto standard or even Linux ABI standard. Still more to be done to fully 
understand the complexity for processor implementations.
* Question: how does macro-op fusion interact with things like faults and 
precise exceptions? Answer: it does add extra complexity. One solution is if 
you get a fault, then re-fetch and execute without fusion.

## Trace debugging in lowRISC: Wei Song
* Watch this blog for much more on our trace debug work very soon.

## RISC-V I/O Scale Out Architecture for Distributed Data Analytics: Mohammad Akhter
* For analytics, need a deep net with many nodes. This demands balanced 
low-latency computing I/O, memory, and storage processing.
* Wireless network evolution is driven by real-time data with better QoS. Very 
rapid growth rate in bandwidth and reduction in round-trip time latency for 
LTE, LTE-A, 5G, ...
* Built a deep learning micro-cluster. Uses RapidIO, NVidia GPUs. No RISC-V 
though. They've then looked at how this might look with RISC-V cores instead.
* Want to support AXI rand RapidIO.
* Produced a hardware simulation model with TileLink packet generators 
producing data that is transferred over a RapidIO transport.
* A RISC-V CPU generator model with port for RapidIO available (where?)

## Coherent storage. The brave new world of non-volatile main memory: Dejan Vucinić
* There are two emerging resistive non-volatile memories. ReRAM and PCM. Read 
latency is orders of magnitude lower than NAND, somewhere between that of DRAM 
and NAND.
* Should non-volatile memories be treated like memory, or like storage?
* For now, it seems to make sense to have the digital logic for the NVM 
controller off-chip (including coherence state).
* Wear levelling, data protection at rest further motivate the controller 
being placed along with non-volatile media.
* One potential approach is a coherent storage controller in reconfigurable 
logic.
* RISC-V shopping list: Hardware coherence, fast+wide ports for peripherals to 
join the coherence domain, relinquish the non-volatile memory controller for 
now, and get used to high variability in main memory response time.

## RISC-V as a basis for ASIP design: Drake Smith
* "Every design is different, so why is every embedded processor the same?"
* Using RISC-V as a basis for ASIP can avoid many concerns. SecureRF produces 
quantum-resistant security for low resource devices using group theoretic 
cryptography.
* Using the Microsemi Smartfusion2+ board as the test platform.
* With a software-only port, their WalnutDSA was 63x faster than Micro-ECC.
* Adding a custom instruction to accelerate it only added 2% area on the FPGA 
and gave another 3x increase in speed.

## An updated on building the RISC-V software ecosystem: Arun Thomas
* 2016 wishlist: Upstream GNU toolchain, Clang//LLVM and QEMU. Also Linux 
kernel, Yocto, Gentoo, and BSD. Plus Debian/RISC-V port.
* Now people are getting ready to send patches for review for toolchains and 
QEMU.
* FreeBSD 11 will officially support RISC-V. For the Debian/RISC-V port, see 
Manuel's talk tomorrow.
* Arun argues the Foundation should fund developers to build core software 
infrastructure. Additionally, we should also decide on a process for proposing 
ISA enhancements.
* What might funded developers do? Upstreaming and maintainership, porting 
software, performance optimisation/analysis, enhancing test suites and 
methodologies, continuous integration and release management.
* How should proposals be be handled? Various groups have approaches for this 
already. e.g. Rust, Python, IEEE, IETF. Arun has put together a [straw-man 
proposal on specification 
development](https://github.com/arunthomas/riscv-rfcs).
* Arun would like to see the next iteration for the privileged spec to go 
through a comment period.

## ORCA-LVE, embedded RISC-V with lightweight vector extensions: Guy Lemieux
* Using 900LUTs for a speedup of 12x. Proposed and added a standardised vector 
engine to their processor.
* Smallest version of the ORCA implementation can fit in 2k LUTS on the 
Lattice iCE40 and runs at about 20MHz.
* Their approach for lightweight vector extensions is to add a dedicated 
vector data scratchpad and to re-use the RISC-V ALU.
* Vector operands are just RISC-V scalar registers containing pointers into 
the vector scratchpad.
* To encode vector operations, they use two 32-bit instruction bundles.
* To allocate vector data, just use an alternative malloc function. Intrinsics 
are available to manipulate vectors.
* In the future, want to add 2D and 3D operations as well as subword SIMD.
* Why not using the proposed RISC-V vector extensions? Because the detailed 
proposal isn't yet released, and LVE intends to be more lightweight and lower 
overhead.
* Question: can these instructions raise exceptions? Answer: that hasn't been 
properly defined yet.

## FPGArduino. A cross-platform RISC-V IDE for the masses: Marko Zec
* The main attraction of the Arduino IDE is simplicity and quick results
* Provide pre-compiled toolchains for OSX, Windows, and Linux. For C 
libraries, took mainly from FreeBSD.
* boards.txt defines IDE menu entries and options. Also support pre-build FPGA 
bitstreams and support for upload from IDE.
* Have produced f32c, a retargetable scalar RISC-V core written (mostly) in 
VHDL.

## SiFive's RISC-V computer: Jack Kang
* SiFive is a fabless semiconductor company building customisable SoCs
* They produce a free and open platform spec for their platforms
* This week announced "Freedom Unleashed" (Linux application cores, high speed 
peripherals), and "Freedom Everywhere" (targeted at embedded and IoT).
* The Freedom Unleashed demo will be shown today, running on an FPGA connected 
to PCIe.
* Question: why 180nm for the Freedom Everywhere, isn't it rather old now?
Answer: it is low cost and fast time to market so will make sense for some.
* Question: will peripherals etc be open sourced? Answer: things we do 
ourselves e.g. SPI will be.

## MIT's RISCy expedition: Andy Wright
* Build proofs from small components, build them up to complete, real 
processors.
* They are now releasing their work, the Riscy processor library, Riscy BSV 
utility library, and reference processor implementations. Currently 
multi-cycle and in-order pipelined. Soon, out-of-order execution.
* Have infrastructure for tandem verification.
* How is modular design possible? RTL modules are not modularly refinable 
under composition, i.e. implementation details of one module may put 
additional constraints on another. But BSV language features do support 
composability.
* The processor design flow involves taking the Riscy blocks, forming the 
initial connections, performing modular refinement, and then scheduling 
optimisation to reduce overheads due to BSV scheduling logic.
* Connectal implements the connections from FPGA to a host computer through 
PCIe. This also works on Zynq FPGAs with an AXI transport.
* Tandem verification: run the same program on two RISC-V implementations at 
once. Generated verification packets at commit stage, use non-deterministic 
information from the implementation under test for synchronisation, and then 
compare the results.
* Check out the code [on Github](https://github.com/csail-csg/riscy).
* Planned work involves formal specifications, proofs for modules, and proof 
for processors.

## A software-programmable FPGA IoT platform: Andrew Canis
* Lattice's vision for an FPGA IoT platform is that it has high ease of use 
(use C/C++ as design entry), and flexibility for a range of sensors, 
actuators, communication devices.
* A hybrid computing solution: the RISC-V processor with FPGA hardware. RISC-V 
processor plus LegUp-generated hardware acclerators to handle the processing 
part of the IoT platform.
* The Lattice RISC-V processor has a 4 stage pipeline, and can be configured 
for RV32I, RV32IM, and RV32IC. It compares favourably to the LM32, e.g. RV32IC 
takes 1.6K LUTs vs 2K LUTs for the LM32 while also achieving higher DMIPS and 
code density.
* LegUp is a high level synthesis tool.
* For a sum of squares of speech samples example, the LegUp synthesized 
accelerator gives a 5.4x speedup vs the RISC-V software implementation.
* LegUp has plans to support LegUp-synthesized custom instruction 
implementations

## Apache mynewt: James Pace
* [Mynewt](http://mynewt.apache.org) is an open source OS for constrained IOT.
Supports ARM, AVR, Mips (and now RISC-V?).
* Apache Mynewt is "Linux" for devices that cannot run Linux.
* It is a community effort, run through the Apache Software Foundation.
Currently ~280k lines of code.
* Plans for Bluetooth 5 support in the future, deployments for industrial 
wireless sensor networks.
* The Mynewt kernel is a pre-emptive, multi-tasking RTOS with a tickless 
kernel.
* Question: does Mynewt support SMP? Answer: not currently.

## DSP ISA extensions for an open-source RISC-V implementation (PULP): Pasquale Davide Schiavone
* RI5CYv2 is an evolution of their RISC-V implementation. It is an RV32IMC 
implementation with some PULP-specific ISA extensions to target energy 
efficiency.
* Includes support for profiling and core execution trace.
* Coremark/Mhz is competitive with the ARM Cortex M4.
* Hardware loop instructions benefit control-intensive applications
* Add DSP extensions to improve energy efficiency for signal processing 
algorithms. Want to execute more quickly so the core can enter a low-power 
mode.
* RI5CYv2 adds dot product between vectors, saturation instructions, small 
vector instructions, ... GCC support is present for these.
* These additional instructions give a performance increase of up to 9.5x, 
6.4x on average for data-intensive kernels.
* The fan-out 4 of the critical path is 31. When laying out at 65nm, area is 
67 kilo-gate equivalents.
* Released so far just 10% of what they will release in the future, so there's 
much more to come. The full PULP will be released in December, an in the 
meantime you can use the PULPino core.

## The DOVER Edge: A Metadata-Enhanced RISC-V Architecture: André DeHon
* How do we handle the 'edge' of a metadata tagged system? e.g. I/O to the 
untagged world, legacy devices, DMA.
* PUMP is a metadata processing engine that checks tags upon every instruction 
and memory access.
* For slave devices, tags can be associated with memory mapped devices. These 
are used to write rules to control access. This allows giving configuration 
control to particular drivers, without giving the driver control to all 
devices or other privileges.
* DMA I/O policies might target: containment (who's allowed to read/write a 
buffer), integrity (mark incoming data as untrusted), secrecy, and
data presence/synchronisation.
* Add new supported opcodes as input to the PUMP representing DMA load and DMA 
store. Modify PC tag and Instr tag to represent the state of the DMA and the 
DMA source.
* If a DMA is deemed to be misbehaving, it can be totally disabled by the PUMP 
or the particular operation could be discarded.
* In this design, there is both an IO pump and a processor PUMP. The IO pump 
is pipelined so it will not reduce system throughput.
* The IO pump generates an interrupt on a rule miss. The miss handler uses the 
same rule function as for the processor PUMP.

## Improving the performance-per-area factor of RISC-V based multi-core systems: Tobias Strauch
* The speaker has spent many years working on C-slow retiming
* System hyper pipelining is based on C-slow retiming. It replaces original 
registers with memories, and adds thread stalling and bypassing features.
* In 'deep pipelining', run one thread in 'beast mode'. Switch to another 
thread if an instruction dependency is detected.
* Created the microRISC project, working on the V-scale design. With SHP was 
able to move from 80MHz to 250MHz.
* miniRISC (based on lowRISC). Want to perform SHP on the Rocket core. The 
speaker proposes that instead of having multiple minions you have a 
hyper-pipelined core.
* The source code of the projects will be released in PDVL, a new language 
"way better than Chisel and Bluespec Verilog(!)" that produces VHDL and 
Verilog.

## Working towards a Debian RISC-V port: Manuel A. Fernandez Montecelo
* Debian is a community of volunteers who care about free and open-source 
software.
* Debian contains more than 22k source packages
* Debian contains a mix of officially supported ports, unofficial releases (on 
Debian infrastructure but not part of the stable release process), and others 
are outside of Debian infrastructure (e.g. Raspbian).
* Why a Debian port for RISC-V? Interested as Manuel feels affinity with the 
goals of the project, previously enjoyed working with the OpenRISC port.
* Goal is to have a complete, fully supported, continuously updated Debian 
port. The initial step is to bootstrap a viable, basic OS disk image.
* The chosen RISC-V target is 64-bit little endian. This is the recommended 
default and what is planned for the lowRISC board.
* Been working on and off since November 2014. Upstreaming of toolchains etc 
would be very helpful. Have now built 300-400 "essential" packages.
* Packages where mostly cross-compiled, with some compiled 'natively' inside 
emulators. Some require building multiple times to e.g. break circular 
dependencies.
* ABI changes mean work has to restart from scratch.

## Kami. A framework for hardware verification: Murali Vijayaraghavan
* This work is part of the "Riscy Expedition" by MIT. Want to build chips with 
proofs.
* Must to able to verify an optimisation is correct independent of contexts, 
to enable modular verification of a full system.
* Kami is a DSL inside the Coq proof assistant for verifying Bluespec-style 
hardware.
* Have finished building required theory and proof automation infrastructure.  
Are currently working on proving a cluster of multi-cycle cores connected to a 
coherent cache hierarchy implements sequential consistency.
