+++
Description = ""
date = "2018-01-11T11:00:00+00:00"
title = "lowRISC Jtag internals"
parent = "/docs/jtag-v0.6/"
prev = "/docs/jtag-v0.6/index/"
next = "/docs/jtag-v0.6/index/"
showdisqus = true

+++

This lowRISC release introduces jtag debugging and compressed instructions, allowing upstream debian Linux distribution to be used.

## RTL changes

The Jtag uses Xilinx built-in instruction register of 6 bits and available user data registers. These data register numbers deviate from the RISC-V specification but otherwise conforms to the Berkeley Rocket standard. This deviation eliminates the requirement for separate hardware to implement the debug interface and keeps costs low, allowing the same board as previously to be used.

## Linux driver

The JTAG does not impact on Linux operation. Extra facilities are available if KGDB is compiled in and it is not clear what the virtual memory approach will be in GDB at the moment.

## User land operation

A complete suite of Linux user commands is available via the Debian Linux distribution for RISCV. There is not necessity for the distribution to be built from scratch.

## Remote booting

All the booting methods of the previous release are possible but for debugging most users will find it convenient to just load BBL with Linux appended inside GDB.
