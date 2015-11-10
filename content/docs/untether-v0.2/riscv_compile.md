+++
Description = ""
date = "2015-11-10T14:10:00+01:00"
title = "Compile and install RISC-V cross-compiler"
parent = "/docs/untether-v0.2/dev-env/"
prev = "/docs/untether-v0.2/verilator/"
next = "/docs/untether-v0.2/linux_compile/"
showdisqus = true

+++

### Introduction of the RISC-V cross-compilation tools

A number of cross-compilation tools are provided in the $TOP/riscv-tools directory:

 * `riscv-fesvr`: The front-end server that serves system calls on the host machine.
 * `riscv-gnu-toolchain`: The GNU GCC cross-compiler for RISC-V ISA.
 * `riscv-isa-sim`: The RISC-V ISA simulator ([Spike](https://github.com/riscv/riscv-isa-sim#risc-v-isa-simulator))
 * `riscv-pk`: The proxy kernel that serves system calls on target machine.

Programs can be compiled and run in three different modes:

 * **Bare metal mode**: <br/>
   *Simulation only* <br/>
   Programs run in this mode have no peripheral support.<br/>
   This mode is used only for ISA regression test. The resturn value of a program indicates the result of an ISA test case. 0 is success while none-zero indentify the No. of the failing case.
 * **Newlib (supervisor) mode**: <br/>
   *Simulation and FPGA* <br/>
   Programs run in this mode have the full control (supervisor priority) of peripherals (limited in simulation) but are single-threaded.<br/>
   Bootloaders are run in this mode.
 * **Linux (user) mode**: <br/>
   *FPGA only* <br/>
   Programs runs in a RISC-V Linux. They get multi-thread and peripheral support from the Linux kernel.

Compiling and simulating programs in different modes depends on different tool sets.

 * **Bare metal mode**
  * Behaviour simulation: <br/>
    `riscv-gnu-toolchain`(newlib); `riscv-isa-sim`; `riscv-fesvr`.
  * RTL simulation: <br/>
    `riscv-gnu-toolchain`(newlib); [verilator]({{<relref "verilator">}}).
  * FPGA simulation: <br/>
    `riscv-gnu-toolchain`(newlib); [vivado]({{<relref "xilinx.md">}}).
  * FPGA test: <br/>
    N/A
 * **Newlib (supervisor) mode**:
  * Behaviour simulation: <br/>
    `riscv-gnu-toolchain`(newlib); `riscv-isa-sim`; `riscv-fesvr`; `riscv-pk`.
  * RTL simulation: <br/>
    `riscv-gnu-toolchain`(newlib); [verilator]({{<relref "verilator.md">}}).
  * FPGA simulation: <br/>
    `riscv-gnu-toolchain`(newlib); [vivado]({{<relref "xilinx.md">}}).
  * FPGA test: <br/>
    `riscv-gnu-toolchain`(newlib); [vivado]({{<relref "xilinx.md">}}).
 * **Linux (user) mode**
  * Behaviour simulation: <br/>
    `riscv-gnu-toolchain`(newlib+linux); `riscv-isa-sim`; `riscv-fesvr`; `riscv-pk`; [vmlinux](../linux_compile#linux); [root.bin](../linux_compile#busybox).
  * RTL simulation: <br/>
    N/A
  * FPGA simulation: <br/>
    N/A
  * FPGA test: <br/>
    `riscv-gnu-toolchain`(newlib+linux); [vivado]({{<relref "xilinx.md">}}); [vmlinux](../linux_compile#linux); [root.bin](../linux_compile#busybox).

### Building the RISC-V cross-compilation tools

A build script is provided to build most of the cross-compilation tools and Spike:

    # set up the RISCV environment variables
    cd $TOP/riscv-tools
    ./build.sh

After the compilation, the Spike and the newlib GCC binaries should be available:

    which spike
    # the newlib gcc
    which riscv64-unknown-elf-gcc

The RISC-V GCC/Newlib Toolchain Installation Manual can be found
[here](https://github.com/riscv/riscv-tools#the-risc-v-gccnewlib-toolchain-installation-manual).

### Building the Linux GCC

The build script above provide the newlib GCC but not the Linux GCC, which needed for compiling programs in Linux (user) mode. To build a Linux GCC compiler:

    # set up the RISCV environment variables
    cd $TOP/riscv-tools/riscv-gnu-toolchain
    # ignore if build already exist
    mkdir build
    cd build
    ../configure --prefix=$RISCV
    make -j linux

After the compilation, the Linux GCC binaries should be available:

    which riscv64-unknown-linux-gnu-gcc
