+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "FPGA Simulation"
parent = "/docs/untether-v0.2/simulation/"
prev = "/docs/untether-v0.2/fpga-demo/"
showdisqus = true

+++

An FPGA simulation is provided using the Xilinx ISim simulator. However, due to the lack of behavioural models for all peripherals, this FPGA simulation covers only part of the whole SoC.

   * All parts of the Rocket cores, L1/L2 caches and on-chip interconnects are simulated.
   * A full DDR RAM simulation model is available from Xilinx (disabled by default) but extremely slow.
   * A behavioural RAM simulation model is provided using SystemVerilog DPI interfaces (enabled by default).
   * In simulation, both UART and SD (SPI) I/Os are constantly driven or open.

Normally FPGA simulation is used only for debugging the initialization of 
peripherals.

### Run FPGA simulation

Use the hello world test as an example:

    cd $TOP/fpga/board/$FPGA_BOARD
    # compile and load the test
    make hello
    # run the simulation
    make simulation

The result of simulation is recorded in `$TOP/fpga/board/$FPGA_BOARD/simulate.log`.

Also, the waveform of the simulation is automatically recorded to <br/>
`$TOP/fpga/board/$FPGA_BOARD/lowrisc-chip-imp/lowrisc-chip-imp.sim/sim_1/behav/lowrisc-chip.vcd`. 
If no VCD is needed, remove related lines in 
`$TOP/fpga/board/$FPGA_BOARD/script/simulate.tcl`. When VCD is enabled, be 
careful with disk space as the VCD file can grow very large.

### Simulate other programs

The program to be executed in simulation is stored in the on-chip boot BRAM (`src/boot.mem`). To load simulation with an arbitrary program, it is needed to compile the program and replace the BRAM image. `elf2hex` should be used to translate an executable into a memory image. See [[RTL simulation]] (../vsim#elf2hex) for more information.

### Enable the full DDR simulation model

It is possible to simulate the actual behaviour of the DDR interface but it is extremely slow.

To enable the full DDR simulation model, revise `script/make_project.tcl`, 
changing

    #set_property verilog_define [list FPGA FPGA_FULL KC705] $obj
    set_property verilog_define [list FPGA] $obj

into

    set_property verilog_define [list FPGA FPGA_FULL KC705] $obj
    #set_property verilog_define [list FPGA] $obj

which effectively defines the `FPGA_FULL` and `KC705` macros for FPGA simulation. For NEXYS4-DDR, replace macro `KC705` with `NEXYS4`.

Please rebuild the whole FPGA project to update the change:

    make cleanall
    make project

Unless the DDR interface is the debugging target, it is strongly suggested NOT 
to enable this option.
