+++
date = "2017-02-09T15:12:36Z"
title = "lowRISC project ideas for GSoC 2017"
+++

lowRISC is taking part in the [2017 Google Summer of 
Code](https://developers.google.com/open-source/gsoc/) as a mentoring 
organisation. See the [full program 
timeline](https://developers.google.com/open-source/gsoc/timeline) for a 
run-down of key dates. Student applications are due by 4pm UTC on April 3rd.

See the [2015]({{< ref "docs/gsoc-2015-ideas.md" >}}) and [2016]({{< ref 
"docs/gsoc-2016-ideas.md" >}}) ideas pages for more
potential projects. If you want feedback on ideas, you're best posting to the 
[lowrisc-dev mailing 
list](http://listmaster.pepperfish.net/cgi-bin/mailman/listinfo/lowrisc-dev-lists.lowrisc.org).

# Project ideas (in no particular order)

## Your project here

If you have a project idea relevant to lowRISC, don't worry that it's not 
listed here. For a good student with an interesting project we'll almost 
definitely have an appropriate mentor. You are strongly recommended to get in 
touch either on the mailing list or directly to discuss the idea though.  Some 
projects might be better handled under a different mentoring organisation, 
e.g. a PyPy port to RISC-V would make more sense under the Python Software 
Foundation.

## Contributions to compiler testing
**Summary:** Improve the state of the art in RISC-V compiler testing.

LLVM compiler tests typically involve verifying certain instruction sequences 
are present in the output, i.e. don't involve program execution. This has 
advantages, but it has the disadvantage of relying on test author writing the 
test correctly in the first place. A highly ambitious way of ensuring the 
generated RISC-V instructions correctly implement the semantics of the LLVM IR 
would be to perform an equivalence check where feasible. A more 
straight-forward approach might be to test the behaviour of the function both 
[when interpreting LLVM IR](https://github.com/andoma/vmir) and when executing 
the generated RISC-V code. There is also interesting work around testing ABI 
conformance, with the [calling convention golden 
model](https://github.com/lowRISC/riscv-calling-conv-model) being a first step 
towards this. We would be interested in extending this work.

**Details:**

**Skill level:** intermediate/advanced

**Language:** C++, Python

**Mentor:** Alex Bradbury <asb@lowrisc.org>

## lowRISC/RISC-V in education
**Summary:** Produce a simulator tool with output useful for those learning 
computer architecture.

Tools like the [MARS MIPS 
simulator](http://courses.missouristate.edu/KenVollmar/MARS/) are very popular 
for university-level education, giving the ability to experiment with simple 
assembly programs, single step, view register values and so on. This project 
would look at providing something with similar functionality for the RISC-V 
ecosystem. A potential extension would be to support features unique to 
lowRISC such as tagged memory. The RISC-V support in 
[jor1k](https://github.com/s-macke/jor1k) could be a starting point for a 
Javascript implementation of this idea.

**Details:**

**Skill level:** intermediate/advanced

**Language:** Javascript, language of your choice

**Mentor:** Alex Bradbury <asb@lowrisc.org>

## "Simulated" memory controller
**Summary:** Provide a way to produce realistic performance numbers from FPGA.

It is a common pitfall to misinterpret or incorrectly scale performance 
numbers derived from benchmarks run on an FPGA-based SoC design. The problem 
is that your external memory interface is running at a very high speed 
compared to the core CPU (e.g. a 25MHz core clock speed but external memory 
running a several hundred MHz). This can be misleading when trying to consider 
what the performance would be on an ASIC, as the CPU clock speed could be many 
times higher but the memory frequency be the same or increase by a much 
smaller amount. The solution is to have a simulation-ready memory controller 
that will produce delays much closer to a system where the memory interface is 
running at a much slower speed.

**Details:**

**Skill level:** advanced

**Language:** SystemVerilog or Chisel

## Programmable DMA engine
**Summary:** Implement a DMA engine using a small RISC-V core.

This project would involve looking at the feasibility of implementing a DMA 
engine that executes the RISC-V instruction set. What instruction set 
extensions would increase its efficiency and reduce overhead?

**Details:**

**Skill level:** advanced

**Language:** SystemVerilog or Chisel


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

**Mentor:**

## Building a Basic Embedded Security Module

**Summary:** Extend a basic microcontroller subsystems with security
extensions.

We want to explore the applicability of a secure subsystem inside the
lowRISC system-on-chip for security related tasks. The basic idea is
to have a flexible playground for security research. For example this
subsystem can be used to securely boot the system, remote attestation,
or even to provide a Trusted Execution Environment (TEE) to the user
software.

For that subsystem we start with a simple 32-bit microcontroller with
(at least) two privilege levels. The goal of this idea is to add one
of the following:

* A model for non-volatile memory and one-time programmable memory

* The interfaces to other system resources: Secure communication
  channel and system control interface

* Integration and drivers for cryptographic accelerators

* An interface that transparently encrypts bus access data

Those are just the apparent ideas for a secure subsystem, we are open
to your own ideas!

**Details:**

**Skill level:** intermediate/advanced

**Language:** (System) Verilog or Chisel, C

**Mentor:** Stefan Wallentowitz <stefan@wallentowitz.de>

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
