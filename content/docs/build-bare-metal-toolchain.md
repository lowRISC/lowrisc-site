+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Baremetal toolchain"

+++

### Why is is this step needed ?

* Because you haven't used the quickstart procedure to install pre-built executables.
* Because you want to build everything from source or for a different O/S version.
* Because you don't trust binaries.

### What is it used for ?

* The bare-metal boot loader and test programs require a newlib based flow.
* The Linux kernel and BBL requires a bare-metal flow.
* You might want to build custom software from source on the workstation.

## Build the bare-metal RISCV toolchain (slow, but see quickstart procedure to see if build is necessary)

    cd $TOP/rocket-chip/riscv-tools/
    bash ./build.sh
    cd $TOP/rocket-chip/riscv-tools/riscv-gnu-toolchain/build
    ../configure --prefix=$RISCV
    make -j$(nproc) linux

Proceed to the next step as follows:

* [Install support for RISCV emulation] ({{< ref "docs/riscv-qemu-emulation.md">}})
