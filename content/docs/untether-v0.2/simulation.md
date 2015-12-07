+++
Description = ""
date = "2015-11-10T15:31:00+01:00"
title = "Simulations and FPGA Demo"
parent = "/docs/untether-v0.2/"
prev = "/docs/untether-v0.2/dev-env/"
next = "/docs/untether-v0.2/release/"
showdisqus = true

+++

This release works with three different simulators and provides an FPGA demo using the [Xilinx Kintex-7 KC705 evaluation kit] (http://www.xilinx.com/products/boards-and-kits/ek-k7-kc705-g.html).

 * [Behavioural Simulation (Spike)] ({{<relref "docs/untether-v0.2/spike.md">}})<br/>
   A fast instruction level simulator. The "golden" implementation of Rocket cores. <br/>
   Peripheral support from the front-end server (not compatible with the FPGA implemantion).

 * [RTL simulation] ({{<ref "vsim.md">}})<br/>
   RTL level simulation for the whole lowRISC SoC provided by [Verilator] ({{<ref "verilator.md">}}). <br/>
   Behaviour memory model and simple HTIF for ISA regression test.
   
 * [FPGA demo] ({{<ref "kc705.md">}})<br/>
   A RISC-V Linux demo on KC705. <br/>
   Peripherals: 1GB DDR3 DRAM, UART, SD+FAT32. <br/>

 * [FPGA simulation] ({{<ref "kc705-sim.md">}})<br/>
   Pre-synthesis FPGA simulation for the whole lowRISC SoC provided by Xilinx ISim (a part of Xilinx Vivado). <br/>
   Providing the full peripheral simulation with different configuration options.
 