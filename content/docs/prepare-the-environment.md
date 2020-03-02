+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Prepare the environment"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

Most CAD tools assume that /bin/sh is a link to /bin/bash. However Ubuntu links to /bin/dash by default, which is not fully
backward compatible. Change this default before proceeding.

lowRISC tools and source code are robust between versions of Linux, but it has been
found that
Vivado (the Xilinx FPGA implementation suite) [is particular about the O/S](https://www.xilinx.com/support/answers/54242.html)

All builds were completed with Vivado 2018.2. This was the newest version when this release was begun. Newer versions may well work but are untested. We have not tried every version but 2015.4 used on the previous releases does not work due to unidentified synthesis bugs in the virtual memory behaviour.
It is not known whether our previous releases can work with the latest tool installation.

You should have installed the prerequisites on the download page. If not do so now:
[Download the source code] ({{< ref "docs/download-the-code.md">}})

### Next steps
    
## System on chip debug

The built-in hardware [Open SystemOnChip Debug](http://opensocdebug.org) trace debugger from previous releases is not available.
Some of its functionality (for example loading programs) is available from the GDB/openocd combination.

### The remainder of the steps are flexible and a suggested order is given below:

* [Develop an FPGA Bitstream] ({{< ref "docs/generate-the-bitstream.md">}})
