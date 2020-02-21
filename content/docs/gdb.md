+++
Description = ""
date = "2018-01-11T11:00:00+00:00"
title = "lowRISC GDB usage"
parent = "/docs/"
prev = "/docs/_index"
next = "/docs/_index"
showdisqus = true

+++

This lowRISC release supports Rocket and Ariane CPUs with both support RV64GC API, allowing upstream Debian Linux distribution to be used. If using buildroot, everything is built from source so it can be customised for any API, for example a no-FPU API.

## RTL changes

Consult the JTAG page for the latest information. Rocket operation on Nexys4-DDR requires modification to the scan chain to avoid external hardware being required. GenesysII operation is possible without CPU modification using the second channel of the USB to JTAG/UART converter. Regardless of the method the openocd configuration file will require modification depending on the solution chosen. This page refers to Rocket debugging on the NExys4-DDR.

## Linux driver

The JTAG does not impact on Linux operation. Extra facilities are available if KGDB is compiled in and at the moment openocd requires different settings in order to behave correctly if the MMU is on.

## Remote debugging

For bare-metal debugging most users will find it convenient to just load the software inside GDB. The latest release of openocd does not listen to remote machines by default, so the machine that gdb executes should be the same as the openocd machine.

## target gdb support

RISCV support for gdb is managed by buildroot. If you want to use the tui mode that splits the screen between source and register windows (for example), buildroot does not build in support for xterm-256color. Use the command:

    export TERM=vt100

(which is a subset of xterm 256 colour support) to enable the tui support.
