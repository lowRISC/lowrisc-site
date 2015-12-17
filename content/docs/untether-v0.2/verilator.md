+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "Install Verilator"
parent = "/docs/untether-v0.2/dev-env/"
prev = "/docs/untether-v0.2/xilinx/"
next = "/docs/untether-v0.2/riscv_compile/"
showdisqus = true

+++

### Verilator

[Verilator](http://www.veripool.org/wiki/verilator) is written by Wilson Snyder (<wsnyder@wsnyder.org>), with Duane Galbi and Paul Wasson (<pmwasson@gmail.com>).

"Verilator is the fastest free Verilog HDL simulator, and beats most commercial simulators. It compiles synthesizable Verilog (not test-bench code!), plus some PSL, SystemVerilog and Synthesis assertions into C++ or SystemC code. It is designed for large projects where fast simulation performance is of primary concern, and is especially well suited to generate executable models of CPUs for embedded software design teams." [[1]](#Verilator)

### Installation

Verilator is already available through `apt-get` on Ubuntu but we recommend compiling and installing the latest release to have the best support for SystemVerilog and DPI.

For downloading and compiling Verilator, please following the instructions of [http://www.veripool.org/projects/verilator/wiki/Installing](http://www.veripool.org/projects/verilator/wiki/Installing). "Building from tarball" should fit the purpose.

Below is an example script for setting up the environment for Verilator:

    # assume Verilator is installed to /local/tool/verilator
    export VERILATOR_ROOT=/local/tool/verilator
    export PATH=$PATH:$VERILATOR_ROOT/bin

When Verilator is installed locally, some soft-links are missing which stops 
the compilation of simulation. If compiler errors similar to the following 
appear,

    make[1]: *** No rule to make target `<Verilator install path>/include/verilated.mk'. Stop.
    Can't open perl script "<Verilator install path>/bin/verilator_includer": No such file or directory

please set up the following soft links:

    ln -s $VERILATOR_ROOT/share/verilator/include $VERILATOR_ROOT/include
    ln -s $VERILATOR_ROOT/share/verilator/bin/verilator_includer \
      $VERILATOR_ROOT/bin/verilator_includer


### References
<!-- References -->

<a name="Verilator"></a>
[1]: Wilson Snyder, Duane Galbi, and Paul Wasson. "Introduction to Verilator". [[Web]](http://www.veripool.org/wiki/verilator)
