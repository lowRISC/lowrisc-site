+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Documentation"

+++

## Code Releases

* [lowRISC with tagged memory and minion core]({{< ref "docs/minion-v0.4/index.md" >}})
<br>*Release version 0.4, 04-2017*
<br>This release provides a more complete prototype of tagged memory implementation.
This includes the ability to define tag propagation rules and policies that control when encountering unexpected tags should raise exceptions.
These features have been incorporated into the Rocket core.
An optimised tag cache has also been developed in order to minimise any additional main memory traffic from the use of tags.
A simple "minion" core is added to provide an SD-card interface.
This system also supports a keyboard and provides a VGA compatible text display.
We continue to support the Nexys4 DDR FPGA platform.
The [tutorial]({{< ref "docs/minion-v0.4/index.md" >}})
outlines the build procedure and forthcoming releases that we are
planning.

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

Over the summer of 2016 we hosted a group of interns, kindly sponsored by [IMC 
Financial Markets](http://www.imc.nl) who worked on adding custom acceleraors 
for video decoding to the lowRISC platform. This work resulted in the creation 
of several documents:

* A detailed [report]({{< ref "docs/internship-2016/report.md" >}}) on what 
was produced over the summer, what went well and what didn't, as well as a 
description of the accelerators.
* A tutorial on [adding new stream processors]({{< ref 
"docs/internship-2016/accelerator-tutorial.md" >}}) to the video accelerator 
infrastructure developed over the summer.
* A tutorial on [extending lowRISC with new devices]({{< ref 
"docs/internship-2016/device-tutorial.md" >}}).
* A guide describing how to [recreate the video decode demo]({{< ref 
"docs/internship-2016/video-tutorial.md" 
>}}).


Although now over, you may be interested in our [project
idea list for Google Summer of Code 2015]({{< ref "docs/gsoc-2015-ideas.md" 
>}}) and for [GSoC 2016]({{< ref "docs/gsoc-2016-ideas.md" >}}).

