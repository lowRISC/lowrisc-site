+++
Description = ""
date = "2016-11-29T15:10:00+00:00"
title = "Fifth RISC-V Workshop: Day One"

+++
The [fifth RISC-V 
workshop](https://riscv.org/2016/10/5th-risc-v-workshop-agenda/) is going
on today and tomorrow at the Google's Quad Campus in Mountain View. I'll be 
keeping a semi-live blog of talks and announcements throughout the day.

## Introduction: Rick O'Connor and Dom Rizzo
* This workshop is yet again bigger than the last. 350+ attendees, 107 companies, 29 universities.
* The next workshop will be May 9th-10 in Shanghai, China.

## RISC-V at UC San Diego: Michael Taylor
* Startup software stacks today look a light like an iceberg. A small amount 
of 'value-add' at the top, and a huge stack of open source underneath.
* How do we build the equivalent for hardware, the fully open source ASIC 
stack?
* Need core IP, IO pads, standard cells, PLLs, high speed I/O, tools, BGA 
packages, PCB design, firmware etc
* basejump aims to provide a 'base class' for cheap hardware development. It 
includes a standard library of components, an open source package design, and 
an open source motherboard
* `bsg_ip_cores` aims to be like C++ STL, but for SystemVerilog
* BSG Ten is a recent design featuring 10 RISC-V cores that will be taping out 
before the end of the year on a TSMC shuttle run.
* Aim for 100% of the design will be open, including design files for the 
chip, PCB, BGA package, firmware.
* BSG Ten has its own 5-stage RV32IM pipeline
* Also working on 'Certus', a 16nm TSMC design featuring Rocket cores, a 
neural network accelerator, and the BSG I/O infrastructure.
* Suggestion: RoCC interface should be wired to the toplevel of the Rocket 
hierarchy
* Suggestion: The RISC-V community should have at least yearly stable 
end-to-end releases of full RISC-V stacks (Linux to Verilog)

## Updates on PULPino: Florian Zaruba
* Imperio is the first ASIC implementation of PULPino, done in UMC 65nm.  
Speed: 500MHz.
* Area is 700kGE for the SoC and 40kGE for the core (1kGE = 1.44um2).
* What is PULP? Parallel Ultra Low Power (platform).
* PULPino is a much simplified version of PULP, featuring just 1 core, reduced 
interconnect and simplified cache design.
* Have hardware loops, post-incrementing loads and stores and SIMD instruction 
extensions.
* Over 20 companies and research institutes are using PULPino
* PULPinov2 is targeted for Q12017. This features support for Verilator 
simulation, IP-XACT description, new peripherals (uDMA), new streamlined event 
unit, SDK, updated compiler, and improved documentation and tutorials
* In the future, want to work on a secure PULPino capable of running SeL4
* Working on a 10kGE or less RISC-V core. Evaluating 1 and 3-stage pipeline 
designs.
* Want to explore heterogeneous configurations, featuring FPU and 
accelerators.
* Find out more at the [PULP website](http://www.pulp-platform.org).

## SiFive FE310 and low-cost HiFive1 development board: Jack Kang
* SiFive is a fabless semiconductor company. Their business model is to build 
custom SoC designs for their customers. Customers give specs and/or IP and 
SiFive deliver packaged, tested chips.
* Although a commercial company who may offer commercial licenses, they are 
committed to updating the open source rocket-chip implementation.
* RISC-V chips are here: the Freedom E310. This features an RV32IMAC core.  
320MHz+ on TSMC180G. 1.61DMIPS/MHz, 16K L1 I$, 16K data scratchpad, multiple 
power domains (supports low power standby). Comes in a 6x6 48-pin QFN
* Claim to be 9x more power efficient than Intel Quark and 2x more power 
efficient than the ARM Cortex M0+.
* The HiFive 1 is an Arduino compatible board for this chip. The board design 
and SDK is/will be open source. It's now up on 
[CrowdSupply](https://www.crowdsupply.com/sifive/hifive1). $59 will get you 
one board.
* The RTL for their implementations presented at the last RISC-V workshop are 
now open source and [up at GitHub](https://github.com/sifive/freedom).
* Question: how much (ballpark) might it cost to get 100 prototype chips? For 
Freedom Everywhere (microcontroller), looking at less than $100k depending on 
the level of customisation needed.
* Question: what is the plan for getting the SiFive chips to be competitive 
with the Cortex-M4 and other designs from ARM? Answer: this will come in time 
with custom instructions, custom accelerators etc. The ability to customise 
will result in better performance/watt than any off the shelf solution.

## Rapid silicon prototyping and production for RISC-V SoCs: Neil Hand
* Need to support rapid evolution of IoT designs.
* IoT class designs can be achieved in tens of k$.
* All standards based, but not open source
* A standard cell ASIC is typically 52-78 weeks, compared to 10 weeks for a 
Baysand Metal configurable standard cell.
* Codasip have 3-stage and 5-stage implementations RISC-V implementations. The 
slide compares gate count and frequency vs Rocket and ZScale (watch out for 
the slides to be posted, I didn't get a chance to jot down the numbers)
* Have a story for easy extensibility, adding new instructions and having a 
new SDK etc generated.
* UltraSoC provides debug
* LLVM is the glue that holds the solution together. They generate an LLVM 
compiler based on their processor model and any customer-defined extensions.
* A test chip will be taping out very soon. Also exploring general 
availability for a dev-board
* They are developing their own alternative to QEMU for their customers with a 
non-copyleft license.

## Extending RISC-V for application-specific requirements: Steve Cox
* Sometimes a pre-defined ISA is insufficient. May require an 
application-optimised ISA. e.g. the Google TPU
* ASIP designer is a tool for automating ASIP design. The process can start 
with a pre-existing example model, e..g RISC-V
* ASIP designer has been used in more than 250 unique SoC products
* The speaker gives an example of a header compression accelerator. Start with 
a simple 3-stage RV32IM core. This is 24.5k gates on TSMC 28HPM at 500MHz and 
32GPRs.
* First, consider instruction level parallelism. e.g. switching to a 2-slot 
VLIW. This reduced cycle could by 21% and increased gate count by 31%.
* Next, try adding application-specific instructions. This reduced the code 
size by 56%, cycle count by 67%, and added 9% to the gate count (compared to 
the original baseline).
* Next, try adding a compare immediate and branch instruction. This reduces 
code size by 8% and cycle count by 18% vs the previous result.

## A memory model for RISC-V: Muralidaran Vijayaraghavan
* Why not SC/TSO? Simple implementations have low performance.
* Why not the POWER/ARM models? Expose too many microarchitectural details and 
their axiomatic models are too complex
* Why not RMO? The dependency requirements are too strict
* Want a simple specification with the inclusion of sufficient fences to force 
sequential consistency behaviour when necessary
* Which is why they've introduced WMM: which has a simple operational 
specification like SC, TSO.
* WMM introduces the conceptual device of an invalidation buffer. This holds 
stale values that may be read by a future load.
* WMM has reconcile fences (clears the invalidation buffer) and commit fences 
(flushes the store buffer).
* All instructions are committed in order, so stores cannot overtake loads.
This prevents 'out of thin air' generation of values
* A write -back coherent cache hierarchy is typically global store atomic. SMT 
cores with L1 write-through caches aren't, so don't do it.
* Mapping C++11 atomic operations to WMM is straight forward
* Question: what is the difference to the programmer vs TSO? Answer: you would 
have to put a reconcile fence whenever you require load/load ordering

## A Memory Consistency Model for RISC-V: Caroline Trippel
* Princeton have been working on memory consistency model verification. This 
resulted in PipeCheck and CCICheck. Then implemented ArMOR, which worked to 
more precisely define memory models. COATCheck looks at how e.g. instructions 
that are executed as a result of page table walks interact with the memory 
model. Finally, TriCheck helps to verify the lowering of e.g. C++11 atomic 
constructs to the ISA level, as well as checking the ISA memory model and 
hardware memory model.
* Have identified and characterised flaws in the current RISC-V memory model 
specification (ASPLOS'17).
* Two broad categories of memory model relaxation. Preserved program order 
(defines program orderings that hardware must preserve by default) and store 
atomicity (defines the order in which stores become visible to cores).
* Propose tighter preserved program order and non-multi-copy store atomicity.
* Why allow non-multiple-copy atomic stores? Commercial ISAs e.g. ARM, Power 
allow this, and RISC-V is intended to be integrated with other vendor ISAs on 
a shared memory system.
* Want preserved program order to require same address read-read ordering
* Want PPO to maintain order between dependent instructions
* TriCheck compares high level language outcomes to ISA-level outcomes for a 
spectrum of legal ISA microarchitectures
* The currently document RISC-V memory model lacks cumulative fences, which 
are needed for C/C++ acquire/release synchronisation
* They have formulated an english language diff of the current spec with 
proposed changes, but are also working on a formal model.

## Trust, transparency and simplicity: Eric Grosse
* Know your adversary. Many of them might sometimes be your partner as well as 
your adversary (e.g. state actors). Notably, seems to be fairly little in the 
way of advanced corporate espionage from other companies.
* Fix 1: secure communications. SSL, PGP etc
* Fix 2: authentication. e.g. two-step authentication, hardware security 
devices
* Fix 3: stay up to date with patches
* The disclosure process in the hardware community is dramatically different 
than software. e.g. rowhammer was known to some hardware vendors well before 
the public disclosure.
* Long standing practitioners' wisdom: "Complexity is the enemy of security"
* Modern systems aren't just incredibly complex, they're also largely 
undocumented.
* A paranoid's choice of CPU? x86 with Qubes-OS on a NUC kit. Or Coreboot, 
u-root on Asus KGPE-D16 motherboard
* For RISC-V, you have the critical advantage of openness - be sure to keep 
it. Please resist adding features lightly, or else consider removing others in 
compensation. Also consider a CHERI security extension, or tagged memory

## RISC-V Foundation update: Rick O'Connor
* Rick gives another overview of the RISC-V Foundation, and reiterates that 
RISC-V is not an open source processor core but an open ISA specification. The 
Foundation will encourage both open source and proprietary implementations
* Every year at least two RISC-V Foundation board seats will be up for 
election.
* It's likely the end of year workshop each year will be in Silicon Valley, 
and the Spring/Summer workshop will move locations around the year
* The board of directors was formed in Q2 2016, and the technical and 
marketing committees were formed in Q3 2016.

## RISC-V Marketing Committee update: Arun Thomas
* The marketing committee mission: grow RISC-V mindshare and grow the RISC-V 
community
* Activities include organising RISC-V workshops and tutorials, and RISC-V 
participation at industry events
* Want to help create RISC-V educational materials for industry practitioners, 
researchers, and university students
* The marketing committee has several task groups: RISC-V workshops, outreach, 
RISC-V content (creating riscv.org content and educational and marketing 
materials), and member content (promoting content from RISC-V Foundation 
members)
* David Patterson announces both of his textbooks will have RISC-V editions

## RISC-V Technical Committee update: Yunsup Lee
* Immediate goals:
  * Maintain a roadmap of the RISC-V ISA
  * Provide and maintain a golden simulator for the RISC-V ISA
  * Provide and maintain a set of verification/validation tests to ensure 
  conformance
  * To upstream software development tools (compiler, debugger etc)
  * To maintain and update a list of hardware implementations of the 
  architecture
* Longer term goals
  * Establish processes to define and standardise future ISA extensions
  * Provide guidelines for platform integration
  * Set up program committees for future RISC-V workshops
* Task groups: opcode space management, privileged ISA specification, formal 
specification, debug specification, security, vector extensions, software 
toolchain
* By Feb, debug spec will be ratified by the foundation, calling convention 
fixed and documented, ELF format fixed and documented, priv-1.10.0
* By November, ratify vector extension
* Formal specification task group: Formal models written in L3, BSV and in Coq

## Free Chips Project: Yunsup Lee
* A plan to launch a not-for-profit for hosting open-source RISC-V 
implementations, tools, and code
* SiFive loves open source, believes it is essential to their mission.
* The rocket-chip generator has had almost 4000 commits. 40% of all commits so 
far come from SiFive
* SiFive contributions to the rocket-chip repository are made under the Apache 
v2 license.
* SiFive added RV32I+M/A/F support, compressed support, blocking data cache, 
and data SRAM options
* SiFive will publish a TileLink specification
* SiFive recently implemented a library 'Diplomacy' for parameter negotiation.
Also added multi-clock support, clock crossings, and asynchronous reset flops
* The SiFive blocks repository contains low-speed peripherals like SPI, UART, 
PWM, GPIO, PMU. These are written in Chisel with TileLink interfaces. It also 
includes wrappers for high-speed Xilinx FPGA peripherals
* The SiFive Freedom repository has submodules for rocket-chip and 
sifive-blocks and top-level SoC integration glue code
* The Free Chips project has a mission to be a home for open-source codebases 
to enable faster, better, cheaper chips. It will sustain and evolve 
open-source software tools and HDL code for SoC design. It will ensure free 
and open contributions are available to all of the SoC design community. It 
will manage publicly accessible, online repositories of source code, 
documentation and issues

## 128-bit addressing in RISC-V and security: Steve Wallach
* Aim for programming generality. Might have to recompile, but don't want to 
have to restructure your software.
* Computer virtual addresses span to local disk only, while other identifiers 
such as MACs, URLs, IPv6 are globally unique. What if one unified name 
structure could be developed?
* RV128I strawman. 64-bits are used for an object ID, and the other 64 bits 
used for a byte offset.
* The object ID is a software or hardware structure considered to be worthy of 
a distinct name
* Protection and memory management are independent
* The machine that is simplest to program wins. User cycles are more important 
than CPU cycles

## The challenges of securing and authenticating embedded devices: Derek Atkins
* Why not just use symmetric encryption e.g. AES to secure your devices? It's 
hard to deploy and it doesn't scale (either have one key for many devices or a 
database of a huge number of keys)
* Why do people think public key won't work? They think it's too big, too 
slow, or too power hungry.
* Many of these beliefs are true, e.g. ECC execution time on Cortex-M ARM 
cores is 233-1089ms. Implementations range in 8-30KB of ROM and require 
800-3000B of RAM. Hardware implementations are faster, but take a lot of 
gates. RSA and Diffie-Hellman are larger and take longer
* Fundamentally these overheads are there because a large number of 4086 bit 
numbers are multiplied
* Group theoretic cryptography (GTC) offers a potential answer. Complexity 
scales linearly with security instead of quadratically like RSA, ECC etc
* GTC can work with just 6-8 bit math
* The Ironwood Key Agreement Protocol enables two endpoints to generated a 
shared secret over an open channel. The Walnut digital signature algorithm 
allows one device to generate a document that is verified by another.
* When comparing WalnutDSA on a Rocket core, it compared very favourable to 
microECC. 4.9ms run-time vs 2110ms (458ms with multiply/divide).
* WaltnutDSA written in RISC-V assembly achieved a 3.0ms run time
* The C implementation currently runs faster on the ARM Cortex-M3

## RISC-V with Sanctum Enclaves: Ilia Lebedev
* Today privilege implies trust (e.g. a hypervisor is privileged and so must 
be trusted). Sanctum decouples hardware protection from trust
* Sanctum uses hardware-assisted isolation, offering strong privacy and 
integrity with low overhead
* In remote software attestation, a trusted remote piece of hardware might 
measure (hash) and sign the software that is running. The remote user can then 
decides where to trust the certificate or not. Claim that prior work included 
too much software in their attestation
* Intel recently introduced SGX, which allowed a process to be placed in an 
enclave. It aims to protect privacy and integrity of an enclave against a 
privileged software adversary. It also protects against some physical attacks, 
or instance by encrypting DRAM contents
* There have been a number of side channel attacks demonstrated against SGX.  
e.g. dirty bits on page tables, or cache timing attacks
* Sanctum aims to protect against indirect tacks (such as cache timing 
attacks) as well as the direct attacks covered by SGX. It does not protect 
against physical access or fault injection
* With Sanctum, the device manufacturer acts as a certificate authority
* Sanctum has a small software TCB, a ~5KLoC machine-mode security monitor
* The reference Sanctum implementation was built on the Rocket RISC-V 
implementation
* Enclaves execute on private cores. i.e. it will never share L1 caches, 
register, branch target buffer, TLB
* Sanctum also isolates physical memory. DRAM regions are defined, which are 
non-overlapping regions of memory assigned to certain enclaves
* To isolate enclaves in the last level cache, allocate exclusively at a 
region granularity (see the slides and/or the Sanctum paper for a description 
of exactly how this works)
* To provide hardware-assisted isolation, always maintain the invariant that 
entries in the TLB are safe and necessary invariants were checked while 
performing the page walk
* Very small hardware overhead (50 gates for LLC address rotation, 600 gates 
for DMA whitelist). Roughly 2% area increase in total. Roughly 6% performance 
overhead in measurements

## Joined up debugging and analysis in the RISC-V world: Gajinder Panesar
* Need a vendor-neutral debug infrastructure, enabling access to different 
proprietary debug schemes used today by various cores
* Need monitors into interconnects, interfaces, and custom logic which are 
run-time configurable with support for cross-triggering
* UltraSoC provides silicon IP and tools for on-chip debug
* As an example, consider a software-defined radio chip. Might want to track 
CPU cycles spent on compute vs cache stalls. Or you might track utilised DDR 
bandwidth over time.
* UltraSoC monitors are non-intrusive by default
* Has a portfolio of 30 modules. e.g. bus monitors, communications

_Alex Bradbury_
