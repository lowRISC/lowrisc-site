+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "RTL simulation"
parent = "/docs/untether-v0.2/simulation/"
prev = "/docs/untether-v0.2/spike/"
next = "/docs/untether-v0.2/fpga-demo/"
showdisqus = true

+++

Here we describe how to simulate the lowRISC SoC using Verilator.

### Compilation

To compile a simulator for the lowRISC SoC:

    cd $TOP/vsim
    make sim

This generates a simulator named `DefaultConfig-sim`. It is optimized for 
simulation speed and does not generate a waveform. If the compilation time is 
too long on your machine, you can disable compiler optimization by commenting 
out the optimization flags in `Makefile`:

    # remove optimization if compilation takes too long or runs out of memory
    veri_opt_flags = -O3 -CFLAGS "-O1"

If a waveform is needed for debugging failed test cases, a debugging simulator 
can be compiled by

    cd $TOP/vsim
    make sim-debug

The resulting simulator is named `DefaultConfig-sim-debug`.

### Running simulations

The simulator recognizes the following arguments:

    +vcd                    enable waveform output.
    +vcd_name=FILE_NAME     set the VCD file name, "verilated.vcd" in default.
    +load=HEX_FILE          specify the hex file (memory image).
    +max-cycles=NUM         specify the maximal number of simulation cycles.

<a name="elf2hex"></a>
The `+vcd` and `+vcs_name` arguments are only effective with the debugging simulator. Executables must be translated to hex files (memory image) for simulation. `elf2hex` is a program provided by riscv-fesvr for this purpose.

    # translate rv64ui-p-add to rv64ui-p-add.hex
    elf2hex 16 4096 rv64ui-p-add > rv64ui-p-add.hex

The second argument of `elf2hex`, 4096 in the above example, defines the size 
of the memory image to be 64 KB. For large executables, modify this argument 
accordingly.

To run a program without VCD:

    DefaultConfig-sim +max-cycles=100000000 +load=rv64ui-p-add.hex | spike-dasm > rv64ui-p-add.log

where `rv64ui-p-add.log` has the instruction trace.

If a VCD is required:

    DefaultConfig-sim-debug +vcd +vcd_name=rv64ui-p-add.vcd +max-cycles=100000000 \
      +load=rv64ui-p-add.hex | spike-dasm > rv64ui-p-add.log

Then the waveform is stored in `rv64ui-p-add.vcd`.

### Running the ISA regression test

To run a regression test:

    cd $TOP/vsim
    make -j$(nproc) run-asm-tests

If any test case ever failed, again using `rv64ui-p-add` as an example, a VCD for this test case can be generated:

    make output/rv64ui-p-add.verilator.vcd

### Other useful Makefile targets

    # generate Verilog for the Chisel Rocket-cores
    make verilog

