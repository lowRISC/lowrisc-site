+++
date = "2018-10-11T14:00:00Z"
title = "RISC-V LLVM Coding Lab at the LLVM Developers' Meeting 2018"

+++

Alex Bradbury is running a [Coding 
Lab](https://llvmdev18.sched.com/event/HGJT/coding-lab-for-risc-v-tutorial) at 
the [2018 LLVM Developers' Meeting](https://llvm.org/devmtg/2018-10/) to 
complement his [LLVM backend 
tutorial](https://llvmdev18.sched.com/event/H2UV/llvm-backend-development-by-example-risc-v).

This coding lab will build on the material presented in the backend and guide 
you through some sample modifications to the RISC-V backend, including both 
codegen and MC layer (assembler/disassmbler) modifications. Anyone familiar 
with C++ and a passing familiarity with LLVM IR should be able to get 
something out of this session, and you're able to go at your own pace.

This page will be updated with full instructions prior to the coding lab.

You will need:

* A laptop
* A debug build of recent HEAD LLVM with the RISC-V backend enabled 
(see below). Incremental builds should be relatively fast, but if your 
laptop is underpowered you may want to plan to ssh out to a faster machine you 
own.

## Building LLVM

The canonical source for LLVM build instructions are the [getting started 
guide](https://llvm.org/docs/GettingStarted.html) or [instructions on building 
LLVM with CMake](https://llvm.org/docs/CMake.html). I outline my recommended 
options below.

When developing LLVM you really want a build with
debug info and assertions. This leads to huge binaries and a lot of
work for your linker. GNU ld tends to struggle in this case and it's likely 
you'll encounter long build times and/or run out of memory if GNU ld is your 
system linker (`ld --version` reports "GNU ld"). Linkers such as GNU gold or 
LLVM's lld do not have this problem. The following instructions will check out 
and build LLVM using a system `clang` and `lld`, installed from your package 
manager. If you're on Debian or Ubuntu, you may want to look at the packages 
available at [apt.llvm.org](http://apt.llvm.org/).

    git clone http://llvm.org/git/llvm.git
    mkdir build
    cd build
    cmake -G Ninja -DCMAKE_BUILD_TYPE="Debug" \
      -DBUILD_SHARED_LIBS=True -DLLVM_USE_SPLIT_DWARF=True \
      -DLLVM_BUILD_TESTS=True \
      -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
      -DLLVM_ENABLE_LLD=True \
      -DLLVM_TARGETS_TO_BUILD="all" \
      -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="RISCV" ../
    cmake --build .

The cmake options are chosen in order to allow a relatively fast
incremental rebuild time.

