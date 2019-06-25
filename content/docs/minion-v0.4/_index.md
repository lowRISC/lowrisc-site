+++
Description = ""
date = "2017-04-14T13:00:00+00:00"
title = "Tutorial for the v0.4 lowRISC release"
showdisqus = true

+++

_By Jonathan Kimmitt, Wei Song and Alex Bradbury_ (also see acknowledgements below)

**Release version 0.4** (06-2017)

## Introduction

[lowRISC][lowRISC] is a not-for-profit organisation whose goal is to
produce a fully open source System-on-Chip (SoC) in volume. We are
building upon RISC-V processor core implementations from the RISC-V
team at UC Berkeley. We will produce a SoC design to populate a
low-cost community development board and to act as an ideal starting
point for derivative open-source and commercial designs.

In previous tutorials you can learn about [trace debugging][DebugTutorial],
the [initial tagged memory implementation][TaggedMemoryTutorial] or how to run
the design on an FPGA using our [original untethered
implementation][UntetheredTutorial].

This tutorial adds further functionality towards the final SoC design:

* An optimised tag cache
* The ability to define tag propagation rules and policies for triggering exceptions
* A simple minion core sub-system for accessing the SD-interface, keyboard and VGA-compatible text display

The trace infrastructure is still available but standalone operation with keyboard/display is now possible for the end-user.

The build environment and pre-built images support the same platform as the previous releases, a competitively priced
[Nexys™4 DDR Artix-7 FPGA Board]
(http://store.digilentinc.com/nexys-4-ddr-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/).

| Function              | _Tagged-v0.1_  | _Untethered-v0.2_ | _Debug-v0.3_ | _Minion-v0.4_ |
| --------------        | :----------:   | :--------------:  | :----------: | :-----------: |
| Rocket Priv. Spec.    |      ?         |       ?           |      1.7     | nearly 1.91   |
| Tagged memory         |   *            |                   |              | *             |
| untethered operation  |                |   *               |      *       | *             |
| SD card               | tethered       |   SPI             |      SPI     | SD            |
| UART console          | tethered       |   standard        |  standard/trace | standard/trace/VGA |
| PS/2 keyboard         |                |                   |              | *             |
| Minion Core           |                |                   |              | *             |
| Kernel md5 boot check |                |                   |              | *             |
| PC-free operation     |                |                   |              | *             |

### Contents

  1. [Overview of the Minion system]({{< ref "docs/minion-v0.4/overview.md" >}})
    * [Minion internals]({{< ref "docs/minion-v0.4/minion.md" >}})
  2. [Prepare the environment]({{< ref "docs/minion-v0.4/environment.md" >}})
    * [Install FPGA and simulation tools]({{< ref "docs/minion-v0.4/installtools.md" >}})
 
  3. [Tagged memory developments]({{< ref "docs/minion-v0.4/tag_lowrisc.md" >}})
   * [Hierarchical tag cache]({{< ref "docs/minion-v0.4/tag_cache.md" >}})
   * [Tag Support]({{< ref "docs/minion-v0.4/tag_core.md" >}})

  4. Other
   * [Debug Walkthrough]({{< ref "docs/minion-v0.4/walkthrough.md" >}})
   * [Running on the FPGA]({{< ref "docs/minion-v0.4/fpga.md" >}})
 
  5. [Release notes] ({{<ref "docs/minion-v0.4/release.md">}})
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
* Furkan Turan provided the zedboard patches
* Philipp Jantscher did the initial tagged memory port to debug-v0.3

### Other useful sources of information

  * [Open SoC Debug (Overview slides)](http://opensocdebug.org/slides/2015-11-12-overview/)

<!-- Links -->

[lowRISC]: https://www.lowrisc.org/
[TaggedMemoryTutorial]: {{< ref "docs/tagged-memory-v0.1/_index.md" >}}
[UntetheredTutorial]: {{< ref "docs/untether-v0.2/_index.md" >}}
[DebugTutorial]: {{< ref "docs/debug-v0.3/_index.md" >}}

