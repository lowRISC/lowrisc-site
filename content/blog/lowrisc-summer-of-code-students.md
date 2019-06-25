+++
date = "2015-05-13T20:45:07+01:00"
title = "Summer of Code students for lowRISC"

+++

lowRISC was fortunate enough to be chosen as a mentoring organisation in this 
year's [Google Summer of 
Code](https://developers.google.com/open-source/soc/). The Google Summer of 
Code program funds students to work on open source projects over the summer. 
We had 52 applications across the [range of project 
ideas](https://www.lowrisc.org/docs/gsoc-2015-ideas/) we've been advertising.
As you can see from the range of project ideas, lowRISC is taking part as an 
umbrella organisation, working with a number of our friends in the wider open 
source software and hardware community.
We were allocated three slots from Google, and given the volume of high 
quality applications making the selection was tremendously difficult. We have 
actually been able to fund an additional three applicants from other sources, 
but even then there were many promising projects we couldn't support. We are 
extremely grateful to all the students who put so much time and effort in to 
their proposals, and to everyone who volunteered to mentor. The six 'summer of 
code' projects for lowRISC are:

* [An online Verilog IDE based on 
YosysJS](http://www.google-melange.com/gsoc/project/details/google/gsoc2015/asy/5757334940811264). 
Baptiste Duprat mentored by Clifford Wolf
 * Baptiste will be working with an Emscripten-compiled version of
the [Yosys](http://www.clifford.at/yosys/) logic synthesis tool, building an 
online Verilog IDE on top
of it which would be particularly suitable for training and teaching
materials. A big chunk of the proposed work is related to visualisation of the 
generated logic. Improving the accessibility of hardware design is essential for
growing the potential contributor base to open source hardware
projects like lowRISC, and this is just the start of our efforts in that 
space.

* [Porting seL4 to 
RISC-V](http://www.google-melange.com/gsoc/project/details/google/gsoc2015/hesham/5868011953061888). 
Hesham ALMatary mentored by Stefan Wallentowitz
 * [seL4](https://sel4.systems/) is a formally verified microkernel, which 
currently has ports
for x86 and ARM. Hesham will be performing a complete port to
RISC-V/lowRISC. Security and microkernels are of great interest to
many in the community. It's also a good opportunity to expand RISC-V platform 
support and to put the recently released [RISC-V Privileged Architecture 
Specification](https://blog.riscv.org/2015/05/risc-v-draft-privileged-architecture-version-1-7-released/) 
through its paces. Hesham previously performed a port of RTEMS to
OpenRISC.

* [Porting jor1k to 
RISC-V](http://www.google-melange.com/gsoc/project/details/google/gsoc2015/prannoy1994/5651442522128384). 
Prannoy Pilligundla mentored by Sebastian Macke
 * [jor1k](https://s-macke.github.io/jor1k/) is by far the 
 [fastest](https://github.com/s-macke/jor1k/wiki/Benchmark-with-other-emulators) 
 Javascript-based full system
simulator. It also features a network device, filesystem support, and
a framebuffer. Prannoy will be adding support for RISC-V and look at
supporting some of the features we offer on lowRISC such as [minion
cores or tagged 
memory](https://www.lowrisc.org/docs/memo-2014-001-tagged-memory-and-minion-cores/).
This will be great not only as a demo, but
also have practical uses in tutorial or educational material.

* TCP offload to minion cores using rump kernels. Sebastian Wicki
mentored by Justin Cormack
 * The intention here is to get a [rump kernel](http://rumpkernel.org/) 
(essentially a libified
NetBSD) running bare-metal on a simple RISC-V system and evaluate
exposing the TCP/IP stack for use by other cores. e.g. a TCP/IP
offload engine running on a minion core. TCP offload is a good
starting point, but of course the same concept could be applied
elsewhere. For example, running a USB mass storage driver (and filesystem
implementation) on a minion core and providing a simple high-level
interface to the application cores.

* Extend Tavor to support directed generation of assembly test cases.
Yoann Blein mentored by Markus Zimmermann
 * [Tavor](https://github.com/zimmski/tavor) is a sophisticated fuzzing tool 
implemented in Go. Yoann
will be extending it to more readily support specifying instruction
set features and generating a fuzzing suite targeting an ISA such as
RISC-V. Yoann has some really interesting ideas on how to go about
this, so I'm really interested in seeing where this on ends up.

* Implement a Wishbone to TileLink bridge and extend TileLink
documentation. Thomas Repetti mentored by Wei Song
 * [Wishbone](http://en.wikipedia.org/wiki/Wishbone_%28computer_bus%29) is the 
interconnect of choice for most existing open
source IP cores, including most devices on 
[opencores.org](http://opencores.org/). The Berkeley
[Rocket](https://github.com/ucb-bar/rocket-chip) RISC-V implementation uses 
their own 'TileLink' protocol (we provide a [brief 
overview](https://www.lowrisc.org/docs/tagged-memory-v0.1/rocket-chip/). By providing a
reusable bridge, this project will allow the easy reuse of opencores devices 
and leverage the many man-years of effort that has already gone in to them.

The first 3 of the above projects are part of Google Summer of Code
and the bottom 3 directly funded, operating over roughly the same timeline. 
We're also going to be having two local
students interning with us here at the University of Cambridge
Computer Lab starting towards the end of June, so it's going to be a
busy and productive summer. It bears repeating just how much we appreciate the 
support of everyone involved so far - Google through their Summer of Code 
initiative, the students, and those who've offered to act as mentors. We're 
very excited about these projects, so please join us in welcoming the students 
involved to our community. If you have any questions, suggestions, or guidance 
please do leave them in the comments.

_Alex Bradbury_
