+++
date = "2016-02-19T13:12:36Z"
title = "lowRISC project ideas for GSoC 2016"
+++


lowRISC is taking part in the [2016 Google Summer of 
Code](https://summerofcode.withgoogle.com/) as a mentoring organisation. We 
are working with a number of our friends in the open source hardware 
community, acting as an 'umbrella' organisation to provide a wider range of 
projects.  For an introduction to GSoC, see [the GSoC 
FAQ](https://developers.google.com/open-source/gsoc/faq). You can find our 
[GSoC organisation page 
here](https://summerofcode.withgoogle.com/organizations/6271463900315648/).
See the [full program 
timeline](https://summerofcode.withgoogle.com/how-it-works/) for key dates.
Student applications are open between March 14th and March 25th.

See [last year's idea list]({{< ref "docs/gsoc-2015-ideas.md" >}}) for more
potential projects. We also recommend you check out the projects being 
mentored by [our friends at the FOSSi 
Foundation](http://fossi-foundation.org/gsoc16-ideas.html). Additional 
projects mentored by other organisations that may benefit lowRISC and the open 
source hardware eocsystem include
[multi-threaded TCG in QEMU](http://qemu-project.org/Google_Summer_of_Code_2016#Multi-threaded_TCG_Projects),
[developing a RISC-V processor model for 
ArchC](http://www.archc.org/gsoc-2016.html),
[improving the RISC-V port of Coreboot](https://www.coreboot.org/Project_Ideas#coreboot_on_the_open_source_Berkeley_RISC_V_processor),
or [working on cross-bootstrap in Debian](https://wiki.debian.org/SummerOfCode2016/Projects#SummerOfCode2016.2FProjects.2FCrossBootstrap.Cross_Bootstrap).
Also see the [MyHDL projects](http://dev.myhdl.org/gsoc/gsoc_2016.html).

# Project ideas (in no particular order)

## Your project here

If you have a project idea relevant to lowRISC, don't worry that it's not 
listed here. For a good student with an interesting project we'll almost 
definitely have an appropriate mentor. You are strongly recommended to get in 
touch either on the mailing list or directly to discuss the idea though.  Some 
projects might be better handled under a different mentoring organisation, 
e.g. a PyPy port to RISC-V would make more sense under the Python Software 
Foundation.

## Porting musl libc to RISC-V

**Summary:** Create a port of the musl libc to RISC-V 32-bit and 64-bit.

Musl is an MIT-licensed libc implementation with excellent support for static
linking. It has been used by a number of lightweight Linux distributions, most
prominently Alpine. This project would involve porting musl to the 32-bit and
64-bit RISC-V instruction set architecture. An unoptimised port should require
less than 1KLOC, so after achieving this initial milestone time should be spent
both building out the musl benchmark suite and implementing optimised
implementations for key functions. A partially complete port of Musl is 
actually [available here](https://github.com/lluixhi/musl-riscv), so although 
there will be work in completing a port and preparing it for upstreaming, we 
are particularly interested in proposals that go beyond a functioning port and 
consider interesting things that could be done regarding testing, 
benchmarking, and so on.

**Links:**

*   [Musl homepage](http://www.musl-libc.org/)

**Details:**

**Skill level:** intermediate

**Language:** C

**Mentor:** Rich Felker <dalias@libc.org>

## Improve device-tree support for the Linux RISC-V port

**Summary:** Implement solid, well-tested device-tree support for the Linux 
RISC-V port.

The [Linux RISC-V port](https://github.com/riscv/riscv-linux) is currently 
fairly barebones, and makes use of the host-target interface (HTIF) for most 
I/O. This project would involve cleaning it up, ensuring there is good support 
for instantiating devices using device-tree, and thoroughly testing this 
through modifications to the bootloader and to 
[QEMU](https://github.com/riscv/riscv-qemu).

**Links:**

* [Device tree for 
dummies](https://events.linuxfoundation.org/sites/events/files/slides/petazzoni-device-tree-dummies.pdf)
* [RISC-V Linux](https://github.com/riscv/riscv-linux)
* [RISC-V QEMU](https://github.com/riscv/riscv-qemu)

**Details:**

**Skill level:** intermediate/advanced

**Language:** C

**Mentor:** Roy Spliet <rs855@cam.ac.uk>

## Contributions to the Yosys ecosystem
[Yosys](http://www.clifford.at/yosys/) is a framework for Verilog RTL 
synthesis.  The following list is incomplete and is meant to inspire student 
proposals. Do not simply pick one of the projects on this list! We are 
interested in genuinely original student proposals. Please contact Clifford 
Wolf early in the process to discuss your ideas.

**Ideas regarding [Project IceStorm](http://www.clifford.at/icestorm/) (the 
FOSS iCE40 FPGA flow)**

* Improvements in Arachne-pnr place and route tool, such as
	* Analytical (e.g. quadratic wirelength) placement
	* Support for LUT cascade feature
	* Support for BRAM cascade feature
	* Improved inference of `SB_IO` cells
	* Timing driven place and route
	* Speedups (OpenCL?)
* Alternative iCE40 place and route flow (e.g. using VPR/VTR)
* Additional support for more iCE40 devices (e.g. UltraLite)
* In-hardware validation flow for chip databases

**Ideas regarding [Yosys](http://www.clifford.at/yosys/)**

* Additional front- and back-ends
* New architectures (e.g. additional FPGA families)
* New non-synthesis flows (verification, etc.)
* New yosys commands and other features

**Ideas regarding [YosysJS](http://www.clifford.at/yosys/yosysjs.html)**

* Interactive schematic viewer running in the web browser
* Puzzle games and other web-based Verilog training tools
* Port of Icarus Verilog to JavaScript (using EMCC)

**Skill level:** intermediate/advanced

**Language:** C++, Javascript

**Mentor:** Clifford Wolf <clifford@clifford.at>

## Port a teaching operating system to the lowRISC platform

**Summary:** Port a teaching OS such as XINU or Xv6 to RISC-V and lowRISC

[Xv6](https://pdos.csail.mit.edu/6.828/2014/xv6.html) and 
[XINU](http://www.xinu.cs.purdue.edu/) are both compact, easy to understand 
implementations of a Unix-like operating system. Porting one of these to 
RISC-V and to the lowRISC platform will help to enable its use in teaching, 
and also open up the possibilities for courses that deal with modifications 
across the whole hardware and software stack (e.g. implementing a new OS 
feature, and modifying the underlying hardware to better support it).

**Links:**

* [Xv6](https://pdos.csail.mit.edu/6.828/2014/xv6.html)
* [XINU](http://www.xinu.cs.purdue.edu/)

**Details:**

**Skill level:** intermediate/advanced

**Language:** C

**Mentor:** Alex Bradbury <asb@lowrisc.org>

## Integrate more open-source IP for lowRISC on FPGAs

**Summary:** Introduce open-source IP for components such as UART, SPI, and 
the memory controller.

The current [untethered lowRISC release]({{< ref "docs/untether-v0.2/_index.md" 
>}}) makes use of Xilinx IP for its memory controller, SPI controller, and 
UART. Replacing these with open-source IP from OpenCores or elsewhere would 
allow customisation of the whole system, and may be a useful step towards 
supporting the untethered lowRISC design on Altera FPGAs. A useful starting 
point would likely be to study what IP is currently available and to assess 
its quality.

**Links:**

* [OpenCores](http://opencores.org/)

**Details:**

**Skill level:** intermediate/advanced

**Language:** Verilog/VHDL and Chisel

**Mentor:** Wei Song <ws327@cam.ac.uk>

## Implement a Trusted Execution Environment

**Summary:** Port an existing open-source Trusted Execution Environment to the 
lowRISC platform.

A Trusted Execution Environment (TEE) runs in parallel to the general purpose 
OS ('Rich OS') like Linux and executes security-sensitive tasks. Global
Platform has standardized TEE and
[OP-TEE](https://wiki.linaro.org/WorkingGroups/Security/OP-TEE) is an
open-source GP-compliant TEE, which seems like a good target for
porting to RISC-V and the lowRISC minion cores. There are different
options to implement the TEE and another important component is the
trusted firmware to boot both the secure and the non-secure world. It
is also thinkable to port OP-TEE as components running on an L4
Microkernel, such as seL4 which
[has been ported in last years GSoC](http://heshamelmatary.blogspot.de/2015/10/a-talk-about-my-gsoc-project-with.html).

This project is potentially very large and it is important to discuss
alternatives and define a good subset in the discussion with us before
applying.

**Links:**

* [TEE spec](http://www.globalplatform.org/specificationsdevice.asp)
* [OP-TEE](https://wiki.linaro.org/WorkingGroups/Security/OP-TEE)

**Details:**

**Skill level:** advanced

**Language:** C

**Mentor:** Stefan Wallentowitz <stefan@simless.com>

## Trace-debug analysis tool

**Summary:** Implement a client program to usefully analyse trace debug data.

We are currently working on implementing [trace debug 
support](http://opensocdebug.org/) in to the lowRISC SoC. This provides a 
powerful way to debug complicated multi-threaded applications as well as to 
help diagnose hardware implementation issues. This project would involve 
implementing a program on Linux to parse this data and present it in a useful 
way to aid debugging. We're open to proposals using the
language and UI toolkit of your preference, but think TypeScript
and [Electron](http://electron.atom.io/) would form a particularly interesting
starting point.

**Links:**

* [OpenSoC debug](http://opensocdebug.org/)

**Details:**

**Skill level:** intermediate

**Language:** Your choice (C++, Python, TypeScript, ..?)

**Mentor:** Stefan Wallentowitz <stefan@wallentowitz.de> and Bruce Mitchener 
<bruce.mitchener@gmail.com>

## Generic hardware/software interface for software-defined radio

**Summary:** Identify and implement useful hardware blocks to support 
software-defined radio.

The lowRISC project employs a configurable I/O-Subsystem for low speed I/O.
This project hops to provide something similar for wireless connectivity 
(2.5G, Wifi, Bluetooth, ZigBee, etc.). The goal is to define a minimal subset 
of hardware elements as building blocks, so that they can be controlled and 
configured for different wireless standards. 

**Links:**

* [Software-defined radio](https://en.wikipedia.org/wiki/Software-defined_radio)
* [Myriad RF](https://myriadrf.org/)

**Details:**

**Skill level:** advanced

**Language:** Verilog/VHDL/Chisel, C

**Mentor:** Stefan Wallentowitz <stefan@simless.com> and David May 
<david@simless.com>

## Implement a SPIR-V front end for Nyuzi

**Summary:** Support the new SPIR-V intermediate language for the Nyuzi GPGPU.

[SPIR-V](https://www.khronos.org/spir) is an intermediate language for 
parallel computation. Supporting SPIR-V on Nyuzi would allow a variety of 
parallel languages to target it. There is already an LLVM back-end for Nyuzi, 
so this task would consist of writing a front end that parses SPIR-V and 
converts it to the LLVM intermediate code form, using Nyuzi specific 
intrinsics for handling branch divergence.

**Links:**

* [Nyuzi GPGPU](https://github.com/jbush001/NyuziProcessor)
* [A description of handling branch divergence using the Nyuzi LLVM 
backend](latchup.blogspot.com/2014/12/branch-divergence-in-parallel-kernels.html)
* [Sample code for a parallel language front-end on 
Nyuzi](https://github.com/jbush001/NyuziToolchain/tree/master/tools/spmd-compile)
* [Source code for SPIR-V tools](https://github.com/KhronosGroup/SPIRV-Tools)

**Details:**

**Skill level:** advanced

**Language:** C++

**Mentor:** Jeff Bush <jeffbush001@gmail.com>

## Port an operating system kernel to Nyuzi

**Summary:** Port an OS kernel of your choice to the Nyuzi GPGPU to put the 
recently added MMU and supervisor mode through its paces.

Nyuzi currently runs programs on bare metal and doesn't have a real operating 
system. Supervisor mode and MMU support have recently been implemented in 
hardware. Porting an operating system would be useful both to test the 
hardware implementation and to enable more complex use cases.

This project would consist of:

* Selecting an operating system such as FreeBSD or L4, or potentially creating 
a custom OS (Linux may be challenging because of its size and because it is 
heavily GCC dependent and Nyuzi uses an LLVM based toolchain). Ideally, the 
kernel should support virtual memory, multiple processes, and system/user 
mode.
* Writing Nyuzi specific drivers and BSP code for it, - Bring up and debugging 
it in the emulator and Verilog simulation (or, as a bonus, on FPGA)
* Potentially fixing hardware bugs and adding new hardware features if needed

**Links:**

* [Nyuzi GPGPU](https://github.com/jbush001/NyuziProcessor)

**Details:**

**Skill level:** advanced

**Language:** C

**Mentor:** Jeff Bush <jeffbush001@gmail.com>

## CMSIS-DSP on PULPino

**Summary:** Implement a subset of the ARM CMSIS DSP library on the Pulpino
platform

Pulpino is an open-source design containing a 32-bit RISC-V implementation
enhanced with DSP extensions. The ARM CMSIS DSP library is a set of common
signal processing functions. The implementation will consist in selecting a
reasonable subset of the library, implementing it on Pulpino, finely optimizing
it to take advantage of PULP's DSP extensions, and benchmarking it against
an ARM implementation on a Cortex M4. This will help measuring the impact of
the existing extensions and drive future extensions. The work could also be
extended to the parallelization of this subset on the Pulp platform.

**Links:**

* [PULP](http://www.pulp-platform.org)
* [CMSIS-DSP](http://www.keil.com/pack/doc/CMSIS/DSP/html/index.html)

**Details:**

**Skill level:** intermediate

**Language:** C

**Mentor:** Germain Haugou <haugoug@iis.ee.ethz.ch>

## Doom on PULPino

**Summary:** Porting DOOM on the PULPino platform

In this project, we set the challenging objective of porting the DOOM game to
PULPino - an open-source microcontroller platform based on a 32-bit RISC-V
implementation with DSP extensions. The project will consist in 1) porting the
main game engine on RISC-V, optimizing it by means of the PULPino DSP
extensions; 2) test it using an artificial set of inputs, such as mouse data
collected from running DOOM on a normal workstation, and check consistency with
the expected outputs, 3) design of a simple interface for the Zedboard version
of PULPino in Vivado, to enable using simple buttons for the input and a
compatible HDMI display for the output.

The project could easily be extended to provide a more advanced interface (e.g.
a mouse) if you are interested in HW design.

**Links:**

* [PULP](http://www.pulp-platform.org)
* [DOOM](https://github.com/id-Software/DOOM)

**Details:**

**Skill level:** intermediate/high

**Language:** C, some Vivado FPGA work (no or very small amount of RTL coding)

**Mentor:** Francesco Conti <f.conti@unibo.it>

## Arduino to Pulpino library porting

**Summary:** Porting the Arduino software libraries to PULPino.

PULPino is a small RISC-V based platform that has been published as open-source
recently. The platform is using a highly optimized RISC-V core and contains all
the necessary peripherals usually found on modern microcontrollers including
SPI, I2C, GPIO and UART. PULPino is currently available for RTL simulation,
FPGA (ZedBoard) and a first low-volume test chip was taped out in January. The
goal of this project is to make PULPino compatible with the Arduino ecosystem
and port the required libraries to the PULPino RISC-V  platform. If time
permits a PCB for the test-chip can be created during the project and/or some
applications using the Arduino compatibility layer can be developed.

**Links:**

* [PULP](http://www.pulp-platform.org)
* [Arduino software](https://www.arduino.cc/en/Main/Software)

**Details:**

**Skill level:** intermediate

**Language:** C/C++

**Mentor:** Andreas Traber <atraber@iis.ee.ethz.ch>
