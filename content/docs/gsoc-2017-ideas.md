+++
date = "2017-02-09T15:12:36Z"
title = "lowRISC project ideas for GSoC 2017"
+++

lowRISC is hoping to take part in the [2017 Google Summer of 
Code](https://developers.google.com/open-source/gsoc/) as a mentoring 
organisation. See the [full program 
timeline](https://developers.google.com/open-source/gsoc/timeline) for a 
run-down of key dates. Notably, we'll find out whether we have been accepted 
or not on February 27th.

See the [2015]({{< ref "docs/gsoc-2015-ideas.md" >}}) and [2016]({{< ref 
"docs/gsoc-2016-ideas.md" >}}) ideas pages for more
potential projects. Note this ideas list is currently being updated.

# Project ideas (in no particular order)

## Your project here

If you have a project idea relevant to lowRISC, don't worry that it's not 
listed here. For a good student with an interesting project we'll almost 
definitely have an appropriate mentor. You are strongly recommended to get in 
touch either on the mailing list or directly to discuss the idea though.  Some 
projects might be better handled under a different mentoring organisation, 
e.g. a PyPy port to RISC-V would make more sense under the Python Software 
Foundation.

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

## Integrate more open-source IP for lowRISC on FPGAs

**Summary:** Introduce open-source IP for components such as UART, SPI, and 
the memory controller.

The current [untethered lowRISC release]({{< ref "docs/untether-v0.2/index.md" 
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

### Open SoC Debug: Nexus Trace Format

Trace debugging is the method to observe the execution of a
system-on-chip. lowRISC is based on the
[Open SoC Debug](http://opensocdebug.org) project that creates open
source building blocks for a debug infrastructure, with a strong focus
on efficient trace debugging.

One of the main challenges is the transfer of trace events to the
host. On the one for efficiency and on the other hand for
compatibility.

The goal of this project is to adopt the Open SoC Debug infrastructure
to packatize traces in the popular
[Nexus (IEEE 5001)](http://nexus5001.org/) format.

*Skill Level*: Intermediate

*Language/Tools:* SystemVerilog

*Mentor:* [Stefan Wallentowitz](mailto:stefan@wallentowitz.de)

### Open SoC Debug: Trace Visualization and Configuration

The [Open SoC Debug](http://opensocdebug.org) project creates open
source building blocks for a debug infrastructure, with a strong focus
on efficient trace debugging. The lowRISC debug infrastructure builds
on those. Currently we focus on the target (hardware) side of the
infrastructure, but want to improve the host software, especially
visualization of traces and configuration of the debug hardware.

In this project you should not reinvent the wheel, but build around
existing infrastructure. For example the
[Open Trace Format 2](https://silc.zih.tu-dresden.de/otf2-current/html/)
and the
[SCORE-P infrastructure](http://www.vi-hps.org/projects/score-p/) are
good starting points. For the visualization and interface building we
suggest having a look at state of the visualization tools like
[ravel](https://github.com/LLNL/ravel) to integrate with or build a
new framework for example on [electron](http://electron.atom.io/).

*Skill Level*: Beginner, Intermediate

*Language/Tools*: C++/Java/JS

*Mentor:* [Philipp Wagner](mailto:mail@philipp-wagner.com),
 [Stefan Wallentowitz](mailto:stefan@wallentowitz.de)

### Open SoC Debug: Trace Logging to Memory

In the lowRISC (which use [Open SoC Debug](http://opensocdebug.org))
we currently transfer traces from the debug target to the host for
on-line visualization or offline processing. But low level traces may
be interesting even while the system-on-chip is in the field, similar
to system traces, e.g. from Linux. The idea is to write the traces to
a reserved space in the system memory and read them from the running
software.

Basically this idea involves two hardware tasks: A configuration
interface for trace logging and the interface between the debug
interconnect and the system memory. Ideally your proof-of-concept
includes a simple software. This setup can be optimized for example
with trace compression and circular buffering.

*Skill Level*: Intermediate

*Language/Tools*: System Verilog

*Mentor:* [Stefan Wallentowitz](mailto:stefan@wallentowitz.de)

### Port lowRISC to LimeSDR

[LimeSDR](https://myriadrf.org/projects/limesdr/) is a flexible
software-defined radio platform that integrates an FPGA and a Lime
Microsystems LMS7002 field-programmable RF frontend.

The idea of this project is to port lowRISC to the FPGA of the LimeSDR
board. The major challenges are porting the most important I/O and
memory interfaces and bringing up the communication to the signal
processing blocks. If time permits, a simple wireless algorithm may be
implemented on the lowRISC-limeSDR platform.

*Skill level*: Intermediate

*Language/Tools*: HDL, FPGA synthesis

*Mentor:* [Andrew Back](andrew@abopen.com),
 [Stefan Wallentowitz](mailto:stefan@wallentowitz.de)
