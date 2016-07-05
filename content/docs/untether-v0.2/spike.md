+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "Behavioural Simulation (Spike)"
parent = "/docs/untether-v0.2/simulation/"
next = "/docs/untether-v0.2/vsim/"
showdisqus = true

+++

### Introduction

[Spike](https://github.com/riscv/riscv-isa-sim) is a RISC-V functional
ISA simulator. It models a RISC-V core and cache system. Note that our fork 
hasn't currently been modified to include tagged memory support.

In this release, due to the peripheral mismatch between the original Rocket-chip and untethered lowRISC SoC, Spike can only be used to run a Linux Kernel and non-I/O related programs.

Please see [Compile and install the RISC-V cross-compiler] ({{<ref 
"docs/untether-v0.2/riscv_compile.md">}}") for the installation of Spike.

### Using Spike

The command-line arguments to Spike can be listed with `spike -h`:

    # usage: spike [host options] <target program> [target options]
    # Host Options:
    #   -p <n>             Simulate <n> processors [default 1]
    #   -m <n>             Provide <n> MiB of target memory [default 4096]
    #   -d                 Interactive debug mode
    #   -g                 Track histogram of PCs
    #   -l                 Generate a log of execution
    #   -h                 Print this help message
    #   --isa=<name>       RISC-V ISA string [default RV64IMAFDC]
    #   --ic=<S>:<W>:<B>   Instantiate a cache model with S sets,
    #   --dc=<S>:<W>:<B>     W ways, and B-byte blocks (with S and
    #   --l2=<S>:<W>:<B>     B both powers of 2).
    #   --extension=<name> Specify RoCC Extension
    #   --extlib=<name>    Shared library to load

Note: to use the `-g` argument Spike has to be compiled with the
`--enable-histogram` option. This is not the case by default.

    # set up the RISCV environment variables
    cd $TOP/riscv-tools/riscv-isa-sim
    mkdir build
    cd build
    ../configure --prefix=$RISCV --with-fesvr=$RISCV --enable-histogram
    make -j$(nproc)
    make install

### Running Spike

#### Bare metal mode

Spike can be used to run the ISA regression test cases provided in `$TOP/riscv-tools/riscv-tests/isa`.

    cd $TOP/riscv-tools/riscv-tests/isa
    make rv64ui-p-add
    spike rv64ui-p-add
    # show the return value
    echo $?

Since there is no peripheral support in the bare metal mode, the return value 
is the only way to see the result of a test case. `0` indicates success while 
non-zero identifies the failed test case.

<a name="spike-boot"></a>
#### Booting RISC-V Linux

Before booting Linux, please make sure the Linux image (`vmlinux`) and the 
ramdisk (`root.bin`) are available. Please see [Compile RISC-V Linux and
ramdisk `root.bin`] ({{<ref "docs/untether-v0.2/linux_compile.md">}}") for more details.

    cd $TOP/riscv-tools/
    spike +disk=busybox-1.21.1/root.bin bbl linux-3.14.41/vmlinux
