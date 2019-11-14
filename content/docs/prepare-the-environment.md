+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Prepare the environment"
parent = "/docs/refresh-v0.6/"
showdisqus = true

+++

lowRISC tools and source code are robust between versions of Linux, but it has been
found that
Vivado (the Xilinx FPGA implementation suite) [is particular about the O/S](https://www.xilinx.com/support/answers/54242.html)

All builds were completed with Vivado 2018.2. This was the newest version when this release was begun. Newer versions may well work but are untested. We have not tried every version but 2015.4 used on the previous releases does not work due to unidentified synthesis bugs in the virtual memory behaviour.
It is not known whether our previous releases can work with the latest tool installation.

For this version of Vivado the Xilinx recommended O/S 64-bit Ubuntu 16.04.3 LTS / 18.04 LTS.

It has been found that most of the problems with Vivado will go away if LD\_LIBRARY\_PATH is unset after sourcing the Vivado setup. 
This is caused by obsolete versions of system libraries such as  libstc++ being incorporated into Vivado to make it more "portable".
Do not succumb to the temptation to update the system libraries inside Vivado because some of the APIs have changed.

If your machine cannot meet these requirements then synthesis should be able to run, albeit rather slowly, inside a virtual machine.
The pre-build binary images were created with Ubuntu 18.04 LTS.

You should have installed the prerequisites on the download page. If not do so now:
[Download the source code] ({{< ref "docs/download-the-code.md">}})

### Next steps
    
## System on chip debug

The built-in hardware [Open SystemOnChip Debug](http://opensocdebug.org) trace debugger from previous releases is not yet available.
Some of its functionality (for example loading programs) is available from the GDB/openocd combination.

### The remainder of the steps are flexible and a suggested order is given below:

* [Develop an FPGA Bitstream] ({{< ref "docs/generate-the-bitstream.md">}})
