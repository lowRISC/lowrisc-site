+++
Description = ""
date = "2019-06-10T15:00:00+01:00"
title = "An update on Ibex, our microcontroller-class CPU core"

+++

At the beginning of many chips projects, there’s a dream. Could we create a more
future-proof chip by embedding an FPGA fabric into it? Could we measure glucose
levels more accurately by integrating a small bio lab onto a chip? Could we more
reliably recognize kittens in a set of pictures by implementing neural network
inference in hardware?

In implementation, this dream becomes a piece of hardware, with digital or
analog logic, sensors, actuators, and much more. Let’s get it produced and try
out the real thing! But wait. How do you control the hardware block? How do you
feed data to it? How do you make sure the startup sequence is done exactly in
the right way? The answer often is: add an embedded micro-controller core to
handle the control logic. A small, efficient, and rock-solid core. Where could
you get such a core?

Say hello to Ibex: a small, 32-bit microcontroller-class RISC-V CPU core written
in SystemVerilog. Reliable, unpretentious, getting the job done.

* Ibex supports the standard RV32I/EMC instruction set, allowing you to tap into
a large ecosystem of compilers and software libraries.
* Its two stage pipeline design balances a small area overhead with good
performance. It gives you an IPC of 0.67 in CoreMark (2.44 CoreMarks/MHz) with
an area of just 18.9 kGE. That’s 0.027 mm² in a 65 nm technology!
([Reference](https://doi.org/10.1109/PATMOS.2017.8106976)) But Ibex works
equally well on FPGAs. The same configuration utilizes 2.5 k 6-input Slice LUTs
and 1 DSP slice on low-end Xilinx 7-series FPGAs when targeting a clock
frequency of 50 MHz.
* And best of all: there are no usage restrictions. Ibex is open source under
the Apache 2.0 License, [download it today](https://github.com/lowRISC/ibex/)
and get started!

So if you need a microcontroller-class CPU core, look no further and give Ibex a
try! Our friendly community awaits you [over at
GitHub](https://github.com/lowRISC/ibex/) to discuss enhancements, issues or
help you get your favorite feature added to Ibex!

![Ibex block diagram](/img/Ibex_block_diagram-100619.png "Ibex block diagram")

If you're interested in using Ibex in your design, you'd be in good company.
Researchers at the University of Manchester (with support from Andrew Attwood
from the STFC Hartree Centre) are already working on taping out a design including
the Ibex core, with reconfigurable FPGA instruction set
extensions. Do get in touch at [info@lowrisc.org](mailto:info@lowrisc.org) if
you’re looking to integrate Ibex into one of your designs…

![University of Manchester design with Ibex
core](/img/forte_placement.png "University of Manchester design with
Ibex core")

Ibex stands on an impressive mountain of engineering, erected by many great
people mostly at ETH Zürich and the University of Bologna. Before [it was
contributed to
lowRISC](/blog/2019/05/lowrisc-expands-press-release/) in
December 2018, Ibex was called Zero-riscy. The history of the core can be traced
back to a CPU core called “OR10N”, which was first taped out in 2013. Since that
time, many, many hours of engineering, testing,
and benchmarking went into what is now Ibex. That’s why it is such a solid
design, and that’s the legacy lowRISC is proud to build upon. 

lowRISC started working on Ibex around the time I joined the engineering team,
since then we’ve been able to make a range of improvements in collaboration with
our partners at Google and ETH Zürich, with [Pirmin also
joining](/blog/2019/06/introducing-pirmin-laura/) the
effort recently.

One of the first things we did with Ibex was the replacement of the debug system
with one that is compliant to the RISC-V Debug Specification. (Thanks to Robert
Balas and Davide Schiavone who started this work on a similar CPU core!) We also
cleaned up the code in many places to make it easier to read and extend. And
just recently Tao Liu from Google added a UVM testbench to make it easier to
verify that the core works as expected. 

Importantly, this is an active and ongoing effort. With the engineering and
project maintenance resources lowRISC and our partners are putting into Ibex and
related IP blocks, we aim to make it the make Ibex _the_ go-to
microcontroller-class CPU core. Our [issue tracker on
GitHub](https://github.com/lowRISC/ibex/issues) should give you a rough idea of
what’s coming.

Do you want to join us making Ibex even better? For example, do you want to set
up world-class continuous integration for this core? lowRISC is hiring, and
we’re looking for a broad range of engineers: hardware, software and tooling.
[Join us!](/jobs/)

You want to know more about Ibex and how lowRISC develops it to be a piece of
high-quality free and open source IP? [Join Philipp for a talk at the Week of
Open Source Hardware (WOSH) in Zürich, Switzerland on Friday, June
14.](https://fossi-foundation.org/wosh/)

_Philipp Wagner_
