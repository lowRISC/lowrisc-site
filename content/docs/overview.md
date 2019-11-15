+++
Description = ""
date = "2018-01-12T13:00:00+00:00"
title = "Overview of the latest release"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

<a name="figure-overview"></a>
<img src="/img/screenshot3.png" alt="Drawing" style="width: 600px; padding: 20px 0px;"/>

_The lowRISC Rocket system running X-windows with an xterm running vim showing the boot loader Ethernet handling code highlighted, load average, clock display and xfishtank in the background on a 640x512 screen with 8-bit pseudo-colour._

## Board support

Once again the aim of releasing a fully functional system on a low-cost board (the Nexys4-DDR) is achieved.

To satisfy the requirement to run X-windows some optimisations were made since the previous release:

boot loader reduced from 64K to 32K without removing critical functionality.

Graphical frame buffer with 640 x 512 x 8 bit depth added.

Only one JTAG chain and cable interface is available on Nexys4-DDR. This means that gdb usage and Vivado usage are mutually exclusive.

Our goal of supporting the same FPGA board as the previous release
may only be realised with slight changes to the JTAG instruction register length and data register numbers.
The only software tool impacted is openocd, and necessary patches and new command script support have been upstreamed. This behaviour should not be confused with the nested tag chain support that certain SiFive chips make use of.
For more information about JTAG internals and the changes necessary for LowRISC, consult the following link:

* [JTAG internals]({{< ref "docs/jtag.md" >}})

## Overview of the boot process

Ethernet and SD-Card booting is still available. However the remote Ethernet method uses a tftp server (trivial file transfer protocol)
instead of a custom protocol. This is intended to make it easier to maintain, however being an older protocol, it is slower as each
packet is smaller and individually acknowleged.

## NFS root file system

The experimental NFS root file system of the previous release which was rather slow is supplemented by experimental
nbd (network block device) and aoe (ATA over Ethernet) support.

## Future JTAG developments

The JTAG core offered previously was incompatible with Vivado usage. If an external JTAG (for example OLIMEX)
is available this can be used instead as the relevant plumbing is built into the top level.

Please [get in touch with us]({{< ref "community.md" >}}) if you have ideas 
and opinions about future directions we should take.

Continue the process below:

* [Download the source code] ({{< ref "docs/download-the-code.md">}})
