+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "Release Notes"
parent = "/docs/untether-v0.2/"
prev = "/docs/untether-v0.2/simulation/"
showdisqus = true

+++

### Release notes

 * Rocket-core (Chisel)
   * Merge the latest (10-2015) updates from RISC-V.
   * Add uncached read/write in L1 D$ (support memory mapped I/O).
   * Remove the HTIF CSR read/write port.
   * Redefine CSRs `mtime`, `mtohost`, `mfromhost`, `mreset` to PCRs.
   * Add memory map, I/O map, and IRQ PCRs.
   * Add a global PCR controller shared by all Rocket cores.
   * Nearly remove all functions of the HTIF (only needed for bare-metal mode)
   * Add soft reset to Rocket cores, L2$.
   * Rewrite TileLink/NASTI and TileLink/NASTI-Lite interfaces.
   * Add 64-bit IRQ inputs.
   * Rewrite and simplify top level connections and parameter definitions.
 * lowRISC-chip
   * All chisel components (Rocket cores, L2 caches) are encapsulated in a Chisel island with only two NASTI interface exposed.
   * A NASTI on-chip interconnect (crossbar, buffer, Lite/NASTI bridge) is provided using SystemVerilog.
   * UART (Xilinx IP) connected and tested.
   * SD (Xilinx SPI IP) connected and tested. Software support for FatFS is provided.
   * DDR RAM and Memory controller (Xilinx IP) is connected and tested.
   * Boot from on-chip BRAM.
 * Design environment
   * A KC705/NEXYS4-DDR FPGA demo with RISC-V Linux boot. [[FPGA demo]] ({{<ref "docs/untether-v0.2/fpga-demo.md">}})
   * Merge the latest (10-2015) cross-compiler updates from RISC-V.
   * Replace VCS with opensourced Verilator. [[RTL simulation]] ({{<ref "docs/untether-v0.2/vsim.md">}})
   * Rewrite all Makefile support.
 * Missing from this release vs the previous [**Version 0.1**: tagged memory (04/2015)]({{< ref "docs/tagged-memory-v0.1/_index.md" >}})
   * No tagged memory support (will be added back soon).
   * No support for ZedBoard.

### Previous releases

 * [**Version 0.1**: tagged memory (04-2015)]({{< ref "docs/tagged-memory-v0.1/_index.md" >}})
