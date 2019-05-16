+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "Untethered lowRISC tutorial"
showdisqus = true

+++

_By Wei Song_

**Release version 0.2** (12-2015)

## Introduction

[lowRISC][lowRISC] is a not-for-profit organisation whose goal is to
produce a fully open source System-on-Chip (SoC) in volume. We are
building upon RISC-V processor core implementations from the RISC-V
team at UC Berkeley.  We will produce a SoC design to populate a
low-cost community development board and to act as an ideal starting
point for derivative open-source and commercial designs.

This tutorial introduces a standalone implementation of the [Rocket chip][RocketChip].
The original Rocket chip relies on a companion processor
for accessing peripheral devices and I/O. This design replaces the companion
processor with actual peripheral devices on FPGA providing an 'untethered'
SoC that is able to boot a [RISC-V Linux][RISCVLinux]. A demo is provided using
either a [Xilinx Kintex-7 KC705 evaluation kit]
(http://www.xilinx.com/products/boards-and-kits/ek-k7-kc705-g.html)
or a low-end [Nexys™4 DDR Artix-7 FPGA Board]
(http://store.digilentinc.com/nexys-4-ddr-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/).

Please note that this release is based on recent upstream Rocket-chip sources 
and therefore it does not currently include the tagged memory support provided 
in our previous release. We plan to re-integrate tagged memory support with 
additional optimisations in the early half of next year.

The tutorial also acts as an introduction to the RISC-V tools and provides
a step-by-step guide to setting up the environment necessary to run
test programs either in simulation or on an FPGA.

### Contents

  1. [Overview of the Rocket chip]({{< ref "docs/untether-v0.2/overview.md" >}})
    * [Rocket core]({{< ref "docs/untether-v0.2/rocket-core.md" >}})
    * [Memory mapped I/O (MMIO)]({{< ref "docs/untether-v0.2/mmio.md" >}})
    * [Memory and I/O maps, soft reset, and interrupts]({{< ref "docs/untether-v0.2/pcr.md" >}})
    * [Bootload procedure]({{< relref "docs/untether-v0.2/bootload.md" >}})
    * [Configuration parameters]({{< ref "docs/untether-v0.2/parameter.md" >}})
  2. [The development environment]({{< ref "docs/untether-v0.2/dev-env.md" >}})
    * [Install Xilinx Vivado] ({{<ref "docs/untether-v0.2/xilinx.md">}})
    * [Install Verilator] ({{<ref "docs/untether-v0.2/verilator.md">}})
    * [Compile and install RISC-V cross-compiler] ({{<ref "docs/untether-v0.2/riscv_compile.md">}})
    * [Compile the RISC-V Linux and the ramdisk `root.bin`] ({{<ref "docs/untether-v0.2/linux_compile.md">}})
  3. [Simulations and FPGA Demo] ({{<ref "docs/untether-v0.2/simulation.md">}})
     * [Behavioural Simulation (Spike)] ({{<relref "docs/untether-v0.2/spike.md">}})
     * [RTL simulation] ({{<ref "docs/untether-v0.2/vsim.md">}})
     * [FPGA demo] ({{<ref "docs/untether-v0.2/fpga-demo.md">}})
     * [FPGA simulation] ({{<ref "docs/untether-v0.2/fpga-sim.md">}})
  4. [Release notes] ({{<ref "docs/untether-v0.2/release.md">}})
     * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/_index.md" >}})

### Other useful sources of information

  * [Setting up the RISC-V tools](https://github.com/riscv/riscv-tools/blob/master/README.md)
  * [Tagged memory and minion cores in the lowRISC SoC (lowRISC-MEMO 2014-001)](https://www.lowrisc.org/docs/memo-2014-001-tagged-memory-and-minion-cores/)
  * [The RISC-V Instruction Set Manual -- Volume I: User-Level ISA](https://riscv.org/specifications/)
  * [The RISC-V Instruction Set Manual -- Volume II: Privileged Architecture](https://riscv.org/specifications/privileged-isa/)

### Acknowledgements

Many thanks to the RISC-V team at Berkeley for all their support and
guidance. Special thanks to
Krste Asanović,
Scott Beamer,
Christopher Celio,
Henry Cook,
Yunsup Lee,
and
Andrew Waterman
for fielding numerous questions from us about the implementation
details of the Rocket core and chip.

Also thanks to Stefan Wallentowitz who has provided advice for this release.

<!-- Links -->

[RocketChip]: https://github.com/ucb-bar/rocket-chip
[Chisel]: https://chisel.eecs.berkeley.edu/
[lowRISC]: https://www.lowrisc.org/
[RISCVLinux]: https://github.com/riscv/riscv-linux
