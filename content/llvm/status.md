+++
date = "2018-05-07T10:00:00Z"
title = "lowRISC RISC-V LLVM status page"

+++

lowRISC has been pursuing the development of an upstream RISC-V LLVM backend.
For an overview of this work as well as the current patch set, please see 
[github.com/lowRISC/riscv-llvm](https://github.com/lowRISC/riscv-llvm).

An early [status blog post]({{< ref "blog/moving-riscv-llvm-forwards.md" >}}) 
provides a good overview of the development approach.

As of May 2018, the vast majority of these patches are now upstream and most 
users wishing to experiment with support for RISC-V in LLVM projects will 
likely be best served by building directly from the upstream repositories. You 
may prefer to follow this repository if you want to study how the backend is 
put together.

Immediate next steps:

* Week of 7th May: The patches in the [lowRISC 
riscv-llvm](https://github.com/lowRISC/riscv-llvm) repository will be 
refreshed.
* Week of 14th May: The repository will be updated with documentation on 
adding custom instructions, building upon a presentation at the Barcelona 
RISC-V Workshop.

The current patchset allows the entirety of the GCC torture suite to compile
and run for {RV32I, RV32IM, RV32IFD} with or without the 'C' (compressed) 
extension. Additionally, all torture suite tests compile and run for RV64I at 
O1, O2, O3, and Os. MC-layer support is present for RV32IMAFDC+RV64IMAFDC, and 
codegen support for RV32IMFDC and RV64I.

The [runner 
script](https://github.com/lowRISC/riscv-llvm/blob/master/scripts/run_torture_suite.sh) 
includes a list of skipped tests. Tests which are architecture-specific or 
which exercise features not supported by Clang are skipped and not included in
the totals.
