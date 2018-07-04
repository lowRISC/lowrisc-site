+++
Description = ""
date = "2016-01-05T17:35:57+00:00"
title = "Third RISC-V Workshop: Day One"
aliases = "/blog/2016/01/second-risc-v-workshop-day-one/"

+++
The [third RISC-V workshop](https://riscv.org/2015/12/prelim-agenda-3rd-risc-v-workshop/) is going
on today and tomorrow at the Oracle Conference Center, California. I'll be 
keeping a semi-live blog of talks and announcements throughout the day. See 
[here](https://www.lowrisc.org/blog/2016/01/third-risc-v-workshop-day-two) for
notes from the second day.

## Introductions and RISC-V Foundation Overview: Rick O'Connor
* Save the date, the 4th RISC-V workshop will be July 12th-13th at the MIT 
CSAIL/Stata Center.
* In August 2015, articles of incorporation were filed to create a non-profit
RISC-V Foundation to govern the ISA.
* RISC-V Foundation mission statement: The RISC-V Foundation is a non-profit 
consortium chartered to standardize, protect, and promote the free and open 
RISC-V instruction set architecture together with its hardware and software 
ecosystem for use in all computing devices.
* The RISC-V ISA and related standards shall remain open and license-free to 
all parties.
* The compatibility test suites shall always be publicly available as a source 
code download.
* To protect the standard, only members (with commercial RISC-V products) of 
the Foundation in good standing can use "RISC-V" and associated trademarks, 
and only for devices that pass the tests in the open-source compatibility 
suites maintained by the Foundation.
* Drafting a new license for the ISA 'combining the best of BSD, GPL and so 
on'.
* The Foundation will have a board of 7 directors elected by the members. All 
members of committees must be members of the RISC-V Foundation.
* All details of the foundation are a work in progress. Feedback is welcome!
* 16 member companies so far. Bluespec, Draper, Google, Hewlett Packard Labs, 
Microsemi, Oracle, SiFive, antmicro, codasip, Gray Research, Lattice 
Semiconductor, lowRISC, ROA logic, Rumble Development, Syntacore, Technolution

## RISC-V Updates: Krste Asanovic
* The 1.9 version of the compressed extension is on track to become frozen and 
become blessed as v2.0. Now is the time to speak up if you have any feedback 
or concerns!
* Privileged architecture 1.7 was released in May 2015 and has received a lot 
of feedback. Hope to release an updated draft addressing feedback in the next 
month or two. Doubt it will really settle down before the summer, as it needs 
more OS and driver development against it.
* 'V' Vector Extension: not yet ready to release a draft for this workshop, 
but the RTL of the HWacha vector coprocessor has been open-sourced along with 
3 tech-reports.
* Hwacha is NOT the V extensions. It's a research project designed to push the 
limits of in-order decoupled data-parallel accelerators (e.g. GPUs). The 
microarchitecture does demonstrate some of the ideas that will appear in V.
* Ongoing ISA research at UCB: virtual local store (VLS, Henry Cook's 2009 
master's thesis) and user-level DMA (copying data between DRAM and VLS 
directly).
* New Berkeley open-source cores: BOOM out-of-order implementation and V-Scale 
(verilog implementation of Z-Scale).
* RISC-V is being transitioned out of Berkeley. This involves upstreaming of 
tools and the RISC-V Foundation taking over the standards process.
* SiFive has been founded by some of the lead RISC-V developers (Krste 
Asanovic, Yunsup Lee, Andrew Waterman). Sutter Hill Ventures have invested.
* Most urgent outstanding issues: holes and ambiguities in the specification 
and the platform specification.
* Holes in the spec: floating-point NaNs (resolved and updated), CSR 
read/write semantics (resolved, updated spec), memory model (far from 
resolved), Hypervisor support (no proposal). A formal spec of the whole ISA 
and memory model is desired.
* Although RISC-V was designed in reusable layers, some concrete standards for 
hardware platforms are desirable e.g. memory maps, interrupt controller, power 
management. To what extent can platform specs be shared across 
microcontroller-class, application cores, and rack-scale designs?

## RISC-V External Debug (aka JTAG debugging): Tim Newsome
* Goals: a debug system that works for everybody with a working system done by 
July 1st 2016.
* The specification will be submitted to the RISC-V Foundation and there are 
plans for an open source release of the debugger and implementations for 
Rocket and Z-Scale.
* Status: the specification is mostly complete.
* Features: (many, see the slides). Interested in tracing core execution to on 
or off-chip RAM and providing a framework to debug any component on the 
system, not just the RISC-V cores.
* The debug transport module provides access to the system bus. It implements 
a message queue and optional authentication.
* New CSRs will be added and exposed on the system bus.
* The spec describes a small amount of debug memory (1KiB ROM) and 8-16 bytes 
of RAM. This memory is not cached and is shared between all cores.
* Up to 4095 hardware breakpoints supported (but 4 is more typical). Each may 
support exact address match, address range match, exact data match, data range 
match, ...
* The work-in-progress spec will be posted to the hw-dev RISC-V mailing list 
later today. Comments very welcome.
* Question: how does this map to gdb's capabilities? Are there things it can 
do but gdb can't or vice-versa? It's not a 1:1 match but should be a superset 
of what gdb can do.
* Question: how does the tracing scale? Hasn't be investigated yet.
* Question: will support be integrated into the BOOM codebase? Answer: not 
currently planned.
* Question: there's a wide spectrum of functionality that different 
implementations could implement. Is there a discovery mechanism for the 
functionality that is supported? Yes.

## RISC-V in Axiom: Michael Gielda
* Axiom is a fully open source 4K film camera design. It is an EU Horizon 2020 
project with multiple partners.
* Aim of Axiom is to create an extensible open source platform that is also a 
desirable project in itself. The aim is to open up what is currently a fairly 
closed industry and lower barriers of entry to new players. There is an 
obvious parallel to the RISC-V and lowRISC projects.
* Chose the largest Zynq FPGA that had zero-cost tool support to maximise the 
number of people who can hack on the design.
* Using the Z-Scale as a soft-core for communication between the FPGA 
pre-processing board (Kintex-7) and the FPGA SoC main board with a dual-core 
Cortex-A9 (Zynq 7030).
* Long-term goals are to ensure the design can be reused through 
parameterisation, and look at broadening adoption of the Chisel design 
methodology.
* The Axiom Gamma project is almost half-way done. There will be an EU 
technical review in March at which point it should be working.

## Emulating future HPC SoC architectures using RISC-V: Farzad Fatollahi-Fard
* Should HPC take inspiration from the embedded market?
* Is building an SoC for HPC a good idea? HPC is power limited 
(performance/Watt) which arguably means HPC and embedded requirements are 
aligned.
* From a previous project case study (Green Wave), they found an embedded SoC 
design was performance/power competitive with Fermi. This had a 12x12 2D 
on-chip torus network with 676 compute cores, 33 supervisor cores, 1 PCI 
express interface, 8 Hybrid Memory Cube interfaces, ...
* Proposed an FPGA-implemented SoC for HPC. This contains 4 Z-scale processors 
with a 2x2 concentrated mesh with 2 virtual channels. The Z-Scale was chosen 
for area-efficiency on FPGA.
* The network is implemented using the [OpenSoC 
fabric](https://github.com/LBL-CoDEx/OpenSoCFabric) (open source and in 
chisel). AHB endpoints have now beed added and AXI is in-development.
* A 96-core system was constructed using multiple FPGAs.
* For more info, see [CoDEx HPC](http://www.codexhpc.org/).

## GRVI Phalanx. A massively parallel RISC-V FPGA accelerator: Jan Gray
* GRVI is pronounced 'groovy'.
* There's lots of interest in FPGA accelerators right now (Altera acquisition, 
MSR's catapult).
* FPGAs are an interesting platform. Massively parallel. Specialized.
Connected. High throughput. Low latency. The big barrier is of course porting 
your software. Jan argues OpenCL for FPGAs is a major breakthrough for this 
problem, if you're lucky enough to have an application that can be expressed 
in OpenCL.
* Phalanx is an accelerator accelerator - an infrastructure making it easier 
to run you application on an FPGA and connect everything together. It is 
composed of processor+accelerator clusters+NoC.
* Jan's Razor: "In a CMP, cut inessential resources from each CPU, to maximize 
CPUs per die."
* Jan has achieved an RV32I datapath in about 250 LUTs. This core can achieve 
300-375MHz, 1.3-1.6CPI. The 'GRVI' core is ~320 6-LUTs so "1 MIPS/LUT".
* How many can you fit on a modern FPGA? The limiting resource is really the 
block RAMs. In a cluster, two processing elements can share an instruction 
BRAM, and all PEs can share a cluster memory.
* How should the clusters be interconnected? A 5-port virtual channel router 
might be a sensible choice in an ASIC, but does not map well to an FPGA.
Instead use a [Hoplite](http://fpga.org/2015/09/03/introducing-hoplite/) 2D 
router. This is only 1% of the area x delay product of FPGA-optimized VC 
routers. Each cluster has a 300 bit connection to the Hoplite router (with a 
256bit payload).
* 400 of the GRVI Phalanx PEs can fit on a Xilinx KU040. The amortized cost of 
the router per processor is only 40 LUTs.
* Can fit 32 GRVI Phalanx PEs on an Artix-7-35T.
* Want to support different accelerated parallel programming models: SPMD, 
MIMD, MP. All potentially accelerated by custom GRVI And cluster function 
units, custom memory or interconnects, custom accelerators on the NOC.
* Next steps: debug/trace over NoC, Hoplite/AXI4 bridges, OpenCL stack, 
potential bridge to Chisel RISC-V infrastructure?
* Question: how do I get this? Not available yet, and not yet sure on the 
licensing model.

## Coreboot on RISC-V: Ron Minnich
* Initializing the stuff outside the main CPU on a chromebook takes about 1 
billion instructions before it can start Linux.
* Firmware, 1990-2005 "fire and forget". Set al lthe stff kernels can't do 
(e.g. LinuxBIOS), then get out of the way. But now there's a push for the 
firmware to hang around after boot.
* Ron argues this sucks. It's slow, there's no easy bugfix path, and it's not 
SMP capable on x86.
* Why doesn't Ron like persistent firmware? It's another attack vector, 
indistinguishable from a persistent embedded threat. Ron's preference is the 
platform management code run as a kernel thread. Minion cores are ideal for 
this (Ron's words rather than mine - I of course agree whole-heartedly).
* coreboot is a GPLv2 BIOS replacement (not a bootloader). It has multiple 
possible payloads including SeaBIOS and depthcharge (used for verified boot on 
Chromebooks).
* Port was started in October 2014 as a side project. The effort resumed in 
July 2015 with the privileged spec, and as-of September is up and running 
again. The most recent port runs on Spike but not QEMU (due to lack of support 
for the privileged spec).
* RISC-V is a first class citizen in coreboot, all commits must pass tests for 
the RISC-V buildbot.
* src/arch/riscv is 2685 LoC.
* The Federal Office for Information Security in Germany runs a hardware test 
station for coreboot. As soon as real hardware is running, they've offered to 
integrate it into their system.
* Lessons learned
  * provide a boot time SRAM (make sure the address is fixed and not aliased 
by DRAM once DRAM is up).
  * Provide a serial port.
  * Ron reiterates that runtime functions belong in the kernel, not persistent 
    firmware.
  * Firmware tables always need translation by kernel, so make them text not 
    binary.
  * Keep the mask ROM as simple as possible.
  * Don't cheap out on SPI or flash part size. Just plan a 64MiB part.
  * Don't reset the chipset on IE device not present.

## RISC-V and UEFI: Dong Wei and Abner Chang
* There is a UEFI Forum consistent of a board of 12 directors, 12 promoters, 
42 contributors, 213 adopters.
* UEFI and ACPI are both now handled by the UEFI Forum.
* A RISC-V UEFI port is taking place using EDKII (EFI Development Kit II) and
OVMF (Open Virtual Machine Firmware).
* The speakers are giving a very thorough description of the UEFI boot 
mechanism which I'm not able to do justice. You're best waiting for the 
slides+video I'm afraid.
* The project was started a few months ago, and can now boot to a UEFI shell.
* They have created a new RISC-V QEMU target with some PC peripherals (CMOS, 
PM, PCI and other devices), and also implemented RISC-V machine mode.
* Requests for new RISC-V spec additions: a periodic timer CSR, RTC with alarm 
CSR, PI management mode support, ... (sorry, missed some).

## FreeBSD and RISC-V: Ruslan Bukin
* FreeBSD will support RV64I in release 11.0.
* Why use FreeBSD? Among other reasons, it gives a full-stack BSD license 
(RISC-V, FreeBSD, LLVM/Clang).
* FreeBSD has been brought up on Spike.
* The early boot assembly code will put the hardware in a known state, build a 
ring buffer for interrupts, initialise the page tables, enable the MMU, then 
finally branch to a virtual address and call into C code.
* Userspace porting required modifications to jemalloc, csu (crt1.S, crtn.S, 
crti.S), libc, msun (libm), rtld-elf (the runtime linker).
* The FreeBSD port is based on the ARMv8 port. It has a 25k line diff and took 
6 months from scratch.
* Userland started working in December. Support will now be committed to 
FreeBSD SVN.
* Next plans include multicore, FPU, increasing the virtual address space, 
DTrace, performance monitoring counters, QEMU, ...
* Proposed changes: split sptbr to sptrbr0 and sptbr1 for the user VA and the 
kernel VA. This means there is no need to change SPTBR when changing the 
privilege level, and should reduce code size.
* For more on the project, see the relevant [FreeBSD wiki 
page](https://wiki.freebsd.org/riscv).

## Building the RISC-V software ecosystem: Arun Thomas
* "2016 is the year of RISC-V". Or at least, the year of RISC-V software. We 
have a great opportunity to push the software stack forwards.
* What can we achieve by the end of the year? Hopefully upstereamed GNU 
toolchain and QEMU. More mature Clang/LLVM support, upstreamed OS support, 
Debian/RISC-V port, start thinking about Android and a real-time OS.
* How do we get there? We need to recruit more RISC-V developers and make it 
easier for people to get started by producing more docs and specifications.
* Right now, the RISC-V Github has had 48 contributors from a wide range of 
Universities, companies and OSS projects.
* We should present talks and tutorials at developer conferences and local 
user group meetings.
* If you have local patches, upstream them!
* How to attract developers? Could fund developers/projects via the 
Foundation, apply to be a Google Summer of Code mentoring organization, update 
the list of open bugs and future requests on github and track contribution 
statistics.
* We can make it much easier for people to get started by building Debian 
packages, upstreaming, and providing regular binary snapshots.
* Spike is great for prototyping hardware features, but QEMU is a better tool 
for software development and a critical part of the RISC-V software story.
* There's more to specify. e.g. a platform specification (e.g. ARMv8 Server 
Base System Architecture), boot architecture (look at the ARMv8 Server Base 
Boot Requirements), RISC-V ABI, hypervisor, security.
* Useful documents include a RISC-V Assembly Guide, some equivalent of the ARM 
Cortex-A Programmer's Guide, and a New Contributor's Guide.
