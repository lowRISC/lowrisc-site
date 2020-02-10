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

Graphical frame buffer with 640 x 512 x 8 bit depth added. On Ariane the vertical resolution is reduced because its caches map less efficiently onto block rams.

Only one JTAG chain and cable interface is available on Nexys4-DDR. This means that gdb usage and Vivado usage are mutually exclusive.

The changes to the JTAG instruction register length and data register numbers announced in the previous release are unchanged.
The only software tool impacted is openocd, and necessary patches and new command script support have been upstreamed. This behaviour should not be confused with the nested tag chain support that certain SiFive chips make use of.
For more information about JTAG internals and the changes necessary for LowRISC, consult the following link:

* [JTAG internals]({{< ref "docs/jtag.md" >}})

## Overview of the boot process

The boot memory has been reduced from 64K to 32K. This allows more memory to be saved for the graphics. In addition,
the fonts in text mode share a memory with the colour palette in graphics mode.
Toggling of colour palettes in hardware is possible but not exploited by the operating system at the moment.

Three boot methods are available. For general kernel development the Ethernet method is the most convenient. In this mode the FPGA board
acts as a tftp (trivial file transfer protocol) server. The client is the workstation that compiled the kernel+BBL.
This is intended to make it easier to maintain, however being an older protocol, it is slower as each packet is smaller and individually acknowleged.
Centrally managed systems may have throttles on the rate of traffic supported on this protocol, and/or number of DHCP leases that can be given out.
Switching the FPGA board off may be used to reset the port on the remote switch and/or making a direct Ethernet cable (auto-crossover) to the workstation.

For general usage the SD-Card boot method is straightforward. This will be enabled automatically by the 'make sdcard-install' target.
It sits on the first partition of the SD-Card which is a DOS partition. The boot loader knows how to read this DOS partition.

QSPI booting is new to this release. It may be used by default or when it is necessary to repair the root partition without mounting it.
It has a limited capacity which is just sufficient to hold the FPGA bitstream, the Linux kernel, and a mini root partition containing busybox
utilities and fsck (which is called btrfs check if you use the recommended filing system). If you boot using QSPI and repairs are not necessary,
the boot procedure will segue into regular booting after a short delay without intervention. On GenesysII targets the QSPI also provides the
Ethernet MAC address in the OEM (original equipment manufacturer) are of the QSPI.

## Network root file system

The experimental NFS root file system of the previous release which was rather slow is supplemented by experimental
nbd (network block device) and aoe (ATA over Ethernet) support.

Each of these methods has advantages and disadvantages. The biggest problem is connecting into a 1000BaseT system that has the
potential to consume all the buffer memory in a matter of seconds. This is not such a problem for ordinary TCP and UDP traffic
that is naturally throttled into small chunks, but NFS servers will expect to deliver up to a megabyte in one hit (subject to connection
parameters).

## Future JTAG developments

The JTAG core offered previously was incompatible with Vivado usage. If an external JTAG (for example OLIMEX)
is available this can be used instead as the relevant plumbing is built into the top level. However providing
config files for all the possible configurations a user might want is outside the scope of this tutorial.

Please [get in touch with us]({{< ref "community.md" >}}) if you have ideas 
and opinions about future directions we should take.

Continue the process below:

* [Download the source code] ({{< ref "docs/download-the-code.md">}})
