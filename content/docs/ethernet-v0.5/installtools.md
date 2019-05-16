+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Install FPGA and simulation tools"
parent = "/docs/ethernet-v0.5/environment/"
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
