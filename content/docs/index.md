+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Documentation"

+++

## Introduction

The lowRISC series of code and documentation releases has the dual aim for easing the path of new users and students of computer
architecure as well providing a robust tested platform for research into computer architecture whilst at the same time conforming to a license model which is compatible with commercial research and development as well as IC manufacture.

## What is included

Here you can find selected software and hardware IP which works together to produce an (almost) fully open-source computer system, consisting of:

* RISCV CPU written in the Chisel/Scala hardware description language
* A variety of useful peripherals, UART, MMC/SD-Card controller, Ethernet(100BaseT), VGA compatible screen, keyboard
* AXI compatible interface to proprietary DDR memory controller from Xilinx
* Boot loader for MMC/SD-Cards, based on u-boot
* Ethernet booter incorporating DHCP
* RISCV-Linux, adapted with drivers to attach to the above peripherals
* RISCV-Debian operating system

### Getting started breakdown

The latest release has the instructions broken down by topic, instead of the release specific documentation that was included previously.

* [Getting started with binary releases] ({{< ref "docs/GettingStarted.md">}})
* [Introduction to development] ({{< ref "docs/IntroDev.md">}})
* [Preparing the development environment] ({{< ref "docs/Prepare.md">}})
* [Download the source code] ({{< ref "docs/Download.md">}})
* [Configure the RISCV emulator] ({{< ref "docs/dev1.md">}})
## Releases
[Current and previous releases are here] ({{< ref "docs/Releases.md">}})
