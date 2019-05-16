+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Release notes"
parent = "/docs/refresh-v0.6/"
showdisqus = true

+++

### Release notes

 * Rocket-core (Chisel)
   * Updated to March-2018 vintage together with riscv-tools
   * Rocket repository hierarchy left unmodified for easier updates
   * Compressed instructions and JTAG debugging functional in GDB
   * Clock speed doubled from 25MHz to 50MHz to take advantage of improvements
   
 * Software environment
   * SD-Card bootloader now uses proper card recognition algorithm
   * SD-cards now run at 10MHz corresponding to Rocket speed boost
   * Ethernet boot loader supports DHCP and is about ten times faster
   * Debian preview release supported with advanced package tool support
   * Linux kernel updated to latest RISCV release

 * lowRISC system-on-chip
   * Accelerated access to all peripherals using 64-bit busses
   * Proper integration of PC-keyboard codes into Linux driver
   * Debian dialog friendly VGA text compatible colour console screen
   * Eight-packet Ethernet receive buffer and Linux driver NAPI-compliant
   * 2K-byte buffer on all UART transmit and receive paths
   
 * Design environment
   * Updated Vivado synthesis and release to version 2018.1
   * Updated demo images for NEXYS4-DDR FPGA.
   * Minimal Rocket source code changes
   * JTAG debug transport adapted to meet Xilinx hardware constraints
   * Streamlined build more easily meets design constraints.
   
 * Missing from this release vs the previous
   * Tag memory system not ported to latest Rocket
   * No procedure to build your own userland (Debian download required)
   * Trace debugger not ported to latest Rocket

### Previous releases

 * [**Version 0.5**: ethernet multiuser lowRISC (12-2017)]({{< ref "docs/ethernet-v0.5/release.md" >}})
 * [**Version 0.4**: minion lowRISC (04-2017)]({{< ref "docs/minion-v0.4/_index.md" >}})
 * [**Version 0.3**: core trace lowRISC (06-2016)]({{< ref "docs/debug-v0.3/_index.md" >}})
 * [**Version 0.2**: untethered lowRISC (12-2015)]({{< ref "docs/untether-v0.2/_index.md" >}})
 * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/_index.md" >}})
