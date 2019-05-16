+++
Description = ""
date = "2017-04-14T13:00:00+00:00"
title = "Release notes"
parent = "/docs/minion-v0.4/"
showdisqus = true

+++

### Release notes

 * Rocket-core (Chisel)
   * Add tag cache and improved security features.
 * Software environment
   * Most of the previous bare-metal program functionality integrated into one 64K executable
   * Implement 4-bit read/write SD-mode access to memory cards in Linux.
   * Console output appears on serial port and VGA screen in parallel.
   * Bare metal booting kernel in 4-bit SD-mode supported.
 * lowRISC-chip
   * Add Minion core (Pulpino based) to control SD-card, keyboard, and VGA display.
   * Standalone operation (without personal computer) possible.
   * VGA-compatible text display.
   * USB-keyboard (PS/2 compatible)
 * Design environment
   * Updated demo images for NEXYS4-DDR FPGA.
   * Add cfgmem and program-cfgmem targets to fpga Makefile.
 * Missing from this release vs the previous
   * Bitstream configuration from SD-card is no longer convenient.
   * Quad SPI memory execute-in-place is missing from initial demo images.

### Previous releases

 * [**Version 0.3**: core trace lowRISC (06-2016)]({{< ref "docs/debug-v0.3/_index.md" >}})
 * [**Version 0.2**: untethered lowRISC (12-2015)]({{< ref "docs/untether-v0.2/_index.md" >}})
 * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/_index.md" >}})
