+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Build Berkeley boot loader"
parent = "/docs/refresh-v0.6/"
showdisqus = true

+++

## What is this for ?

The RISCV specification defines (optionally) three main modes of operation: user, supervisor, and machine mode. Some documents also refer to a hypervisor mode, which may or may not be necessary. Some of the differences are:

* User mode: the mode which runs the users programs and the lowest privilege level.
  1. No direct access to I/O or privileged instructions or kernel memory or other processes.
  2. Memory management unit always on under Linux.
* Supervisor mode: the mode that the majority of the Linux kernel or other O/S runs.
  1. Access to most privileged instructions and I/O via ioremap function.
  2. Memory management unit may be on or off.
* Machine mode: Bare-metal / First-stage boot loader and BBL runs in this mode.
  1. Memory management off.
  2. No memory protection. 
* Hypervisor mode: Might be supported in future, would be used to support virtualisation such as Xen hypervisor.

A simple summary of BBL is that it is the executable of last-resort when neither user-mode nor Linux cannot handle an operation. Currently it handles:

  1. Any illegal instructions that the RISCV processor is not equipped to handle directly in hardware.
  2. Initiation and responding to timer interrupts.
  3. Handling unaligned memory accesses (deprecated because it slows things a great deal).
  4. Chain loading and initial console access when Linux is booting, to simplify the first-stage boot loader.
  
Now configure and build Berkeley Boot loader

    cd $TOP/rocket-chip/riscv-tools/riscv-pk/
    mkdir -p build
    cd build
    ../configure --prefix=$RISCV --host=riscv64-unknown-elf --with-payload=$TOP/riscv-linux/vmlinux --enable-logo
    make
    cp -p bbl $TOP/fpga/board/nexys4_ddr/boot.bin
    riscv64-unknown-elf-strip $TOP/fpga/board/nexys4_ddr/boot.bin

The use of the strip command minimises the download size for use with Ethernet or MMC/SD-Card loading.

Next step:

* [Initiate Remote Booting] ({{< ref "docs/boot-remote.md">}})
