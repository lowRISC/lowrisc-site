+++
Description = ""
date = "2018-05-08T07:00:00+00:00"
title = "Barcelona RISC-V Workshop: Day One"

+++
The [eighth RISC-V 
workshop](https://riscv.org/2018/04/risc-v-workshop-in-barcelona-agenda/) is 
going
on today in Barcleona. As usual, I'll be keeping a semi-live blog of talks and 
announcements throughout the day.

Follow [here]({{< ref "blog/barcelona-riscv-workshop-day-two.md" >}}) for the 
day two live blog.

Note that slides from most presentations are now [available at 
riscv.org](https://riscv.org/2018/05/risc-v-workshop-in-barcelona-proceedings/).

## Introduction: Rick O'Connor
* This workshop has 325 attendees representing 101 companies and 25 
universties. Largest outside of Silicon Valley.
* Rick gives the usual overview of the RISC-V Foundation structure.
* The RISC-V Foundation currently has over 150 members, including invidual 
members. These members are distributed across 25 countries around the world.

## RISC-V state of the union: Krste Asanovic
* Krste gives an overview of the RISC-V ISA for newcomers.
* RISC-V encoding terminology.
  * Standard: defined by the Foundation
  * Reserved: Foundation might eventually use this space for future standard 
  extensions.
  * Custom: Space for impelmenter-specific extensions, never claimed by 
  Foundation.
* The RISC-V big tent philosophy: enable all types of RISC-V implementation, 
from 32-bit microcontrollers with 1KiB SRAM up to 64-bit Unix servers with 
virtualisation or 128-bit 100k-core supercomputer with PiBs DRAM, open or 
proprietary business models, non-conforming extensions, software 
implementations (e.g. QEMU), ...
  * Minimize wasted work through maximum reuse. Factor out platform-level 
  requirements from reusable ISA and software modules
  * Use standard platform profiles to reduce ecosystem effort.
* A system is minimally RISC-V-ISA-compliant if it runs claimed RISC-V 
unprivileged code correctly. e.g. gcc-compiled RV32IMAC functions work 
correctly. Platform must support loading program, returning result etc.
* One set of unprivileged ISA compliance tests should be able to run on any 
platform. There is a challenge here in handling tiny platforms, e.g. 1KiB 
SRAM.
* A platform specification provides tight constraints on system configuration 
and options to support a software ecosystem.
  * It provides an interface between platform hardware and software, including 
  privileged levels.
  * Avoid unnecessary duplication. Where it's possible to define a common 
  standard, do so.
  * Platform compliance tests will be built in collaboration with the relevant 
  ecosystem. e.g. server platform compliance, ZephyrOS platform compliance.
* Software is king in the RISC-V land
  * ISA extensions need compiler/linker/library support
  * There's no point adding instructions if no software wants to use it.
  * ISA proposals should be sensible to implement.
  * Finished now is better than perfect sometime. But at the same time, 
  shouldn't rush to freeze a spec before it's ready.
* Open-source hardware vs software
  * Some lessons from the free/open source software community apply, but many 
  things are different. e.g. very large investments in hardware that cannot be 
  changed once manufactured, threat of patent lawsuits
* Major milestones in 2017
  * Fixed holes in user ISA, no changed now in IMAFDQC
  * Froze priv-1.10 spec. Updates must be backwards compatible
  * Memory model work
  * Linux ABI frozen
  * Debug spec completed
* 2018 initiatives
  * Working to prepare the base ISA for ratifications
  * Formal spec in progress
  * Hypervisor spec done, need implementations
  * Crypto in progress
  * J (dynamic translation / runtimes) in progress
  * Packed SIMD in progress
  * Security task group ongoing
  * Fast interrupts started
  * Trace started
  * Krste comments it may take longer to finish these things vs comparable 
  industry projects.  Have many more stakeholders giving input.
* 2018 embedded platform
  * New ABI for embedded (e.g. long double = 64bit)
  * Build on RV32E
  * compiler/library work for improved code compression
* RISC-V and security
  * Set up security standing committee. Chaired by Helena Handschuh (Rambus), 
  vice-chair Joe Kiniry (Galois Research).

## The state of RISC-V software: Palmer Dabbelt
* Palmer shows a picture of Xorg with web browser, terminal, webcam, and a 3d 
video game all running on a RISC-V core (SiFive Unleashed with Microsemi 
add-on board).
* GNU-based toolchains
  * binutils, gcc, glibc, newlib all upstreamed.
* The RISC-V Linux kernel port was upstreamed in January 2018. It only 
supports RV64I systems for now, and is currently missing some platform 
drivers. Help would be welcomed in getting these upstream.
* RISC-V Fedora and Debian support is in progress
* RISC-V LLVM port is making rapid progress. RV32IMFDC upstream. [As a 
correction to the talk, compressed support is upstream - thanks to 
contributions from Andes Tech and Qualcomm!]
* Bootloaders: U-boot is upstream, TianoCore is a work in progress. Coreboot 
RISC-V support is upstream but a little out of date. UEFI standard process is 
ongoing.
* Embedded runtimes: Zephry is upstream, seL4 upstream, FreeRTOS exists but 
isn't upstream, Micrium uC/OS is available, as is ThreadX.
* Debugging: GDB port upstream, OpenOCD exists but not upstream. Also 
commercial debuggers: Segger, Lauterbach, UltraSoC, IAR is upcoming.
* The core software stack has been supported by a consortium of developers 
from a range of companies.
* RISC-V software implementations: Spike, RV8, Renode, QEMU (upstreamed and 
included in a upstream release about a week ago)
* There are also commercial simulators, such as Imperas OVP and Esperanto's 
simulator.
* Help wanted: OpenJDK JIT port, Arduino runtime
* The RISC-V platform specification working group will define profiles for 
types of RISC-V systems. e.g. bare-metal embedded, RTOS, embedded Linux, 
portable Linux.

## The RISC-V vector ISA update: Roger Espassa
* The spec isn't yet ready...but it's getting really close
* Updates and discussion points:
  * Register types moved to an extension.
  * Widening multiplies
  * Debating whether reductions should be in base or not
  * Worked on overlaying V-reg and F-reg to save state, decided against it
  * Fixed point vclip instructions
  * Mask support for speculative vectorisation
  * Possibility to fit integer MADD within encoding
* Scalar support: the encoding allows indicating that the destination vreg is 
a "scalar shape". Introduce VLO/VSO to load/store single scalar elements.
* Roger is outlining the newly introduced instructions. I can't usefully 
summarise these, so you're best waiting for the slides to be published.
* vclip is introduced to help support fixed point.
* FP16 operations are introduced and are required for the V extension.
* The vector extension introduces interesting instructions such as vector-fpr 
merge, vector-fp merge, slide down / slide up
* Plan to close the base spec very soon
* Want to see compiler output before bringing for ratification
* Haven't yet started on formal spec for the vector ISA

## The ISA formal spec technical update: Rishiyur Nikhil
* What what use is an ISA formal spec?
  * Answer questions about compiler correctness. Will executing a certain two 
    C programs produce the same results? For all inputs? For all C and 
    corresponding RISC-V programs?
  * Answer questions on implementation correctness. Will executing this progam 
  produce correct results? On all RISC-V processors?
* ISA formal spec goals
  * Clear and understandable to the human reader. Precise and complete.
  Machine readable. Executable (run RISC-V programs, boot an OS). Usable with 
  various formal tools.
* Key issues
  * RISC-V's modularity. A wide range of options, some of which are 
  dynamically selectable or can vary between privilege levels. The spec needs 
  to capture all combinations and still remain readable.
  * Extensibility. Want to allow people to build upon the formal spec to add 
  support their own extensions.
  * Non-detterminism and concurrency.
* Status. Various approaches are being pursued: 3 projects in Haskell, 1 
project in SAIL, 1 project in L3, another in a 'functional subset' of Verilog
  * One of the Haskell projects (led by a team at MIT) is furthest along.
  Models RV32I, RV64I, M, priv U+S+M, Sv39 VM
* Next steps: within a couple of months publish a formal spec that is complete 
for RV32IMAC, RV64IMAC, user+supervisor+machine mode, sv32+sv39, and a simple 
sequential memory model. Liaise with the compliance group to use the formal 
spec as a golden reference for compliance suites. Then work to integrate with 
the weak memory model.
* Potential follow-up projects (by community?)
  * Formally show equivalences between different ISA formalisations
  * Demonstrate extensibility to other standard options (e.g. vector, crypto)
  * Use it! (to provide correctness of hardware implementations, compilers, 
  ...)

## RISC-V memory consistency model status update: Dan Lustig
* The specification is released for public comment, which will run through to 
June 16th.
* Fundamentally, the RISC-V memory consistency model specifies the values that 
can be returned by loads.
* The RISC-V memory model specification defines the RISC-V weak memory 
ordering (RVWMO) model and extensions: Zam (misaligned atomics), Ztso (Total 
Store Ordering).
* Global memory order (GMO): a total order over the memory operations 
generated by the instructions in each program
* GMO is constrained by the Preserved Program Order (PPO)
* Load Value Axiom
* Atomicity Axiom: no store from another hart can appear in the global memory 
order between a paired LR and successful SC (see spec for full details of 
rule)
* Progress Axiom: no memory operation may be preceded in the global memory 
order by an infinite sequence of other memory operations
* Misaligned AMOs are not supported in the base 'A' extension, but can be 
supported with the 'Zam' extension.
* Ztso strengthens the baseline memory model to TSO, but TSO-only code is not 
backwards-compatible with RVWMO.
* Authored two appendices which give lengthy explanations in plain English as 
well as axiomatic and operational models. More than 7000 litmus tests are 
available online.
* Ongoing/future work
  * Mixed-size, partially overlappy memory accesses
  * Instruction fetches and fence.i, TL flushes and sfence.vma etc
  * Integrations with V, J, N, T extensions
  * ...

## Software drives hardware. Lessons learned and future directions: Robert Oshana
* Software engineers can innovate earlier/often and drive more specific core 
requirements for hardware design team
* Software engineers like to dream of a simple single core running at very 
high clock rate, and zero latency unlimited bandwidth access to a single 
memory. A hardware engineers dreams of many cores at 1ghz with accelerators, 
separate memories etc.
* Trying to achieve even faster development cycles.
* Start with system modelling, move to system definition, and produce 
intrinsic libraries, new instructions, programming model details, and a Chisel 
model.
* Moving towards "software driven hardware" to support the software 
programming model (2020).
* NXP are using PULPino.
* Challenge: establishing a robust open community for RISC-V. Want to see 
multiple vendors contributing back to the 'RISC-V ISA mainline'.
* Using RISC-V mainly as 'minion cores'. Focused on efficient core designs and 
ISA enhancement for application-specific functionality. e.g. bit manipulation, 
crypto. Other innovation targets include a multi RISC-V core MCU SoC.
* Embedded software engineers will take a bigger role in defining the SoC 
architecture
  * Programming model
  * System optimsiation
* Open source RISC-V implementations will allow more software driven hardware.
Ecosystem is vital to success.

## Unleashing the power of data with RISC-V: Martin Fink
* Why has Western Digital made such a big commitment to RISC-V even though 
they're not in the processor business? Feel there's too much focus on the CPU, 
when the focus needs to be on the data.
* Half the world's data lives on Western Digital devices.
* First Western Digital RISC-V core. 2-way superscalar, mostly in-order core 
with 9 stage pipeline. RV32IMC, 1 load/store pipe, 1 multiplier, 1 divider, 4 
ALU engines.
  * Performance targets at 28nm. Dhrystone greater than 2MIPS/Mhz, CoreMark 
  over 3 CM/MH. 1GHz operation.
  * Built to show it can be done and better understand RISC-V
  * Most of the work went into the uncore.
* Produced a NAND controller SoC using RISC-V. Added instruction optimisations 
for NAND media handling.
* Still on track to ship first products with RISC-V in 2019.
* RISC-V in embedded
  * Free and open IP connectivity buses enabling plug and play of proprietary 
  and open source IPs
* RISC-V in enterprise
  * Datacenter CPUs with smart, fast and open peripheral buses enable new 
  compute paradigms for AI workloads
* General purpose architectures are no longer sufficient. Workload diversity 
demands diverse technologies and architectures.
* Open source software licenses can apply to HDL, GDSII, Gerber. There is more 
work still needed though.
* Strong believer in the GPLv2. The troubling part about permissive licensing 
is it allows people to do proprietary things without sharing. Pragmatically, 
many companies gravitate towards permissive licenses like Apache. Hope to move 
work word towards copyleft over time.
* Western Digital is working to support development of open source IP building 
blocks for the community. Will actively partner and invest in the ecosystem.
Accelerate development of purpose-built processors for a broad range of Big 
Data and Fast Data environments.
* There is a multi-year transition of Western Digital devices, platforms and 
systems to RISC-V.
* Question from the audience: will Western Digital be open sourcing their 
cores? Would like to, but not making a commitment today. One of the challenges 
is uncoupling from the uncore. Ultimately hope to share cores and IP blocks.

## RISC-V debugging. Custom ISA extensions, multicore, DTM variants: Markus Goehrle
* Support for a variety of external and internal interfaces, as well as 
interconnections of standard debug transport modules (DTM).
* TRACE32 has Linux-awareness, including the ability to view resources such as 
task and kernel modules, addresses of dynamic objects etc.
* Support heterogeneous systems, custom ISA extensions
* Found that a lot of customers have built something based on the draft debug 
specification, as well as others who implement their own custom debug IP.
People are also doing custom solutions for trace. The speaker strongly urges 
people to feed into the debug specification standardisation process.

## GDB for RISC-V: Jeremy Bennett
* GDB support was committed upstream as of early March, including basic bare 
metal support. This sees nightly regression tests with a pass rate above 99%.
* Next steps include:
  * XML target description support
  * Memory map support
  * Remote I/O support
  * Adding non-DWARF stack unwinding
  * Upstreaming a GDB Simulator
  * Linux application debugging
* GDB support for multicore debug is evolving, with support for multiple 
active inferiors with their own flow of control and address space. Each 
inferior is associated with a program space (symbol table and DWARF debug 
information) for the code running on that inferior.
* Upstream GDB supports multiple concurrent inferiors which has been tested 
for RISC-V with a 36-core system. More work is needed for complex address 
spaces (e.g. where some memory is shared with other inferiors).

## A common software development environment for many-core RISC-V hardware and virtual platforms: Gajinder Panessar and Simon Davidmann
* Talking today about a collaboration between Imperas and UltraSoC to provide 
a common environment for debugging simulation-based and hardware debug.
* Chip designs are getting more complex, including asymmetric multi-core.
* Embedded software is increasingly important and engineering intensive.
* Traditionally use GDB, with one instance per core. This has little 
visibility as it only sees the memory space of the attached CPU. It also gives 
poor control, and bugs may occur non-deterministically.
* Imperas provide a commercial simulation solution, running at 100-2000MIPS.
  * This suports the Imperas 'MPD' full platform debugger.
* UltraSoC provide IP for debug/monitoring for the whole SoC
* Imperas and UltraSoC have collaborated to provide a common solution.

## HiFive unleashed. World's First Multi-Core RISC-V Linux Dev Board: Yunsup Lee
* When Instagram was acquired for $1B it has just 13 engineers. They achieved 
that partially by reusing open source software.
* See SiFive silicon cloud services as a parallel to Amazon AWS. Offers a 
selection of CPU soft IPs, prototype ASICs, production ASICs.
* Talking today about the Freedom Unleashed platform. Features 4 application 
cores and 1 embedded core.
* The HiFive Unleashed board feature an SiFive FU540-C000, 8GB DDR4, Gigabit 
Ethernet port, 32MB Quad SPI flash, microSD card for removable storage, 
MicroUSB for debug and serial communication, digital GPIO pins, FMC connector.
* Did a preliminary SPECINT2006 comparison. Competitive with A53 chips from 
Rockchip or Alwinner (higher than the lower-clocked Allwinner, but slower than 
the Rockchip).
* Open-V: a SiFive/ONCHIP microcontroller based on Freedom Everywhere. Built 
in TSMC 180nm, 3.3mm x 2.6mm. 2.7M transistors. ONCHIP provided a range of 
analog IP, which were integrated with a SiFive E31 core. The components will 
be available through SiFive.
* You can now submit proposals for your own freedom chip through the 
"Democratizing Ideas" program. Partners will be announced at the First Annual 
RISC-V Summit in December. Deadline is the end of October.
* RISC-V is completing the innovation cycle of research, education, and 
industry.

## HiFive unleashed expansion kit: Ted Marena
* Marketing update: Looking for collaboration on a porting to RISC-V 
whitepaper. Would also like to see member companies communicating why they 
chose RISC-V.
* Microsemi set up the MI-V ecosystem to support various RTOSes on soft RISC-V 
cores on FPGA.
* The Mi-V HiFive Unleashed Expansion board connects to the HiFive board via 
FMC. Has PCIe connectors, SATA, HDMI, USB, microSD.
* Porting an application from ARM to RISC-V is the same effort as porting from 
one ARM SoC to another. No two ARM SoCs have the same memory map or peripheral 
functionality. Neither will RISC-V SoCs.
* Mi-V HiFive Unleashed board aims to accelerate the RISC-V Linux ecosystem, 
enabling the community to port tools, OSes, middleware, packages to RISC-V.

## Simulating heterogeneous multi-node 32-bit and 64-bit RISC-V systems running Linux and Zephry with Renode: Michael Gielda
* Antmicro: 'turn ideas into software-driven products'
* Check out renode.io
* Renode is an open source instruction set simulator with a multi-layered 
framework on top. It mimics entire platforms.
* Cores are implemented in C, and the rest is implemented in C', Python, or 
any .NET-compatible language.
* Strengths include transparent and robust debugging, easy integration, rich 
model abstractions, ...
* Renode has a simple platform description format that is human readable, 
modular, and extendible.
* Also have the capability to simulate entire networks or wireless and wired 
devices in one time domain.
* Can save and restore whole simulation state.

## Debian GNU/Linux port for RISC-V 64-bit: Manuel Fernandez Montecelo
* Goal is to have Debian ready to install and run on RISC-V systems.
* Debian has more than 27k source packages, and also supports other kernels 
such as FreeBSD or GNU Hurd.
* There are three kinds of Debian port
  * Those outside of Debian infrastructure, e.g. Raspbian.
  * Unofficial/unsupported. Not in 'stable' releases but hosted in Debian 
  infrastructure.
  * Officially supported. Part of the 'stable' releases and fully supported.
* RISC-V is currently unofficial, working its way towards officially 
supported.
* Initial plan
  * Bootstrap and create viable, basic OS disk images
  * Get it to the state of 'unofficial/unsupported'
  * Move towards an official backend
* Why not 32-bit or 128-bit variants?
  * Too early for 128
  * 32-bit ports struggle to get large packages built. Plus less work has been 
    done on 32-bit Linux-capable systems.
* Started in 2016, but went in haitus until late 2017/early 2018 for Linux and 
glibc upstreaming and freezing of the ABI.
* 25th Feb - 5th March: Cross-built base set of packages
* 5th - 13th March: First 'native' build.
* 13th - 23rd March: Second 'native' build in a clean environment (isolated 
environment similar to 'production' auto-builders.
* 75% of packages are now there. Progress is slowing down as many of the 
remaining packages are either very large or difficult.
* Uncovered a range of bugs in QEMU, toolchain and so on.
* Manuel has a long lost of contributors to thank. Thank you to everyone who 
helped make this port happen!

## Fedora on RISC-V: Richard Jones
* Every few years Red Hat Enterprise Linux is forked from Fedora.
* Red Hat and Fedora have a strong upstream first policy
* Final bootstrap took 2 months. 16725 builds producing 12785 binary packages
* The current build farm contains 2 HiFive unleashed boards, 11 qemu instances 
on 4 Intel servers.
* The server market is worth about $80B/year annually. 3 billion physical 
servers are shipped a year. Of those, x86 servers are about 85% of the market 
by value.
* Don't make these mistakes for the server market:
  * Require manual intervention to choose the right bootloader/kernel per 
  vendor
  * Require out of tree drivers or patches
  * No standards or constantly changing standards
  * No organisation providing direction on server standards
  * Incompatible variants of the ISA meaning a single kernel image can't be 
  made
  * Breaking ABIs
  * Intimately tied to Linux so other OS vendors are excluded
  * Dev boards being too expensive for developers

## Smallest RISC-V device for next-generation edge computing: Seiji Munetoh
* First target application is authentication. HMAC-SHA256 and variants
* Use optical communication for host/device comms
* Use SRAM to emulate storage memory chip
* The BootROM is synthesized and embedded in the SoC
* The first generation processor utilises a PULPino core. Target GF14LP, 300um 
x 250uM. 2KB data SRAM. Plus authentication engine, analog custom circuits 
(LDO, clock/reset, PD/LED IF).
* Created a 2.5D integrated device, use a silicon interposer less than 1mm2.
Processor SoC plus 32KB MPI-SRAM, plus optical IO (MicroLED, MicroPD), plus 
power.
* Evaluated the architecture using low cost FPGA boards (ZedBoard, Zybo, 
Arty).
* Moved the instruction SRAM out of the processor die, and evaluate the 
performance effect of different widths between processor and external SRAM.
Ended up using an 8-bit bus configuration.
* Improved SHA256 performance by adding a hwardware engine.
* Made a debug chip packaged in QFP64 wire-bond
* Currently testing the 2.5D integrated device
* The second generation device was taped out in Feb 2018, featuring a new SoC 
design with instruction cache, RF interface, sensors.

## Poster and demo previews
* Far too fast-paced to summarise. Be sure to come back tomorrow for a new 
liveblog. If you're here at the workshop, be sure to come and say hello during 
the poster session.

_Alex Bradbury_
