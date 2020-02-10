### Structure of the git repository

The structure of the repository is as follows:

 * `ariane`: The root of the ETHZ riscv system verilog processor
 * `ariane/bootrom`: The simulation boot rom
 * `ariane/ci`: The check-in checks
 * `ariane/docs`: The Ariane CPU documentation
 * `ariane/fpga`: The ETHZ version of the Ariane FPGA build environment
 * `ariane/include`: The main Ariane include directory
 * `ariane/openpiton`: The multi-CPU L1.5 infrastructure (not used in this project)
 * `ariane/scripts`: The build scripts
 * `ariane/src`: The majority of the system verilog source files
 * `ariane/tb`: The example files to use Ariane in a testbench
 * `buildroot-2019.11.1-lowrisc`: The modified buildroot installation
 * `buildroot-2019.11.1-lowrisc/arch`: The architecture specific files
 * `buildroot-2019.11.1-lowrisc/board`: The board specific files
 * `buildroot-2019.11.1-lowrisc/boot`: The boot-loader files
 * `buildroot-2019.11.1-lowrisc/configs`: The configuration files
 * `buildroot-2019.11.1-lowrisc/dl`: The staging area for downloads
 * `buildroot-2019.11.1-lowrisc/docs`: The buildroot documentation
 * `buildroot-2019.11.1-lowrisc/fs`: The staging area for the root file system
 * `buildroot-2019.11.1-lowrisc/linux`: The linux support
 * `buildroot-2019.11.1-lowrisc/mainfs`: The majority of packages are built here
 * `buildroot-2019.11.1-lowrisc/package`: The patches and package build instructions
 * `buildroot-2019.11.1-lowrisc/rescuefs`: The mini root rescue filing system
 * `buildroot-2019.11.1-lowrisc/support`: The support files
 * `buildroot-2019.11.1-lowrisc/system`: The system files
 * `buildroot-2019.11.1-lowrisc/toolchain`: The compiler files
 * `buildroot-2019.11.1-lowrisc/utils`: The utility files
 * `buildroot-fs-overlay`: The main overlay (replacement root file system files)
 * `buildroot-fs-overlay/etc`: The /etc overlay
 * `buildroot-fs-overlay/usr`: The /usr /overlay
 * `buildroot-fs-overlay/var`: The /var overlay
 * `buildroot-rescue-overlay`: The rescue mini root overlay
 * `buildroot-rescue-overlay/etc`: The rescue /etc overlay
 * `debian-riscv64`: The optional debian operating system installation scripts
 * `debian-riscv64/work`: The scripts and miscellaneous files for the Debian install.
 * `fpga`: The lowrisc primary FPGA specific source and scripts
 * `fpga/constraints`: The timing and pin constraints
 * `fpga/genesys2_ariane`: The auto-generated GenesysII Ariane variant
 * `fpga/genesys2_rocket`: The auto-generated GenesysII Rocket variant
 * `fpga/nexys4_ddr_ariane`: The auto-generated Nexys4-DDR Ariane variant
 * `fpga/nexys4_ddr_rocket`: The auto-generated Nexys4-DDR Rocket variant
 * `fpga/reports`: The FPGA timing and area reports
 * `fpga/scripts`: The build scripts
 * `fpga/src`: The main lowrisc verilog/system verilog source code
     * `apb_uart`: UART implementation intended to be software compatible with ns16750
     * `spi_mem_programmer`: Simple implementation of a QSPI memory interface
     * `ariane-ethernet`: Ethernet module adapted for 1000BaseT
 * `fpga/work-fpga`: The auto-generated results and bitstream area
 * `fpga/xilinx`: The Xilinx FPGA IP generation scripts and results
 * `jenkins`: The jenkins regression scripts directory (obsolete)
 * `lowrisc-quickstart`: The staging area for binary installs
 * `rocket-chip`: The root of the Berkeley Rocket CPU writen in Chisel
 * `rocket-chip/bootrom`: The first-stage boot and device tree source
 * `rocket-chip/chisel3`: The Chisel language files
 * `rocket-chip/csrc`: The C source files
 * `rocket-chip/emulator`: The simulation files
 * `rocket-chip/firrtl`: The FIR intermediate representation register transfer language
 * `rocket-chip/hardfloat`: The hardware floating point support files
 * `rocket-chip/lib`: The library directory
 * `rocket-chip/macros`: The macros directory
 * `rocket-chip/project`: The project directory
 * `rocket-chip/regression`: The regression tests
 * `rocket-chip/scripts`: The build scripts
 * `rocket-chip/src`: The toplevel source directory
 * `rocket-chip/target`: The toplevel target directory
 * `rocket-chip/torture`: The torture tests
 * `rocket-chip/vsim`: The Verilog simulation directory
 * `rocket-chip/vsrc`: The Verilog hand-written source files
 * `scripts`: The top-level scripts (obsolete)
 * `scripts/debug_rom`: The debug methodology (obsolete)
 * `src`: The toplevel source directory
 * `src/OpenIP`: The AXI infrastructure written by Gary Guo
 * `src/test`: The testbench source code in behavioural Verilog

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
