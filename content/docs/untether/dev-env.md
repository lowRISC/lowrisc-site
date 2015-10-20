+++
Description = ""
date = "2015-10-14T14:18:00+01:00"
title = "The development environment"
parent = "/docs/untether/"
prev = "/docs/untether/dev-env/"
next = "/docs/untether/dev-env/"
showdisqus = true

+++


### File structure of the repository

 * `chisel`: The [Chisel](https://chisel.eecs.berkeley.edu/) compiler used for 
 compiling the rocket system.
 * `chisel-components`: Extra chisel building blocks used in lowRISC chip.
 * `csrc`: SystemVerilog DPI functions for behavioural/FPGA simulations.
 * `fpga`: FPGA demo implementations
   * `board`: Demo projects for individual developement boards.
     * `kc705`: Xilinx KC705 developement board.
 * `hardfloat`: The IEEE 754-2008 compliant floating-point unit.
 * `junctions`: Peripheral components and IO devices associated with the RocketChip.
 * `project`: Global configuration for Chisel compilation.
 * `riscv-tools`: The cross-compilation and simulation tool chain.
   * `lowrisc-tests`: lowRISC chip dedicated test environment.
   * `riscv-fesvr`: The front-end server that serves system calls on the host machine.
   * `riscv-gnu-toolchain`: The GNU GCC cross-compiler for RISC-V ISA.
   * `riscv-isa-sim`: The RISC-V ISA simulator [Spike](https://github.com/riscv/riscv-isa-sim#risc-v-isa-simulator)
   * `riscv-opcodes`: The enumeration of all RISC-V opcodes executable by the Spike simulator.
   * `riscv-tests`: Tests for the Rocket core.
 * `rocket`: The Chisel code for the Rocket core.
 * `socip`: The SystemVerilog/Verilog building blocks used in lowRISC chip.
   * `nasti`: A SystemVerilog implemenation of NASTI/NASTI-Lite on-chip interconnection.
 * `src`: The top level Chisel code of lowRISC chip.
 * `uncore`: The Chisel code of the memory subsystem.
 * `vsim`: RTL/Behavioural SystemVerilog simulation environment.
 * `vsrc`: SystemVerilog code of lowRISC top and testbenches.