+++
Description = ""
date = "2015-11-12T13:05:11+01:00"
title = "RTL simulation"
parent = "/docs/untether-v0.2/simulation/"
prev = "/docs/untether-v0.2/spike/"
next = "/docs/untether-v0.2/kc705/"
showdisqus = true

+++

Here we describe how to simulate the lowRISC SoC using Verilator.

### Compilation

To compile a simulator for lowRISC SoC:

    cd $TOP/vsim
    make sim

This will give you a simulator named `DefaultConfig-sim`. It is optimized for simulation speed and does not generate waveform. If the compilation time is too long on your machine, you can remove the compilation optimization by comment out the optimization flags in `Makefile`:

    # remove optimization if compilation takes too long or run out of memory
    veri_opt_flags = -O3 -CFLAGS "-O1"

If waveform is needed for debugging failed test cases, a debugging simulator can be compiled by

    cd $TOP/vsim
    make sim-debug

The resulting simulator is named `DefaultConfig-sim-debug`.

### Running simulations

The simulator recognize the follwing arguments:

    +vcd                    enable waveform output.
    +vcd_name=FILE_NAME     set the VCD file name, "verilated.vcd" in default.
    +load=HEX_FILE          specify the hex file (memory image).
    +max-cycles=NUM         specify the maximal number of simulation cycles.

<a name="elf2hex"></a>
The `+vcd` and `+vcs_name` arguments are only effective with the debuggong simulator. Executables are translated to hex files (memory image) for simulation. `elf2hex` is a program provided by riscv-fesvr for this purpose.

    # rv64ui-p-add -> rv64ui-p-add.hex
    elf2hex 16 4096 rv64ui-p-add > rv64ui-p-add.hex

The second argument of `elf2hex`, 4096 in the above example, defines the size of the memory image to 64 KB. For large executables, modify this argument accordingly.

To run a test case without VCD:

    DefaultConfig-sim +max-cycles=100000000 +load=rv64ui-p-add.hex | spike-dasm > rv64ui-p-add.log

where `rv64ui-p-add.log` has the instruction trace.

If a VCD is required:

    DefaultConfig-sim-debug +vcd +vcd_name=rv64ui-p-add.vcd +max-cycles=100000000 \
      +load=rv64ui-p-add.hex | spike-dasm > rv64ui-p-add.log

Then the waveform is stored in `rv64ui-p-add.vcd`.

### Running the ISA regression test

To run a regression test:

    cd $TOP/vsim
    make run-asm-tests

If any test case ever failed, again using `rv64ui-p-add` as an example, a VCD for this test case can be generated:

    make output/rv64ui-p-add.verilator.vcd

### Other useful Makefile targets

    # generate Verilog for the Chisel Rocket-cores
    make verilog

