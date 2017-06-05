+++
Description = ""
date = "2017-04-14T13:00:00+00:00"
title = "Prepare the environment"
parent = "/docs/minion-v0.4/"
prev = "/docs/minion-v0.4/softwaremethodology/"
next = "/docs/minion-v0.4/installtools/"
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
    swig git libtool libreadline-dev libelf-dev python-dev

### Download the code

The code is hosted in the
[lowRISC chip git repository](https://github.com/lowrisc/lowrisc-chip). All
external repositories are fetched as submodules. You need to clone the
proper branch (`minion-v0.4`):

    git clone -b minion-v0.4 --recursive https://github.com/lowrisc/lowrisc-chip.git
    cd lowrisc-chip

### Structure of the git repository

The structure is similar to the one described
[here](/docs/untether-v0.2/dev-env/#gitstruct). Essentially
one folder was added that contains the Minion repository:

 * `minion_subsystem`: Minion (Pulpino) subsystem and peripherals

### Next steps

To set the correct environment variables for running lowRISC, you need to
source the script `set_env.sh` (formerly `set_riscv_env.sh`) in the base directory:

    source set_env.sh

It is possible to override the default values by exporting variables before sourcing the script.
The following variables are overridable:

    $TOP                Path to the lowrisc-chip directory ($PWD).
    $RISCV              Path to the riscv toolchain ($TOP/riscv).
    $OSD_ROOT           Path to the Open SoC Debug tools ($TOP/tools).
    $FPGA_BOARD         The target FPGA board (nexys4_ddr).

Next steps:

 * [Install FPGA and simulation tools](/docs/minion-v0.4/installtools)

The built-in hardware [Open SystemOnChip Debug](http://opensocdebug.org) trace debugger is enabled by default.
It needs the following software installation instructions to be followed, in order to enable host communications. As well as trace debugging it
allows Linux kernels to be loaded from the PC for debugging purposes. However the lowRISC can also run standalone, if desired.

Follow these instructions _(caution: from a previous release)_ and then use the browser back button:

 * [Build the osd software](/docs/debug-v0.3/osdsoftware)

