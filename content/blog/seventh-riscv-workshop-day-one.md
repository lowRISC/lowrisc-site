+++
Description = ""
date = "2017-11-28T15:16:45+00:00"
title = "Seventh RISC-V Workshop: Day One"

+++
The [seventh RISC-V 
workshop](https://riscv.org/2017/10/7th-risc-v-workshop-agenda/) is going
on today and tomorrow at Western Digital in Milpitas. I'll be 
keeping a semi-live blog of talks and announcements throughout the day.

Follow [here]({{< ref "blog/seventh-riscv-workshop-day-two.md" >}}) for the 
day two live blog.

## Introduction: Rick O'Connor
* Workshop is sold out, 498 attendees registered representing 138 companies 
  and 35 universities.
* There will be 47 sessions squeezed into 12 and 24 minute increments, plus 26 
  poster / demo sessions.
* The 8th RISC-V workshop will be held on May 7th-10th at the Barcelona 
  Supercomputing Center and Universitat Politecnica de Catalunya.
* Rick gives a refresher on the structure of the RISC-V Foundation.
* The RISC-V Foundation now has only 100 members (including individual 
members).
* We're on a _tight_ schedule today. No applause and no questions!

## RISC-V state of the union: Krste Asanovic
* Krste gives a rapid overview of the RISC-V ISA.
* RISC-V aims to be simple, clean-slate, modular, and stable.
* RISC-V started in May 2010. v1.0 of the ISA came in 2011, first Rocket 
tapeout in 2012, first Linux port in 2013, v2.0 (frozen) IMAFD spec in 2014.
First commercial softcores and first commercial SoC in 2017.
* Large companies are adopting RISC-V for deeply embedded controllers in their 
SoCs ("minion cores"), replacing home-grown and commercial cores.
  * [Editor's note: pleasing to see the "minion core" name take off around the 
  wider RISC-V community!].
* Small and proprietary-ISA soft-core IP companies are switching to the RISC-V 
standard to access a larger market. "If you're a softcore IP provider, you 
should have a RISC-V product in development".
* RISC-V has seen government adoption, e.g. India adopted it as a national 
ISA. A recent security-focused DARPA project standardised on RISC-V. Israel 
Innovation Authority are creating the GenPro platform around RISC-V.
* Many startups are choosing RISC-V for new products. "We haven't had to tell 
startups about RISC-V; they find out about it very quickly when shopping for 
processor IP".
* Commercial ecosystem providers: starting to see mainstream commercial 
support. "Demand is driving supply in the commercial ecosystem".
* RISC-V in academic research: becoming the standard ISA for academic 
research. There will be talks at the workshop about the Celerity 500 RISC-V 
core SoC in 16nm FinFET, and FireSim which models 1024 quad-core RISC-V 
servers in the cloud.
  * The CARRV RISC-V workshop at MICRO was even better attended than the 
  machine learning workshop.
* Expect in a few years time that the vast majority of undergraduates will be 
taught RISC-V at University.
* Racepoint Global have been hired for Foundation marketing.
* RISC-V Technical Roadmap for 2017:
  * Primary goal was to formally standardise the base ISA, resolve issues with 
  the memory model, debug, and stabilize the privileged architecture.
  * Good progress has been made, but the spec hasn't yet been ratified. One of 
  the issues is differentiating the base spec versus clarifications for 
  different "profiles". There is no plan to change any instruction 
  specification versus 2.0.
  * The Unix platform is stable as of the privileged 1.10 spec (i.e. no 
  backwards incompatible changes from now on).
* ISA specifications and profiles
  * The original ISA specs mixed instruction specifications with platform 
  mandates. Now work is ongoing to separate instruction set specifications 
  from platform profiles.
  * Instruction set specifications should be maximally reusable, while the 
  profiles should be as constrained as possible to simplify software 
  compatibility.
* Single-letter names will run out some day, so a proposal has been made to 
allow finer-grained naming of instruction sets to describe profiles. Use Zxxxx 
to name standard instruction extensions (while Xyyyyy is used for non-standard 
instruction extensions). See the isa-dev list for more information.
* Profiles for software compatibility. A software ABI/SBI defines a profile.
A software ABI/SBI defines a profile. Also need profiles M-mode-only 
microcontrollers, and MU-mode microcontrollers, and for booting MSU platforms.
Aim for have first ready in Q12018.
* Memory model: the original was too weak for C11 and underspecified, but a 
team of experts have come together over the past year to resolve the issues.
RVWMO is the base memory model and is weak, while RVTSO is an optional 
extension providing a strong TSO memory model.
* Calling convention and ABI has been stabilized and documented.
* GCC and binutils have been upstreamed and released in GCC. LLVM upstream is 
in progress.
* A number of other compilers and languages are now available. e.g. CompCert, 
Go, Rust, OCaml, Jikes JVM, OpenJDK, ...
* The Linux port has been accepted upstream for the 4.15 release.
Additionally, the hypervisor spec has been released (designed to support 
recursive virtualisation using an enhanced S mode).
* Run-halt debug going well, is being targeted by commercial vendors.
* 2017 summary: All planned major technical decisions settled, some more work 
on the ratification process is needed.
* Technical roadmap goals for 2018:
  * Complete ratification of base ISA and first profiles
  * Base vector extensions proposed and ratified
  * Hypervisor implemented, spec ratified
  * Formal spec completed and released
* Vector: see the talk from Roger. Aim to be the Best Vector ISA Ever (TM).
* Security: really two separable efforts in the foundation: trusted execution 
environments and cryptographic instruction extensions. Also a huge amount of 
other work in the academic community.
* Interrupts: currently have fast local interrupts and global platform-level 
interrupts. Also have requests for high end systems who want per-hart 
message-signal interrupts (MSI) and from low-end embedded that want 
pre-emptive vectored prioritized interrupts.
* Improving embedded compression: the C extension was designed for general 
purpose computing with Unix binaries. People are seeing non-competitive RISC-V 
code size on pure embedded workloads, like due to lack of byte/halfword memory 
access? Considering an alternative C extension for RV32E systems.
* A new task group has been up for the 'J' extension, exploring support for 
dynamically translated languages. Looking at issues like integer overflow, 
garbage collection, and instruction cache management.
* Summary
  * Very rapid development and adoption "by the time you decide to do a 
  project, support will be there".
* Question: does the foundation have any formal ways of addressing IP 
challenges? Answer: have been documenting prior art for the base ISA 
instructions. Would be good to continue to expand this to cover reference 
hardware implementations.

## RISC-V Hypervisor Extension: Andrew Waterman
* Presenting work with extensive contributions from Paolo Bonzini and John 
Hauser
* Goal is to virtualize S-mode to support running guest OSes under Type-1, 
Type-2 and hybrid hypervisors. Also want to be high performance and to support 
recursive virtualisation.
* The hypervisor extension adds new privileged modes. S-mode becomes HS-mode, 
and we also add the Virtualised Supervisor (VS) and Virtualized User (VU) 
modes.
* What needs to be virtualized? Supervisor architecture state (CSRs), memory, 
I/O and interrupts.
* Additional copies of most supervisor CSrs are provisioned as background 
supervisor CSRs, e.g. bsscratch, bsepc. In HS-mode, foreground CSRs contain 
S-mode state and background CSRs contain inactive VS-mode state. These are 
swapped in VS-mode.
* Use two-level address translation to virtualize memory. Original virtual 
addresses are translated to guest physical addresses by the VS-level page 
table, and then guest physical addresses are translated to machine physical 
addresses by the HS-level page table.
  * Page table entry formats and page table layouts are the same as S-mode
* Software and timer interrupts are easy to virtualise, as they're already 
exposed via the SBI. The two-level paging scheme can be used to trap MMIO 
accesses.
  * Could avoid extra traps into the hypervisor with a virtualisation-aware 
  PLIC. This is considered a platform issues, outside of the scope of the 
  hypervisor ISA.
* Need an I/O MMU to initiated DMAs without trap into the hypervisor - also a 
platform issue.
* The hypervisor extension is designed to be efficiently emulatable on M/S/U 
systems with traps into M-mode.
* Specification v.01 is [available on 
GitHub](https://github.com/riscv/riscv-isa-manual). Hoping to implement in 
Spike in Q1 2018.
* Want to see a silicon implementation prior to ratification.

## RISC-V memory consistency model status update: Dan Lustig
* The goal was to define the RISC-V memory consistency model ("specifies the 
values that can be returned by loads"). Support a wide range of hardware 
implementations, as well as Linux, C/C++ and lots of other critical software.
* The fundamental debate was about strong models (such as x86-TSO) vs weak 
models (ARM, IBM Power). Strong models have stricter ordering rules, resulting 
in something that's simpler for programmers and for architects. Weak models 
have more relaxed ordering rules, better performance/power/area and more 
microarchitectural freedom.
* In order to find a compromise, defined RVTSO (strong) and RVWMO (weak).
  * Both are multi-copy atomic. This means cores are allowed to peek at stores 
  they have issues as long as they haven't been observed by anyone else and is 
  much simpler to reason about than the Power and ARMv7 memory models.
* The base RISC-V memory model is RVWMO (software must assume this if it wants 
to be portable). It's important to note that a hardware implementation meeting 
the RVWMO specification could be more conservative (stronger). Additional have 
the Ztso extension for RVTSO, which software might target.
* RVWMO and RVTSO differ in the degree of memory access reordering they permit 
at the point of global visibility. In RVTSO, only store-to-load reordering can 
be observed. In RVWMO, most memory accesses can be reordered freely unless 
synchronized via .sq, .rl and/or fences.
* Dan has some handy diagrams that explain the RVWMO and RVTSO rules in a 
nutshell, which you should be able to study once the slides become available.
* Software written for RVWMO will run on all RISC-V hardware (RVWMO and Ztso).
RVTSO-only software can be be written, but will only run on hardware 
implementing Ztso. A flag in the ELF header will be used to ensure this.
* If you don't want to think about memory models, just use the standard OSes 
and toolchains. If you care about PPA or flexibility, use RVWMO. If you have 
lots of legacy x86 code, use hardware implementing Ztso so that any software 
will work. If you believe TSO is the future, use hardware with Ztso and emit 
code with the TSO-only magic number.
* Fragmentation due to the presence of two memory models is an obvious risk.
Try to discourage software from targeting both, and encourage targeting RVWMO 
wherever possible (redundant fences simple become no-ops).
* There have been a number of other ISA changes. ld.rl and sd.aq are 
deprecated. ld.aqrl and sd.aqrl mean RCsc. Also clarified other subtleties.
May have future extensions to the fence instruction, and .aq/.rl variants for 
byte and halfword-size loads/stores.

## RISC-V - Enabling a new era of open data-centric computing architectures: Martin Fink
* Most people think of Western Digital as a storage company, but actually 
they're a _data_ company.
* Big data is well known, but increasingly there are applications that require 
"fast data" (immediate access to information).
* Big data applications have historically focused on general purpose compute.
But we need to be able to move beyond general purpose compute to meet new 
application requirements.
* In a general purpose compute architecture, everything is centered around the 
CPU rather than the data.
* Workload diversity demands diverse technologies and architectures, both for 
"big data" and "fast data".
* There are a wide range of data-centric applications at the edge.
* RISC-V meets the needs of big data (move compute to data) and fast data 
(memory centric compute). It enables purpose-built environments for big data 
and fast data applications.
* Western Digital ships in excess of 1 billion cores per year, and expect to 
double that. They are making a commitment to transition all of those 1 billion 
cores towards RISC-V, across their whole product portfolio.
* Want to process the data where it lives, which RISC-V will help to enable.
* Represents a new style of development. In some cases, WD may develop their 
own cores, in others may buy them, in others may partner with another company 
to co-develop them.
* Western Digital will work to accelerate the RISC-V ecosystem:
  * Support the development of open source IP building blocks for the 
  community
  * Actively partner and invest in the ecosystem
  * Accelerate development of purpose-built processors for a broad range of 
  Big Data and Fast Data environments
  * Multi-year transition of Western Digital devices, platforms and systems to 
  RISC-V purpose built architectures
* First device from WD with a RISC-V core is likely to not ship until late 
2019 to early 2020.
* Summary
  * Big Data and Fast Data need purpose-built environments
  * Openness and ecosystem enable best-in-class innovation. The motivation is 
  enabling innovation, _not_ reducing cost.
  * Western Digital brings the momentum of over 1B cores per year

## Industrial-strength high-performance RISC-V processors for energy-efficient computing: Dave Ditzel
* Coming out of "stealth mode" in this talk.
* Chris Celio is joining Esperanto, but will continue to maintain and support 
BOOM. Esperanto will also be implementing even higher performance out-of-order 
processors.
* Esperanto have been pursuing an implementing of the draft Vector ISA in 
order to understand design trade-offs.
* RISC-V is off to a great start, but many in industry view RISC-V as a 
curiosity or toy, only for low end. Repeatedly see questions about high-end 
designs (in Verilog!), graphics, machine learning, or HPC applications.
* See Esperanto as complementing existing core vendors, "expanding RISC-V's 
piece of the pie".
* Experanto is designing a high-performance RISC-V core comparable to the best 
IP alternatives. It is designing an energy-efficient RISC-V core for high 
TeraFLOP computing needs. The goal is to make RISC-V more compelling than the 
other high-end alternatives.
* Will produce IP with human readable, synthesizable Verilog.
* Esperanto is building the highest TeraFLOPS per Watt machine learning 
computing system, and it will be based on the RISC-V ISA
* ET-Maxion will be the highest single thread performance 64-bit RISC-V 
processor. Starting from BOOM v2, but expect substantial changes. Optimized 
for 7nm CMOS. This will be used in Esperanto's products and made available as 
a licensable core.
* Second core is the ET-Minion. This is intended to do all the heavy floating 
point work, with very high floating point throughput and energy efficiency.
This will be a 64-bit RISC-V core with vector extensions, an in-order 
pipeline, and extra instruction extensions for machine learning. Also have 
multiple hardware threads of execution. Like the ET-Maxion, this will be used 
in Esperanto products and available as a licensable core.
* Putting these together in a product: Esperanto's AI supercomputer on a chip.
16 64-bit ET-Maxion RISC-V cores with private L1 and L2 caches, 4096 64-bit 
ET-Minion RISC-V cores each with their own vector floating point unit, 
hardware accelerators, Network on Chip to allow processors to reside in the 
same address space, multiple levels of cache, etc.
* Other companies are proposing special purpose hardware for machine learning 
using proprietary instruction sets. Esperanto want to base all processing on 
RISC-V, adding instruction extensions and hardware accelerators where 
necessary.
* Also looked at using RISC-V for graphics. Wrote a shader compiler that can 
generate RISC-V compilers, and the code to distribute the workload across 
thousands of cores.
* Argue that proprietary, custom instruction sets are a bad choice. Instead, 
make general purpose RISC-V processors with domain specific extensions when 
needed.

## Andes Extended Features: Dr Chuan-Hua Chang
* Andes Technology is a Taiwan-based CPU IP company with over 2 billion 
Andes-Embedded SoCs shipped in diverse applications.
* Have extended the RISC-V architecture in the V5m with:
  * Vectored interrupts and priority-based preemptive interrupts for the PLIC
  * StackSafe features
  * Exception redirection to the debuggers
* The V5m ISA includes
  * Andes Perfomance extension
  * Optional Andes DSP extension
  * Optional Andes Custom extension
* For the vectored PLIC, vector table entry 0 contains exceptions and local 
interrupts except "external interrupt". Vector table entry 1 and above 
contains external interrupts from the PLIC. The PLIC interrupt ID is 
transmitted directly from PLIC to a hart.
* The extended PLIC saves over 30 instructions for dispatch and software 
preemption overhead.
* StackSafe monitors the SP register value to detect stack pointer overflow 
and underflow, and for recording the maximum observed stack size.
* Andes ISA extensions add
  * GP-implied load/store instructions with a larger immediate range.
  * Compare an operand with a small constant and branch
  * Instructions for zero/sign-extensions
  * CoDense: code size compression instructions
* The Andes DSP ISA extension features over 130 instructions, using only GPRs.
Introduces a range of SIMD instructions, zero-overhead loops, and 64-bit 
signed/unsigned addition and subtractions, and signed/unsigned multiplication 
and addition.
  * See 50% cycle reduction for the Helix MP3 decoder, and 80.1% cycle 
  reduction for the G.729 codec.
* Andes Custom Extension (ACE) provides a framework to facilitate custom 
instruction design and implementation.

## Customisation of a RISC-V processor to achieve DSP performance gain: Marcela Zachariasova
* Codasip studio is a processor development environment which takes a high 
level description of a processor and automatically generates software tool, 
RTL, and verification environments.
* Take one of Codasip's Berkelium RISC-V cores as the starting point.
* Configure the core by enabling/disabling ISA extensions as desired. You can 
also define new instructions, driven by profiling information.
* Case study: audio processing solution for IoT (developed with Microsemi).
* Ultimately, saw a 13.62x speedup for a 2.43x area overhead vs RV32IM.

## Freedom U500, Linux-capable, 1.5GH quad-core RV64GC SoC: Jack Kang
* Freedom Unleashed 500: 250M+ transistors, TSMC 28nm, high-performance 
integrated RISC-V SoC, U54MC RISC-V CPU Core Complex
* 1.5GHz+ SiFive E51/U53 CPU. 1xE51 (16KB L1I$, 8KB DTIM), 4 x U54. 32KB L1I$, 
32KB L1D$.
* All five cores in a coherent system with 2MB L2$.
* Development board available in Q12018.
* Feature GbE, DDR3/4, and ChipLink (a serialized chip-to-chip TileLink 
interconnect).
* The E51 core is a 64-bit, 1.5GHz CPU "minion core".
* Coherent, 2MB 16-way L2 subsystem.
* Single U54 core-only area 0.224mm2, single U53 core complex area 0.538mm2 
(including 32KB/32KB L1 cache). 1.7 DMIPS/MH, 2.75 CoreMark/MHz.
* HiFive Unleashed will have the SiFive Freedom Unleashed 500 SoC connected to 
a Microsemi PolarFire FPGA, Provide USB and HDMI via the FPGA, as well as 
PCIe. Available Q1'2018.
* HiFive Unleashed Early Access Program: give early access to FPGA-based 
prototypes (now) and development boards (soon). To get access, email 
info@sifive.com.

## Revolutionizing RISC-V based application design possibilities with GlobalFoundries: Gregg Bartlett
* GlobalFoundries is the only foundry that is a RISC-V Foundation member. See 
that the RISC-V approach is a good match for GlobalFoundries.
* For the last year, have been engaged in applications where RISC-V processors 
are showing up. DNN accelerators, cluster computing, automotive/embedded SoCs, 
X86/GPU co-processors.
* Argue foundry technology allows differentiated customer solutions. e.g.
22FDX and 12FDX.
* 22FDX is targeted to serve segments such as mobility, IoT, RF, and 
automotive.
* FDXcellerator program features multiple RISC-V cores, as well as LPDDR4, 
MIPI etc.
* Partnered with SiFive (E31+E51), Reduced Energy Microsystems, Andes, ETH 
Zurich / University of Bologna (PULP), Berkeley Labs, IIT Chennai.
* For the SiFive partnership, no cost to customers for E31/E51 cores until 
production starts.

## RISC-V LLVM. Towards a production-ready LLVM-based toolchain: Alex Bradbury
* I was the presenter, so no notes right now.

## A RISC-V Java update: Martin Maas
* Jikes RVM now runs full JDK6 applications, including the Decapo benchmark 
suite. Passes the Jikes RVM core test suite. About 15000 lines of code.
* Managed languages have been under-represented in computer architecture 
research for quite some time.
* Challenges: long running on many cores, concurrent tasks, fine-grained 
interactions. Difficult fit for many common simulation approaches, e.g. Qemu 
or Gem5.
* Instead, we can run managed workloads on real RISC-V hardware in FPGA-based 
simulation to enable modifying the entire stack.
* By modifying the hardware, we can do fine-grained tracing without perturbing 
the software being tested.
* Can explore the interaction with the memory system, e.g. DRAM row misses 
encountered during garbage collection.
* This will allow a wide range of research that was difficult without this 
infrastructure.
* Have the Jikes Research VM (baseline JIT, no optimising JIT). Can run 
OpenJDK Hotspot JVM with the Zero (interpreter) backend, but no 
high-performance JIT compiler port yet. Help needed!
* The RISC-V Foundation has launched the J extension working group today, to 
better support managed-language support to RISC-V.


## MicroProbe. An open source microbenchmark generator ported to the RISC-V ISA: Schuyler Eldridge
* Not yet open source, but in the process of releasing it.
* Why make microbenchmarks? Might want to study worst case power consumption, 
look for performance bugs, determine if the design is reliable, ... But 
writing microbenchmarks is a labour-intensive process.
* MicroProbe has the user write microbenchmark generation policies. The 
framework then produces benchmarks according to those policies.
* The target definition (ISA, microarchitecture, environment) is written using 
YAML. Code generation and generation policies are written using Python.
* MicroProbe uses riscv-meta from Michael Clark.
* The user describes a microbenchmark as transforms over an intermediate 
representation (IR) for describing benchmarks.

## Lauterbach debug support for RISC-V: Bob Kupyn
* Lauterbach is solely focused on hardware and software debug tools. All 
design, development and manufacture is done in Munich.
* Claim the widest range of supported microprocessors in the market.
* More than 100k installed Lauterbach debuggers, estimate 40% of the market.
* Have a RISC-V JTAG debugger. Currently just run-control, awaiting a stable 
trace debug spec.
* Trace32 debugger supports all the features you'd expect. The RISC-V port 
supports RV32 and RV64. In the future, want to add trace support and 
Linux/Target OS awareness.
* In the initial release, support SiFive Coreplex E31 and E51.

## J-link debug probe now available for RISC-V: Paul Curtis
* J-Link aims to be the "ultimate debug probe". Supporting ARM, Mips, RX, 
8051, and now RISC-V.
* J-Link is open in the sense you can incorporate it into your product using 
the J-Link SDK.
* J-Link is "intelligent", eliminating round-trip-time over USB or IP using 
kernels in the debug adapter.
* Over 600k units sold.
* Also have Embedded Studio, other products.

## Porting the ThreadX RTOS to RISC-V: John Carbone
* ThreadX in production since 1997.
* Small footprint, priority-based, fully preemptive RTOS with a single linear 
address space.
* Has advanced features like preemption-threshold scheduling, real-time event 
trace, memory-protected modules.
* Ported with co-operation from Mirosemi, ran on the Smartfusion2 Creative 
Development Board.
* Anticipate commercial availability for RISC-V before the end of 2017.

## xBGAS. A bridge proposal for RV128 and HPC: John Leidel
* Extended Base Global Address Space (xBGAS)
* Want to provide extended addressing capabilities without ruining the base 
ABI.
* Extended addressing must not specifically rely upon any one virtual memory
* xBGAS is not a direct replacement for RV128.
* See a variety of potential application domains.
* HPC-PGAS: traditional message passing has a tremendous amount of overhead.
There are a range of low-latency PGAS runtimes, but little hardware/uarch 
support.
* Add extended (eN) register that map to base general registers. These are 
manually utilized via extended load/store/move instructions.
* You only get access to the extended address space when using the new 
extended addressing instructions.
* ISA extensions: base integer load/store, raw integer load/store, address 
management (explicitly read/write the extended registers).
* No support for things like atomics currently. (Question for the community: 
how to define extensions to extensions?)
* A number of outstanding issues with the ABI and calling convention. How to 
link base RISC-V objects with objects containing extended addressing? Howe do 
we address the caller/callee saved state with extended registers? What about 
debugging and debugging metadata.
* The software part of this is being led by the Data Intensive Scalable 
Computing Lab at Texas Tech. Have a prototype implementation in LLVM.
* Hardware part of the effort taking place at Tactical Computing Labs, LBNL 
and MIT. Looking at pipelined and accelerator-based implementations.
* The current spec is [available 
here](https://github.com/tactcomplabs/xbgas-archspec). Comments and 
collaborators are encouraged!

## Extending the 16 GPR standard beyond RV32E: Mitch Hayenga
* Motivation: Register file area/power/latency is critical to any processor.
Large register files help with static code scheduling, but wide issue 
out-of-order processors have the potential to hide register spill latency and 
issue bandwidth.
* There are a number of commercially available cores that only offer 16 
double-precision floating point registers.
* Want to see the 16GPR option being orthogonal just like any other ISA 
variant (RV32E currently can't be combined with the F and D extensions).
* Reduced the available registers to x0-x15 and f0-f15. Modified GCC and glibc 
and used gem5 with the Coremark/Dhrystone/Whetstone/Spec2006 benchmarks.
* For the simple benchmarks, saw a 6-8% increase in static code size. Smaller 
increase in dynamic instructions (and Whetstone saw a reduction). Saw in-order 
execution time impacted, but much smaller impact for the out-of-order designs.
* For SPECInt, saw (very) slightly improved code density and execution time.  
In perlbench this was primarily due to reduced function call overhead.
* The impact was more negative for SPECFP.
* Architectural overheads limit the viable design space of multithreaded 
out-of-order CPUs.
* New potential designs:
  * Dual-threaded, small window out-of-order CPUs (~20 instruction windows).
  This is impractical with the current RISC-V register file size requirements
  * Large, high-IPC, many threaded CPU designs.

## Using Pyrope to create transformable RISC-V architectures: Haven Skinner
* Hardware design is difficult. You need multiple codebases (cycle accurate, 
high level simulation, verification reference model). Also need to adjust 
pipeline stages and verify the hardware.
* A new HDL (Pyrope) can help!
* Fluid pipelines are the "hammer" used to address design complexity. Fluid 
pipeline transformations change the number of stages as part of the compile 
flow.
* A fluid pipeline has valid/stop signals, and pipeline stages should tolerate 
random delays.
* Collapsing stages was useful in order to build an emulator out of a RISC-V 
fluid core. Can also change the number of pipeline stages automatically, and 
perform formal verification.
* For a Verilog implementation, saw 2MIPS when compiling with Verilator. When 
collapsing fluid pipelines to produce a fast emulator, saw 6MIPS. Spike 
achieves around 12 MIPS.
* Compared synthesis results of the fluid pipelines vs a range of open source 
RISC-V cores.
* For "fluid verification", can collapse the stages in a RISC-V core, then 
verify against a trivial single stage RISC-V core. Used yosys to do this.

## Performance isolation for multicore within labeled RISC-V: Zihao Yu
* In multi-core architectures, core share resources such as L3, memory, and 
I/O. This can cause uncertainties and QoS violations.
* Take inspiration from labeled networks and try to apply to computer 
architecture. Describe the Labeled von Neumann Architecture (LvNA).
* Each request has a label, each label is correlated with a 
process/thread/variable, labels are propagated across the whole machine, and 
software-defined control logic is used to provide different service for 
different labeled groups.
* Proposed PARD (ASPLOS 2015). Programmable Architecture for 
Resourcing-on-Demand.
  * Add a label register, allocate a label for each VM, attach a label to each 
  request, and add label-based programmable control logic.
* LvNA + RISC-V = Labeled RISC-V
* Saw less than 3% overhead in terms of code, less than 5% resource overhead, 
and no performance overheads for critical apps.
* Plan to tape out with TSMC 40nm next year.

## A Practical Implementation of a Platform Level Interrupt Controller (PLIC): Richard Herveille
* PLIC design goals: easy integration with external bus interfaces, be fully 
compliant, and very flexible. Should work from small microcontrollers all the 
way up to large server applications.
* The deign flexibility may result in management complexity. Potentially 
hundreds or thousands of registers in a memory mapped management interface. So 
try to define a management interface that minimises the memory map.
* Create the memory map dynamically based on parameters given to the IP core.  
The register arrangement and documentation is automated.
* See the [Roa Logic website](https://roalogic.com).

## Open source RTOS ports on RISC-V: Nitin Deshpande
* Ported FreeRTOS, MyNewt, and Huawei LitOS.
* FreeRTOS: 32-bit version running on a RISC-V soft processor, 64-bit 
currently runs on Spike.
* MyNewt: RISC-V support was already available, added the BSP and MCU/HAL 
support.
* LiteOs: ported the kernel, BSP, and HAL. Already merged into upstream LiteOS 
GitHub.
* Had a positive experience with RISC-V.
* Mi-V is an ecosystem that aims to accelerate the adoption of RISC-V.

## RISC-V poster preview
* This is too rapid fire to summarise, sorry!

_Alex Bradbury_
