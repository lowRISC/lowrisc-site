+++
Description = ""
date = "2018-01-11T11:00:00+00:00"
title = "lowRISC Ethernet internals"
parent = "/docs/ethernet-v0.5/"
prev = "/docs/ethernet-v0.5/index/"
next = "/docs/ethernet-v0.5/index/"
showdisqus = true

+++

This lowRISC release introduces 100Mbps Ethernet, allowing remote ssh and 
network filing system functionality.

## RTL changes

The PHY of the Ethernet uses reduced media independent interface (RMII). The transmission rate is fixed at 100MHz
and is found to be compatible with most hubs and switches. The possibility to communicate with the PHY is programmed
but not used.

The core of the Ethernet block is adapted from a suite of IP provided by Alex Forencich.

https://github.com/alexforencich/verilog-ethernet.git

It requires a wrapper and some buffer RAMs to enable it to be controlled by the Rocket, plus an interrupt interface.
This interface always operates in promiscuous mode, meaning all valid packets received by the media access controller (MAC)
are passed to the kernel to decide what shall be done with them.

The regular routines are setting and retrieving the MAC address of the device are present, but they make no difference to
operation in this version/

## Linux driver

A conventional model is followed with no DMA. It is assumed that the transmit will be so fast that the transmit buffer will
never be full. Conversely multiple packets could be received before being noticed by the processor and for this purpose the
received is adapted to receive up to 8 full-sized packets in quick succession. THis driver is interrupt driven in the usual way.

## User land operation

A complete suite of Linux user commands is available via the Poky Linux districution for RISCV. Only a few small changes are needed
to adapt the distribution to the changed device names.

## DHCP

Dynamic host configuration protocol is supported for standalone computer use. It cannot be used if remote booting or NFS is required.
A time protocol server is also preferable but not a showstopper.

## Remote booting

This release adds a protocol for booting Linux or bare metal programs over Ethernet. Hence it is possible to operate without SD-cards
or serial access to the device. In the latter case it highly desirable to have a VGA monitor and USB keyboard, and separate power provision
needs to be provided.
