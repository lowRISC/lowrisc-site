+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Baremetal toolchain"

+++

### Why is is this step needed ?

This release of lowRISC uses the upstream gcc and friends from the RISCV repository.
Many users will already have access to a RISCV toolchain, but the latest one is included
here because the latest kernel makes use of some recent flags.

### What is it used for ?

* The bare-metal boot loader requires a newlib based flow.
* The Linux kernel and BBL are configured to use either a bare-metal flow or the linux compiler.
* You might want to build custom software from source on the workstation.

## Install location

The default installation location is /opt/riscv. If this location is forbidden then $HOME/riscv might
be a suitable alternative. This should be customised in the top-level Makefile before starting the toolchain step.

## Build the bare-metal RISCV toolchain (slow, but see quickstart procedure to see if build is necessary)

    make toolchain

Proceed to the next step as follows:

* [Install support for RISCV emulation] ({{< ref "docs/download-install-debian.md">}})
