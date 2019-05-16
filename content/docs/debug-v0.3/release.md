+++
Description = ""
date = "2016-05-16T12:00:00+00:00"
title = "Release notes"
parent = "/docs/debug-v0.3/"
prev = "/docs/debug-v0.3/add_device/"
showdisqus = true

+++

### Release notes

 * Rocket-core (Chisel)
   * Add core trace and software trace modules in each Rocket core using Chisel black-boxes.
   * Add Chisel debug network to Rocket-chip to connect the debug modules in cores.
   * Add a trace CSR (swtrace) for software trace triggering.
   * Merge the latest (05-2016) updates from RISC-V.
   * Use the shared TileLink MEM network and reduce code discrepancy with the upstream Rocket to be minimal.
   * Updated `Configs.scala` and `LowRISCChip.scala` to utilize new features from the upstream RISC-V.
 * lowRISC-chip
   * Add trace debugger from Open SoC Debug.
   * Upgrade the IO side NASTI to a full NASTI interface.
   * Rewrite the NASTI to NASTI-Lite interface in socip.
   * Re-structure the SystemVerilog top level to use macros from Chisel compiler.
 * Design environment
   * A NEXYS4-DDR FPGA demo.
   * Better Makefile support.
 * Missing from this release vs the previous
   * No tagged memory support (will be added back soon).
   * No support for ZedBoard and KC705.

### Previous releases

 * [**Version 0.2**: untethered lowRISC (12-2015)]({{< ref "docs/untether-v0.2/_index.md" >}})
 * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/_index.md" >}})
