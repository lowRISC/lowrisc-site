+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Linux kernel build step"
parent = "/docs/refresh-v0.6/"
showdisqus = true

+++

## What's this all about?

Most of the support for RISCV specific development has taken place on very new versions of Linux.
A fully generic kernel is hard to achieve given all the possible scenarios 
where RISCV could be used. Nevertheless certain helperss are assumed to be 
always available which simplify matters:

  1. The Kernel entry address is 0x80200000
  2. Berkeley boot loader (BBL) handles the initial console output using it's SBI interface
  3. A device tree blob (DTB) is passed to Linux to enable it to decide which devices to enable. This blob is analogous to the BIOS settings in a traditional PC.

In addition an initial root filing system is needed to allow site specific 
configuration. This initial filesystem is responsible for loading the real 
rootfs, which might be on SD card or NFS.

The initial boot environment will interrogate the FPGA switch settings to decide how to boot:

| FPGA Switch: | 15..12 | 11..8 | 7..4 | 3..0 |
| ------ | ------ | ----- | ---- | ---- |
| Don't boot ||||0000|
| GDB boot ||||00?1|
| SD boot ||||0010|
| DHCP boot ||||0100|
| SD root |||0000||
| NFS root |||0001||
| Custom root |||001?||
| Reserved |||01??||
| Reserved |||1???||
| Reserved ||????|||
| MAC LSB |????||||

The LSB of the switches determines the boot address and should always be off unless GDB is in use. The SD boot and DHCP boot switches are interpreted by the boot loader to determine whether to check for an SD-Card presence or not. The SD root and NFS root options are determined by Linux using the /dev/gpio0 device, which also controls the LEDs. The decision making code is in debian-riscv64/work/busyboxinit.sh and is interpreted as an ash shell script. If a custom option is chosen the DOS partition the card will be mounted to search for further customisations (such as an address of a server to search for).

### You should already have prepared a cpio archive in the Debian directory. If not, visit here first:

* [Downloading and Installing Debian] ({{< ref "docs/download-install-debian.md">}})

or generate directly with this command:

    make -C ../debian-riscv64 cpio

or copy from the quickstart binary release:

    wget https://github.com/lowRISC/lowrisc-chip/releases/download/v0.6-rc3/initramfs.cpio

## Configuring and building the Linux kernel (independent of the device tree blob)

    cd $TOP/riscv-linux
    make ARCH=riscv defconfig
    make ARCH=riscv -j 4 CROSS_COMPILE=riscv64-unknown-linux-gnu- CONFIG_INITRAMFS_SOURCE="initramfs.cpio"

The next recommended step is:

* [Build the Berkeley boot loader (BBL)] ({{< ref "docs/build-berkeley-boot-loader.md">}})
