+++
Description = ""
date = "2016-05-16T12:00:00+00:00"
title = "Tutorial for the debug preview of lowRISC"
showdisqus = true

+++

_By Stefan Wallentowitz and Wei Song_

**Release version 0.3** (07-2016)

## Introduction

[lowRISC][lowRISC] is a not-for-profit organisation whose goal is to
produce a fully open source System-on-Chip (SoC) in volume. We are
building upon RISC-V processor core implementations from the RISC-V
team at UC Berkeley. We will produce a SoC design to populate a
low-cost community development board and to act as an ideal starting
point for derivative open-source and commercial designs.

In previous tutorials you can learn about
[tagged memory][TaggedMemoryTutorial] or how to run the design on an
FPGA as an [untethered system][UntetheredTutorial].

This tutorial adds further functionality towards the final SoC design
by adding a debug infrastructure. It contains a technology preview of
what we plan and gives some background on the trace debugging
techniques. A demo is provided using a low-end
[Nexys™4 DDR Artix-7 FPGA Board]
(http://store.digilentinc.com/nexys-4-ddr-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/).

### Contents

  1. [Overview of the debug infrastructure]({{< ref "docs/debug-v0.3/overview.md" >}})
    * [Debug interface]({{< ref "docs/debug-v0.3/interface.md" >}})
    * [Debug modules]({{< ref "docs/debug-v0.3/debugmodules.md" >}})
	* [Debug software and methodology]({{< ref "docs/debug-v0.3/softwaremethodology.md" >}})

  2. [Prepare the environment]({{< ref "docs/debug-v0.3/environment.md" >}})
    * [Generic lowRISC setup]({{< ref "docs/debug-v0.3/lowriscsetup.md" >}})
    * [Open SoC Debug software]({{< ref "docs/debug-v0.3/osdsoftware.md" >}})

  3. [Debug walkthrough]({{< ref "docs/debug-v0.3/walkthrough.md" >}})
    * [Connecting to RTL simulation and enumeration]({{< ref "docs/debug-v0.3/simulation.md" >}})
    * [A debug session]({{< ref "docs/debug-v0.3/debugsession.md" >}})
	* [Running on the FPGA]({{< ref "docs/debug-v0.3/fpga.md" >}})

  4. Other
    * [SoC structure updates]({{< ref "docs/debug-v0.3/soc_struct.md" >}})
    * [How to add a new peripherial]({{< ref "docs/debug-v0.3/add_device.md" >}})
    * [Working with Zedboard]({{< ref "docs/debug-v0.3/zedboard.md" >}})

  5. [Release notes] ({{<ref "docs/debug-v0.3/release.md">}})
     * [**Version 0.2**: untethered lowRISC (12-2015)]({{< ref "docs/untether-v0.2/_index.md" >}})
     * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/_index.md" >}})

### Other useful sources of information

  * [Open SoC Debug (Overview slides)](http://opensocdebug.org/slides/2015-11-12-overview/)

<!-- Links -->

[lowRISC]: https://www.lowrisc.org/
[TaggedMemoryTutorial]: {{< ref "docs/tagged-memory-v0.1/_index.md" >}}
[UntetheredTutorial]: {{< ref "docs/untether-v0.2/_index.md" >}}

