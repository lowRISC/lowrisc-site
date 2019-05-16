+++
Description = ""
date = "2018-08-20T13:26:41+01:00"
title = "Releases"

+++

* [lowRISC with run/step debugging via JTAG and GDB]({{< ref "docs/refresh-v0.6/_index.md" >}})
<br>*Release version 0.6, released October 2018*
<br>This release updates the Rocket IP to March 2018 and includes compressed instructions and JTAG debugging conforming to the RISCV Debug Specification with custom JTAG DTM (see [JTAG internals]({{< ref "docs/jtag.md" >}}) for details). The root filing system is updated to use the mostly upstreamed Debian repository and the peripheral data path widths are increased to 64-bits for better performance.

* [lowRISC with 100MHz Ethernet and Network filing system access]({{< ref "docs/ethernet-v0.5/_index.md" >}})
<br>*Release version 0.5, 01-2018*
<br>This preview release provides a complete Ethernet reference design, tools, and NFS root capability.
This includes the ability to arp, ping, ssh client and server, mount remote NFS disks, and run a full multi-user system (within the available RAM and FPGA CPU performance limitations)
The SD-card interface is promoted to a Rocket peripheral to boost performance.
The human interface (keyboard and VGA compatible text display) are integrated as the default Rocket console.
We continue to support the Nexys4 DDR FPGA platform, only the Minion is omitted.
The [tutorial]({{< ref "docs/ethernet-v0.5/_index.md" >}})
outlines the build procedure and forthcoming releases that we are
planning.

* [lowRISC with tagged memory and minion core]({{< ref "docs/minion-v0.4/_index.md" >}})
<br>*Release version 0.4, 06-2017*
<br>This release provides a more complete prototype of tagged memory implementation.
This includes the ability to define tag propagation rules and policies that control when encountering unexpected tags should raise exceptions.
These features have been incorporated into the Rocket core.
An optimised tag cache has also been developed in order to minimise any additional main memory traffic from the use of tags.
A simple "minion" core is added to provide an SD-card interface.
This system also supports a keyboard and provides a VGA compatible text display.
We continue to support the Nexys4 DDR FPGA platform.
The [tutorial]({{< ref "docs/minion-v0.4/_index.md" >}})
outlines the build procedure and forthcoming releases that we are
planning.

* [lowRISC with a trace debugger]({{< ref "docs/debug-v0.3/_index.md" >}})
<br>*Release version 0.3, 07-2016*
<br>In this code release we present a first prototype of the lowRISC debug
infrastructure. It extends the `untethered` lowRISC system with the
means to control the system, load programs and trace the software
execution. The [tutorial]({{< ref "docs/debug-v0.3/_index.md" >}})
outlines the debug system and the future directions we are
planning. It demonstrates debugging with the RTL simulation and on
the Nexys4 DDR FPGA board.

* [Untethered lowRISC]({{< ref "docs/untether-v0.2/_index.md" >}})
<br>*Release version 0.2, 12-2015*
<br>A code release providing a standalone lowRISC by `untethering` the Rocket chip.
Cores in the original Rocket chip relies on a  companion processor to access I/O devices.
This release repalce this companion core with actual FPGA peripherals.
A [tutorial]({{< ref "docs/untether-v0.2/_index.md" >}}) explains how to use this code release and explains the underlying structural changes.

* [lowRISC with tagged memory]({{< ref "docs/tagged-memory-v0.1/_index.md" >}})
<br> *Release version 0.1, 04-2015*
<br>A code release builds on the Rocket RISC-V implementation to offer
support for tagged memory (see the [release blog post](
{{< ref "blog/lowrisc-tagged-memory-preview-release.md" >}})). We've put together an
[extensive tutorial]({{< ref "docs/tagged-memory-v0.1/_index.md" >}}) on how to use this
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
