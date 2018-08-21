+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Prepare the environment"
parent = "/docs/refresh-v0.6/"
prev = "/docs/refresh-v0.6/softwaremethodology/"
next = "/docs/refresh-v0.6/installtools/"
showdisqus = true

+++

lowRISC tools and source code are robust between versions of Linux, but it has been
found that
Vivado (the Xilinx FPGA implementation suite) [is particular about the O/S](https://www.xilinx.com/support/answers/54242.html)

All builds were completed with Vivado 2018.1. This was the newest version at the time of writing.
We have not tried every version but 2015.4 used on the previous releases does not work due to unidentified synthesis bugs in the virtual memory behaviour.
It is not known whether our previous releases can work with the latest tool installation.

For this version of Vivado the Xilinx recommended O/S 64-bit Ubuntu 16.04.3 LTS.

It has been found that most of the problems with Vivado will go away if LD\_LIBRARY\_PATH is unset after sourcing the Vivado setup. 
This is caused by obsolete versions of system libraries such as  libstc++ being incorporated into Vivado to make it more "portable".
Do not succumb to the temptation to update the system libraries inside Vivado because some of the APIs have changed.

If your machine cannot meet these requirements then synthesis should be able to run, albeit rather slowly, inside a virtual machine.
The pre-build binary images were created with Ubuntu 16.04.3 LTS.

Ensure you have all the necessary packages installed:

    sudo apt-get install autoconf automake autotools-dev curl \
    libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison \
    flex texinfo gperf libncurses5-dev libusb-1.0-0-dev libboost-dev \
    swig git libtool libreadline-dev libelf-dev python-dev \
    microcom chrpath gawk texinfo nfs-kernel-server xinetd pseudo \
    libusb-1.0-0-dev hugo device-tree-compiler zlib1g-dev libssl-dev \
    multistrap debian-ports-archive-keyring qemu-user-static iverilog \
    openjdk-8-jdk-headless iperf3 libglib2.0-dev libpixman-1-dev

After installing microcom you will probably want to add your username to the dialout group:

    sudo usermod -a -G dialout $USER

This takes effect at next login. To use immediately you can use:

    sudo gpasswd dialout

followed by (your old shell settings will be forgotten):

    newgrp dialout

otherwise only the super user can make use of microcom

Next steps:

 * [Install FPGA and simulation tools]({{<ref "docs/refresh-v0.6/installtools.md">}})

You might want to add the Vivado tools to your path first to keep the environment clean. This prevents system tools
from trying to use shared libraries from the (older) Vivado install. Proceed as follows if you chose the default install
location (or follow your system adminstrator instructions)

    source /opt/Xilinx/Vivado/2018.1/settings64.sh
    unset LD_LIBRARY_PATH

### Next steps
    
To set the correct environment variables for running lowRISC, you need to
source the script `set_env.sh` in the base directory.
This must be done in a fresh shell window, not one used to work on any other branch of LowRISC:

    source set_env.sh

It is possible to override the default values by exporting variables before sourcing the script.
The following variables are overridable:

    $TOP                Path to the lowrisc-chip directory ($PWD).
    $RISCV              Path to the riscv toolchain ($TOP/riscv).
    $FPGA_BOARD         The target FPGA board (nexys4_ddr).

## The remainder of the preparation steps are optional and have been moved to the development page

## System on chip debug

The built-in hardware [Open SystemOnChip Debug](http://opensocdebug.org) trace debugger from previous releases is not available.
Some of its functionality (for example loading programs) is available from the GDB/openocd combination.
