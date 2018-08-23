+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "Compile and install RISC-V cross-compiler"
showdisqus = true

+++

### Introduction of the RISC-V cross-compilation tools

A number of cross-compilation tools are provided in the $TOP/riscv-tools directory:

 * `riscv-fesvr`: The front-end server that serves system calls on the host machine.
 * `riscv-gnu-toolchain`: The GNU GCC cross-compiler for RISC-V ISA.
 * `riscv-isa-sim`: The RISC-V ISA simulator ([Spike](https://github.com/riscv/riscv-isa-sim#risc-v-isa-simulator))
 * `riscv-pk`: The proxy kernel that serves system calls on target machine.

There are four ways to test a program:

 * Behavioural simulation: run the program in the RISC-V ISA simulator (Spike). <br/>
   The `syscall()` interface provided in the original RISC-V proxy kernel is not compatible with the I/O interfaces provided in this release.
   Spike can be used to run programs that do not access I/O devices or user mode programs that run inside the RISC-V Linux.
 * RTL simulation: simulate the program in Verilator (`$Top/vsim/`). <br/>
   No I/O devices is available in RTL simulation.
 * FPGA simulation: simulate the program using Xilinx ISim (`$Top/fpga/board/$FPGA_BOARD/`). <br/>
   Behavioural modules for I/O devices are provided by Xilinx IPs; however, host end modules (UART terminal and SD card) are not available.
 * FPGA run: actually run the program on an FPGA board (`$Top/fpga/board/$FPGA_BOARD/`). <br/>
   Full I/O support (UART and SD).

Programs can be compiled and run in three different modes:

 * **Bare metal mode**: supervisor programs with no I/O accesses. <br/>
   *Behavioural simulation and RTL Simulation* <br/>
   Programs run in this mode have no peripheral support. This mode is used only for ISA and cache regression tests. The return value of a program indicates the result of an ISA test case. 0 is success while none-zero indentifies the No. of the failing case. Programs compiled in this mode would run silently on FPGAs or in FPGA simulations.
 * **Newlib mode**: supervisor programs with access to I/O devices. <br/>
   *FPGA simulation and FPGA run* <br/>
   Programs run in this mode have the full control (supervisor priority) of peripherals (limited in simulation) but are single-threaded. Bootloaders are run in this mode.
 * **Linux mode**: user programs with Linux support. <br/>
   *Behavioural simulation and FPGA run* <br/>
   Programs runs in the RISC-V Linux. They get multi-thread and peripheral support from the Linux kernel.

Compiling and simulating programs in different modes depends on different tool sets.

 * **Bare metal mode**
  * Behavioural simulation: <br/>
    `riscv-gnu-toolchain`(newlib); `riscv-isa-sim`; `riscv-fesvr`.
  * RTL simulation: <br/>
    `riscv-gnu-toolchain`(newlib); `verilator` (built-in)
 * **Newlib (supervisor) mode**:
  * FPGA simulation: <br/>
    `riscv-gnu-toolchain`(newlib); [vivado]({{<ref "docs/xilinx.md">}}).
  * FPGA run: <br/>
    `riscv-gnu-toolchain`(newlib); [vivado]({{<ref "docs/xilinx.md">}}).
 * **Linux (user) mode**
  * Behavioural simulation: <br/>
    `riscv-gnu-toolchain`(newlib+linux); `riscv-isa-sim`; `riscv-fesvr`; `riscv-pk`; [vmlinux](../linux_compile#linux); [root.bin](../linux_compile#busybox).
  * FPGA run: <br/>
    `riscv-gnu-toolchain`(newlib+linux); [vivado]({{<ref "docs/xilinx.md">}}); [vmlinux](../linux_compile#linux); [root.bin](../linux_compile#busybox).

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

The build script above provides a GCC build using the Newlib libc but not the 
GNU libc, which is needed for compiling programs to run in user mode on Linux.
To build a Linux GCC compiler:

    # set up the RISCV environment variables
    cd $TOP/riscv-tools/riscv-gnu-toolchain
    # ignore if build already exist
    mkdir build
    cd build
    ../configure --prefix=$RISCV
    make -j$(nproc) linux

After the compilation, the Linux GCC binaries should be available:

    which riscv64-unknown-linux-gnu-gcc
