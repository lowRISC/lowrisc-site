+++
Description = ""
date = "2019-06-24T00:00:00+00:00"
title = "Release notes"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

### Release notes

 * Rocket-core (Chisel)
   * Core unchanged from previous release (JTAG chain modified to suit FPGA constraints)

 * Preliminary Ariane-core support (SystemVerilog)
   * Wrapped with replacement UNIX platform components to emulate Rocket Coreplex.
   * 10-15% larger and slower than Rocket. Boots X-Windows (with some screen size limitations on Nexys4-DDR).
   
 * Software environment
   * Ethernet boot loader supports TFTP (trivial file transfer protocol) and is standards compliant.
   * SD-Card boot loader only loads needed ELF segments.
   * QSPI boot loader supports mini-root filing system with verbose pre-boot file-system check of SD-Card.
   * Pseudo-unique OEM Ethernet MAC address supported on Genesys2, locally administered MAC on Nexys4-DDR.
   * JTAG debug Xilinx custom chain number support merged into upstream riscv-openocd.
   * riscv-gcc, riscv-gdb, Linux kernel 5.3.18. riscv-pk managed by buildroot.
   * LowRISC device driver patches updated locally.
   * RISCV-pk support for ns16750 compatible UART merged upstream. No local modifications needed.
   * Linux 8-bit pseudo-colour frame buffer driver integrated in kernel, no X-windows binary modifications required.
   * Userland built from recent sources, managed by buildroot-2019.11-1.

 * lowRISC system-on-chip
   * Integrated HCI Bluetooth interface with keyboard and mouse driver (requires non-standard UART buffer capacity).
   * VGA graphics colour screen 640x480x8 bit depth.
   * Genesys2 supports 1000BaseT Ethernet with compatible infrastructure / Nexys4-DDR supports 100BaseT.
   * SD-Card block driver layer managed in hardware (adapted from the OpenPiton project).
   * 16750 compatible UART from the Ariane project (VHDL, translated to Verilog)
   
 * Design environment
   * Updated Vivado synthesis and release to version 2018.2
   * NEXYS4-DDR FPGA and Genesys2 FPGA boards supported.
   * Rocket and Ariane supported in the same socket in the system-on-chip
   * Streamlined build more easily meets design constraints.
   * Most toolchain stages automated in a top-level Makefile.
   
### Previous releases

 * [**Version 0.6**: technical refresh lowRISC (06-2018)]({{< ref "/docs/ariane-v0.7/release.md" >}})
 * [**Version 0.5**: ethernet multiuser lowRISC (12-2017)]({{< ref "/docs/ethernet-v0.5/release.md" >}})
 * [**Version 0.4**: minion lowRISC (04-2017)]({{< ref "/docs/minion-v0.4/_index.md" >}})
 * [**Version 0.3**: core trace lowRISC (06-2016)]({{< ref "/docs/debug-v0.3/_index.md" >}})
 * [**Version 0.2**: untethered lowRISC (12-2015)]({{< ref "/docs/untether-v0.2/_index.md" >}})
 * [**Version 0.1**: tagged memory (04-2015)]({{< ref "/docs/tagged-memory-v0.1/_index.md" >}})
