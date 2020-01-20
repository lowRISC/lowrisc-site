+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Linux kernel build step"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

## What's this all about?

Most of the support for RISCV specific development has taken place on very new versions of Linux. The lowRISC release
uses a patched version of linux-5.3.8 (the latest stable version at the time of writing).

A fully generic kernel is hard to achieve given all the possible scenarios 
where RISCV could be used. Nevertheless certain helpers are assumed to be 
always available which simplify matters:

  1. The Kernel entry address is 0x80200000
  2. Berkeley boot loader (BBL) handles the initial console output using its SBI interface
  3. A device tree blob (DTB) is passed to Linux to enable it to decide which devices to enable. This blob is analogous to the BIOS settings in a traditional PC. This device tree will vary according to which CPU is chosen and which FPGA board (due to memory size limits).

All build stages that require a kernel to be pre-built, will invoke the kernel build automatically. However the user may
have a preference between different flavours of Linux. All variants use the same source code, only the configuration changes.

## Configuring and building the Linux kernel (independent of the device tree blob)

    make linux # plain linux with serial console and SD-Card root
    make visual # VGA console, SD-Card root

## Kernels for experimental use and/or advanced users

    make rescue # serial console, miniroot with fsck, busybox, and network access
    make install # serial console with Debian installer root
    make vinstall # VGA console, Debian installer root

Only the rescue kernel requires a pre-built Debian image as part of its function. the experimental install kernels fetch the Debian installer from upstream servers. This functionality is considered beta because of the intensive network and disk access. Most users will prefer the plain linux kernel unless they have a VGA screen and keyboard. Ariane builds are more robust with the rescue kernel, even if the root filing system doesn't require checking. This is believed to be related to the performance aspects and internal processor micro-architecture. If not in rescue mode, the new SD-Card block drivers allows the main root filing system to be selected immediately on boot. If the Debian installer target is chosen and succeeds, it only installs a basic system, not the X-windows system that is produced by the normal instructions.

All kernel builds will compile and append BBL to the head of the executable. To do this manually visit the following:

* [Build the Berkeley boot loader (BBL)] ({{< ref "docs/build-berkeley-boot-loader.md">}})
