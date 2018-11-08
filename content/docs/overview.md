+++
Description = ""
date = "2018-01-12T13:00:00+00:00"
title = "Overview of the Refresh system"
parent = "/docs/refresh-v0.6/"
showdisqus = true

+++

<a name="figure-overview"></a>
<img src="figures/lowRISC_tag.png" alt="Drawing" style="width: 600px; padding: 20px 0px;"/>

## Pre-defined Design constraints

Our goal of supporting the same FPGA board as the previous release
may only be realised with slight changes to the JTAG instruction register length and data register numbers.
The only software tool impacted is openocd, and this has been patched for this release to allow the alternative
numbers to be used if Xilinx is detected as the manufacturer ID
due to FPGA design constraints.

For more information about JTAG internals and the changes necessary for LowRISC, consult the following link:

* [JTAG internals]({{< ref "docs/jtag.md" >}})

## Overview of the Remote boot process

The same booting options as ethernet-v0.5 are available. We also add a new method which replaces
some of the functionality of the trace debugger that was first offered in v0.3: this is the GDB/openocd pairing
which will be familiar to some due to its popularity in low-cost ARM debugging environments.

## NFS root file system

The NFS root file system requires a separate server such as a Linux server or laptop. Regardless of whether
NFS or SD root is used, the previous riscv-poky release is replaced by (almost) upstream Debian binaries,
eliminating the requirement to build the userland from scratch, a lengthy and error-prone process.

## Future JTAG developments

This release incorporates a JTAG core for the first time, but there is of
course much more to be done. The top priority is making GDB/openocd cognisant of the
different virtual memory features offered in the different modes.

Please [get in touch with us]({{< ref "community.md" >}}) if you have ideas 
and opinions about future directions we should take.

Continue the process below:

* [Download the source code] ({{< ref "docs/download-the-code.md">}})
