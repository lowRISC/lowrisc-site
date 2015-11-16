+++
Description = ""
date = "2015-10-20T14:14:00+01:00"
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
point for deritivative open-source and commercial designs.

This tutorial introduces a standalone implementation of the [Rocket chip][RocketChip].
The original Rocket chip relies on a companion processor
for accessing peripheral devices and I/O. This design replaces the companion
processor with actual peripheral devices on FPGA providing an `untethered`
SoC that is able to boot a [RISC-V Linux][RISCVLinux]. A demo is provided using
the [Xilinx Kintex-7 KC705 evaluation kit]
(http://www.xilinx.com/products/boards-and-kits/ek-k7-kc705-g.html). 

The tutorial also acts as an introduction to the RISC-V tools and provides
a step-by-step guide to setting up the environment necessary to run
test programs either in simulation or on an FPGA.

### Contents

  1. [Overview of the Rocket chip]({{< ref "overview.md" >}})
    * [Rocket core]({{< ref "rocket-core.md" >}})
    * [Memory mapped I/O (MMIO)]({{< ref "mmio.md" >}})
    * [Memory and I/O maps, soft reset, and interrupts]({{< ref "pcr.md" >}})
    * [Bootload procedure]({{< ref "bootload.md" >}})
    * [Configuration parameters]({{< ref "parameter.md" >}})
  2. [The development environment]({{< ref "dev-env.md" >}})
    * [Install Xilinx Vivado] ({{<ref "xilinx.md">}})
    * [Install Verilator] ({{<ref "verilator.md">}})
    * [Compile and install RISC-V cross-compiler] ({{<ref "riscv_compile.md">}})
    * [Compile the RISC-V Linux and the ramdisk `root.bin`] ({{<ref "linux_compile.md">}})
  3. [Simulations and FPGA Demo] ({{<ref "simulation.md">}})
     * [Behavioural Simulation (Spike)] ({{<ref "spike.md">}})
     * [RTL simulation] ({{<ref "vsim.md">}})
     * [FPGA demo] ({{<ref "kc705.md">}})
     * [FPGA simulation] ({{<ref "kc705-sim.md">}})
  4. [Release notes] ({{<ref "release.md">}})
     * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/index.md" >}})

### Other useful sources of information

  * [Setting up the RISC-V tools](https://github.com/riscv/riscv-tools/blob/master/README.md)
  * [Tagged memory and minion cores in the lowRISC SoC (lowRISC-MEMO 2014-001)](http://www.lowrisc.org/docs/memo-2014-001-tagged-memory-and-minion-cores/)

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

<!-- Links -->

[RocketChip]: https://github.com/ucb-bar/rocket-chip
[Chisel]: https://chisel.eecs.berkeley.edu/
[lowRISC]: http://www.lowrisc.org/
[RISCVLinux]: https://github.com/riscv/riscv-linux