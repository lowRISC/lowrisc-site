+++
Description = ""
date = "2017-09-05T14:00:00+00:00"
title = "Building upstream RISC-V GCC+binutils+newlib: the quick and dirty way"
slug = "building-upstream-risc-v-gccbinutilsnewlib-the-quick-and-dirty-way"

+++
There are a number of available options for building a RISC-V GCC toolchain. 
You might use the build system from the 
[riscv/riscv-tools repository](https://github.com/riscv/riscv-tools), or 
investigate toolchain generators such as 
[crosstool-ng](http://crosstool-ng.github.io/). However in the case of 
riscv-tools, it's not always clear how this corresponds to the code in the 
relevant upstream projects. When investigating a potential bug, you often just 
want to build the latest upstream code with as little fuss as possible. For 
distribution purposes you'd probably want to perform a proper multi-stage 
build, but for a quick test you might find the following recipe useful:

    git clone --depth=1 git://gcc.gnu.org/git/gcc.git gcc
    git clone --depth=1 git://sourceware.org/git/binutils-gdb.git
    git clone --depth=1 git://sourceware.org/git/newlib-cygwin.git
    mkdir combined
    cd combined
    ln -s ../newlib-cygwin/* .
    ln --force -s ../binutils-gdb/* .
    ln --force -s ../gcc/* .
    mkdir build
    cd build
    ../configure --target=riscv32-unknown-elf --enable-languages=c \
    --disable-shared --disable-threads --disable-multilib --disable-gdb \
    --disable-libssp --with-newlib \
    --with-arch=rv32ima --with-abi=ilp32 --prefix=$(pwd)/built
    make -j$(nproc)
    make install

This will produce a newlib toolchain targeting RV32IMA in the `built/` 
subdirectory. When files are duplicated in the newlib, binutils and gcc 
repositories, the gcc version takes precedence.

Major credit to everyone who worked on getting these toolchain 
ports upstream (Kito Cheng, Palmer Dabbelt, and others).
