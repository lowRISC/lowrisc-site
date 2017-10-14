+++
Description = ""
date = "2017-04-14T13:00:00+00:00"
title = "Overview of the ethernet infrastructure"
parent = "/docs/ethernet-v0.5P/"
next = "/docs/ethernet-v0.5P/environment/"
showdisqus = true

+++

<a name="figure-overview"></a>
<img src="../figures/lowRISC_tag.png" alt="Drawing" style="width: 600px; padding: 20px 0px;"/>

## Pre-defined Design constraints

Our goal of supporting the same FPGA board as the previous release
may only be realised with a single 100MHz Ethernet port, due to PCB design constraints.
Nevertheless it is conceived that 1GHz Ethernet could be made use of by a different board.

## Overview of the Remote boot process

Using a custom protocol from a remote PC allows the first-stage boot loader to fit in the 64K ROM
of the FPGA. It's contents are included in the bitstream as before. The boot process involves
transferring a kernel and initial filing system of approximately 5MBytes in around a minute.

## NFS root file system

The NFS root file system requires a separate server such as a Linux server or laptop.

## Future ethernet developments

This release incorporates a 'ethernet' core for the first time, but there is of
course much more to be done. In the future, we want to integrate support for intelligent
I/O, to have the ethernet control the boot process, perhaps with tftp, and to optimise
the interface between the ethernet and application cores (for example with DMA).

Please [get in touch with us]({{< ref "community.md" >}}) if you have ideas 
and opinions about future directions we should take. Now
it's time to learn more about the debug system or jump into using it:

 * [Prepare the environment and get started]({{< ref "docs/ethernet-v0.5P/environment.md" >}})
