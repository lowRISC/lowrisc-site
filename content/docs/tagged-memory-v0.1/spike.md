+++
Description = ""
date = "2015-04-12T15:42:11+01:00"
title = "Running simulations using Spike"
parent = "/docs/tagged-memory-v0.1/"
prev = "/docs/tagged-memory-v0.1/simulations/"
next = "/docs/tagged-memory-v0.1/emulator/"
aliases = "/docs/tutorial/spike/"
showdisqus = true

+++


[Spike](https://github.com/riscv/riscv-isa-sim) is a RISC-V functional
ISA simulator. It models a RISC-V core and cache system. Note that our fork 
hasn't currently been modified to include tagged memory support.

An example hello world program is provided in `riscv-tools/hello/`:

    # set up the RISCV environment variables
    cd $TOP/riscv-tools/hello
    make

This will generate three executables to run with and without the
support of the proxy kernel and with the support of a full Linux OS:

  * `hello.bare` : For bare metal mode
  * `hello.pk`: For use with the Proxy kernel and newlib
  * `hello.linux`: For Linux OS 

To run the three hello world programs in their corresponding modes:

### Bare metal mode

    # requirements: riscv-isa-sim, riscv-fesvr, riscv-gnu-toolchain
    spike hello.bare

### With proxy kernel and newlib

    # requirements: riscv-isa-sim, riscv-fesvr, riscv-pk, riscv-gnu-toolchain
    spike pk hello.pk

### With a full Linux OS

    # requirements: riscv-isa-sim, riscv-fesvr, riscv-gcc, riscv-linux, root.bin
    # copy the program to the root image: 
    sudo mount -o loop $TOP/riscv-tools/busybox-1.21.1/root.bin \
      $TOP/riscv-tools/busybox-1.21.1/mnt
    sudo cp hello.linux $TOP/riscv-tools/busybox-1.21.1/mnt/hello
    sudo umount $TOP/riscv-tools/busybox-1.21.1/mnt

    # boot Linux in Spike
    spike +disk=$TOP/riscv-tools/busybox-1.21.1/root.bin \
      $TOP/riscv-tools/linux-3.14.13/vmlinux

    # in the booted linux type: /hello

### Using Spike

The command-line arguments to Spike can be listed with `spike -h`:

    # usage: spike [host options] <target program> [target options]
    # Host Options:
    #   -p <n>             Simulate <n> processors
    #   -m <n>             Provide <n> MB of target memory
    #   -d                 Interactive debug mode
    #   -g                 Track histogram of PCs
    #   -h                 Print this help message
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

The Spike simulator supports an interactive debug mode. To invoke
interactive debug mode, launch spike with `-d`, e.g:

    spike -d pk hello

To see the contents of a register (0 is for core 0):

    : reg 0 a0

To see the contents of a memory location (physical address in hex):

    : mem 2020

To see the contents of memory with a virtual address (0 for core 0):

    : mem 0 2020

You can advance by one instruction by pressing <enter>. You can also execute until a desired condition is reached:

    (stop when pc=0x2020)
    : until pc 0 2020

    (stop when mem[0x2020]=0x50a9907311096993)
    : until mem 2020 50a9907311096993

Alternatively, you can execute as long as a condition is true:

    : while mem 2020 50a9907311096993

You can continue execution indefinitely by:

    : r

At any point during execution (even without `-d`), you can enter the interactive debug mode with `ctrl-c`.
To end the simulation from the debug prompt, press `ctrl-c` or: 

    : q

The proxy kernel also supports some arguments. One of them is to run programs in physical memory mode (-p), e.g:

    spike pk -p hello

For other arguments, see `lowrisc-chip/riscv-tools/riscv-pk/pk/init.c`

