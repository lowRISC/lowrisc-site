+++
Description = ""
date = "2016-05-16T12:00:00+00:00"
title = "Connecting to RTL simulation and enumeration"
parent = "/docs/debug-v0.3/walkthrough/"
prev = "/docs/debug-v0.3/walkthrough/"
next = "/docs/debug-v0.3/debugsession/"
showdisqus = true

+++

### Build the RTL simulation

The RTL simulation is a compiled simulation of the entire system with
cycle accuracy. You can generate the sources and build the simulation
using:

    CONFIG=DebugConfig make -C $TOP/vsim sim

The build will take a few minutes.

### Start the RTL simulation

Next you can launch the RTL simulation and wait for the debug tool to
connect:

    $TOP/vsim/DebugConfig-sim +waitdebug

You will see the following output:

    Glip TCP DPI listening on port 23000 and 23001

The simulation waits for the Open SoC Debug software to connect.

You may want to debug the system with a waveform (vcd), for which you need to
compile a debug simulator and add the `+vcd` parameters.

    # compile a debug simulator
    CONFIG=DebugConfig make -C $TOP/vsim sim-debug
    # run simulation
    $TOP/vsim/DebugConfig-sim-debug +vcd +vcd_name=sim.vcd

The debugger allows you to load a program at run-time but you may want to
pre-load a program using the `+load` parameter.

    $TOP/vsim/DebugConfig-sim +load=program

### Connect the debug daemon

In a second terminal you can now start the daemon (don't forget to set
up the environment in the second terminal):

    opensocdebugd tcp

The daemon will connect using a local TCP connection and run the
enumeration of the system, which leads to following output:

	Open SoC Debug Daemon
	Backend: tcp
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
         [0] base address: 0x0000000040000000, memory size: 65536 Bytes
         [1] base address: 0x0000000080000000, memory size: 134217728 Bytes
     [4]: CTM
       version: 0000
     [5]: STM
       version: 0000
    Wait for connection

You can see the system identifier (`dead`) and that six modules were
found. Each module is listed by the type and the version. For the
Memory Access Module (MAM) extra information is available, namely the
data and address width and the available memory regions. Thats all the
daemon does, it then waits for a tool to connect.

On the first terminal (simulation) you can see that the daemon has
connected:

	Client connected

You are now ready to actually debug the system and software running in
it.
