+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Tutorial for the v0.6 lowRISC release"
showdisqus = true

+++

_By Jonathan Kimmitt_ (also see acknowledgements below)

**Release version 0.6** (10-2018)

## Introduction

[lowRISC][lowRISC] is a not-for-profit organisation whose goal is to
produce a secure, flexible, and fully open source System-on-Chip (SoC). We are
building upon RISC-V processor core implementations from the RISC-V team at UC
Berkeley. This aims to be the ideal starting point for derivative open source
and commercial designs.

This tutorial adds further functionality towards the final SoC design:

* An eight packet buffer for Ethernet reception.
* Bare-metal GDB debugging over JTAG without any extra hardware.
* Processor speed doubled to 50MHz.
* Colour Console with proper PC-compatible keyboard events.
* Ethernet boot-loader DHCP support, ten times faster boot-loading.
* SD-Card boot-loader comprehensive card detection base on u-boot.
* Platform-level interrupt controller support.
* All peripheral data paths 64-bit width.
* Latest RISCV-kernel and Debian userland with advanced package tool.

The build environment and pre-built images support the same platform as the previous releases, a competitively priced
[Nexys™4 DDR Artix-7 FPGA Board]
(http://store.digilentinc.com/nexys-4-ddr-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/).

| Function              | _Tagged-v0.1_  | _Untethered-v0.2_ | _Debug-v0.3_ | _Minion-v0.4_ | _Ethernet-v0.5_ | _Refresh-v0.6_     |
| --------------        | :----------:   | :--------------:  | :----------: | :-----------: | :-------------: | :-------------: |
| Rocket Priv. Spec.    |      ?         |       ?           |      1.7     | nearly 1.91   | nearly 1.91     | 1.10 |
| Tagged memory         |   *            |                   |              | *             | *               |      |
| untethered operation  |                |   *               |      *       | *             | optional        | *    |
| SD card               | tethered       |   SPI             |      SPI     | SD            | SD              | SD   |
| UART console          | tethered       |   standard        |  standard/trace | standard/trace/VGA |standard/VGA | standard/VGA |
| PS/2 keyboard         |                |                   |              | *             | *               | * |
| Minion Core           |                |                   |              | *             |                 |   |
| Kernel md5 boot check |                |                   |              | *             | *               | * |
| PC-free operation     |                |                   |              | *             | *               | * |
| Remote booting        |                |                   |              |               | *               | * |
| Multiuser operation   |                |                   |              |               | *               | * |
| Compressed instructions |               |                  |              |               |                 | * |
| Debian binary compatible |              |                  |              |               |                 | * |

### Contents

  1. [Release notes] ({{<ref "docs/refresh-v0.6/release.md">}})
     * [**Version 0.6**: technical refresh lowRISC (06-2018)]({{< ref "docs/refresh-v0.6/release.md" >}})
     * [**Version 0.5**: ethernet multiuser lowRISC (12-2017)]({{< ref "docs/ethernet-v0.5/release.md" >}})
     * [**Version 0.4**: minion tag cache lowRISC (6-2017)]({{< ref "docs/minion-v0.4/release.md" >}})
     * [**Version 0.3**: trace debugger lowRISC (7-2016)]({{< ref "docs/debug-v0.3/_index.md" >}})
     * [**Version 0.2**: untethered lowRISC (12-2015)]({{< ref "docs/untether-v0.2/_index.md" >}})
     * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/_index.md" >}})

  2. [Getting started with binary releases] ({{< ref "docs/getting-started.md">}})

  3. [Index of development documentation]  ({{< ref "docs/_index.md">}})

  4. [Frequently asked questions]  ({{< ref "docs/current-release-faq.md">}})
  
### Work planned / In progress / TO DO
* Optimising card transfer speed / Implementing multi-block transfers.
* Offloading SD-card acceleration and Video scrolling to Minion.

### Acknowledgements
* Wei Song was lead hardware developer up to v0.4
* Stefan Wallentowitz and Philipp Wagner provided the trace debug system (from v0.3)
* Furkan Turan provided the Zedboard patches
* Philipp Jantscher did the initial tagged memory port to debug-v0.3
* The Ethernet transceiver library is due to Alex Forencich (http://alexforencich.com/wiki/en/verilog/ethernet/readme). The preview version was translated from VHDL written by Philipp Kerling (https://github.com/pkerling/ethernet_mac)
* Palmer Dabbelt maintained the Linux kernel port to RISCV
* Andrew Waterman and a large team at SiFive developed the Rocket CPU
* Manuel Montecelo, Karsten Merker and Aurelien Jarno developed the Debian port to RISCV (https://wiki.debian.org/RISC-V#Creating_a_riscv64_chroot_from_a_merged_repository_with_debootstrap) and all assisted with debugging the bootstrap procedure on LowRISC.
* Rick Chen and the u-boot team provided the basis of the first stage MMC/SD boot loader

### Other useful sources of information

  * [Open SoC Debug (Overview slides)](http://opensocdebug.org/slides/2015-11-12-overview/)

<!-- Links -->

[lowRISC]: https://www.lowrisc.org/
[TaggedMemoryTutorial]: {{< ref "docs/tagged-memory-v0.1/_index.md" >}}
[UntetheredTutorial]: {{< ref "docs/untether-v0.2/_index.md" >}}
[DebugTutorial]: {{< ref "docs/debug-v0.3/_index.md" >}}

