+++
Description = ""
date = "2016-05-16T12:00:00+00:00"
title = "Open SoC Debug Software"
parent = "/docs/debug-v0.3/environment/"
prev = "/docs/debug-v0.3/lowriscsetup/"
next = "/docs/debug-v0.3/walkthrough/"
showdisqus = true

+++

Building the Open SoC Debug software is currently done manually, but
it only involves a few steps.

### Build glip software

First you need to build and install the glip software to connect to
the FPGA or simulation.

    cd $TOP/opensocdebug/glip
    ./autogen.sh
	mkdir build; cd build
	../configure --prefix=$OSD_ROOT --enable-tcp --enable-uart
	make && make install

### Build Open SoC Debug software

Then the actual Open SoC Debug software is installed. You can leave
out the python bindings, but you will loose a very convenient way to
interact with the debug system.

    cd $TOP/opensocdebug/software
    ./autogen.sh
	mkdir build; cd build
	../configure --prefix=$OSD_ROOT --enable-python-bindings
	make && make install

Done!
