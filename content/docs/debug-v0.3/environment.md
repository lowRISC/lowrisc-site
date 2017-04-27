+++
Description = ""
date = "2016-05-16T12:00:00+00:00"
title = "Prepare the environment"
parent = "/docs/debug-v0.3/"
prev = "/docs/debug-v0.3/softwaremethodology/"
next = "/docs/debug-v0.3/lowriscsetup/"
showdisqus = true

+++

We still recommend you work with a 64-bit Ubuntu (14.04 LTS).
Everything except using the FPGA boards should also work
out-of-box in a virtual machine.

For more details follow the
[instructions of the previous tutorial](/docs/untether-v0.2/dev-env).

Ensure you have all the necessary packages installed:

    sudo apt-get install autoconf automake autotools-dev curl \
    libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison \
    flex texinfo gperf libncurses5-dev libusb-1.0-0 libboost-dev \
    swig git libtool libreadline-dev libelf-dev python-dev

### Download the code

The code is hosted in the
[lowRISC chip git repository](https://github.com/lowrisc/lowrisc-chip). All
external repositories are fetched as submodules. You need to clone the
proper branch (`debug-v0.3`):

    git clone -b debug-v0.3 --recursive https://github.com/lowrisc/lowrisc-chip.git
    cd lowrisc-chip

### Structure of the git repository

The structure is similar to the one described
[here](/docs/untether-v0.2/dev-env/#gitstruct). Essentially
one folder was added that contains the Open SoC Debug repositories:

 * `opensocdebug`: Open SoC Debug and dependencies
  * `glip`: The [generic logic interface project](http://glip.io)
  * `hardware`: Hardware modules of Open SoC Debug
  * `software`: The Open SoC Debug software

### Next steps

To set the correct environment variables for running lowRISC, you need to
source the script `set_env.sh` (formerly `set_riscv_env.sh`) in the base directory:

    source set_env.sh

It is possible to override the default values by exporting variables before sourcing the script.
The following variables are overridable:

    $TOP                Path to the lowrisc-chip directory ($PWD).
    $RISCV              Path to the riscv toolchain ($TOP/riscv).
    $OSD_ROOT           Path to the Open SoC Debug tools ($TOP/tools).
    $FPGA_BOARD         The tager FPGA board (nexys4_ddr).

Next, you should follow the following steps:

 * [Build the generic lowRISC setup](/docs/debug-v0.3/lowriscsetup)
 * [Build the osd software](/docs/debug-v0.3/osdsoftware)

