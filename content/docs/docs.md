+++
Description = ""
date = "2019-06-24T00:00:00+01:00"
title = "Documentation"

+++

## Introduction

This page is an index to documentation for our 64-bit RISC-V SoC platform.
We'll be refreshing with further pointers to documentation for our
[other projects]({{< ref "/our-work" >}}).

These SoC platform code releases and documentation have the aim of easing the path of new users and students,
providing a robust tested platform for research into computer architecture,
and conforming to a license model which is compatible with commercial research
and development as well as IC manufacture. The current release is:

* [lowRISC with Ariane SystemVerilog CPU and X-windows support]({{< ref "docs/ariane-v0.7/tutorial.md" >}})
<br>*Release version 0.7, released February 2020*
<br>This release supports the Rocket CPU from the ariane-v0.7 release as well as the Ariane CPU. The (optional) Debian distribution has gone through some major refactoring to provide support for rust and llvm. We recommend using a slightly modified version of buildroot-2019.11-1, which includes preliminary support for X-windows. It does not support OpenGL or any kind of acceleration.

[All releases are available here] ({{< ref "docs/lowrisc-releases.md">}})

## What is included

Here you can find selected software and hardware IP which works together to produce an (almost) fully open-source computer system, consisting of:

* RISCV CPU, either Rocket written in the Chisel/Scala hardware description language, or Ariane written in System Verilog
* A variety of useful peripherals, UART, MMC/SD-Card controller, Ethernet(100/1000BaseT), Bluetooth, X-windows compatible screen
* PC-Compatible HID keyboard interface, additional Bluetooth Keyboard/Mouse (additional interfacing hardware PMOD-BT required)
* AXI compatible interface to proprietary DDR memory controller from Xilinx (included in Vivado)
* Choice of three boot loaders (QSPI flash memory, MMC/SD-Card, tftp Ethernet)
* RISCV-Linux kernel v5.3.18, supplemented with drivers to attach to the above peripherals
* Linux userland operating system based on buildroot-2019.11-1

### Getting started breakdown

The latest release has the instructions broken down by topic, instead of the release specific documentation that was included previously.

* [Introduction to development] ({{< ref "docs/introduction-to-development.md">}})
* [Overview of the latest release]({{< ref "docs/overview.md" >}})
* [Download the source code] ({{< ref "docs/download-the-code.md">}})
* [Install FPGA synthesis and simulation tools]({{< ref "docs/xilinx.md" >}})
* [Preparing the development environment] ({{< ref "docs/prepare-the-environment.md">}})
* [Build the buildroot tree] ({{< ref "docs/buildroot.md">}})
* [Produce an FPGA Bitstream] ({{< ref "docs/generate-the-bitstream.md">}})
* [Flash the SD-Card] ({{< ref "docs/flash-the-SD-Card.md">}})
* [Program the FPGA] ({{< ref "docs/program-the-FPGA.md">}})
* [Configure DHCP] ({{< ref "docs/DHCP-configuration.md">}})
* [Install support for RISCV emulation] ({{< ref "docs/RISCV-qemu-emulation.md">}})
* [Optional: downloading and Installing Debian] ({{< ref "docs/download-install-debian.md">}})
* [Remote Booting using tftp] ({{< ref "docs/boot-remote.md">}})
* [Booting the kernel from QSPI memory] ({{< ref "docs/boot-qspi.md">}})
* [Booting the kernel from SD-Card] ({{< ref "docs/boot-sd.md">}})
* [Preparing to launch X-windows] ({{< ref "docs/launch-xwindows.md">}})
* [Updating the kernel on a running system] ({{< ref "docs/update-running-kernel.md">}})
* [Booting a customised network filing system] ({{< ref "docs/boot-customised-NFS.md">}})
* [Debugging with gdb]  ({{< ref "docs/gdb.md">}})
* [Frequently asked questions for this release]  ({{< ref "docs/frequently-asked-questions.md">}})

### Internals description

* [Memory map] ({{< ref "docs/memory-map.md">}})
