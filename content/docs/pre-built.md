+++
Description = ""
date = "2018-01-12T13:00:00+00:00"
title = "Using prebuilt images"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

## Getting Started with the ariane-v0.7 prebuilt binaries

This guide will walk you through downloading the binaries of the latest lowRISC release and booting it
on a Nexys4DDR FPGA.

*    You will require:
*    A Linux PC with sudo access with two readily accessible USB ports
*      (these instructions apply to Ubuntu 16.04.5 LTS)
*    A Nexys4DDR FPGA board from Digilent with combined power and USB cable
*    A micro-SD card (minimum 4GBytes capacity)
*    A PC-compatible SD-card reader

## Choosing a hardware configuration

lowRISC can be configured standalone, mimicking a PC, or with a remote serial console (not to be confused with the tethered option mentioned in some RISCV documentation sources). For the remote console option the FPGA configuration can come from USB memory stick, so the large (up to 28GBytes) Vivado installation is not required. For the standalone option it has to come from Quad-SPI flash memory.

### Remote console requirements

*   A USB memory stick if you don't want to use Vivado and Quad-SPI.
*   Install microcom or your favourite terminal emulator program (remote keyboard option only will be available)
*    You will need to use the following command to allow microcom to run as the non-superuser:
*    sudo usermod -a -G dialout $USER

### Standalone (PC free) requirements
    
*   A VGA compatible LCD monitor
*   A PS/2 style PC-AT keyboard with USB connector
*   A copy of Vivado 2018.1 webpack edition (with SDK if you plan to do development) to program the Quad-SPI

#### For both options a 100Base-T Ethernet cable to a home hub or corporate LAN is recommended.

The quickstart Makefile should be installed as follows:

    git clone https://github.com/lowRISC/lowrisc-quickstart.git
    cd lowrisc-quickstart
    
If you don't have git installed the following workaround may be used:

    wget https://github.com/lowRISC/lowrisc-quickstart/archive/master.zip
    unzip master
    cd lowrisc-quickstart-master

However the Makefile was obtained, proceed as follows to obtain the release files:

    make getrelease

Three files will be downloaded as follows:

*   boot.bin - The Linux kernel, Berkeley boot loader, and initial cpio (ramdisk)
*   chip_top.bit - The FPGA bitstream containing the RISCV processor and peripherals and the first-stage booter
*   rootfs.tar.xz - The compressed tape archive containing the Debian root filing system for RISCV
