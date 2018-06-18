+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Prepare the environment"
parent = "/docs/jtag-v0.6/"
prev = "/docs/jtag-v0.6/softwaremethodology/"
next = "/docs/jtag-v0.6/installtools/"
showdisqus = true

+++

lowRISC tools and source code are robust between versions of Linux, but it has been
found that
Vivado (the Xilinx FPGA implementation suite) [is particular about the O/S](https://www.xilinx.com/support/answers/54242.html)

All builds were completed with Vivado 2018.1. This was the newest version at the time of writing. We have not tried every version but 2015.4 used on the previoud releases does not work due to unidentified synthesis bugs in the virtual memory behaviour.

For this version of Vivado the Xilinx recommended O/S 64-bit Ubuntu 16.04.3 LTS.

It has been found that most of the problems with Vivado will go away if LD\_LIBRARY\_PATH is unset after sourcing the Vivado setup. 
This is caused by obsolete versions of system libraries such as  libstc++ being incorporated into Vivado to make it more "portable".
Do not succumb to the temptation to update the system libraries inside Vivado because some of the APIs have changed.

If your machine cannot meet these requirements then synthesis should be able to run, albeit rather slowly, inside a virtual machine.
The pre-build binaries were created with Ubuntu 16.04.3 LTS.

The following instructions are identical to the previous release, apart from the release name.
For a more detailed explanation follow the
[instructions of a previous tutorial](/docs/untether-v0.2/dev-env).

Ensure you have all the necessary packages installed:

    sudo apt-get install autoconf automake autotools-dev curl \
    libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison \
    flex texinfo gperf libncurses5-dev libusb-1.0-0 libboost-dev \
    swig git libtool libreadline-dev libelf-dev python-dev \
    microcom chrpath gawk texinfo nfs-kernel-server xinetd pseudo \
    libusb-1.0-0-dev hugo

Next steps:

 * [Install FPGA and simulation tools](/docs/jtag-v0.6/installtools)

You might want to add the Vivado tools to your path first to keep the environment clean. This prevents system tools
from trying to use shared libraries from the (older) Vivado install. Proceed as follows if you chose the default install
location (or follow your system adminstrator instructions)

    source /opt/Xilinx/Vivado/2018.1/settings64.sh
    unset LD_LIBRARY_PATH

### Download the code

The code is hosted in the
[lowRISC chip git repository](https://github.com/lowrisc/lowrisc-chip). All
external repositories are fetched as submodules. In case you want to work on multiple branches
give each checkout a unique name (such as lowrisc-chip-jtag-v0.6)
You need to clone the
proper branch (`jtag-v0.6`):

    git clone -b jtag-v0.6 --recursive https://github.com/lowrisc/lowrisc-chip.git lowrisc-chip-jtag-v0.6
    cd lowrisc-chip-jtag-v0.6

### Structure of the git repository

The structure is similar to the one described
[here](/docs/untether-v0.2/dev-env/#gitstruct). However
the peripherals that were previously in the Minion repository are connected directly to the rocket.

### Next steps
    
To set the correct environment variables for running lowRISC, you need to
source the script `set_env.sh` (formerly `set_riscv_env.sh`) in the base directory.
This must be done in a fresh shell window, not one used to work on any other branch of LowRISC:

    source set_env.sh

It is possible to override the default values by exporting variables before sourcing the script.
The following variables are overridable:

    $TOP                Path to the lowrisc-chip directory ($PWD).
    $RISCV              Path to the riscv toolchain ($TOP/riscv).
    $OSD_ROOT           Path to the Open SoC Debug tools ($TOP/tools).
    $FPGA_BOARD         The target FPGA board (nexys4_ddr).

The remainder of this page is optional if you choose to use our pre-compiled images.

## Download and build Linux and busybox (early stage user commands)

This step is optional if you choose to use our pre-compiled images.

    sh $TOP/riscv-tools/fetch_and_patch_linux.sh

## Building the RISCV toolchain (quick start: detailed instructions are below)

    cd $TOP/riscv-tools/
    ./build.sh
    cd riscv-gnu-toolchain/build
    ../configure --prefix=$RISCV
    make -j$(nproc) linux

Or for more detail, follow these instructions _(caution: from a previous release)_ and then use the browser back button:

 * [Compile and install RISC-V cross-compiler] ({{<ref "riscv_compile.md">}})

## System on chip debug

The built-in hardware [Open SystemOnChip Debug](http://opensocdebug.org) trace debugger from previous releases is not available.
Some of its functionality (for example loading programs) is available from the GDB/openocd combination.
