+++
Description = ""
date = "2019-06-24T00:00:00+00:00"
title = "Tutorial for the v0.7 lowRISC release"
showdisqus = true

+++

_By [Jonathan Kimmitt]({{< ref "/docs/jonathankimmitt.md" >}}) (lead developer), and Alex Bradbury (lead reviewer)_ (also see acknowledgements below)

**Release version 0.7** (06-2019)

## Introduction

[lowRISC][lowRISC] is a not-for-profit community interest company whose goal is to
produce a fully open source System-on-Chip (SoC) in volume. We are
building upon RISC-V processor core implementations from the RISC-V
team at UC Berkeley, and the pulp-platform team at ETH-Zurich. We will produce a SoC design to populate a
low-cost community development board and to act as an ideal starting
point for derivative open-source and commercial designs. At the moment LowRISC CIC does not have the resources to harden
the IP itself into a chip, however the FPGA demonstrator will continue to improve.

This tutorial adds further functionality towards the final SoC design:

* Graphical Colour Console with X-windows support incorporating Bluetooth™ mouse and keyboard events.
* Choice of SD-Card, Quad-SPI or Ethernet TFTP boot-loader with DHCP support.
* Linux 5.3.18 mainline RISCV kernel and buildroot-2019.11-1 configurable userland (Debian support optional).
* Choice of 64-bit general purpose compressed (RV64-GC) Rocket (Chisel) or Ariane (SystemVerilog) CPU.

The build environment and pre-built images (if legally allowed to be distributed) support a competitively priced
[Nexys™4 DDR Artix-7 FPGA Board with 128M RAM]
(http://store.digilentinc.com/nexys-4-ddr-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/),
as well as the [Genesys2 Kintex-7 FPGA Board with 1GB RAM]
(https://store.digilentinc.com/genesys-2-kintex-7-fpga-development-board/).

The Nexys4-DDR has now been replaced by the functionally equivalent
[Nexys A7-100T](https://store.digilentinc.com/nexys-a7-fpga-trainer-board-recommended-for-ece-curriculum/) on Digilent's website.


| Function                 | _Tagged-v0.1_  | _Untethered-v0.2_ | _Debug-v0.3_   | _Minion-v0.4_      | _Ethernet-v0.5_ | _Refresh-v0.6_  | _Ariane-v0.7_   |
| --------------           | :----------:   | :--------------:  | :----------:   | :-----------:      | :-------------: | :-------------: | :-------------: |
| Rocket Priv. Spec.       |      ?         |       ?           |      1.7       | nearly 1.9.1       | nearly 1.9.1    | 1.10            | 1.10            |
| Tagged memory            |   *            |                   |                | *                  | *               |                 |                 |
| untethered operation     |                |   *               |      *         | *                  | optional        | *               | *               |
| SD card                  | tethered       |   SPI             |      SPI       | SD                 | SD              | SD              | SD              |
| UART console             | tethered       |   standard        | standard/trace | standard/trace/VGA | standard/VGA    | standard/VGA    | serial          |
| PS/2 keyboard            |                |                   |                | *                  | *               | *               | *               |
| PS/2 mouse               |                |                   |                |                    |                 |                 | *               |
| Minion Core              |                |                   |                | *                  |                 |                 |                 |
| Kernel md5 boot check    |                |                   |                | *                  | *               | *               | optional        |
| PC-free operation        |                |                   |                | *                  | *               | *               | optional        |
| Remote booting           |                |                   |                |                    | *               | *               | *               |
| Multiuser operation      |                |                   |                |                    | *               | *               | *               |
| Compressed instructions  |                |                   |                |                    |                 | *               | *               |
| Debian binary compatible |                |                   |                |                    |                 | *               | *               |
| Ariane SystemVerilog CPU |                |                   |                |                    |                 |                 | *               |
| frame buffer /dev/fb0    |                |                   |                |                    |                 |                 | *               |
| X-windows                |                |                   |                |                    |                 |                 | *               |
| SD-Card H/W accelerator  |                |                   |                |                    |                 |                 | *               |

### Contents

  1. [Release notes] ({{<ref "/docs/ariane-v0.7/release.md">}})
     * [**Version 0.7**: Ariane lowRISC (06-2019)]({{< ref "/docs/ariane-v0.7/release.md" >}})
     * [**Version 0.6**: technical refresh lowRISC (06-2018)]({{< ref "/docs/ariane-v0.7/release.md" >}})
     * [**Version 0.5**: ethernet multiuser lowRISC (12-2017)]({{< ref "/docs/ethernet-v0.5/release.md" >}})
     * [**Version 0.4**: minion tag cache lowRISC (6-2017)]({{< ref "/docs/minion-v0.4/release.md" >}})
     * [**Version 0.3**: trace debugger lowRISC (7-2016)]({{< ref "/docs/debug-v0.3/_index.md" >}})
     * [**Version 0.2**: untethered lowRISC (12-2015)]({{< ref "/docs/untether-v0.2/_index.md" >}})
     * [**Version 0.1**: tagged memory (04-2015)]({{< ref "/docs/tagged-memory-v0.1/_index.md" >}})

  2. [Index of development documentation]  ({{< ref "/docs/docs.md">}})

  3. [Frequently asked questions]  ({{< ref "/docs/frequently-asked-questions.md">}})
  
### Work planned / In progress / TO DO
* Implementing multi-block writes in the hardware accelerator.
* Eliminating any discrepancies between Rocket and Ariane behaviour.
* Expanding the available graphics resolution using DDR memory backing store.

### Acknowledgements
* Wei Song was lead hardware developer up to v0.4
* Stefan Wallentowitz and Philipp Wagner provided the trace debug system (from v0.3)
* Furkan Turan provided the Zedboard patches
* Philipp Jantscher did the initial tagged memory port to debug-v0.3
* The Ethernet transceiver library is due to Alex Forencich (http://alexforencich.com/wiki/en/verilog/ethernet/readme). The preview version was translated from VHDL written by Philipp Kerling (https://github.com/pkerling/ethernet_mac)
* Palmer Dabbelt maintains the Linux kernel port to RISCV
* Andrew Waterman and a large team now at SiFive developed the Rocket CPU
* Manuel Montecelo, Karsten Merker and Aurelien Jarno developed the Debian port to RISCV (https://wiki.debian.org/RISC-V#Creating_a_riscv64_chroot_from_a_merged_repository_with_debootstrap) and all assisted with debugging the bootstrap procedure on LowRISC.
* Ang Li of Princeton University (angl@princeton.edu) provided the new SD-Card block interface hardware
* Florian Zaruba and the pulp-platform team at ETH Zurich developed and released the Ariane System-Verilog core, and the new build system.
* The QPSI peripheral was adapted from a design written by Ilia Sergachev.
* The riscv set_ir command to set IR value for JTAG registers was contributed by Darius Rad <darius@bluespec.com>

### Other useful sources of information

  * [Open SoC Debug (Overview slides)](http://opensocdebug.org/slides/2015-11-12-overview/)

<!-- Links -->

[lowRISC]: https://www.lowrisc.org/
