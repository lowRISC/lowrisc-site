+++
Description = ""
date = "2015-06-29T17:02:57+01:00"
title = "Second RISC-V Workshop: Day One"

+++
The [second RISC-V workshop](https://riscv.org/2015/06/preliminary-agenda-for-the-2nd-risc-v-workshop-is-posted/) is going
on today and tomorrow in Berkeley, California. I'll be keeping a semi-live 
blog of talks and announcements throughout the day.

## Introductions and welcome: Krste Asanović

* The beginning of Krste's talk will be familiar for anyone who's seen an 
introduction to RISC-V before. Pleasingly, there are a lot of new faces here 
at the workshop so the introduction of course makes a lot of sense.
* Although the core RISC-V effort is focused on the ISA specification, there 
is interest in looking to expand this to look at how to standardise access to 
I/O etc.
* RV32E is a "pre-emptive strike" at those who might be tempted to fragment 
the ISA space for very small cores. It is a 16-register subset of RV32I.
* The compressed instruction set has been released since the last workshop, 
there will be talk later today about it. It gives 25-30% code size reduction, 
and surprisingly there's still lots of 16-bit encode space for additional 
extensions.
* Krste makes the point that AArch64 has 8 addressing modes vs just 1 for 
RISC-V. The comparison of the size of the GCC/LLVM backends is perhaps less 
interesting given that the ARM backend actually has rather a lot more 
optimisations.
* "Simplicity breeds contempt". "So far, no evidence more complex ISA is 
justified for general code"
* Will be talking about a Cray-style vector ISA extension later today (i.e.  
not packed-SIMD ISA or GPU-style).
* Rocket core is only about ~12kloc of Chisel in total. ~5kloc for the 
processor, ~2kloc for floating-point units, ~4.6kloc for 'uncore' (coherence 
hubs, L2, caches etc).
* State of the RISC-V Nation: many companies 'kicking the tires'. If you were 
thinking of designing your own RISC ISA for project, then use RISC-V. If you 
need a complete working support core *today* then pay $M for an industry core.  
If you need it in 6 months, then consider spending that $M on RISC-V 
development.
* RISC-V Foundation is being formed, a 501(c)(6), with Rick O'Conner as 
Executive Director. The mission statement is "to standardize, protect, and 
promote the free and open RISC-V instruction set architecture and its hardware 
and software ecosystem for use in all computing devices". Plan is to publicly 
announce before HotChips later this year and is actively recruiting companies 
who want to be 'founding' members. You will need to be a member of the 
foundation in good standing to use the RISC-V trademark (unless you are a 
non-profit).

## An update on lowRISC: Alex Bradbury

* Many thanks to the audience for all the questions. My slides are [available 
here](https://speakerdeck.com/asb/an-update-on-lowrisc).
* Unfortunately the SHAKTI project team from India have been caught up in the 
malfunctioning US State Department computer systems and so haven't been able 
to get visas to give their talk

## Compressed Extension Proposal: David Patterson

* Looked at existing compressed instruction sets, and tried to simplify things 
and throw away ideas that add complexity but provide little benefit.
* Ended up with a specification that is pleasingly minimal, with each 
instruction decoding to a single RV32 instruction.
* Keen on community feedback on additional RVC instructions. Identified a set 
of 24 that have little impact on current compiler-generated code, but could be 
useful for some use cases.
* You can read the RVC spec 
[here](https://riscv.org/specifications/compressed-isa/).
* Points out that Thumb2 is only a 32-bit address ISA. Although it is slightly 
smaller than RV32C, the RISC-V compressed spec has the benefit of supporting 
64-bit addressing.
* Rather than adding the complexity of load multiple and store multiple, 
experimented with adding calls to a function that does the same thing. This 
hurts performance, but gives a large benefit for code size.
* One question was on the power consumption impact. Don't have numbers on that  
yet.
* Should we require the compressed instruction set? Don't want to add it to 
the minimal 'I' instruction set, but could add it to the standard expected by 
Linux.

## GoblinCore64. A RISC-V Extension for Data Intensive Computing: John Leidel

* Building a processor design aimed at data intensive algorithms and 
applications. Applications tend to be very cache unfriendly.
* GC64 (Goblin Core) has a thread control unit. A very small micro-coded unit 
(e.g. implement RV64C) is microcoded to perform the contest switching task.
* Have added user-visible registers for thread id, thread context, task 
exception register etc etc.
* The GKEY supervisor register contains a 64-bit key loaded by the kernel. It 
determines whether a task may spawn and execute work on neighboring task 
processors, providing a very rudimentary protection mechanism.
* Making use of RV128I - it's not just there for fun!
* Support various instruction extensions, e.g. IWAIT, SWPAWN, JOIN, GETTASK, 
SETTASK. Basic operations needed to write a thread management system (such as 
pthreads) implemented as microcoded instructions in the RISC-V ISA.
* Also attempting to define the data structures which contain task queue data.
* Currently looking at lowRISC-style minion cores to implement microcoded 
memory coalescing units.
* Read the GC64 specification doc 
[here](http://discl.cs.ttu.edu/gitlab/gc64/gc64-doc/tree/master).

## Vector Extension Proposal: Krste Asanović

* Goals: efficient and scalable to all reasonable design points. Be a good 
compiler target, and to support implicit auto-vectorisation through OpenMP and 
explicit SPMD (OpenCL) programming models. Want to work with virtualisation 
layers, and fit into the standard 32-bit encoding space.
* Krste is critical of GPUs for general compute. I can summarise his arguments 
here, but the slides will be well worth a read. Krste has spent decades 
working on vector machines.
* With packed SIMD you tend to need completely new instructions for wider 
SIMD. Traditional vector machines allow you to set the vector length register 
to provide a more uniform programming model. This makes loop strip-mining more 
straight-forward.
* Add up to 32 vector data registers (v0-v31) in addition to the basic scalar 
x and f registers. Each vector register is at least 3 elements each, with 
variable bits per element. Also add 8 vector predicate registers, with 1-bit 
per element. Finally, add vector configuration and vector length CSR 
registers.
* Other features
  * Reconfigurable vector registers allow you to exchange unused architectural 
  registers for longer vectors. e.g. if you only need 4 architectural vector 
  registers you'll have a larger vector length.
  * Mixed-precision support
  * Intenger, fixed-point, floating-point arithmetic
  * Unit-stride, strided, indexed load/stores
  * Predication
* Mixed-precision support allows you to subdivide a physical register into 
multiple narrower architectural registers as requested.
* Sam binary code works regardless of number of physical register bits and the 
number of physical lanes.
* Use a polymorphic instruction encoding. e.g. a single signed integer ADD 
opcode that works on different size inputs and outputs.
* Have separate integer and floating-point loads and stores, where the size is 
inherent in the destination register number.
* All instructions are implicitly predicated under the first predicate 
register by default.
* What is the difference between V and Hwacha? Hwacha is a non-standard 
Berkeley vector extensions design to push the state-of-the-art for 
in-order/decoupled vector machines. There are similarities in the lane 
microarchitecture. Current focus is bringing up OpenCL for Hwacha, with the V 
extension to follow.
* Restartable page faults are supported. Similar to the DEC Vector VAX.
* Krste pleads people not to implement a packed SIMD extension, pointing out 
that a minimal V implementation would be very space efficient.

## Privileged Architecture Proposal: Andrew Waterman

* Aims to provide a clean split between layers of the stack.
* You can read the privileged spec 
[here](https://riscv.org/specifications/privileged-isa/).
* Supports four privilege modes. User, Supervisor, Hypervisor and Machine 
mode.
* For a simple embedded system that only needs M-mode there is a low 
implementation cost. Only 2^7 bits of architectural state in addition to the 
user ISA, plus 2^7 more bits for timers and another 2^7 for basic performance 
counters.
* Defined the basic virtual memory architectures to support current Unix-style 
operating systems. The design is fairly conventional, using 4KiB pages.
* Why go with 4KiB pages rather than 8KiB as was the initial plan? Concerned 
with porting software hard-coded to expect 4KiB pages. Also concerns about 
internal fragmentation.
* Physical memory attributes such as cacheability are not encoded in the page 
table in RISC-V. Two major reasons that Andrew disagrees with this are that 
the granularity may not be tied to the page size, plus it is problematic for 
virtualisation. Potentially coherent DMA will become more common meaning you 
needn't worry about these attributes.
* Want to support device interactions via a virtio-style interface.
* The draft Supervisor Binary Interface will be released with the next 
privileged ISA draft. It includes common functionality for TLB shootdowns, 
reboot/shutdown, sending inter-processor interrupts etc etc. This is a similar 
idea to the PALCode on the Alpha.
* Hardware-accelerated virtualization (H-mode) is planned, but not yet 
specified.
* A draft version of v1.8 of the spec is expected this summer, with a frozen 
v2.0 targeted for the fall.

## RapidIO. The Unified Fabric for Performance-Critical Computing: Rick O'Connor

* There are more 10Gbps RapidIO ports on the planet than there are 10Gbps 
Ethernet ports. This is primarily due to the 100% market penetration in 4G/LTE 
and 60% global 3G.
* The IIT Madras team are using RapidIO extensively for their RISC-V work
* Has been doing work in the data center and HPC space. Looking to use the AXI 
ACE and connect that to RapidIO.
* There is interesting work on an open source RapidIO stack.

## CAVA. Cluster in a rack: Peter Hsu

* Problem: designing a new computer is expensive. But 80% is the same every 
time.
* CAVA is not the same as the Oracle RAPID project.
* Would like to build a 1024-node cluster in a rack. DDR4 3200 = 25.6GB/s per 
64-bit channel. Each 1U card would be about 600W with 32 nodes.
* Looking at a 96-core 10nm chip (scaled from a previous 350nm project).  
Suppose you have a 3-issue out of order core (600K gates) and 32KiB I+d cache, 
that would be around 0.24mm^2 in 10nm.
* Estimate a vector unit might be around the same area.
* Peter has detailed estimates for per-chip power, but it's probably best to 
refer to the slides for these.
* Research plan for the cluster involves a unified simulation environment, 
running on generic clusters of x86 using open-source software. Everyone uses 
the same simulator to perform "apples to apples" comparison. This allows easy 
replication of published work.
* Simulation infrastructure will involve a pipeline siumlator, SoC simulator 
(uncore logic), and a network simulator.
* Interested in applying Cray-style vectors to database workloads
* Could also have the ability to make associativity ways and possible 
individual cache lines lockable.

_Alex Bradbury_
