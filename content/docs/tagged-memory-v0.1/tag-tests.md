+++
Description = ""
date = "2015-04-12T15:33:14+01:00"
title = "Tagged memory tests"
parent = "/docs/tagged-memory-v0.1/"
prev = "/docs/tagged-memory-v0.1/new-instructions/"
next = "/docs/tagged-memory-v0.1/setup/"
aliases = "/docs/tutorial/tag-tests/"
showdisqus = true

+++

The original Rocket chip repository provides a thorough test suite for
the RISC-V ISA
([`riscv-tools/riscv-tests/isa`](https://github.com/riscv/riscv-tests/tree/master/isa)). All
tests are written in assembly.

A new test case is provided in [`riscv-tools/riscv-tests/isa/rv64si/ltag.S`](https://github.com/lowRISC/riscv-tests/tree/master/isa/rv64si/ltag.S)

More complicated tests can be found in
[`riscv-tools/lowrisc-tag-tests/tests`](https://github.com/lowRISC/lowrisc-tag-tests/tree/master/tests):

  * `tag_ld_st.cc` - Verifies a long sequence of random tag writes
  * `parity.cc` - Random data is allocated on the heap. All the tag bits are then set by generating a number of different parity bits. Finally, all data is read back together with the corresponding tag bits and the parity bits are validated. 

### Running the tests

The tests can be run using the proxy kernel or within RISC-V
Linux. You can generate the proxy kernel executables using the
Makefile included (simple type `make`) or `make linux` to generate
binaries for RISC-V Linux.

The detailed steps necessary to run the tests in simulation or on the FPGA are
described in the subsequent sections of the tutorial.

