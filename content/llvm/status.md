+++
date = "2075-08-21T10:00:00Z"
title = "lowRISC RISC-V LLVM status page"

+++

**Note**: This page is something of a placeholder for a more dynamic status 
page.

lowRISC has been pursuing the development of an upstream RISC-V LLVM backend.
For an overview of this work as well as the current patch set, please see 
[github.com/lowRISC/riscv-llvm](https://github.com/lowRISC/riscv-llvm).

Aside from hand-written unit tests, most testing has been performed using the 
GCC torture suite. For RV32I at `-O1`, `-O2`, `-O3`, and `-Os`, **1392 out of
1392** (100%) of these tests compile and run.

Issues detailing further work and improvements are tracked
[here](https://github.com/lowrisc/riscv-llvm/issues?q=is%3Aissue+is%3Aopen+label%3Abug).
The [runner script](https://github.com/lowRISC/riscv-llvm/blob/master/scripts/run_torture_suite.sh) 
includes a list of skipped tests. Tests which are architecture-specific or 
which exercise features not supported by Clang are skipped and not included in
the totals.
