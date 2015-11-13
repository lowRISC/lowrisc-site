+++
Description = ""
date = "2015-10-20T14:14:00+01:00"
title = "Untethered lowRISC tutorial"
showdisqus = true

+++

_By Wei Song_

**Release version 0.2**

## Introduction

### Contents

  1. [Overview of the Rocket chip]
  2. [Overview of the Rocket core]
  3. [The development environment]({{< relref "dev-env.md" >}})
    * [Install Xilinx Vivado] ({{<relref "xilinx.md">}})
    * [Install Verilator] ({{<relref "verilator.md">}})
    * [Compile and install RISC-V cross-compiler] ({{<relref "riscv_compile.md">}})
    * [Compile the RISC-V Linux and the ramdisk `root.bin`] ({{<relref "linux_compile.md">}})
  4. [Simulations and FPGA Demo] ({{<relref "simulation.md">}})
     * [Behavioural Simulation (Spike)] ({{<relref "spike.md">}})
     * [RTL simulation] ({{<relref "vsim.md">}})
     * [FPGA demo] ({{<relref "kc705.md">}})
     * [FPGA simulation] ({{<relref "kc705-sim.md">}})
  6. [Release notes] ({{<relref "release.md">}})
     * [**Version 0.1**: tagged memory (04-2015)]({{< relref "docs/tagged-memory-v0.1/index.md" >}})

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
