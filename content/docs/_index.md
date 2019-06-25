+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Documentation"

+++

## Introduction

This page is an index to documentation for our 64-bit RISC-V SoC platform.
We'll be refreshing with further pointers to documentation for our [other
projects]({{< ref "our-work.md" >}}).

These SoC platform code releases and documentation have the aim of easing the path of new users and students,
providing a robust tested platform for research into computer architecture,
and conforming to a license model which is compatible with commercial research
and development as well as IC manufacture. The current release is:

* [lowRISC with run/step debugging via JTAG and GDB]({{< ref "docs/refresh-v0.6/_index.md" >}})
<br>*Release version 0.6, released October 2018*
<br>This release updates the Rocket IP to March 2018 and includes compressed instructions and JTAG debugging conforming to the RISCV Debug Specification with custom JTAG DTM (see [JTAG internals]({{< ref "docs/jtag.md" >}}) for details). The root filing system is updated to use the mostly upstreamed Debian repository and the peripheral data path widths are increased to 64-bits for better performance.

[All releases are available here] ({{< ref "docs/lowrisc-releases.md">}})

## What is included

Here you can find selected software and hardware IP which works together to produce an (almost) fully open-source computer system, consisting of:

* RISCV CPU written in the Chisel/Scala hardware description language
* A variety of useful peripherals, UART, MMC/SD-Card controller, Ethernet(100BaseT), VGA compatible screen, keyboard
* AXI compatible interface to proprietary DDR memory controller from Xilinx
* Boot loader for MMC/SD-Cards, based on u-boot
* Ethernet booter incorporating DHCP
* RISCV-Linux, adapted with drivers to attach to the above peripherals
* RISCV-Debian operating system

## Quick Start

As the source distribution is large, effort has been put into to making an easy-to-use quickstart procedure. This procedure does not require a huge amount of prior knowledge.

* [Getting started with binary releases] ({{< ref "docs/getting-started.md">}})

### Getting started breakdown

The latest release has the instructions broken down by topic, instead of the release specific documentation that was included previously.

* [Introduction to development] ({{< ref "docs/introduction-to-development.md">}})
* [Overview of the Refresh system]({{< ref "docs/overview.md" >}})
* [Download the source code] ({{< ref "docs/download-the-code.md">}})
* [Install FPGA synthesis and simulation tools]({{< ref "docs/xilinx.md" >}})
* [Preparing the development environment] ({{< ref "docs/prepare-the-environment.md">}})
* [Produce an FPGA Bitstream] ({{< ref "docs/generate-the-bitstream.md">}})
* [Configure DHCP] ({{< ref "docs/dhcp-configuration.md">}})
* [Building a bare-metal tool chain] ({{< ref "docs/build-bare-metal-toolchain.md">}})
* [Install support for RISCV emulation] ({{< ref "docs/riscv-qemu-emulation.md">}})
* [Downloading and Installing Debian] ({{< ref "docs/download-install-debian.md">}})
* [Build the Linux Kernel] ({{< ref "docs/linux-kernel-build.md">}})
* [Build the Berkeley boot loader (BBL)] ({{< ref "docs/build-berkeley-boot-loader.md">}})
* [Initiate Remote Booting] ({{< ref "docs/boot-remote.md">}})
* [Updating the kernel on a running system] ({{< ref "docs/update-running-kernel.md">}})
* [Booting a customised NFS system] ({{< ref "docs/boot-customised-nfs.md">}})
* [Frequently asked questions for this release]  ({{< ref "docs/current-release-faq.md">}})

### Other content

Our [first memo](
{{< ref "docs/memo-2014-001-tagged-memory-and-minion-cores.md" >}}) describes our
vision for tagged memory and minion cores in lowRISC.
