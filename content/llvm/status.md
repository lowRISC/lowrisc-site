+++
date = "2075-08-21T10:00:00Z"
title = "lowRISC RISC-V LLVM status page"

+++

lowRISC has been pursuing the development of an upstream RISC-V LLVM backend.
For an overview of this work as well as the current patch set, please see 
[github.com/lowRISC/riscv-llvm](https://github.com/lowRISC/riscv-llvm).

The most recent [status blog post]({{< ref "blog/moving-riscv-llvm-forwards.md"
>}}) provides a good overview of status, roadmap, and development approach.

Aside from hand-written unit tests, most testing has been performed using the 
GCC torture suite. For RV32I at `-O0`, `-O1`, `-O2`, `-O3`, and `-Os`, **1390 out of
1390** (100%) of these tests compile and run. For RV64I, **1390 out of 1390**
(100%) of these tests compile and run at `-O1`, `-O2`, `-O3`, and `-Os`. There
is 1 compilation failure at O0. MC-layer support is now present for a number of
standard ISA extensions (RV32MAFD), as well as code-gen for RV32M.

Issues detailing further work and improvements are tracked
[here](https://github.com/lowrisc/riscv-llvm/issues?q=is%3Aissue+is%3Aopen+label%3Abug).
The [runner script](https://github.com/lowRISC/riscv-llvm/blob/master/scripts/run_torture_suite.sh) 
includes a list of skipped tests. Tests which are architecture-specific or 
which exercise features not supported by Clang are skipped and not included in
the totals.
