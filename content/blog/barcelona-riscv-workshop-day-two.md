+++
Description = ""
date = "2018-05-09T07:00:00+00:00"
title = "Barcelona RISC-V Workshop: Day Two"

+++
The [eighth RISC-V 
workshop](https://riscv.org/2018/04/risc-v-workshop-in-barcelona-agenda/) is 
continuing
today in Barcleona. As usual, I'll be keeping a semi-live blog of talks and 
announcements throughout the day.

Look back [here]({{< ref "blog/barcelona-riscv-workshop-day-one.md" >}}) for 
the day one live blog.

Note that slides from most presentations are now [available at 
riscv.org](https://riscv.org/2018/05/risc-v-workshop-in-barcelona-proceedings/).

## Fast interrupts for RISC-V: Krste Asanovic
* Embedded is a major use for RISC-V. There is a desire for faster interrupt 
handling with support for nested preempted interrupts.
* Summary of current RISC-V interrupts
  * Local interrupts are directly connected to one hart. There's no 
  arbitration between harts to service. Determine cause through xcause CSR.
  Only two standard local interrupts (software, timer).
  * Global (external) interrupts are routed via the platform-level interrupt 
  controller (PLIC) which arbitrates between multiple harts claiming an 
  interrupt.
* The machine interrupt pending (mip) CSR contains bits for local software, 
local timer, and external interrupts (from the PLIC). It tells you which 
interrupts are present.
* mie mirrors the layout of mip, and allows you to enable/disable interrupts.
* mstatus keeps track of interrupt status, containing a small interrupt stack.
* The interrupt is reported in the mcause CSR. The exception code indicates 
which interrupt was responsible - you might have to then interrogate the PLIC 
if it was an external interrupt.
* mtvec (machine trap vector base) contains the address of the trap vector 
('base'). It also contains bits which control whether interrupts are direct 
(all exceptions and interrupts jump to base) or vectored (exceptions go to 
base, interrupts are vectored).
* There's two parts of an interrupt: what you were doing when it happened 
(state context), and what you're going to do. mepc and mstatus allow the 
contact to be saved and restored.
* Problems with current interrupts:
  * Hardware preemption is only possible by switching privileged modes
  * Fixed priority for local interrupts
  * The vector table holds jumps instructions, which can only jump +/- 1MiB. A 
  free register would be required to jump further, resulting in even more 
  instructions.
  * PLIC has variable priority, but the vectoring must be done in software.
  * The PLIC needs two memory accesses: one to claim it, one to indicate 
  completion.
  * The Unix ABI (which is the only one that has been standardised) requires 
  many registers to be saved/restored.
* Have had input via multiple proposals: Andes, Syntacore, Seagate, Liviu 
Ionescu, SiFive
* There have been discussions on the list about the interrupt handler 
interface for software. It comes down to a choice between having the interrupt 
handler as a regular C function (requiring save/restore of all caller-save 
registers in hardware or software) or an inline handler which uses a gcc 
interrupt attribute to convert the function to always callee-save every 
register. Krste suggests both approaches are needed.
* Krste explains how an "interrupt" attribute on a C function might work. In 
this example, every register is callee-saved, so registers are saved as you 
need to use them.
* If you then went to call a function using the C ABI you need to save/restore 
8 arguments, 7 temporaries, and 1 return address. Even more if you have to 
save the floating point context. Krste argues that moving this to hardware 
isn't enough, you need a new ABI to reduce the amount of state.
* A number of options have been proposed for vectoring.
  * Having function pointers in a table. Downside is this is new functionality 
  you'd have to add to a pipeline.
  * The SiFive proposal is to add a new +/-2GiB offset instruction which is 
  only visible in a new interrupt ISA mode. The advantage is the pipeline can 
  treat this as a regular instruction fetch, albeit with a different encoding.
* Would like to allow each interrupt to be configured with its privilege mode 
and the 'interrupt level' which describes the preemption level, and a 
priority.
* To manage preempted context state it's necessary to push/pop 
mepc/mpp/mil/mie to a memory stack. You also need to remember the previous 
interrupt level, 'mil'. Now multiple levels must be tracked, which Krste 
proposes could be stored in mcause.

## RISC-V DSP (P) extension proposal: Chuan-Hua Chang
* P extension task group will define and ratify a packed-SIMD DSP extension 
containing instructions which operate on XLEN-bit integer registers. It will 
also define compiler intrinsic functions that can be directly used in 
high-level programming languages.
* The initial proposal is based on the AndeStar V3 DSP ISA.
* Supports e.g. 16-bit SIMD instructions with min, max, abs, compare, clip 
operations. Similar for 8-bit SIMD.
* GPR-based SIMD is more efficient for various embedded domains. It addresses 
the need for high performance generic code processing as well as digital 
signal processing.
* Want to make this easy to use through intrinsic functions and optimised DSP 
libraries.
* For 64-bit data types, use pairs of GPRs on RV32. An implementation could of 
course still use a 2R1W register file, but use multiple cycles to read a 
64-bit value.
* After the task group is created, bi-weekly meetings will be set up.

## Security task group update: Richard Newell
* The security group was previously a task group of the technical committee.
There is now a new security standing committee, at the same level with the 
marketing and technical committees.
* Task groups will be set up to look at cryptograpshic ISA extensions and 
trusted execution environments for microcontroller
* The full charter will be published on riscv.org

## Formal assurance for RISC-V implementations: Daniel M. Zimmerman
* Galois started with a focus on cryptography, but has broadened its scope to 
"high assurance everything"
* There are a range of definitions for RISC-V. The human-readable instruction 
manual, mechanisations in the form of software simulators or hardware 
implementations. The formal model working group have also been working on 
this.
* How can we provide assurance about these definitions / mechanisations?
* Assurance means: the system does what it is supposed to do and doesn't do 
anything else.
* When trying to get assurance through compliance tests, a huge burden is put 
on the shoulders of the test writers. Those conformance tests need to be 100% 
complete. This also doesn't help determine if an implementation has 
undesirable behaviours.
* Alternatively, formally verify your system. Compile a model to RTL via 
clash, then use equivalence checking tools to compare against your own 
implementation.
* Need machine-readable specification of the correctness and security of an 
implementation as well as a way to measure the conformance of an 
implementation.
* How to validate a specification?
  * Might perform rigorous validation through execution: ad hoc testing, 
  simulation coverage analysis, or bisimulation.
  * Alternatively perform rigorous verification through formal reasoning: 
  prove test benches always pass, verification coverage analysis, or 
  bisimulation.
* Security properties require a different approach. They typically have a 
different form, e.g. "the following property must never hold". Galois is 
developing a DSL that lets you specify the architecture, correctness 
properties and security properties of a hardware design. It's also working on 
a security test suite.
* Want to help systems engineers understand and explore the effects of design 
and implementation decisions on power, performance, area, and security.
* Status
  * LANDO DSL is in early stages of development. Expect initial version before 
  2018 RISC-V summit
  * Security test suite: early stages of development
  * Metrics and measures: evaluating existing tools for PPA and looking at 
  existing metrics work for security
  * Dashboard: early stages of design
  * Feature model generation: early stages of design

## Undefined, Unspecified, Non-deterministic, and Implementation Defined Behavior in Verifiable Specifications: Clifford Wolf
* Users of an ISA specification
  * Software engineers: just don't do anything that's not specified
  * Software security engineers: what can we expect from the hardware if we do 
  the thing that wasn't specified?
  * Hardware design engineers: do something safe and simple for anything not 
  specified. But what does safe mean?
  * Hardware verification engineers
* This presentation is a taxonomy of types of 'not specified' behaviour, using 
nomenclature taking from different domains.
* Undefined behaviour: the "just don't do that" approach to not specifying 
behaviour. The spec is void for any program as a whole if it does this 
undefined behaviour once.
* Could introduce an 'undefined value', but that has similar issues
* Non-deterministic behaviour / unpredictable behaviour: allow more than one 
choice, which may change under re-execution
* Unspecified value: the instruction will return a value, but the spec doesn't 
say which value
* Implementation defined behaviour / value: similar to unspecified value / 
behaviour, but the implementer must specify what it is.
* Fully specified behaviour: the ideal choice for verification. Explicitly 
state what all implementations must do.
* Clifford strongly prefers implementation defined or fully specified 
behaviour.

## Foundational HPC systems in 2020 and beyond: Steven Wallach
* Architecture 1.0 (see Mark Hill paper). The world was very 
processor-centric. CPUs with memory attached.
* Architecture 2.0. Not just the ISA. Move towards memory-driven computing.
  * Numerical processing is trivial, but achieving efficient memory access is 
  very hard.
  * Caches now need to be protected machine state.
* An RV128 working group is going to be started, chaired by Steven
  * Propose a 64-bit object ID and 64-bit byte offset.
* On an RV128 system, have to be able to execute RV64 programs and map 64-bit 
virtual into 128-bit virtual. Also map system calls.
* Object 0 is kernel object, object 1 RV64, object 2 RV32.
* Encrypted memory is identified with an object ID
* Steven suggests disabling speculation if kernel objects are referenced.

## European processor initiative and RISC-V: Mateo Valero
* BSC-CNS is a consortium including the Spanish government, Catalan 
government, and UPC
* Now have 529 people from a wide range of countries.
* Need to reach 50GFlops/W
* MareNostrum 4 has been recognised as the "most beautiful datacenter in the 
world". Total peak performance is 13.7 PFlops
* USA, Japan, China are all building huge supercomputers with domestic 
technology. Can the EU do the same?
* The EU has a large HPC ecosystem and a number of centers of excellence in 
HPC applications.
* Through the Mont Blanc project, proposed the use of ARM processors in 
supercomputing applications. Extended current mobile chips with HPC features.
* Europe has only 4 machines in the world top 20.
* With Brexit and Softbank, ARM is not 'European' any more.
* Through EuroHPC, the Commission has proposed to invest 1B.
* The European Processor Initiative is a consortium consisting of 23 partners.
They will form the company 'EPI Semiconductor' which will produce the EPI 
common platform. Now looking at growing the consortium, including companies 
from other countries.
* Three streams
  * General purpose and common platform. ARM SVE or other candidates. BULL 
  will be system integrator / chip integrator.
  * Accelerator: RISC-V
  * Automotive
* RISC-V accelerator vision: throughput-oriented designs, lower power, 
supporting MPI+OpenMP

## Securing High-performance RISC-V Processors from Time Speculation: Chris Celio
* Meltdown and Spectre don't just impact a single processor design or a single 
company's design, but really impact any CPU using speculation.
* A timing attack is when a change in your program input affects the time of 
another user.
* There are 3 parts to a timing attack
  * Victim runs code that leaks observable side effects
  * Attacker runs code affected by timing leaks
  * Attacker measures time his code took to run
* Chris built up a taxonomy of time leaks. Two axes: were are we leaking from, 
and what are we directly leaking.
* High level ideas:
  * Don't leak any observable side-effects in the machine if speculation is 
  aborted
  * Avoid bandwidth interference between different time domains. Depending on 
  the time domain you care about, this could be bandwidth to a functional 
  unit.
* Modern speculative cores have 100-300 instructions in-flight, but not all 
are speculative. About 25% are beyond the point of non-return.
* Idea: do not update predictors speculatively.
* Idea: Don't speculatively update the cache. Could get rid of fully inclusive 
L1/L2/L3 caches in favour of neither exclusive nor inclusive (NENI) caches.
Then allocate only into the L1 cache.
* Idea: misspeculation recovery should be deterministic. Any shared resource 
can leak time
* Idea: partition caches etc
* Idea: dynamic partitioning
* Idea: partial and full flushes. e.g. flush 1/4 BTB entries.
* Many other ideas (see the full list in the slides!)

## Evaluation of RISC-V for Pixel Visual Core: Matt Cockrell
* Background: the Pixel Visual Core is a Google-design Image Processing Unit 
(IPU). It has a dedicated A53 which aggregates application layer IPU resource 
requests.
* Looking at adding a microcontroller as a job scheduling and dispatch unit.
* When selecting a core, key considerations were: level of effort (how 
difficult to integrate), risk (stability and reliability of support), and 
license.
* First candidate was the internal 'Bottle Rocket' project. This implements 
RV32IMC, reusing parts of the Rocket design. High level of effort, medium 
risk.
* Second candidate: Merlin (github.com/origintfj/riscv). Low level of effort, 
high risk.
* Third candidate: RI5CY, produced by the PULP team. Low level of effort, 
medium risk.
* Selected RI5CY for a number of reasons: it had been taped out, had good 
infrastructure, the license was acceptable, and it was implemented in 
SystemVerilog rather than Chisel.
* Why SystemVerilog rather than Chisel?
  * SystemVerilog builds on established physical design and verification flows
  * Chisel generated verilog loses designer's intent, making it difficult to 
  read and debug
  * Chisel generated code makes certain physical design items difficult such 
  as sync/asnc clocks, power domains, clock domains etc
* Next steps: add full compliance for privilege/debug specification and 
evaluate performance impact after adding RI5CY to the Pixel Visual Core.

## Linux-Ready RV-GC AndesCore with Architecture Extensions: Charlie Su
* The AndeStar V5 architecture adopts RISC-V and adds pre-defined useful Andes 
extensions as well as custom-extension frameworks for domain-specific 
acceleration.
* Baseline extension instructions
  * Memory access and branches with fewer instructions
  * Code size reduction on top of C extension ('CoDense')
  * DSP/SIMD (see P extension proposal)
  * Custom instructions
  * CSR-based extensions that don't require new instructions. e.g. stack 
  protection mechanism, power management, ...
* Delivered 32-bit and 64-bit implementations of the V5 architecture 
implementation AndeStar V5m which is a superset of RV-IMAC.
* An N25 (32-bit) small configuration is 37k gates at 28HPC, 1GHz. Large 
configuration is 159k gates.
* Introducing new 25-series cores adding floating point support (N25F/NX25F), 
MMU, and S mode (A25/AX25).
* 3.49CM/MHz
* Added hit under miss caches and hardware support for misaligned accesses
* Use single-port SRAMs to reduce area and power
* COPILOT tool allows auto-generation of development tools for a set of custom 
extensions.
* Software
  * Worked with Express Logic to port 64-bit ThreadX
  * Added support for AX25 to QEMU
  * Working on adding further component support for Linux: u-boot, ftrace, 
  loadable modules, Linux perf.
* openSUSE is helping to enable their 'EBBR' specification for RISC-V

## Processor trace in a holistic world: Gajinder Panesar
* Understanding program behaviour in complex system isn't easy, and using a 
debugger isn't always possible. Processor Branch Trace can provide visibility 
into program execution.
* Processor Branch Trace works by tracking execution from a known start 
address and sending messages about the deltas taking by the program. For 
uncoditional branches, there is no need to report the destination address.
* The trace encoder ingress port defines singles to export from the processor.
It contains information such as the privilege mode, address of the 
instruction, the instruction.
* The trace encoer sends a packet which could contain a delta update with a 
subset of information, or a full context to force synchronisation.
* Trace control can control when a trace is generated, or configure filters.
* Saw a mean 0.252 bits/instruction encoding efficiency across a range of 
benchmarks.
* Next steps: set up task group to standardise processor to encoder interface 
and a compressed branch trace format

## RISC-V meets 22FDX. An open source ultra-low power microcontroller for advanced FDSOI technologies: Pasquale Schiavone and Sanjay Charagulla
* PULP was design for near sensor (aka edge) processing.
* Seen a range of contributions since open sourcing from e.g. Embecosm, 
lowRISC, Micron, Google, ...
* PULPissimo has a rich set of peripherals: QSPI, HyperRam+HyperFlash, camera 
interface, I2C, I2S, JTAG, ... Plus an autonomous IO DMA subsystem (uDMA)
* Implements an efficient low-latency interconnect.
* Used a RI5CY core plus extensions: packed SIMD, fixed point, bit 
manipulation, hardware loops. Included a IEEE 754 single precision floating 
point unit.
* 2.3mm2, effective area 1.22mm2. Most of the area taken by memories.
* 40MOPS/mW at 350MOPS. 1.4x better performance and 4x better energy 
efficiency than previous design in 40nm
* Can further reduce power to 65MOPS/mw at 350MOPS when executing just from 
SCM.
* Global Foundries produce up to 10M wafers / year (200mm equivalents)
* GF has a dual-track roadmap. Performance optimized FinFET and power 
optimized FD-SOI.
* FDXcelerator is accelerating RISC-V developers and partners. Partners 
include SiFive, Andes, Reduced Energy Microsystems, ...
* This is the first step towards silicon-qualified free-open-source RISC-V IPs 
on GF FDX22 process

## Ariane. An Open-Source 64-bit RISC-V Application Class Processor and latest improvements: Florian Zaruba
* Ariane is a Linux-capable 64-bit core
* M, S, U privilege modes. TLB. Tightly integrated D$ and I$, hardware page 
table walker
* Area around 185kGE
* Greater than 1.5GHz at 22FDX
* Critical path is 25 logic levels
* 6 stage pipeline. In-order issue, out-of-order writeback, in-order commit
* Why develop another core?
  * Don't want an SoC generator. Don't want to be governed by a 3rd party
* First implementation took about 4 months
* Designed for higher performance in the future: dual issue and/or OoO issue
* Verification strategy
  * RISC-V tests
  * Torture test framework
  * Running applications on FPGA e.g. bootling Linux
  * Verification isn't exhaustive, looking into more alternatives
* Ariane was open-sourced in February 2018. Already seen non-trivial external 
contributions.
* Latest improvements:
  * Completely revised instruction frontend.
  * Re-naming in issue stage
* Return address stack cost ~1KGE, improves IPC by 20%. Resolving 
unconditional jumps immediately increases IPC by ~11%. These changes had no 
negative impact on timing.
* Critical paths are on the memory interfaces, especially tag compare and 
address translation for cache access.
* Kerbin is a proof of concept SoC for Ariane featuring PULP peripherals, a 
64-bit interconnect and debug support.
* Compatible with gdb, but require a debug bridge currently.
* Managed to boot Linux after 5 months development
* FPGA: Targeted the VC707. Core runs at 50-100MHz, 15kLUTs.
* Ariane has been taped out in GF22FDX. 910MHz, ...
* Working on Kosmodrom tapeout which includes a high performance and a low 
power version and a floating point accelerator.
* Working on supporting F and D extensions as well as reduced prevision vector 
operations. Stand-alone floating point unit (~200kGE) will be released in the 
next months.
* Also working on improved integer divider, vector unit, and hardware support 
for atomic memory operations
* Help wanted: support for official RISC-V debug, improved branch predictors, 
multithreading, cache-coherent interconnect, ...

## RISC-V support for persistent memory systems: Matheus Ogleari
* (Missed the first few minutes I'm afraid)
* RISC-V changes: introduce new instructions. ucst (uncacheable write to 
memory), ucld (uncacheable read from memory)
* Also modify the cache controller and memory controller
* These changes would enable new applications. Even defining the instructions 
would allow people to start work using software simulation tools.

## The hybrid threading processor for sparse data kernels: Tony Brewer
* Sparse data sets that greatly exceed a processor's cache size are a 
challenge for most systems. The cache hit rate is low resulting in idle cores.
* The Hybrid Threading Processor defines extensions for thread and message 
management. It's a high thread count barrel processor similar to Cray's MTA 
architecture.
  * Software-managed coherency
  * Event driven processor.
* Can perform atomic operations at memory due to the software-managed 
coherency
* The project was funded under the DARPA CHIPS project. This produced two 
chiplets: the memory controller (MC) chiplet and compute near memory (CNM) 
chiplet.
* Implemented a simulator modelling functionality and performance, and also 
performed power estimation.
* Performed a sensitivity analysis to determine the optimal configuration.
* Compared performance for graph spectral clustering vs Haswell, Nvidia K80, 
Nvidia DGX-1. Saw ~25x better energy efficiency.

## How PULP-based platforms are helping security research: Frank Gurkaynak
* Security of the system is not limited to just "one part". You need to 
consider the entire system
* An open approach has proven useful for security in software. Why should 
hardware be any different?
* Cryptographic accelerators can easily achieve high throughput with low area.
* PULP provides multiple opportunities to add extensions. e.g. new 
instructions added directly to the core, adding peripherals to the bus, or 
hardware accelerators with direct memory access
* Implemented Fulmine, an IoT processor with accelerators. Added two TCDM 
ports, 64bits/cycle. The AES unit performs 2 rounds a cycle, 1.76Gbit/s and 
120pJ per byte (entire chip) at 0.8V and 84MHz
* Side channel attacks are a huge challenge. Recently implemented a leakage 
resilient accelerator which reduces the attack surface by generating a new key 
per data block. This provides 5.29Gbit/s throughput at 256Mhz
* Attacks that target control flow are a serious problem and can be realized 
in both hardware (e.g. glitching) or software. Implemented and published 
sponge based control-flow protection (SCFP), which stores instructions 
encrypted in memory. As instructions must be decrypted, the attacker would 
have to modify both the instruction and the internal state.
  * Implemented in Patronus chip. 25-35% power/area overhead, and 10$ runtime 
  overhead due to 'patches' and additional commands.
  * The probability of an illegal instruction trap when an instruction altered 
  is 91.51% within 1 cycle rising to 99.95% within 3 cycles.

## RISC-V virtual platforms for early RISC-V embedded software development: Kevin McDermott
* New markets have new software requirements
* Virtual platforms can help accelerate software development
* Imperas produce extendable platform kits (EPKs). These are virtual platforms 
with software set-up, allowing users to start quickly.
* Offer the ability to easily define custom instruction extensions
* Can also perform software development using the Ashling RISC-V IDE

_Alex Bradbury_
