Then configure and build the kernel (not forgetting the device tree blob)

    cd $TOP/riscv-linux
    make ARCH=riscv defconfig scripts
    scripts/dtc/dtc arch/riscv/kernel/lowrisc.dts -O dtb -o arch/riscv/kernel/lowrisc.dtb
    make ARCH=riscv -j 4 CONFIG_INITRAMFS_SOURCE=initramfsmmc.cpio

N.B. In this release, since we only support one board, it is acceptable to build the blob into the kernel. To support multiple boards it would be better if it was stored in the boot loader or BBL.
