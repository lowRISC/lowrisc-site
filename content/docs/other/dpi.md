+++
Description = ""
date = "2016-01-15T12:00:00+00:00"
title = "Suggestions for using DPI with Verilator"
showdisqus = true

+++

_By Wei Song_  (15-Jan-2016)


The SystemVerilog Dirtect Programming Interface (DPI) is an interface between SystemVerilog and a foreign programming language, especially C/C++. It allows a SystemVerilog process to call a function/task implmented in C through DPI and also allows SystemVerilog to expose its function/task for C programs to use.

Compared with all other methods such as PLI/VPI and SystemC, DPI is the most light-weighted and supported by almost all major simulators (VCS, NCSim, ModelSim, Xilinx ISim and Verilator) but not sure about Icarus Verilog. It is basically a calling interface that allow Verilog to call C functions and C functions can read arguments from Verilog in a natural way.

The DPI standard is defined in Chapter 35 of the IEEE Standard 1800™-2012 SystemVerilog LRM which can be downloaded free of charge at [http://standards.ieee.org/getieee/1800/download/1800-2012.pdf](http://standards.ieee.org/getieee/1800/download/1800-2012.pdf).

There is also a useful [tutorial](https://www.doulos.com/knowhow/sysverilog/tutorial/dpi/) from Doulos with actual examples.

Verilator implements only a part of the DPI standard but should be enough for most use cases.
A compact description of DPI in Verilator can be found [here](http://www.veripool.org/wiki/verilator/Manual-verilator/#direct_programming_interface__dpi_).

The following is a list of suggestons for using DPI in Verilator:

#### Avoid using DPI tasks

Verilator simulates synthesizable Verilog designs so the support of tasks is nearly non-existed. If a task does not incur delay, it is equivalent to a function and then it should be declared as a function. Furthermore, using a DPI task to access Verilog simulation events needs to access the Verilog scope, which is still problematic. So using DPI tasks should be totally avoided. Even using Verilog tasks in Verilator is not recommended.

#### Avoid accessing Verilog variables in the function body

Value transferring between Verilog and C/C++ should use the function argument list and the return value only. Also all arguments should be input rather than output or reference.
Any extra accesses to Verilog variables inside the function body need to access the Verilog scope, which is still problematic and, therefore, should be avoided.

_Currently we have not found a stable method to initiate this Verilog scope in Verilator. If anyone knows how, please send an example to us, many thanks._

#### Do not use logic/reg/wire but bit

Verilator currently does not support 4-state values for DPI, so use 2-state values instead.

#### Be careful with impure functions

By default Verilator considers DPI functions as pure (no internal state and no side-effect) which allows Verilator to schedule functions freely.
This may generated extra calls to DPI functions which are non-existed in other simulators.
Although the latest Verilator has changed this default behaviour but be prepared for remaining inconsistent issues.
A walk-around is to add a flag argument to indicated whether a DPI call is actually needed.
If the flag is unset, do not cause any side-effect on the C/C++ side (simply return).

#### DPI function working as tasks

The lack of support of tasks is not a huge issue. A DPI function can have its own internal static (or global) variables to record cycles (causing side-effect and this function is no longer pure). Then the Verilog process that calling this DPI function just needs to call the function in every cycle; therefore, the DPI function can track cycles and decide if there is any delay related operations.

For the case of using global variables (or objects), which is needed when the same DPI function can be called by multiple Verilog processes, these variables can be initialized in an initial DPI function called in the initial process.
