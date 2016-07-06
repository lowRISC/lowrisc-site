+++
Description = ""
date = "2016-05-16T12:00:00+00:00"
title = "Running on the FPGA"
parent = "/docs/debug-v0.3/walkthrough/"
prev = "/docs/debug-v0.3/debugsession/"
next = "/docs/debug-v0.3/release/"
showdisqus = true

+++

In this final step, we want to test the debug on the FPGA board. The
debug system will use the UART connection at 3 MBaud to communicate
with the debug system.

### Generate the bitstream

To generate a bitstream change to the FPGA directory and use `make` to
build it:

    cd ${TOP}/fpga/board/nexys4_ddr
    make bitstream

This will take some time (20-60 minutes depending on your
computer).

### Program the FPGA

Next, turn on the FPGA board and connect the USB cable. Now you
download the bitstream to the FPGA:

    make program

Done!

### Connect daemon and run a debug session

Now you can connect to the debug system similar to the simulation
before. In one terminal start the debug daemon:

    opensocdebugd uart device=/dev/ttyUSB0 speed=3000000

You may need to change the device and check the permissions. If
everything works you will see the same output as in the simulation:

	Open SoC Debug Daemon
	Backend: uart
	System ID: dead
	6 debug modules found:
	 [0]: HOST
       version: 0000
     [1]: SCM
       version: 0000
     [2]: DEM-UART
       version: 0000
     [3]: MAM
       version: 0000
       data width: 16, address width: 32
       number of regions: 1
         [0] base address: 0x0000000000000000, memory size: 1073741824 Bytes
     [4]: CTM
       version: 0000
     [5]: STM
       version: 0000
    Wait for connection

### Build Linux

