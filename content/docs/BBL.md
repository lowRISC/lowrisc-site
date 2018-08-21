Now configure and build Berkeley Boot loader

    cd $TOP/rocket-chip/riscv-tools/riscv-pk/
    mkdir -p build
    cd build
    ../configure --prefix=$RISCV --host=riscv64-unknown-elf --with-payload=$TOP/riscv-linux/vmlinux --enable-logo
    make
    cp -p bbl $TOP/fpga/board/nexys4_ddr/boot.bin

Alternatively, if all is well you can let one script take care of it:

    cd $TOP/riscv-linux
    ./make_root.sh

