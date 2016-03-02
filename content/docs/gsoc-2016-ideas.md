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

See [last year's idea list]({{< ref "gsoc-2015-ideas.md" >}}) for more 
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
implementations for key functions.

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

**Mentor:** Clifford Wolf <clifford@clifford.at>

## An alternative flow for ice40 place and route

**Summary:** Make use of VPR/VTR to implement a new place and route flow.

[Project IceStorm](http://www.clifford.at/icestorm/) currently provides a full 
flow from Verilog to the Lattice iCE40 FPGAs making use of 
[Yosys](http://www.clifford.at/yosys/) for synthesis and 
[arachne-pnr](https://github.com/cseed/arachne-pnr) for place and route. It 
would be interesting to instead use VPR from the [Verilog to 
Routing](https://github.com/verilog-to-routing/vtr-verilog-to-routing) flow 
for place and route.

**Links:**

* [Project 
IceStorm](https://github.com/verilog-to-routing/vtr-verilog-to-routing)
* [Yosys](http://www.clifford.at/yosys/)
* 
[Verilog-to-Routing](https://github.com/verilog-to-routing/vtr-verilog-to-routing)

**Details:**

**Skill level:** advanced

**Language:** C++

**Mentor:** Clifford Wolf <clifford@clifford.at>

## Other Yosys-related projects

Clifford is really interested in mentoring projects that build on Yosys or 
IceStorm of the students own devising. Please do reach out to discuss any 
ideas. Some other ideas that haven't been described in more detail include 
retargeting Yosys for other FPGA architectures and new Yosys front-ends or 
back-ends.

**Links:**

* [Project 
IceStorm](https://github.com/verilog-to-routing/vtr-verilog-to-routing)
* [Yosys](http://www.clifford.at/yosys/)

**Details:**

**Skill level:** intermediate/advanced

**Language:** C++, Verilog

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
way to aid debugging. This could be done in Python, C++, even in JavaScript 
using something like [Electron](http://electron.atom.io/).

**Links:**

* [OpenSoC debug](http://opensocdebug.org/)

**Details:**

**Skill level:** intermediate

**Language:** Your choice (C++, Python, Javascript, ..?)

**Mentor:** Stefan Wallentowitz <stefan@wallentowitz.de>

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
