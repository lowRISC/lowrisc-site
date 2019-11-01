+++
Description = ""
date = "2019-10-08T16:30:00+01:00"
title = "Ibex on FPGA - Get stuff executed"

+++

Our microcontroller-class RISC-V processor core
[Ibex](https://github.com/lowRISC/ibex/) for sure is a solid base with which to
start your own project. Over the past months, we have invested a lot of effort
in making the design more mature. This includes [refactoring the RTL to make the
design more understandable and programmer
friendly](https://www.lowrisc.org/blog/2019/07/six-more-weeks-of-ibex-development-whats-new/),
adding UVM-based verification to the source tree, but also integrating support
for the RISC-V compliance suite and [enabling publicly visible, open-source
powered continuous integration
(CI)](https://www.lowrisc.org/blog/2019/08/ibex-code-with-confidence/) to keep
the design stable. 

However, to actually get your own RISC-V system running, quite some more
infrastructure might be needed besides the bare processor core. This includes
for example instruction and data memory, input/outputs, peripherals, interrupt
controllers, a debug module. But don’t worry, we can help you out! There are now
two different system-on-chip designs available to help you get started with Ibex
on FPGA.

![Ibex on the Nexys Video FPGA board](/img/Ibex_on_Nexys_Video.jpg "Ibex on the Nexys Video FPGA board.")

_Ibex on the Nexys Video FPGA board._

## Arty A7 FPGA Example

This is fairly minimal example for the Arty A7 Artix-7 FPGA Development Board
from Digilent that shows you how to integrate Ibex into a top-level design, how
to connect memories and how to compile and run a simple application on the core.
This example is included in the Ibex tree and is a community contribution by
Tobias Wölfel. Thanks @towoe!

## PULPissimo

[PULPissimo](https://github.com/pulp-platform/pulpissimo) is the advanced
microcontroller system from the [PULP team](https://pulp-platform.org) at ETH
Zürich. It features a powerful uDMA for an autonomous input/output subsystem
managing peripherals like UART, SPI, I2C and I2S, supports hardware processing
elements, comes with a JTAG debug module and is supported by the [PULP software
development kit (SDK)](https://github.com/pulp-platform/pulp-sdk) that comes
with suitable compilers, libraries and even example applications. This complete
ecosystem makes PULPissimo a useful starting point for your own project and
explorations. 

Besides re-integrating Ibex into PULPissimo we also created a new FPGA port for
the latest version (Commit ID d37549e). PULPissimo can now be instantiated on
the Digilent Nexys Video Artix-7 FPGA board. This board is equipped with a
XC7A200T device - the largest Artix-7 FPGA supported by the free Vivado WebPACK
Edition - and thus an attractive target for hobbyists.

The picture below visualizes the mapping of the main components inside
PULPissimo onto the resources provided by the Nexys Video FPGA board. Ibex
utilizes a fairly small part of the overall resources (3500 LUTs, roughly 2.6%
of the available resources). There is still plenty of space available for you to
implement you own modules such as custom accelerators!

![PULPissimo implementation on the Nexys Video FPGA
board](/img/PULPissimo_on_Nexys_Video.png "PULPissimo implementation on the
Nexys Video FPGA board")

_PULPissimo implementation on the Nexys Video FPGA board._

As you might know, Ibex was originally developed as Zero-riscy at ETH Zürich and
contributed to us in Dec 2018. We are thus even more happy to enable support for
the latest version of Ibex in the PULPissimo system and give something back to
the PULP team!

## What’s next?

We continue our efforts on making Ibex more robust and extending functionality.
We recently added support for Physical Memory Protection and U-mode. This
will make Ibex a good candidate for porting embedded and real-time operating
systems.

_Pirmin Vogel_
