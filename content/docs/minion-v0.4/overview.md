+++
Description = ""
date = "2017-04-14T13:00:00+00:00"
title = "Overview of the minion infrastructure"
parent = "/docs/minion-v0.4/"
next = "/docs/minion-v0.4/environment/"
showdisqus = true

+++

For this release the goal was to provide small dedicated processors
(known as minions) to off-load peripheral activity from the main Rocket
processor, and to move away from fixed I/O functions towards a more
flexible approach.

In the picture below you can find an updated overview of the lowRISC
system architecture. If you compare it to the
[previous SoC overview]({{< ref "docs/debug-v0.3/overview.md" >}}) you
can see that the major change and main topic of this tutorial is the
new minion infrastructure.

<a name="figure-overview"></a>
<img src="../figures/lowRISC_soc.png" alt="Drawing" style="width: 600px; padding: 20px 0px;"/>

## Pre-defined Design constraints

Our goal of maintaining the hardware platform as per the previous release
may only be realised with a single Minion. nevertheless it is conceived that a fully-fledged
system would make use of several Minions. The Minion processor is based on a cut-down version
of Pulpino, a RISCV-compatible processor from ETH-Zurich. The SD-card interface is eventually
intended to be a software re-programmable input/output device incorporating programmable shift
registers as well as direct CPU control. For purposes of continuity, it was necessary for a
backward compatible interface to be used to allow Linux to boot from a small on-chip memory.

To take advantage of the 4-bit mode of operation available with modern SDHC-cards, a simplified
SD-subsystem from the opencores sd_card_controller project was adapted for use with the Minion.
The enhanced system including processor takes approximately 1/6 of the FPGA. Some aspects of the
operation of these cards are obscure. It is desirable to refer to older documents such as the MMC
card specification for clarification of missing information.

## Overview of the Boot process

To avoid using the SPI mode of the SD-card, a lengthy sequence of inquiry packets needs to be
send to establish the SD-card capabilities. Users should avoid using the onboard PIC processor to
configure the bitstream in SPI mode. This will result in difficulties returning to SD-mode later.
Alternatives available are USB memory stick (if the built-in keyboard is not needed), or on-board
quad-spi flash. The Rocket chip has only 64K ROM (implemented as block RAM) allocated to the boot
process. A full-blown SD-card protocol stack would be many times this size, so we make many simplifying
assumptions about the technology of the card which will be used. Essentially it needs to be Micro-SDHC,
with a fixed 5MHz initialisation and operating frequency.

The initialisation is:

* Cmd0   (reset)
* Cmd8   (send interface condition)
* ACmd41 (send operating condition)
* Cmd2   (send card ID)
* Cmd3   (send relative card address)
* Cmd9   (send card-specific data)
* Cmd13  (send status register)
* Cmd7   (select card)
* Acmd51 (send SD configuration register)
* Acmd6  (set bus width)
* Acmd13 (send SD status)

Assuming no errors occured, sector read can proceed with Cmd16(set block length) followed by Cmd17(read single).

All commands have a command phase, some also have a data phase,
for more details consult the SD Group physical layer specification.

Within each relevant command an elaborate data phase provides longitudinal CRC checking and error recovery.
A future enhancement could add the intelligence for multi-block random access during booting.

## Boot filing system

The boot filing system only supports a single DOS partition, which has to be partition 1. It does not support writing to the card. Most modern SD-cards out of the box will meet these requirements. Under Linux the available facilities are much more
sophisticated, and a second ext2 partition with extended userland commands can happily coexist with this boot partition.

FPGA cards, by their very nature, are noisy environments so it is desirable to be able to check the contents of the second stage boot loader after reading it from card. The builtin ROM can read an md5 text file and compare its contents with the calculated value on the second stage boot loader. The remaining task is to extract the ELF segments for the Berkley Boot Loader (BBL), and the kernel itself to their respective locations in memory, before the boot process proper can begin.

Please [get in touch with us]({{< ref "community.md" >}}) if you have ideas 
and opinions about future directions we should take. Now
it's time to learn more about the debug system or jump into using it:

 * [Prepare the environment and get started]({{< ref "docs/minion-v0.4/environment.md" >}})
