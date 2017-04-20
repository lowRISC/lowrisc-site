+++
Description = ""
date = "2017-04-14T13:00:00+00:00"
title = "Tutorial for the v0.4 lowRISC release"
showdisqus = true

+++

_By Jonathan Kimmitt and Wei Song_ (Stefan Wallentowitz co-authored the previous version)

**Release version 0.4** (04-2017)

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

* The addition of tag cache, with further optimisations vs our previous
releases
* A tag pipeline to allow customised tag rules and for tags to be
used to enforce program invariants
* A Minion core supporting commodity PC peripherals such as a 4-bit SD-card
control, VGA-compatible display, and USB-keyboard - bare-metal and from Linux.

The previous debug infrastructure is still available but optional for the end-user.
The build environment and pre-built images supprt the same platform as the previous releases, a low-end
[Nexys™4 DDR Artix-7 FPGA Board]
(http://store.digilentinc.com/nexys-4-ddr-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/).

### Contents

  1. [Overview of the Minion system]({{< ref "docs/minion-v0.4/overview.md" >}})
    * [Minion internals]({{< ref "docs/minion-v0.4/minion.md" >}})
  2. [Prepare the environment]({{< ref "docs/minion-v0.4/environment.md" >}})
    * [Generic lowRISC setup]({{< ref "docs/minion-v0.4/lowriscsetup.md" >}})
 
  3. [Tagged memory developments]({{< ref "docs/minion-v0.4/tag_lowrisc.md" >}})
   * [Hierarchical tag cache]({{< ref "docs/minion-v0.4/tag_cache.md" >}})
   * [Tag Support]({{< ref "docs/minion-v0.4/tag_core.md" >}})

  4. Other
   * [Walkthrough]({{< ref "docs/minion-v0.4/walkthrough.md" >}})
   * [Running on the FPGA]({{< ref "docs/minion-v0.4/fpga.md" >}})
 
  5. [Release notes] ({{<ref "docs/minion-v0.4/release.md">}})
     * [**Version 0.4**: minion tag cache lowRISC (4-2017)]({{< ref "docs/minion-v0.4/release.md" >}})
     * [**Version 0.3**: trace debugger lowRISC (7-2016)]({{< ref "docs/debug-v0.3/index.md" >}})
     * [**Version 0.2**: untethered lowRISC (12-2015)]({{< ref "docs/untether-v0.2/index.md" >}})
     * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/index.md" >}})

### Other useful sources of information

  * [Open SoC Debug (Overview slides)](http://opensocdebug.org/slides/2015-11-12-overview/)

<!-- Links -->

[lowRISC]: http://www.lowrisc.org/
[TaggedMemoryTutorial]: {{< ref "docs/tagged-memory-v0.1/index.md" >}}
[UntetheredTutorial]: {{< ref "docs/untether-v0.2/index.md" >}}
[DebugTutorial]: {{< ref "docs/debug-v0.3/index.md" >}}

