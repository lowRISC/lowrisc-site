+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Linux kernel build step"
parent = "/docs/refresh-v0.6/"
showdisqus = true

+++

## What's this all about?

Most of the support for RISCV specific development has taken place on very new versions of Linux.
A generic kernel is hardly possible with all the possible scenarios where a RISCV could be used.
Nevertheless certain helps are assumed to be always available which simplify matters:

  1. The Kernel entry address is 0x80200000
  2. Berkeley boot loader (BBL) handles the initial console output using it's SBI interface
  3. A device tree blob (DTB) is passed to Linux to enable it to decide which devices to enable. This blob is analogous to the BIOS settings in a traditional PC.

In addition an initial root filing system is needed to allow site specific configuration. This is known
as a cpio archive and it makes the initial decision which shall be the main boot device. This data structure
is purely held and in RAM and should be discarded as soon as possible once the boot device is identified

### You should already have prepared a cpio archive in the Debian directory. If not visit here first:

* [Downloading and Installing Debian] ({{< ref "docs/Debian.md">}})

or generate directly with this command:

    make -C ../debian-riscv64 cpio

or copy from the quickstart binary release:

    wget https://github.com/lowRISC/lowrisc-chip/releases/download/v0.6-rc3/initramfs.cpio

## Configuring and building the Linux kernel (independent of the device tree blob)

    cd $TOP/riscv-linux
    make ARCH=riscv defconfig
    make ARCH=riscv -j 4 CROSS_COMPILE=riscv64-unknown-linux-gnu- CONFIG_INITRAMFS_SOURCE="initramfs.cpio"

The next recommended step is:

* [Build the Berkeley boot loader (BBL)] ({{< ref "docs/BBL.md">}})
