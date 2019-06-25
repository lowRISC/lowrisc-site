+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Tutorial for the v0.5 lowRISC preview release"
showdisqus = true

+++

_By Jonathan Kimmitt, Wei Song and Alex Bradbury_ (also see acknowledgements below)

**Release version 0.5** (12-2017)

## Introduction

[lowRISC][lowRISC] is a not-for-profit organisation whose goal is to
produce a fully open source System-on-Chip (SoC) in volume. We are
building upon RISC-V processor core implementations from the RISC-V
team at UC Berkeley. We will produce a SoC design to populate a
low-cost community development board and to act as an ideal starting
point for derivative open-source and commercial designs.

This tutorial adds further functionality towards the final SoC design:

* A simple 100Mbps Ethernet capability.
* Remote booting via Ethernet from a Linux server.
* Preview of interrupt driven device drivers in Linux.
* Optimised SD-interface
* Console defaults to keyboard and optimised VGA-compatible text display.
* Network filing system (NFS) support in the RISCV kernel and NFS-root support scripts.
* Multiuser system leveraging the poky Linux build system.

The build environment and pre-built images support the same platform as the previous releases, a competitively priced
[Nexys™4 DDR Artix-7 FPGA Board]
(http://store.digilentinc.com/nexys-4-ddr-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/).

| Function              | _Tagged-v0.1_  | _Untethered-v0.2_ | _Debug-v0.3_ | _Minion-v0.4_ | _Ethernet-v0.5_ |
| --------------        | :----------:   | :--------------:  | :----------: | :-----------: | :-------------: |
| Rocket Priv. Spec.    |      ?         |       ?           |      1.7     | nearly 1.91   | nearly 1.91     |
| Tagged memory         |   *            |                   |              | *             | *               |
| untethered operation  |                |   *               |      *       | *             | optional        |
| SD card               | tethered       |   SPI             |      SPI     | SD            | SD              |
| UART console          | tethered       |   standard        |  standard/trace | standard/trace/VGA |standard/trace/VGA |
| PS/2 keyboard         |                |                   |              | *             | *                         |
| Minion Core           |                |                   |              | *             |                           |
| Kernel md5 boot check |                |                   |              | *             | *                         |
| PC-free operation     |                |                   |              | *             | *                         |
| Remote booting        |                |                   |              |               | *                         |
| Multiuser operation   |                |                   |              |               |                           |

### Contents

  1. [Overview of the Ethernet system]({{< ref "docs/ethernet-v0.5/overview.md" >}})
    * [Ethernet internals]({{< ref "docs/ethernet-v0.5/ethernet.md" >}})
  2. [Prepare the environment]({{< ref "docs/ethernet-v0.5/environment.md" >}})
    * [Install FPGA and simulation tools]({{< ref "docs/ethernet-v0.5/installtools.md" >}})
 
  4. Demo
   * [Running pre-built NFS-root image on the FPGA]({{< ref "docs/ethernet-v0.5/fpga.md" >}})
   * [Running pre-built SD-card image on the FPGA]({{< ref "docs/ethernet-v0.5/fpga2.md" >}})
   * [Developing/building from scratch on the FPGA]({{< ref "docs/ethernet-v0.5/development.md" >}})
 
  5. [Release notes] ({{<ref "docs/ethernet-v0.5/release.md">}})
     * [**Version 0.5**: ethernet multiuser lowRISC (12-2017)]({{< ref "docs/ethernet-v0.5/release.md" >}})
     * [**Version 0.4**: minion tag cache lowRISC (6-2017)]({{< ref "docs/minion-v0.4/release.md" >}})
     * [**Version 0.3**: trace debugger lowRISC (7-2016)]({{< ref "docs/debug-v0.3/_index.md" >}})
     * [**Version 0.2**: untethered lowRISC (12-2015)]({{< ref "docs/untether-v0.2/_index.md" >}})
     * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/_index.md" >}})

### Work planned / In progress / TO DO
* Interfacing Pulpino (Minion) core to on-chip trace/debug bus.
* Programming Minion dynamically from Rocket under Linux.
* Optimising card transfer speed / Implementing multi-block transfers.
* GDB support under Linux.
* Revised interrupt handling block.
* Ethernet interfacing / booting / Linux support.
* Fully supporting tag instructions in compiler.
* Making tag support thread-safe / context switching safe.
* More security demos.
* Userland software running on the Rocket.
* Offloading SD-card acceleration and Video scrolling to Minion.
* Run-control debug for Rocket.

### Acknowledgements
* Stefan Wallentowitz and Philipp Wagner provided the trace debug system
* Furkan Turan provided the Zedboard patches
* Philipp Jantscher did the initial tagged memory port to debug-v0.3
* The Ethernet transceiver library is due to Alex Forencich (http://alexforencich.com/wiki/en/verilog/ethernet/readme). The preview version was translated from VHDL written by Philipp Kerling (https://github.com/pkerling/ethernet_mac)

### Other useful sources of information

  * [Open SoC Debug (Overview slides)](http://opensocdebug.org/slides/2015-11-12-overview/)

<!-- Links -->

[lowRISC]: https://www.lowrisc.org/
[TaggedMemoryTutorial]: {{< ref "docs/tagged-memory-v0.1/_index.md" >}}
[UntetheredTutorial]: {{< ref "docs/untether-v0.2/_index.md" >}}
[DebugTutorial]: {{< ref "docs/debug-v0.3/_index.md" >}}

