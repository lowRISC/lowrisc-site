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
GCC torture suite. For RV32I at `O0`, currently **1315 out of 1352** compile 
and run. Of the failures, 32 are compile-time and 5 are run-time.

Test cases failing at runtime are:

    pr44942
    pr78622
    stdarg-4
    va-arg-15
    va-arg-6


Test cases failing at compile time are:

    20010122-1
    20020413-1
    20021120-1
    20030323-1
    20030811-1
    20030914-1
    20040208-1
    20050121-1
    930622-2
    960215-1
    960513-1
    980608-1
    990208-1
    built-in-setjmp
    comp-goto-1
    complex-6
    conversion
    frame-address
    multi-ix
    pr17377
    pr47237
    pr53645-2
    pr56982
    pr58574
    pr58831
    pr60003
    pr60960
    pr70460
    pr71554
    regstack-1
    simd-6
    stdarg-2

Issues related to these failures are tracked 
[here](https://github.com/lowrisc/riscv-llvm/issues?q=is%3Aissue+is%3Aopen+label%3Abug).
The [runner script](https://github.com/lowRISC/riscv-llvm/blob/master/scripts/run_torture_suite.sh) 
includes a list of skipped tests. Tests which are architecture-specific or 
which exercise features not supported by Clang are skipped and not included in 
the totals.
