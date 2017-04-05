+++
Description = ""
date = "2016-05-16T12:00:00+00:00"
title = "Tutorial for the debug preview of lowRISC"
showdisqus = true

+++

_By Jonathan Kimmitt and Wei Song_

**Release version 0.4** (07-2016)

## Introduction

[lowRISC][lowRISC] is a not-for-profit organisation whose goal is to
produce a fully open source System-on-Chip (SoC) in volume. We are
building upon RISC-V processor core implementations from the RISC-V
team at UC Berkeley. We will produce a SoC design to populate a
low-cost community development board and to act as an ideal starting
point for derivative open-source and commercial designs.

In previous tutorials you can learn about trace debugging, 
[tagged memory][TaggedMemoryTutorial] or how to run the design on an
FPGA as an [untethered system][UntetheredTutorial].

This tutorial adds further functionality towards the final SoC design
by adding a redesigned tag pipeline, and a Minion core supporting commodity PC peripherals
such as a 4-bit SD-card control, VGA-compatible display, and USB-keyboard - bare-metal and from Linux.
The previous debug infrastructure is still available but optional for the end-user.
The build environment and pre-built images supprt the same platform as the previous releases, a low-end
[Nexys™4 DDR Artix-7 FPGA Board]
(http://store.digilentinc.com/nexys-4-ddr-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/).

### Contents

  1. [Overview of the trace pipeline]({{< ref "docs/minion-v0.4/overview.md" >}})
    * [Minion interface]({{< ref "docs/minion-v0.4/interface.md" >}})

  2. [Prepare the environment]({{< ref "docs/minion-v0.4/environment.md" >}})
    * [Generic lowRISC setup]({{< ref "docs/minion-v0.4/lowriscsetup.md" >}})
    * [Open SoC Debug software]({{< ref "docs/minion-v0.4/osdsoftware.md" >}})

  3. [Debug walkthrough]({{< ref "docs/minion-v0.4/walkthrough.md" >}})
    * [Connecting to RTL simulation and enumeration]({{< ref "docs/minion-v0.4/simulation.md" >}})
    * [A debug session]({{< ref "docs/minion-v0.4/debugsession.md" >}})
	* [Running on the FPGA]({{< ref "docs/minion-v0.4/fpga.md" >}})

  4. Other
    * [SoC structure updates]({{< ref "docs/minion-v0.4/soc_struct.md" >}})
    * [How to add a new peripherial]({{< ref "docs/minion-v0.4/add_device.md" >}})
    * [Working with Zedboard]({{< ref "docs/minion-v0.4/zedboard.md" >}})

  5. [Release notes] ({{<ref "docs/minion-v0.4/release.md">}})
     * [**Version 0.3**: trace debugger lowRISC (7-2016)]({{< ref "docs/debug-v0.3/index.md" >}})
     * [**Version 0.2**: untethered lowRISC (12-2015)]({{< ref "docs/untether-v0.2/index.md" >}})
     * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/index.md" >}})

### Other useful sources of information

  * [Open SoC Debug (Overview slides)](http://opensocdebug.org/slides/2015-11-12-overview/)

<!-- Links -->

[lowRISC]: http://www.lowrisc.org/
[TaggedMemoryTutorial]: {{< ref "docs/tagged-memory-v0.1/index.md" >}}
[UntetheredTutorial]: {{< ref "docs/untether-v0.2/index.md" >}}

