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
<br>*Release version 0.7, released November 2019*
<br>This release supports the Rocket CPU from the ariane-v0.7 release as well as the Ariane CPU. The Debian distribution has been updated and now includes preliminary support for X-windows

[All releases are available here] ({{< ref "docs/lowrisc-releases.md">}})

## What is included

Here you can find selected software and hardware IP which works together to produce an (almost) fully open-source computer system, consisting of:

* RISCV CPU, either Rocket written in the Chisel/Scala hardware description language, or Ariane written in System Verilog
* A variety of useful peripherals, UART, MMC/SD-Card controller, Ethernet(100/1000BaseT), X-windows compatible screen
* PC-Compatible keyboard, mouse (additional interfacing hardware required)
* AXI compatible interface to proprietary DDR memory controller from Xilinx (included in Vivado)
* Choice of three boot loaders (QSPI flash memory, MMC/SD-Card, tftp Ethernet)
* RISCV-Linux kernel v5.1.3, supplemented with drivers to attach to the above peripherals
* RISCV-Debian operating system

### Getting started breakdown

The latest release has the instructions broken down by topic, instead of the release specific documentation that was included previously.

* [Introduction to development] ({{< ref "docs/introduction-to-development.md">}})
* [Overview of the Refresh system]({{< ref "docs/overview.md" >}})
* [Download the source code] ({{< ref "docs/download-the-code.md">}})
* [Install FPGA synthesis and simulation tools]({{< ref "docs/xilinx.md" >}})
* [Preparing the development environment] ({{< ref "docs/prepare-the-environment.md">}})
* [Produce an FPGA Bitstream] ({{< ref "docs/generate-the-bitstream.md">}})
* [Configure DHCP] ({{< ref "docs/DHCP-configuration.md">}})
* [Building a bare-metal tool chain] ({{< ref "docs/build-bare-metal-toolchain.md">}})
* [Install support for RISCV emulation] ({{< ref "docs/RISCV-qemu-emulation.md">}})
* [Downloading and Installing Debian] ({{< ref "docs/download-install-debian.md">}})
* [Build the Linux Kernel] ({{< ref "docs/linux-kernel-build.md">}})
* [Build the Berkeley boot loader (BBL)] ({{< ref "docs/build-berkeley-boot-loader.md">}})
* [Initiate Remote Booting] ({{< ref "docs/boot-remote.md">}})
* [Booting the kernel from QSPI memory] ({{< ref "docs/boot-qspi.md">}})
* [Preparing to launch X-windows] ({{< ref "docs/launch-xwindows.md">}})
* [Updating the kernel on a running system] ({{< ref "docs/update-running-kernel.md">}})
* [Booting a customised NFS system] ({{< ref "docs/boot-customised-NFS.md">}})
* [Frequently asked questions for this release]  ({{< ref "docs/frequently-asked-questions.md">}})
