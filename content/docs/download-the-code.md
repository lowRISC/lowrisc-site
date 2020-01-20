### Structure of the git repository

The structure of the repository is as follows:

 * `ariane`: The System-Verilog RISCV core developed by ETHZ
   * `src`: Generic source code
   * `fpga/src`: FPGA-specific source code
 * `debian-riscv64`: Scripts to bootstrap a Debian Linux RISCV system
 * `fpga`: FPGA specific scripts and source
   * `src`: FPGA specific source
     * `apb_uart`: UART implementation intended to be software compatible with ns16750
     * `spi_mem_programmer`: Simple implementation of a QSPI memory interface
     * `ariane-ethernet`: Ethernet module adapted for 1000BaseT
 * `linux-5.x-lowrisc`: The Linux RISCV kernel with LowRISC device drivers
 * `lowrisc-quickstart`: a place to keep pre-built binaries and handy scripts
 * `qemu`: User mode emulation of RISCV instruction set
 * `rocket-chip`: The Rocket core and its sub-systems.
   * `firrtl`: Hardware description intermediate language
   * `hardfloat`: Hardware floating-point arithmetic unit
   * `torture`: Tricky tests that stress the CPU
 * `src`: The top level code of lowRISC chip.
   * `main`: The Verilog code for hardware implementation.
   * `test`: The Verilog/C++(DPI) test bench files
 * `riscv-gnu-toolchain`: The cross-compilation and simulation tool chain. [[Compile and install RISC-V cross-compiler]]({{<ref "docs/riscv_compile.md">}})
   * `riscv-fesvr`: The front-end server that serves system calls on the host machine.
   * `riscv-gnu-toolchain`: The GNU GCC cross-compiler for RISC-V ISA.
   * `riscv-isa-sim`: The RISC-V ISA simulator [Spike](https://github.com/riscv/riscv-isa-sim#risc-v-isa-simulator)
   * `riscv-opcodes`: The enumeration of all RISC-V opcodes executable by the Spike simulator.
   * `riscv-tests`: Tests for the Rocket core.
 * `riscv-openocd`: The JTAG to GDB protocol adapter
 * `riscv-pk`: The proxy kernel need for running legacy programs in the Spike simulator.
 * `src/openIP`: The AXI infrastructure modules provided by Gary Guo

### Ensure you have all the necessary packages installed:

    sudo apt-get install autoconf automake autotools-dev curl \
    libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison \
    flex texinfo gperf libncurses5-dev libusb-1.0-0-dev libboost-dev \
    swig git libtool libreadline-dev libelf-dev python-dev \
    microcom chrpath gawk texinfo nfs-kernel-server xinetd pseudo \
    libusb-1.0-0-dev hugo device-tree-compiler zlib1g-dev libssl-dev \
    debootstrap debian-ports-archive-keyring qemu-user-static iverilog \
    openjdk-8-jdk-headless iperf3 libglib2.0-dev libpixman-1-dev

### Download the code

The code is hosted in the
[lowRISC chip git repository](https://github.com/lowrisc/lowrisc-chip). All
external repositories are fetched as submodules, apart from the linux-kernel
which is created from upstream sources and a patch set. In case you want to work on multiple branches,
give each checkout a unique name (such as lowrisc-chip-ariane-v0.7)
You need to clone the proper branch (`ariane-v0.7`):

    git clone -b ariane-v0.7 --recursive https://github.com/lowrisc/lowrisc-chip.git lowrisc-chip-ariane-v0.7
    cd lowrisc-chip-ariane-v0.7
 
Submodules that did not need to be modified for this release are hosted in the original repository, but the version
will be frozen at the version that was tested by us, which probably will not be the latest.

Next steps:

* [Install Xilinx Vivado] ({{<ref "docs/xilinx.md">}})
