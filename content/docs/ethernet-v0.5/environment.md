+++
Description = ""
date = "2017-10-14T13:00:00+00:00"
title = "Prepare the environment"
parent = "/docs/ethernet-v0.5/"
prev = "/docs/ethernet-v0.5/softwaremethodology/"
next = "/docs/ethernet-v0.5/installtools/"
showdisqus = true

+++

lowRISC tools and source code are robust between versions of Linux, but it has been
found that
Vivado (the Xilinx FPGA implementation suite) [is particular about the O/S](https://www.xilinx.com/support/answers/54242.html)

All builds were completed with Vivado 2015.4. If a newer version is attempted there could be script incompatibilities to fix and/or incompatible upgrades to internal Xilinx IP. We have no evidence that newer versions do not work, however IP changes to support newer chip families can cause obscure error messages which are offputting for the first-time user.

For this version the recommended O/S 64-bit Ubuntu (14.04 LTS). However, this is not stable on newer Intel chip sets, where 16.04 LTS should be used instead. If an unstable choice is made, the most likely result is LD\_LIBRARY\_PATH conflicts and/or synthesis crashes. It should be safe to unset LD\_LIBRARY\_PATH in your shell. This will prevent conflicts with the obsolete libstc++ build-in to Vivado.

Everything except using the FPGA boards should also work
out-of-box in a virtual machine.

The following instructions are identical to the previous release, apart from the release name.
For a more detailed explanation follow the
[instructions of a previous tutorial](/docs/untether-v0.2/dev-env).

Ensure you have all the necessary packages installed:

    sudo apt-get install autoconf automake autotools-dev curl \
    libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison \
    flex texinfo gperf libncurses5-dev libusb-1.0-0 libboost-dev \
    swig git libtool libreadline-dev libelf-dev python-dev \
    microcom chrpath gawk texinfo nfs-kernel-server xinetd pseudo 

Next steps:

 * [Install FPGA and simulation tools](/docs/ethernet-v0.5/installtools)

You might want to add the Vivado tools to your path first to keep the environment clean. This prevents system tools
from trying to use shared libraries from the (older) Vivado install. Proceed as follows if you chose the default install
location (or follow your system adminstrator instructions)

    source /opt/Xilinx/Vivado/2015.4/settings64.sh
    unset LD_LIBRARY_PATH

### Download the code

The code is hosted in the
[lowRISC chip git repository](https://github.com/lowrisc/lowrisc-chip). All
external repositories are fetched as submodules. In case you want to work on multiple branches
give each checkout a unique name (such as lowrisc-chip-ethernet-v0.5)
You need to clone the
proper branch (`ethernet-v0.5`):

    git clone -b ethernet-v0.5 --recursive https://github.com/lowrisc/lowrisc-chip.git lowrisc-chip-ethernet-v0.5
    cd lowrisc-chip-ethernet-v0.5

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

## Download and build Linux and busybox (early stage user commands)

This is not strictly needed unless we are building our own images, but it is easier to do it now.

    sh $TOP/riscv-tools/fetch_and_patch_linux.sh

## Building the RISCV toolchain (quick start: detailed instructions are below)

    cd $TOP/riscv-tools/
    ./build.sh
    cd riscv-gnu-toolchain/build
    ../configure --prefix=$RISCV
    make -j$(nproc) linux

Or for more detail, follow these instructions _(caution: from a previous release)_ and then use the browser back button:

 * [Compile and install RISC-V cross-compiler] ({{<ref "riscv_compile.md">}})

## Optional step

The built-in hardware [Open SystemOnChip Debug](http://opensocdebug.org) trace debugger is disabled by default.
booting and remote access is done via Ethernet by default. However it can easily be enabled for development.

It needs the following software installation instructions to be followed, in order to enable host communications.
As well as trace debugging it allows Linux kernels to be loaded from the PC for debugging purposes.

Follow these instructions _(caution: from a previous release)_ and then use the browser back button:

 * [Build the osd software](/docs/debug-v0.3/osdsoftware)

