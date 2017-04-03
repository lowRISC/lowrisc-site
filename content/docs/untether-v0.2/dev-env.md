+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "A guide to the development environment"
parent = "/docs/untether-v0.2/"
prev = ""
next = "/docs/untether-v0.2/simulation/"
showdisqus = true

+++


## System requirement

We recommend you work with a 64-bit Ubuntu (14.04 LTS) system with GNU GCC >= 4.8 installed. If necessary, create such a setup using [VMware Workstation Player](https://www.vmware.com/products/player/) or [VirtualBox](https://www.virtualbox.org/).

The default simulator for RTL/Behavioural SystemVerilog simulation is [Verilator](http://www.veripool.org/wiki/verilator).
Please download and install a latest version for the best SystemVerilog support.

An FPGA demonstration is provided using either a [Xilinx Kintex-7 FPGA KC705 evaluation kit](http://www.xilinx.com/products/boards-and-kits/ek-k7-kc705-g.html) or a low-end [Nexys™4 DDR Artix-7 FPGA Board](http://store.digilentinc.com/nexys-4-ddr-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/). The KC705 kit comes with a device and node locked license for [Xilinx Vivado Design Suite](http://www.xilinx.com/products/design-tools/vivado.html). The default version for FPGA demonstration project is Vivado 2015.4(64-bit). As for the users of the Nexys4-DDR boards, please acquire a free license and install the WebPACK edition of Vivado.

By default, all simulations produce waveforms in the VCD format.  
[GTKWave](http://gtkwave.sourceforge.net/) can be used to view VCD files.

Here shows software versions and environment variables on my machine:

     # it is better to use bash
     $ echo $0
     bash

     $ uname -s -v -r -i -o
     Linux 3.13.0-66-generic #108-Ubuntu SMP Wed Oct 7 15:20:27 UTC 2015 x86_64 GNU/Linux

     # make sure the RISCV variable is exposed
     $ echo $RISCV
     /home/USER_NAME/proj/lowrisc-chip/riscv

     $ gcc --version
     gcc (Ubuntu 4.8.4-2ubuntu1~14.04) 4.8.4
     Copyright (C) 2013 Free Software Foundation, Inc.
     This is free software; see the source for copying conditions.  There is NO
     warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

     $ which verilator
     /local/tool/verilator/bin/verilator

     $ gtkwave --version
     GTKWave Analyzer v3.3.58 (w)1999-2014 BSI

     This is free software; see the source for copying conditions.  There is NO
     warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

     $ which vivado
     /local/tool/Xilinx/Vivado/2015.4/bin/vivado

     # make sure the XILINX_VIVADO variable is exposed
     $ echo $XILINX_VIVADO
     /local/tool/Xilinx/Vivado/2015.4

Ensure you have all the necessary packages installed before attempting
to build the RISC-V tools:

    sudo apt-get install autoconf automake autotools-dev curl \
      libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison \
      flex texinfo gperf libncurses5-dev libusb-1.0-0 libboost-dev \
      git

## Download the code release

The [lowRISC chip git repository](https://github.com/lowrisc/lowrisc-chip) is 
hosted on GitHub . Instead of cloning individual sub-modules, we recommend
cloning the entire repository to ensure all the sub-modules you
acquire are compatible. Different versions of the sub-modules are not
guaranteed to work.

To clone the whole lowRISC chip git repository:

    # clone the repository to your home directory:
    cd ~/lowRISC/DIR
    # get the branch untether-v0.2
    git clone -b untether-v0.2 --recursive https://github.com/lowrisc/lowrisc-chip.git
    cd lowrisc-chip

There are 3 main branches:

 * *master* : The major release branch, default, most stable. After major releases, only bugfixes related to the latest release are merged.
 * *dev* : The minor release branch, less stable. After major releases, new features are added to this branch waiting for the next major release.
 * *update* : The active development branch, non-stable. The branch for 
 developing new features, testing bugfixes, and experimenting with new ideas.

To setup the necessary RISC-V variables use the setup script
found at `lowrisc-chip/set_riscv_env.sh`:

    # source this file
    echo "Setting up lowRISC/RISC-V environment..."
    echo "Make sure you source this script at the top of lowrisc-chip."
    # Variables for lowRISC/RISC-V
    if [ "$TOP" == "" ]; then
        echo "\$TOP is not available."
        echo "Set \$TOP to the top of lowrisc-chip which is the current directory."
        export TOP=$PWD
    fi
    export RISCV=$TOP/riscv
    export PATH=$PATH:$RISCV/bin
    # choose the FPGA board (KC705 in default)
    export FPGA_BOARD=kc705

<a name="gitstruct"></a>
## Structure of the git repository

 * `chisel`: The [Chisel](https://chisel.eecs.berkeley.edu/) compiler used for 
 compiling the rocket system.
 * `fpga`: FPGA demo implementations
   * `board`: Demo projects for individual development boards. [[FPGA 
     Demo]]({{<ref "docs/untether-v0.2/fpga-demo.md">}})
     * `kc705`: Files for the Xilinx KC705 development board.
     * `nexys4`: Files for the Nexys™4 DDR Artix-7 FPGA Board.
 * `hardfloat`: The IEEE 754-2008 compliant floating-point unit.
 * `junctions`: Peripheral components and I/O devices associated with the RocketChip.
 * `project`: Global configuration for Chisel compilation.
 * `riscv-tools`: The cross-compilation and simulation tool chain. [[Compile and install RISC-V cross-compiler]]({{<ref "docs/untether-v0.2/riscv_compile.md">}})
   * `riscv-fesvr`: The front-end server that serves system calls on the host machine.
   * `riscv-gnu-toolchain`: The GNU GCC cross-compiler for RISC-V ISA.
   * `riscv-isa-sim`: The RISC-V ISA simulator [Spike](https://github.com/riscv/riscv-isa-sim#risc-v-isa-simulator) [[Behavioural Simulation (Spike)]] ({{<relref "docs/untether-v0.2/spike.md">}})
   * `riscv-opcodes`: The enumeration of all RISC-V opcodes executable by the Spike simulator.
   * `riscv-pk`: The proxy kernel need for running legacy programs in the Spike simulator.
   * `riscv-tests`: Tests for the Rocket core.
 * `rocket`: The Chisel code for the Rocket core.
 * `socip`: The SystemVerilog/Verilog building blocks used in lowRISC chip.
   * `nasti`: A SystemVerilog implementaion of NASTI/NASTI-Lite on-chip interconnection.
 * `src`: The top level code of lowRISC chip.
   * `main`: The Chisel/Verilog code for hardware implementation.
   * `test`: The Verilog/C++(DPI) test bench files
 * `uncore`: The Chisel code of the memory subsystem.
 * `vsim`: RTL/Behavioural SystemVerilog simulation environment. [[RTL simulation]] ({{<ref "docs/untether-v0.2/vsim.md">}})

## Compiling and installation of individual tools/packages

 * [Install Xilinx Vivado] ({{<ref "docs/untether-v0.2/xilinx.md">}})
 * [Install Verilator] ({{<ref "docs/untether-v0.2/verilator.md">}})
 * [Compile and install RISC-V cross-compiler] ({{<ref "docs/untether-v0.2/riscv_compile.md">}})
 * [Compile the RISC-V Linux and the ramdisk `root.bin`] ({{<ref "docs/untether-v0.2/linux_compile.md">}})

