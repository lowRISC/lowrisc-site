+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "Simulations and FPGA Demo"
parent = "/docs/untether-v0.2/"
prev = "/docs/untether-v0.2/dev-env/"
next = "/docs/untether-v0.2/release/"
showdisqus = true

+++

This release works with three different simulators and provides an FPGA demo using either a [Xilinx Kintex-7 KC705 evaluation kit] (http://www.xilinx.com/products/boards-and-kits/ek-k7-kc705-g.html) or a low-end [Nexys™4 DDR Artix-7 FPGA Board](http://store.digilentinc.com/nexys-4-ddr-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/).

 * [Behavioural Simulation (Spike)] ({{<relref "docs/untether-v0.2/spike.md">}})<br/>
   A fast instruction level simulator. The "golden" implementation of Rocket cores. <br/>
   Peripheral support from the front-end server (not compatible with the FPGA implemantion).

 * [RTL simulation] ({{<ref "docs/untether-v0.2/vsim.md">}})<br/>
   RTL-level simulation for the whole lowRISC SoC provided by [Verilator] ({{<ref "docs/untether-v0.2/verilator.md">}}). <br/>
   Behavioural memory model and simple HTIF for ISA regression test.
   
 * [FPGA demo] ({{<ref "docs/untether-v0.2/fpga-demo.md">}})<br/>
   A RISC-V Linux demo on KC705/NEXYS4-DDR. <br/>
   Peripherals (KC705): 1GB DDR3 DRAM, UART, SD+FAT32. <br/>
   Peripherals (NEXYS4-DDR): 128MB DDR2 DRAM, UART, MicroSD+FAT32. <br/>

 * [FPGA simulation] ({{<ref "docs/untether-v0.2/fpga-sim.md">}})<br/>
   Pre-synthesis FPGA simulation for the whole lowRISC SoC provided by Xilinx ISim (a part of Xilinx Vivado). <br/>
   Providing the full peripheral simulation with different configuration options.
 
