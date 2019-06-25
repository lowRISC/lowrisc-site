+++
date = "2015-12-18T10:30:00Z"
title = "Untethered lowRISC release"

+++

Over the past several months, we've been working to provide a standalone or 
'untethered' SoC. Cores in the original [Rocket 
chip](https://github.com/ucb-bar/rocket-chip) rely on communicating with a 
companion processor via the host-target interface (HTIF) to access peripherals 
and I/O. This release removes this requirement, adding an I/O bus and 
instantiating FPGA peripherals. The accompanying [tutorial]({{< ref 
"docs/untether-v0.2/_index.md" >}}), written by Wei Song, describes how to 
build this code release and explains the underlying structural changes. We 
support both the [Xilinx 
KC705](http://www.xilinx.com/products/boards-and-kits/ek-k7-kc705-g.html) and 
the lower-priced [Nexys4 
DDR](http://store.digilentinc.com/nexys-4-ddr-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/) 
development boards. We would gladly welcome assistance in supporting other 
boards.

Please note that the codebase temporarily lacks support for tagged memory 
included in the [previous release]({{< ref "docs/tagged-memory-v0.1/_index.md" 
>}}). We plan to re-integrate tagged memory support 
with additional optimisations early next year. You can find a detailed list of 
changes in the [release notes]({{< ref "docs/untether-v0.2/release.md" >}}).
One highlight is support for [RTL simulation using the open-source Verilator 
tool]({{< ref "docs/untether-v0.2/vsim.md" >}}).

This development milestone should make it easier for others to contribute. If 
you're looking to get stuck in, you might want to consider looking at tasks 
such as:

* Cleaning up the [RISC-V Linux port](https://github.com/lowRISC/riscv-linux), 
improving devicetree support and removing the host-target interface.
* Replacing use of proprietary peripheral IP with open-source IP cores.
* Adding support for different FPGA development boards, including Altera 
boards.
* Implementing the [BERI Programmable Interrupt 
Controller](http://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-852.pdf) (p73), and 
adding necessary Linux support.

Our next development priorities are the re-integration of tagged memory 
support and an initial integration of a minion core design. We also expect to 
put out a job advert in the next few weeks for a new member of the lowRISC 
development team at the University of Cambridge Computer Laboratory.
Interested applicants are encouraged to make informal enquiries about the post 
to Rob Mullins <Robert.Mullins@cl.cam.ac.uk>.

We hope to see many of you at the [3rd RISC-V 
Workshop](https://riscv.org/2015/12/prelim-agenda-3rd-risc-v-workshop/) in January, where Wei Song
and Alex Bradbury will be presenting about lowRISC.
