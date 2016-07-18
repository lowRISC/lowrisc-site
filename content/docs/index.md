+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Documentation"

+++

## Code Releases

* [lowRISC with a trace debugger]({{< ref "docs/debug-v0.3/index.md" >}})
<br>*Release version 0.3, 07-2016*
<br>In this code release we present a first prototype of the lowRISC debug
infrastructure. It extends the `untethered` lowRISC system with the
means to control the system, load programs and trace the software
execution. The [tutorial]({{< ref "docs/debug-v0.3/index.md" >}})
outlines the debug system and the future directions we are
planning. It demonstrates debugging with the RTL simulation and on
the Nexys4 DDR FPGA board.

* [Untethered lowRISC]({{< ref "docs/untether-v0.2/index.md" >}})
<br>*Release version 0.2, 12-2015*
<br>A code release providing a standalone lowRISC by `untethering` the Rocket chip.
Cores in the original Rocket chip relies on a  companion processor to access I/O devices.
This release repalce this companion core with actual FPGA peripherals.
A [tutorial]({{< ref "docs/untether-v0.2/index.md" >}}) explains how to use this code release and explains the underlying structural changes.

* [lowRISC with tagged memory]({{< ref "docs/tagged-memory-v0.1/index.md" >}})
<br> *Release version 0.1, 04-2015*
<br>A code release builds on the Rocket RISC-V implementation to offer
support for tagged memory (see the [release blog post](
{{< ref "blog/lowrisc-tagged-memory-preview-release.md" >}})). We've put together an
[extensive tutorial]({{< ref "docs/tagged-memory-v0.1/index.md" >}}) on how to use this
code release as well as documenting many of the changes made.

## Memos

Our [first memo](
{{< ref "docs/memo-2014-001-tagged-memory-and-minion-cores.md" >}}) describes our
plans for tagged memory and minion cores in lowRISC.

## Other

Student applications are now closed, but you may be interested in our [project
idea list for Google Summer of Code 2015]({{< ref "docs/gsoc-2015-ideas.md" >}}).

