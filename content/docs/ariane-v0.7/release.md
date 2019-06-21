+++
Description = ""
date = "2019-06-30T13:00:00+00:00"
title = "Release notes"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

### Release notes

 * Rocket-core (Chisel)
   * Core unchanged from refresh-v0.6 release, JTAG debug uses separate channel to avoid Vivado conflicts

 * Ariane-core (SystemVerilog)
   * Wrapped with replacement UNIX platform components to emulate Rocket Coreplex
   * 10-15% larger and slower than Rocket
   * Preliminary release
   
 * Software environment
   * Ethernet boot loader supports TFTP (trivial file transfer protocol) and is standards compliant
   * SD-Card boot loader skips over debug ELF segments
   * QSPI boot loader supports OEM Ethernet MAC address on Genesys2 allows for future diskless operation
   * Linux kernel updated to 5.1.3

 * lowRISC system-on-chip
   * Integrated PS/2 mouse driver (power supply voltage modification required)
   * VGA graphics colour screen
   * 16550 compatible UART
   
 * Design environment
   * Updated Vivado synthesis and release to version 2018.2
   * NEXYS4-DDR FPGA and Genesys2 FPGA boards supported.
   * Rocket and Ariane supported in the same system-on-chip
   * Streamlined build more easily meets design constraints.
   
 * Missing from this release vs the previous
   * Jtag debugging requires separate PMOD device on Nexys4DDR

### Previous releases

 * [**Version 0.6**: technical refresh lowRISC (06-2018)]({{< ref "docs/refresh-v0.6/release.md" >}})
 * [**Version 0.5**: ethernet multiuser lowRISC (12-2017)]({{< ref "docs/ethernet-v0.5/release.md" >}})
 * [**Version 0.4**: minion lowRISC (04-2017)]({{< ref "docs/minion-v0.4/index.md" >}})
 * [**Version 0.3**: core trace lowRISC (06-2016)]({{< ref "docs/debug-v0.3/index.md" >}})
 * [**Version 0.2**: untethered lowRISC (12-2015)]({{< ref "docs/untether-v0.2/index.md" >}})
 * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/index.md" >}})
