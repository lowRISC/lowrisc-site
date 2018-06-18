+++
Description = ""
date = "2018-01-12T13:00:00+00:00"
title = "Overview of the JTAG infrastructure"
parent = "/docs/jtag-v0.6/"
next = "/docs/jtag-v0.6/environment/"
showdisqus = true

+++

<a name="figure-overview"></a>
<img src="../figures/lowRISC_tag.png" alt="Drawing" style="width: 600px; padding: 20px 0px;"/>

## Pre-defined Design constraints

Our goal of supporting the same FPGA board as the previous release
may only be realised with slight changes to the JTAG instruction register length and data register numbers.
The only software tool impacted is openocd and this has been patched for this release to allow the alternative
numbers to be used if Xilinx is detected as the manufacturer ID
due to PCB design constraints.
Nevertheless it is conceived that 1Gbps Jtag could be made use of by a different board.
However using this version of the FPGA the practical performance is limited to about 2 megabits per second.

## Overview of the Remote boot process

Using a custom protocol from a remote PC allows the first-stage boot loader to fit in the 64K ROM
of the FPGA. It's contents are included in the bitstream as before. The boot process involves
transferring a kernel and initial filing system of approximately 5MBytes in around a minute.

## NFS root file system

The NFS root file system requires a separate server such as a Linux server or laptop.

## Future jtag developments

This release incorporates a 'jtag' core for the first time, but there is of
course much more to be done. In the future, we want to integrate support for intelligent
I/O, to have the jtag control the boot process, perhaps with tftp, and to optimise
the interface between the jtag and application cores (for example with DMA).

Please [get in touch with us]({{< ref "community.md" >}}) if you have ideas 
and opinions about future directions we should take. Now
it's time to learn more about the debug system or jump into using it:

 * [Prepare the environment and get started]({{< ref "docs/jtag-v0.6/environment.md" >}})
