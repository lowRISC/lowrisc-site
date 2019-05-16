+++
Description = ""
date = "2017-04-14T13:00:00+00:00"
title = "Install FPGA and simulation tools"
parent = "/docs/minion-v0.4/environment/"
prev = "/docs/minion-v0.4/environment/"
next = "/docs/minion-v0.4/osdsoftware/"
showdisqus = true

+++

This part is identical to the previous tutorial, simply perform those
steps:

 * [Install Xilinx Vivado] ({{<ref "/docs/xilinx.md">}})
 * [Install Verilator] ({{<ref "verilator.md">}})

The above procedure may change your LD_LIBRARY_PATH to an older version of libraries than some systems expect. If this
happens, you may get a message such as:

* awk: symbol lookup error: awk: undefined symbol: mpfr_z_sub

A work-around is to manually execute `unset LD_LIBRARY_PATH` afterwards before installing the cross-compiler.

Follow these instructions _(caution: from a previous release)_ and then use the browser back button:

 * [Compile and install RISC-V cross-compiler] ({{<ref "/docs/riscv_compile.md">}})
