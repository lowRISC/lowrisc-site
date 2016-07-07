+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "Overview of the Rocket chip"
parent = "/docs/untether-v0.2/"
next = "/docs/untether-v0.2/dev-env/"
showdisqus = true

+++

An overview of Berkeley's RISC-V "Rocket Chip" SoC Generator can be found [here](https://1nv67s1krw3279i5yp7fko14-wpengine.netdna-ssl.com/wp-content/uploads/2015/01/riscv-rocket-chip-generator-workshop-jan2015.pdf).

A high-level view of the `untethered` Rocket chip is shown below. The design
contains multiple Rocket tiles each of which consists of a Rocket core and L1
instruction and data caches. All tiles share a unified and banked L2 cache and an I/O bus.
The Rocket (Chisel) side of the SoC is encapsulated in a Chisel island whose features are configurable using the top-level configuration file `$TOP/src/main/scala/Configs.scala` (see [Configuration parameters]({{< ref "docs/untether-v0.2/parameter.md" >}}) for more details).
Two NASTI/NASTI-Lite interfaces are exposed to the FPGA peripherals. They implement a limited subset of the AXI/AXI-Lite bus functions. The NASTI interface is used by the L2 cache for memory reads and writes, while the NASTI-Lite interface is used by the I/O bus for peripheral accesses.
The NASTI on-chip interconnects are implemented in parameterized SystemVerilog located in `$TOP/socip/nasti`. 

<a name="figure-overview"></a>
<img src="../figures/lowrisc_soc.png" alt="Drawing" style="width: 600px;"/>

 * **On-FPGA Boot RAM** <br/>
  (`0x00000000 - 0x0000FFFF`) <br/>
  On-FPGA Block RAM, 64 KB [[AXI Block RAM (BRAM) Controller v4.0]] (http://www.xilinx.com/support/documentation/ip_documentation/axi_bram_ctrl/v4_0/pg078-axi-bram-ctrl.pdf).
 * **DDR DRAM**  <br/>
  (`0x40000000 - 0x7FFFFFFF`) <br/>
  Off-FPGA DRAM, KC705 DDR3 1 GB, NEXYS4-DDR DDR2 128 MB [[Zynq-7000 AP SoC and 7 Series Devices Memory Interface Solutions v2.4]](http://www.xilinx.com/support/documentation/ip_documentation/mig_7series/v2_4/ug586_7Series_MIS.pdf).
 * **UART**  <br/>
  (`0x80000000 - 0x8000FFFF`) <br/>
  Xilinx AXI UART 16550 [[AXI UART 16550 v2.0]](http://www.xilinx.com/support/documentation/ip_documentation/axi_uart16550/v2_0/pg143-axi-uart16550.pdf).
 * **SD**  <br/>
  (`0x80010000 - 0x8001FFFF`) <br>
  Xilinx AXI Quad SPI [[AXI Quad SPI v3.2]](http://www.xilinx.com/support/documentation/ip_documentation/axi_quad_spi/v3_2/pg153-axi-quad-spi.pdf). <br/>
  Fat 32 support [[FatFs - Generic FAT File System Module]](http://elm-chan.org/fsw/ff/00index_e.html).

## Further reading

 * [Rocket core]({{< relref "docs/untether-v0.2/rocket-core.md" >}})
 * [Memory mapped I/O (MMIO)]({{< ref "docs/untether-v0.2/mmio.md" >}})
 * [Memory and I/O maps, soft reset, and interrupts]({{< ref "docs/untether-v0.2/pcr.md" >}})
 * [Bootload procedure]({{< ref "docs/untether-v0.2/bootload.md" >}})
 * [Configuration parameters]({{< ref "docs/untether-v0.2/parameter.md" >}})

