+++
date = "2015-03-23T13:12:36Z"
title = "lowRISC project ideas for GSoC 2015"
+++

  


lowRISC is taking part in the [2015 
  Google Summer of Code](https://www.google-melange.com/gsoc/homepage/google/gsoc2015) as a mentoring organisation. We are 
working with a number of our friends in the open source hardware community, 
acting as an 'umbrella' organisation to provide a wider range of projects. 
For an introduction to GSoC, see [the 
  GSoC FAQ](https://www.google-melange.com/gsoc/document/show/gsoc_program/google/gsoc2015/help_page#whatis).

Students will be able to start applying on the 16th of March.
The [GSoC Student Guide](http://en.flossmanuals.net/GSoCStudentGuide/) 
is a great resource on what is involved in being a GSoC student. Now is the 
time to look at the suggested projects or consider your own ideas. Please do 
discuss the project with the proposed mentor. If you have an idea not on this 
list you want to discuss, please either contact asb@lowrisc.org or post to the 
[lowrisc-dev 
  mailing list](http://listmaster.pepperfish.net/cgi-bin/mailman/listinfo/lowrisc-dev-lists.lowrisc.org).

**Key dates:**

*   16th March: student applications open
*   27th March: student applications close
*   15th April: Google lets organisations know how many slots they have
*   27th April: Accepted student proposals announced
*   25th May: Students begin coding
*   3rd July: Mid-term evaluations deadline
*   24th August: firm ‘pencils down’ date

# Project ideas (in no particular order)

**Your project here:** If you have a project idea relevant to 
  lowRISC, don't worry that it's not listed here. For a good student with an 
  interesting project we'll almost definitely have an appropriate mentor. You 
  are strongly recommended to get in touch either on the mailing list or 
  directly to discuss the idea though.  Some projects might be better handled 
  under a different mentoring organisation, e.g. a PyPy port to RISC-V would 
  make more sense under the Python Software Foundation.

## Schematic Viewer for Netlists (SVG/JavaScript)

**Summary:** Write a JavaScript library that fills an SVG element with an
interactive schematic view for a circuit that is provided by a netlist in a
JSON format.

Although usable independent from Yosys, the main application for
this will be in educational Web tools for teaching digital circuit design, that
are based on YosysJS. There it will replace an ad-hoc display mechanism based
on GraphViz. Unlike the existing GraphViz solution, the new schematic viewer
should render proper schematic symbols for flip-flops and gates and enable
users to modify the placement of symbols (by moving them around interactively).
Additional goals would be integration of more advanced features that would
directly benefit the educational users, such as the ability to evaluate the
circuit with given input values (in this case the JSON netlist would also
include evaluable models of all circuit elements, such as an
and-inverter-graph).

**Links:**

*   [Yosys website](http://www.clifford.at/yosys/)
*   [Yosys subreddit](http://www.reddit.com/r/yosys)
*   [YosysJS](http://www.clifford.at/yosys/yosysjs.html)
*   ['Viewing RTL as schematic'](https://www.google.co.uk/search?q=view+rtl+as+schematic) (related prior work)
*   Wavedrom library: [waveforms](http://wavedrom.com/tutorial.html) and
        [schematics](http://wavedrom.com/tutorial2.html)

**Details:**

**Skill level:** intermediate

**Language:** Javascript

**Mentor:** Clifford Wolf clifford@clifford.at

## A fully open source FPGA compilation flow using Yosys

**Summary:** Implement a place-and-route mechanism targeting the iCE40 FPGA.

The
bitstream protocol of the iCE40 FPGA has been reverse engineered, which means
we’re almost at the point where we can have a completely free toolchain
targeting an FPGA. The iCE40 provides a relatively small number of LUTs (up to
a few thousand), but is very low power. Netlists for the iCE40 FPGAs can be
created with Yosys, but there is no place-and-route tool at the moment. This
project will involve lots of algorithmic work. A good starting point would be a
simulated annealing based P+R. This project has future applications to lowRISC
in the case that we include some amount of programmable logic for the ‘minion’
cores.

**Links:**

*   [Yosys website](http://www.clifford.at/yosys/)
*   [Yosys subreddit](http://www.reddit.com/r/yosys)
*   [iCE40](http://www.latticesemi.com/Products/FPGAandCPLD/iCE40.aspx)
*   [Placement and routing for FPGAs](https://courses.cs.washington.edu/courses/cse467/11wi/lectures/P&R%20guest%20lecture.pdf)

**Details:**

**Skill level:** advanced

**Language:** C++

**Mentor:** Clifford Wolf clifford@clifford.at

## Porting Icarus Verilog to JavaScript using Emscripten

**Summary:** Icarus Verilog is an Open Source Verilog Simulator consisting of two
parts: (1) a compiler front-end that creates a vvp-scripts and (2) a runtime
that executes those vvp scripts. This project is about porting Icarus Verilog
to JavaScript using Emscripten and creating a JavaScript wrapper to easily
interface with Icarus Verilog from JavaScript. This project will be used as
part of a larger effort to create web-based tools for teaching digital design
techniques.

**Links:**

*   [Icarus Verilog](http://iverilog.icarus.com/)
*   [Emscripten](http://emscripten.org/)

**Details:**

**Skill level:** beginner/intermediate

**Language:** C/C++/JavaScript

**Mentor:** Clifford Wolf clifford@clifford.at

## Accessing the OpenCores ecosystem

**Summary:** Implement a Wishbone to TileLink bridge

The OpenCores and OpenRISC community provide many useful IP cores which have
been used in ASICs and FPGAs for more than ten years. Most of these cores use
the Wishbone interface for communicating with a CPU. This project would create
a tested and documented bridge component between TileLink and Wishbone to allow
these cores to be easily integrated in the lowRISC project and by others in the
RISC-V ecosystem.

**Links:**

*   [Wishbone interconnect](http://opencores.org/opencores,wishbone)
*   [lowRISC/Rocket 'uncore'](https://github.com/lowRISC/uncore)

**Details:**

**Skill level:** intermediate

**Language:** Verilog

**Mentor:** Olof Kindgren olof.kindgren@gmail.com

## Adding Chisel support to FuseSoC

**Summary:** Extend FuseSoC to support Chisel

FuseSoC is a package manager and build system written in Python with the
intention of making it easier to reuse cores from different sources, combine
them into a SoC and run through simulators and FPGA/ASIC flows. Currently, only
Verilog and VHDL (and C/C++ for simulations) is supported. This project would
also add support for cores written in Chisel such as the Rocket core, which
would eventually allow FuseSoC to be used as the build system for the lowRISC
SoC.

**Links:**

*   [FuseSoC homepage](https://github.com/olofk/fusesoc)
*   [Chisel homepage](https://chisel.eecs.berkeley.edu)
*   [Rocket chip](https://github.com/ucb-bar/rocket-chip)

**Details:**

**Skill level:** beginner/intermediate

**Language:** Python

**Mentor:** Olof Kindgren olof.kindgren@gmail.com

## Extend Tavor to support directed generation of assembly test cases

**Summary:** Tavor is a framework for generation-based fuzzing which can be
utilized to quickly provide an initial set of tests for an implementation. In
comparison to formal methods, such as model checking, it is not meant to
perform a full verification. Instead, fuzzing can be applied to test if an
implementation is working at all.

The goal of this project is to use and extend Tavor to fuzz instruction sets.
It should be possible to easily maintain a definition of an instruction set to
generate a small amount of assembly tests. Given an appropriate heuristic,
these tests should cover all defined instructions in multiple corner cases
acting as a sanity test for the implementation under test.

**Links:**

*   [tavor homepage](https://github.com/zimmski/tavor)
*   [Fuzzing CPU emulators](http://roberto.greyhats.it/pubs/issta09.pdf)

**Details:**

**Skill level:** intermediate

**Language:** Go

**Mentor:** Markus Zimmermann markus.zimmermann@nethead.at

## Constrained randomised testing with coverage tracking in Cocotb

**Summary:** Extend the Cocotb co-simulation library to support constrained
randomised testing (e.g. via Google or-tools) and to track achieved coverage of
the tested HDL.

Cocotb is a Python framework for testing VHDL and [System]Verilog hardware
designs.  Although various open source simulators are available, none of them
provide the advanced verification features of expensive proprietary simulators.
This project will implement constrained randomisation and functional coverage
collection in Cocotb, giving open source projects these capabilities.

Constrained Randomisation is a similar concept to fuzz testing; generating
random stimulus transactions according to certain constraints in order to
exercise a hardware design.  To understand how well the randomly generated
inputs are testing design the we also need to instrument the code to track
metrics on which scenarios have been exercised (known as functional coverage).

The goal of this project is to provide a convenient interface to an existing
constraint solver from Cocotb and create and manage a database of functional
coverage points.  To facilitate processing of the coverage data we'll need to
export to various formats for consumption by other tools.  We can also
integrate coverage information with existing software development services such
as coveralls.io.

By undertaking this project you will learn about latest ASIC/FPGA verification
practices and the interaction between hardware and software development

**Links:**

*   [Cocotb homepage](http://potential.ventures/cocotb/)
*   [Cocotb Github](https://github.com/potentialventures/cocotb )
*   [or-tools](https://code.google.com/p/or-tools/)

**Details:**

**Skill level:** intermediate

**Language:** Python

**Mentor:** Chris Higgs chris.higgs@potentialventures.com

## LLVM pass for control-flow hijacking protection using lowRISC’s tagged memory

**Summary:** Implement the control-flow hijacking protection scheme outlined in the lowRISC memo

lowRISC supports tagged memory, a mechanism that associates metadata (tags)
with every location in physical memory. The initial motivation was to protect
against control-flow hijacking, but it has a number of other potential use
cases (described in more detail in our memo). A simple application of tagged
memory is to mark every code pointer (such as return addresses or vtable
addresses) with a tag making them read-only. The program should also be
modified so the presence of this tag is checked upon loading the code pointer.
This project would implement an LLVM pass applying this policy. Possible
extensions to the project would be analysing the overhead of this policy on
various programs, or looking at the protection of heap metadata.

**Links:**

*   [Tagged memory and minion cores memo](https://www.lowrisc.org/docs/memo-2014-001-tagged-memory-and-minion-cores/)
*   [LLVM](http://www.llvm.org)
*   [RISC-V LLVM port](https://github.com/riscv/riscv-llvm)

**Details:**

**Skill level:** intermediate/advanced

**Language:** C++

**Mentor:** Alex Bradbury asb@lowrisc.org

## TCP offload to minion cores using rump kernels

**Summary:** Use the NetBSD 'rump' kernel technology to run an IP stack on
lowRISC’s small RISC-V 'minion' cores for the purpose of TCP offload.

Rump kernels allows the reuse of NetBSD code such as driver implementations or
the TCP/IP stack in other environments. These high quality drivers can be made
to run on a diverse range of platforms including Linux userspace, the Xen
hypervisor, and bare metal. The goal of this project is to get rump kernels running in a
bare metal RISC-V environment. A useful demonstration and proof of concept
would be to show the NetBSD TCP/IP stack running on something approximating a
lowRISC minion core (e.g. a RISC-V core with a 16KiB instruction cache and a 
fairly high cache miss penalty). The sophistication of the TCP/IP offload 
offered will depend on the experience of the student and the time available 
towards the end of the project.

**Links:**

*   [Tagged memory and minion cores memo](https://www.lowrisc.org/docs/memo-2014-001-tagged-memory-and-minion-cores/)
*   [Rump kernels](http://rumpkernel.org/)

**Details:**

**Skill level:** intermediate/advanced

**Language:** C

**Mentor:** Justin Cormack justin@specialbusservice.com

## Porting L4/FIASCO.OC to RISC-V

**Summary:** Port the L4 FIASCO.OC microkernel and L4 runtime environment to
RISC-V.

L4 microkernels are having their revival nowadays as secure and thin
layer between the applications and the hardware. The traditional approach of a
microkernel is that all kernel services are also executed in the user space,
each in one container. Contrary to monolithic kernels, a kernel service is
therefore accessed with inter-process messages and executed in user space. Only
when necessary, certain capabilities are granted to a service container, e.g.,
access to a device for a driver service. This allows for strong separation, but
with the drawback that the inter-process communication needs to be really
efficient. While the original microkernel approaches therefore lacked of
success, modern computer architectures are better suited for the demands on the
inter-process communication. The L4 family of microkernels is the most popular.
</p>

FIASCO.OC is an L4 microkernel developed at TU Dresden/Germany. It is written
in C++ and has real-time capabilities, multi-processor support and an
object-oriented capabilities system. Similar to hypervisors, it is also
possible to encapsulate entire operating systems in para-virtualized containers
(such as L4Linux, L4OpenBSD or L4Android).  The goal of the project is to port
the FIASCO microkernel to the RISC-V architecture. Beside the basic kernel
functionality (memory mapping, processor sharing) a set of service containers
from the L4 Runtime Environment (L4Re) also need to be adapted to the RISC-V
architecture.

**Links:**

*   [FIASCO.OC](https://os.inf.tu-dresden.de/fiasco/)
*   [L4Re runtime environment](http://l4re.org/)

**Details:**

**Skill level:** advanced

**Language:** C/C++

**Mentor:** Stefan Wallentowitz stefan@wallentowitz.de

## Trace Debugging Infrastructure for lowRISC

**Summary:** Design and implementation of a trace debugging infrastructure for the
cores and uncore logic in the lowRISC SoC. 

Debugging embedded systems has
become more and more complex. Traditional run-control debugging needs to be
adapted to be aware of multiple processor cores and other active elements. For
this, cross-triggering techniques and sophisticated tools are helpful for
example.
Beside this, trace debugging techniques become more and more important. Here,
the hardware is monitored and certain events are generated, often with the
timestamp of the event. For example, each change of the program counter can be
trace event or alternatively only branches are considered trace events. Beside
this, other hardware or software events may be part of an execution trace. The
trace is generated while the system executes with minimal interference and
analyzed offline (or also online).  The goal of this project is to analyze
existing trace debugging approaches, especially the Nexus standard. Based on
the discussion hardware monitors are then developed and the configuration and
actual tracing infrastructure are prototypically developed for the lowRISC
system-on-chip. Especially the different kinds of cores and other elements of
the SoC should be considered.

**Links:**

*   [Nexus](http://en.wikipedia.org/wiki/Nexus_%28standard%29)
*   [OpTiMSoC](http://www.optimsoc.org)
*   [Multicore application debugging workshop](http://www.mad-workshop.de//2013.html)

**Details:**

**Skill level:** intermediate

**Language:** (System)Verilog or Chisel

**Mentor:** Stefan Wallentowitz stefan@wallentowitz.de

## Optimized ray tracer for Nyuzi parallel processor

**Summary:** Write a ray tracing library that is optimized for Nyuzi parallel processor.

Nyuzi is an open source parallel processor architecture. This project would
implement a ray tracer that takes advantage of both vector arithmetic and
hardware multithreading. This would act as a benchmark for exploring the
performance of this architecture and also a validation test.  Part of the
project may also involve proposing/implementing instruction set or architecture
extensions to improve performance.

**Links:**

*   [Nyuzi processor](https://github.com/jbush001/NyuziProcessor)
*   [Ray tracing (wikipedia)](http://en.wikipedia.org/wiki/Ray_tracing_%28graphics%29)

**Details:**

**Skill level:** intermediate

**Language:** C/C++

**Mentor:** Jeff Bush jeffbush001@gmail.com

## JTAG hardware debugging support for Nyuzi

**Summary:** Add the ability to single step, inspect memory, set breakpoints over JTAG.

Nyuzi is an open source parallel processor architecture. This project would
implement support in the hardware pipeline (running on FPGA) for control by a
host over JTAG.

**Links:**

*   [Nyuzi processor](https://github.com/jbush001/NyuziProcessor)
*   [USB blaster JTAG tools](https://github.com/swetland/jtag)
*   [JTAG (Wikipedia)](http://en.wikipedia.org/wiki/Joint_Test_Action_Group)

**Details:**

**Skill level:** advanced

**Language:** SystemVerilog, C

**Mentor:** Jeff Bush jeffbush001@gmail.com

## Porting musl libc to RISC-V

**Summary:** Create a port of the musl libc to RISC-V 32-bit and 64-bit.

Musl is an MIT-licensed libc implementation with excellent support for static
linking. It has been used by a number of lightweight Linux distributions, most
prominently Alpine. This project would involve porting musl to the 32-bit and
64-bit RISC-V instruction set architecture. An unoptimised port should require
less than 1KLOC, so after achieving this initial milestone time should be spent
both building out the musl benchmark suite and implementing optimised
implementations for key functions.

**Links:**

*   [Musl homepage](http://www.musl-libc.org/)

**Details:**

**Skill level:** intermediate

**Language:** C

**Mentor:** Rich Felker dalias@libc.org

## jor1k port to RISC-V

**Summary:** Write a RISC-V 32-Bit CPU emulator in Javascript

jor1k is an emulator for the OpenRISC platform and is the fastest emulator
which runs in the web browser and boots Linux. It comes with a working
underlying framework and a comprehensive library for hardware devices such as a
framebuffer and network support, which can be used for the RISC-V too. This
project would involve the programming of the missing part - a RISC-V 32-Bit CPU
emulator following the ISA specification (estimated 1-1.5kLOC). A milestone
would be the booting of Linux. We will then focus on optimizations using
asm.js. Possible extensions include adding support for other features of the
lowRISC platform, such as tagged memory or minion cores.  Basic knowledge about
CPU design and general assembler programming is required. 

**Links:**

*   [jor1k repo](https://github.com/s-macke/jor1k)
*   [RISC-V ISA specification](http://riscv.org/riscv-spec-v2.0.pdf)
*   [jor1k technical details](https://github.com/s-macke/jor1k/wiki/Technical-details)

**Details:**

**Skill level:** intermediate/advanced

**Language:** Javascript

**Mentor:** Sebastian Macke sebastian@macke.de

## OCaml native code port to RISC-V

**Summary:** Write a RISC-V 32-Bit native code generation backend for the OCaml compiler 

OCaml is a functional programming language from the ML family, with code that can be compiled
natively to x86, ARM, Sparc, PowerPC and MIPS binaries using the
[ocamlopt](http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual025.html) compiler
included with the distribution.  This project would add support for the RISC-V instruction
set into ocamlopt, and verify that the resulting code generation passes the test suite included
with the OCaml compiler.  Once that passes, a stretch goal would be to compile libraries in the
OCaml ecosystem to test their correct operation using the [OPAM](https://opam.ocaml.org)
package manager.

**Links:**

*   [OCaml compiler repository](https://github.com/ocaml/ocaml)
*   [Native code compilation in Real World OCaml](https://realworldocaml.org/v1/en/html/the-compiler-backend-byte-code-and-native-code.html#compiling-fast-native-code)

**Details:**

**Skill level:** intermediate/advanced

**Language:** OCaml

**Mentor:** Anil Madhavapeddy anil@recoil.org
