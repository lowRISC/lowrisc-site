+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "Install Verilator"
parent = "/docs/jtag-v0.6/dev-env/"
prev = "/docs/jtag-v0.6/xilinx/"
next = "/docs/jtag-v0.6/riscv_compile/"
showdisqus = true

+++

### Verilator

[Verilator](http://www.veripool.org/wiki/verilator) is written by Wilson Snyder (<wsnyder@wsnyder.org>), with Duane Galbi and Paul Wasson (<pmwasson@gmail.com>).

"Verilator is the fastest free Verilog HDL simulator, and beats most commercial simulators. It compiles synthesizable Verilog (not test-bench code!), plus some PSL, SystemVerilog and Synthesis assertions into C++ or SystemC code. It is designed for large projects where fast simulation performance is of primary concern, and is especially well suited to generate executable models of CPUs for embedded software design teams." [[1]](#Verilator)

### Installation

Installation of verilator is no longer necessary as the rocket-chip build scripts download and build a suitable version on demand.

### References
<!-- References -->

<a name="Verilator"></a>
[1]: Wilson Snyder, Duane Galbi, and Paul Wasson. "Introduction to Verilator". [[Web]](http://www.veripool.org/wiki/verilator)
