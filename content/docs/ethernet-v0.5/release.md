+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Release notes"
parent = "/docs/ethernet-v0.5/"
showdisqus = true

+++

### Release notes

 * Rocket-core (Chisel)
   * Corrections to tag cache security and Rocket behaviour corrected.
   
 * Software environment
   * Choice of boot options controlled by DIP-switches from one executable.
   * Accelerated, interrupt driven access to SD-cards in Linux.
   * Interrupt driven access to 100Base-T F/D Ethernet Linux device driver.
   * Remote Booting from Ethernet or 4-bit SD-mode supported.
   * Network Filing System root supported (with static IP addresses).
   * DHCP networking and Dropbear SSH server/client remote access with local SD-card root.
   * Linux userland based on adapted version of RISCV-poky Linux.

 * lowRISC-chip
   * Accelerated, reduced overhead interrupt-driven control of SD-card.
   * Faster integration of keyboard, and scrolling of VGA display, better integration with LowRISC console.
   * Choice of booting from remote ethernet protocol, SD-card, or remote trace debugger.
   * Unattended, networked operation (with remote multi-user access) possible, subject to performance constraints.
   
 * Design environment
   * Updated demo images for NEXYS4-DDR FPGA.
   * Add etherboot (SD-card root or NFS-root) targets to fpga Makefile.
   * Streamlined build more easily meets design constraints.
   
 * Missing from this release vs the previous
   * Minion was temporarily removed because it was a performance bottleneck in the Linux device driver architecture.
   * Quad SPI memory is dedicated to bitstream configuration.

### Previous releases

 * [**Version 0.4**: minion lowRISC (04-2017)]({{< ref "docs/minion-v0.4/_index.md" >}})
 * [**Version 0.3**: core trace lowRISC (06-2016)]({{< ref "docs/debug-v0.3/_index.md" >}})
 * [**Version 0.2**: untethered lowRISC (12-2015)]({{< ref "docs/untether-v0.2/_index.md" >}})
 * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/_index.md" >}})
